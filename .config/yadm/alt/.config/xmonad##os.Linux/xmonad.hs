{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

import qualified Codec.Binary.UTF8.String as UTF8
import Control.Monad
import qualified DBus as D
import qualified DBus.Client as D
import XMonad.Layout.OneBig
import qualified Data.Map as M
import System.Directory (doesFileExist)
import System.Environment (getEnv)
import System.Exit
import System.FilePath ((</>))
import XMonad
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Tabbed
import qualified XMonad.StackSet as W
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Util.Scratchpad (scratchpadFilterOutWorkspace, scratchpadManageHook, scratchpadSpawnActionCustom)
import XMonad.Util.SpawnOnce

fg = "#ebdbb2"

bg = "#282828"

gray = "#a89984"

bg1 = "#3c3836"

bg2 = "#504945"

bg3 = "#665c54"

bg4 = "#7c6f64"

green = "#b8bb26"

darkgreen = "#98971a"

red = "#fb4934"

darkred = "#cc241d"

yellow = "#fabd2f"

blue = "#83a598"

purple = "#d3869b"

aqua = "#8ec07c"

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "alacritty"

myWorkspace = [show num | num <- [1 .. 10]]

myNormalBorderColor = "#3b4252"

myFocusedBorderColor = "#bc96da"

myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 2

confirmAction :: String -> X () -> X ()
confirmAction msg f = do
  selectAction msg [("Yes", f), ("No", return ())]

selectAction :: String -> [(String, X ())] -> X ()
selectAction msg acts = do
  let mp = M.fromList $ (msg, return ()) : acts
  ans <- dmenuMap mp
  case ans of
    Just x -> x
    Nothing -> return ()

myLayoutHook = avoidStrutsOn [D] $ tiled ||| Full ||| simpleTabbedLeftAlways ||| OneBig (3/4) (3/4)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

myKeyMaps :: D.Client -> XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeyMaps dbus conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList
    [ ((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
    `M.union` mkKeymap conf emacsKeyMap
  where
    closeDbus = io $ D.disconnect dbus
    actXRestart = closeDbus >> spawn "notify-send \"XMonad compiler\" \"Start compile xmonad.hs\" && xmonad --recompile && xmonad --restart && notify-send \"XMonad compiler\" \"XMonad restart successfully\""
    actXExit = closeDbus >> (io $ exitWith ExitSuccess)
    emacsKeyMap =
      [ -- Launcher
        ("M-v", spawn "rofi -modi \"\63053 :greenclip print\" -show \"\63053 \" -run-command '{cmd}' -theme ~/.config/rofi/launcher/style.rasi"),
        ("M-r", spawn "rofi -no-lazy-grab -show drun -modi run,drun,window -theme $HOME/.config/rofi/launcher/style -drun-icon-theme \"candy-icons\" "),
        ("M-<Return>", spawn myTerminal),
        -- Layout
        ("M-<Space>", sendMessage NextLayout),
        ("M-S-<Space>", setLayout $ XMonad.layoutHook conf),
        ("M-l", sendMessage Expand),
        ("M-h", sendMessage Shrink),
        ("M-j", windows $ W.focusDown),
        ("M-k", windows $ W.focusUp),
        ("M-S-j", windows $ W.swapDown),
        ("M-S-k", windows $ W.swapUp),
        ("M-f", sendMessage ToggleStruts),
        ("M-<Tab>", toggleWS),
        ("M-", withFocused (windows . W.sink)),
        -- Windows controller
        ("M-S-c", kill),
        ("M-`", scratchpadSpawnActionCustom $ "alacritty --class scratchpad"),
        -- XMonad
        ("M-S-q", selectAction "Cancel" [("Restart", actXRestart), ("Exit", actXExit)]),
        -- Brightness controller
        ("<XF86MonBrightnessUp>", spawnAndNotify "brightnessctl s +5%"),
        ("<XF86MonBrightnessDown>", spawnAndNotify "brightnessctl s 5-%"),
        -- Audio player controller
        ("<XF86AudioPlay>", spawn "playerctl play-pause"),
        ("<XF86AudioPrev>", spawn "playerctl previous"),
        ("<XF86AudioNext>", spawn "playerctl next"),
        -- Audio volume controller
        ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5%"),
        ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle"),
        ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5%")
      ]
    spawnAndNotify cmd = spawn $ cmd ++ " | xargs -0 notify-send \"Brightness changed\""

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        ( \w ->
            focus w >> mouseMoveWindow w
              >> windows W.shiftMaster
        )
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        ( \w ->
            focus w >> mouseResizeWindow w
              >> windows W.shiftMaster
        )
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myStartupHook = do
  spawnOnce "polybar main"
  io $ setupWallpaper
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "picom --experimental-backends"
  spawnOnce "dunst"
  spawnOnce "fcitx5 -d"
  spawnOnce "emacs --daemon --with-x-toolkit=lucid"
  spawnOnce "nm-applet"
  spawnOnce "v2ray -c ~/.v2ray.json"
  spawnOnce "greenclip daemon"
  spawnOnce "setxkbmap -option caps:escape"

  spawnOnce "sleep 30; /usr/lib/kdeconnectd && sleep 2 && kdeconnect-indicator"
  where
    setupWallpaper :: IO ()
    setupWallpaper = do
      home <- getEnv "HOME"
      doesFileExist (home </> ".wallpaper_fill") >>= \exist ->
        if exist
          then spawn "feh --bg-fill ~/.wallpaper_fill"
          else spawn "feh --bg-scale ~/.wallpaper_scale"

myManageHook =
  scratchpad <+> manageDocks
    <+> composeAll
      [ className =? "MPlayer" --> doFloat,
        resource =? "desktop_window" --> doIgnore,
        resource =? "kdesktop" --> doIgnore,
        isFullscreen --> doFullFloat
      ]
  where
    scratchpad = scratchpadManageHook $ W.RationalRect 0.25 0.1 0.5 0.8

myConfig dbus =
  docks . ewmhFullscreen . ewmh . Hacks.javaHack $
    def
      { modMask = myModMask,
        terminal = myTerminal,
        focusFollowsMouse = myFocusFollowsMouse,
        clickJustFocuses = myClickJustFocuses,
        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        -- keybinding
        keys = myKeyMaps dbus,
        mouseBindings = myMouseBindings,
        -- hooks
        startupHook = myStartupHook,
        layoutHook = myLayoutHook,
        manageHook = myManageHook,
        handleEventHook = handleEventHook def <+> Hacks.windowedFullscreenFixEventHook,
        logHook = dynamicLogWithPP (myLogHook dbus)
      }

-- Override the PP values as you would otherwise, adding colors etc depending
-- on  the statusbar used
myLogHook :: D.Client -> PP
myLogHook dbus =
  def
    { ppOutput = dbusOutput dbus,
      ppCurrent = wrap ("%{B" ++ bg2 ++ "} ") " %{B-}",
      ppVisible = wrap ("%{B" ++ bg1 ++ "} ") " %{B-}",
      ppUrgent = wrap ("%{F" ++ red ++ "} ") " %{F-}",
      ppHidden = wrap " " " ",
      ppWsSep = "",
      ppSep = "| ",
      ppTitle = const "",
      ppSort = (\x -> scratchpadFilterOutWorkspace . x) <$> ppSort def
    }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
  let signal =
        (D.signal objectPath interfaceName memberName)
          { D.signalBody = [D.toVariant $ UTF8.decodeString str]
          }
  D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

main :: IO ()
main = do
  -- Request access to the DBus name
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.Log") [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  xmonad $ myConfig dbus
