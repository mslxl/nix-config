{-# LANGUAGE CPP #-}

import System.Exit
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CopyWindow (copyToAll)
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.DwmStyle
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Prompt.ConfirmPrompt
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Hacks qualified as Hacks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Hooks.ManageHelpers (isDialog, doCenterFloat)

myWorkspaces = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

myTerminal = "wezterm"

myBroswer = "firefox"

myLayoutHook = smartBorders $ avoidStruts $ toggleLayouts full tall
  where
    tall = Tall 1 (3 / 100) (1 / 2)
    full = noBorders Full

myManageHook :: ManageHook
myManageHook =
  manageHook def
    <+> manageDocks
    <+> composeAll
      [ title =? "Picture in picture" --> doFloat <> doF copyToAll
      , title =? "Picture-in-Picture" --> doFloat <> doF copyToAll
      , isDialog                --> doCenterFloat
      ]

myKeys config =
  [ ("M-C-q", confirmPrompt def "exit?" $ io exitSuccess)
  , ("M-S-c", kill),
    ("M-<Return>", spawn $ terminal config),
    ("M-e", spawn myBroswer),
    ("M-C-<Return>", spawn "rofi -show drun"),
    ("M-c", sendMessage NextLayout),
    ("M-f", sendMessage (Toggle "Full") >> sendMessage ToggleStruts),
    ("M-j", windows W.focusDown),
    ("M-k", windows W.focusUp),
    ("M-h", sendMessage Shrink),
    ("M-l", sendMessage Expand),
    ("M-r", refresh),
    ("M-S-h", windows W.swapDown),
    ("M-S-l", windows W.swapUp),
    ("M-S-j", windows W.swapDown),
    ("M-S-k", windows W.swapUp),
    ("<Print>", spawn "flameshot gui"),
    ("M-<Print>", spawn "sleep 2; flameshot gui"),
    ("M-S-s", spawn "flameshot gui"),
    ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5%"),
    ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5%"),
    ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle"),
    ("<XF86MonBrightnessUp>", spawn "brightnessctl -q s +10%"),
    ("<XF86MonBrightnessDown>", spawn "brightnessctl -q s 10%-"),
    ("M-<Space>", withFocused $ windows . W.sink)
  ]
    ++ [ ("M-" ++ key, windows $ W.greedyView ws)
         | (key, ws) <- zip (map show [0 .. 9]) myWorkspaces
       ]
    ++ [ ("M-S-" ++ key, windows $ W.shift ws)
         | (key, ws) <- zip (map show [0 .. 9]) myWorkspaces
       ]
    ++ [("M-<Tab>", toggleWS)]

myConfig =
  def
    { terminal = myTerminal,
      modMask = mod4Mask,
      borderWidth = 1,
      keys = \c -> mkKeymap c keymap,
      manageHook = myManageHook,
      normalBorderColor = "#104010",
      focusedBorderColor = "#FF0000",
      handleEventHook = handleEventHook def <> Hacks.trayerAboveXmobarEventHook <> Hacks.trayerPaddingXmobarEventHook,
      layoutHook = myLayoutHook,
      startupHook = do
        return () -- do not remove it, this is very important to avoid infinity loop
        checkKeymap myConfig keymap
        spawnOnce "bash -c \"cat <SPAWN_ONCE_ON_STARTUP> | bash\""
        spawn "bash -c \"cat <SPAWN_ON_STARTUP> | bash\""
        spawn "sleep 2; feh --bg-fill ~/.wallpaper"
        spawn "xsetroot -cursor_name left_ptr"
        spawnOnce "flameshot"
    }
  where
    keymap = myKeys myConfig

myDynLog h =
  dynamicLogWithPP
    def
      { ppCurrent = xmobarColor "yellow" "" . wrap "[" "]",
        ppTitle = xmobarColor "green" "" . shorten 40,
        ppVisible = wrap "(" ")",
        ppOutput = hPutStrLn h
      }

main =
  do
    xmobarHandle <- spawnPipe "xmobar <XMOBAR_CONFIG>"
    runXmonad xmobarHandle
  where
    runXmonad handle =
      xmonad
        . ewmhFullscreen
        . ewmh
        . docks
        $ myConfig
          { logHook = myDynLog handle
          }
