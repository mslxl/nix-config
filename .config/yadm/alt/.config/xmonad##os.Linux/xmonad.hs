import Control.Monad
import qualified Data.Map as M
import System.Directory (doesFileExist)
import System.Environment (getEnv)
import System.Exit
import System.FilePath ((</>))
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "st"

myWorkspace = [show num | num <- [1 .. 10]]

myNormalBorderColor = "#3b4252"

myFocusedBorderColor = "#bc96da"

myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 2

confirm :: String -> X () -> X ()
confirm msg f = do
  ans <- dmenu [msg, "YES", "NE"]
  when (ans == "YES") f

myLayoutHook = avoidStruts $ tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

myKeyMaps conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList
    [ ((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
    `M.union` mkKeymap conf emacsKeyMap
  where
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
        -- Windows controller
        ("M-S-c", kill),
        -- XMonad
        ("M-S-q q", confirm "Are you sure to exit XMonad?" $ io (exitWith ExitSuccess)),
        ("M-S-q r", confirm "Are you sure to restart XMonad?" $ spawn "notify-send \"Start compile xmonad.hs\" && xmonad --recompile && xmonad --restart && notify-send \"XMonad restart successfully\""),
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
    spawnAndNotify cmd = spawn $ cmd ++ " | xargs -0 notify-send"

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
  io $ setupWallpaper
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "picom --experimental-backends"
  spawnOnce "dunst"
  spawnOnce "greenclip daemon"
  where
    setupWallpaper :: IO ()
    setupWallpaper = do
      home <- getEnv "HOME"
      doesFileExist (home </> ".wallpaper_fill") >>= \exist ->
        if exist
          then spawn "feh --bg-fill ~/.wallpaper_fill"
          else spawn "feh --bg-scale ~/.wallpaper_scale"

myManageHook =
  manageDocks
    <+> composeAll
      [ className =? "MPlayer" --> doFloat,
        resource =? "desktop_window" --> doIgnore,
        resource =? "kdesktop" --> doIgnore,
        isFullscreen --> doFullFloat
      ]

myConfig =
  ewmhFullscreen . ewmh $
    def
      { modMask = myModMask,
        focusFollowsMouse = myFocusFollowsMouse,
        clickJustFocuses = myClickJustFocuses,
        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        -- keybinding
        keys = myKeyMaps,
        mouseBindings = myMouseBindings,
        -- hooks
        layoutHook = myLayoutHook,
        manageHook = myManageHook,
        startupHook = myStartupHook
      }

main :: IO ()
main = xmonad $ myConfig
