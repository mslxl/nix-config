import Data.List

import System.IO
import System.Exit

import XMonad
import XMonad.Util.Cursor
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Prompt.ConfirmPrompt
import XMonad.Actions.Navigation2D
import XMonad.Actions.Search
import qualified XMonad.StackSet as W

-- Recommend to install tlp to save power on laptop

useTerminal		= "alacritty"

winActiveBorderColor 	= "#556064"
winInactiveBorderColor	= "#2F3D44"
allBorderWidth		= 2

workspaceList = map show [1..9]
keyMap conf = mkKeymap conf $
  [("M-<Return>"	, spawn $ terminal conf)
  ,("M-S-q"	, kill)
  ,("M-x"		, shellPrompt myXPConfig)
  ,("M-S-x"	, xmonadPrompt myXPConfig)
  ,("M-d"		, spawn "rofi -show drun")
  ,("M-S-r"	, spawn "xmonad --recompile && xmonad --restart")
  ,("M-S-e"	, confirmPrompt myXPConfig "Are you sure exit XMonad?" $ io exitSuccess)
  ,("M-<Space>" , sendMessage NextLayout)
  ,("M-S-<Space>", withFocused $ windows . W.sink)
  ] ++ 
  [("M-" ++ k	, windowGo d False) | (k, d) <- zip ["j","k","h","l"] [D, U, L, R]]++
  [("M-S-" ++ k	, windowSwap d False) | (k, d) <- zip ["j","k","h","l"] [D, U, L, R]]++
  [("M-" ++ k , sendMessage m) | (k, m) <- zip ["=","-"] [MirrorExpand, MirrorShrink]] ++
  [("M-" ++ show k	, windows $ W.greedyView n) | (n, k) <- zip (workspaces conf) [1..9]] ++
  [("M-S-" ++ show k	, windows $ W.shift n) | (n, k) <- zip (workspaces conf) [1..9]] ++ 
  [("M-<Tab>", spawn "rofi -show window")
  ,("M-<F1>", spawn "alacritty -e fish -c ranger")
  ,("M-<F3>", spawn "pcmanfm")
  ,("M-<F5>", spawn "netease-cloud-music")
  ]


myStartupHook = foldl1 (<+>)
  [ setDefaultCursor xC_left_ptr
  , setWMName "LG3D"
  , spawn "conky --config ~/.xmonad/conky/conky"
  , spawn "feh --bg-fill ~/.wallpaper"
  , spawn "nm-applet"
  , spawn "xfce4-power-manager"
  , spawn "pkill fctix; fctix"
  , spawn "pkill xautolock; xautolock -time 10 -locker blurlock"
  --, spawn "pkill picom; picom -b"
  ]

myManageHook = hooks <+> manageDocks <+> manageHook def
	where hooks = composeOne
		[ checkDock	-?> doIgnore
		, isDialog	-?> doFloat
		]
myLayoutHook = avoidStruts $ gaps' $ smartBorders (tiled ||| Mirror tiled||| simpleTabbedBottom ||| Full)
  where
    tiled = ResizableTall 1 (3/100) (1/2) []
    gaps' = gaps [(U, 20), (R, 20), (L, 20), (D, 20)]


myHandleEventHook = docksEventHook <+> handleEventHook def

spawnPipeDzenBar x y w h =  spawnPipe $ unwords
  [ "dzen2"
  , "-dock"
  , "-fn 'FiraCode Nerd Font'"
  , "-e 'button2='"
  , "-x '"++ show x++"' -y '"++ show y++"'"
  , "-w '" ++ show w ++ "' -h '"++ show h ++"'"
  , "-ta 'l'"
  , "-bg " ++ "#1d1d1d"
  , "-fg " ++ "#ebdbb2"
  ]

spawnStatusBar x y w h = spawn $ unwords
  [ "i3status | "
  , "dzen2"
  , "-fn 'FiraCode Nerd Font'"
  , "-dock"
  , "-e 'button2='"
  , "-x " ++ show x
  , "-y " ++ show y
  , "-w " ++ show w
  , "-h " ++ show h
  , "-ta 'r'"
  , "-bg " ++ "#1d1d1d"
  , "-fg " ++ "#ebdbb2"
  ]


spawnTrayerBar w h = spawn $ unwords
  [ "killall trayer;"
  , "trayer"
  , "--edge bottom"
  , "--expand false"
  , "--width " ++ show w
  , "--height " ++ show h
  , "--transparent true"
  , "--tint 0x1d1d1d"
  , "--widthtype pixel"
  , "--align right"
  , "--SetPartialStrut true"
  , "--SetDockType true"
  ]

dzenLogHook :: Handle -> X()
dzenLogHook h = dynamicLogWithPP $ def
  { ppCurrent		= dzenColor "#fabd2f" "#1d1d1d" . pad . wrap "[" "]"
  , ppVisible		= dzenColor "#d79921" "#1d1d1d" . pad . pad
  , ppHidden		= dzenColor "#ebdbb2" "#1d1d1d" . pad . pad
  , ppUrgent		= dzenColor "#ebdbb2" "#1d1d1d" . pad . wrap "{" "}"
  , ppWsSep		= ""
  , ppSep			= "| "
  , ppLayout		= pad . wrap "#" "#"
  , ppTitle		=  (" " ++) . dzenColor "#b16286" "#1d1d1d" . dzenEscape
  , ppOrder		= \(ws:layout:title) -> [ws, layout] 
  , ppOutput		= hPutStrLn h
  }

myXPConfig = def
  { font 		= "xft: Source Code Pro"
  , position 	= Bottom
  , promptKeymap 	= vimLikeXPKeymap
  }

myConfig dzenHandle = ewmh $ def
  { terminal		= useTerminal
  , modMask 		= mod4Mask
  , keys			= keyMap
  , workspaces		= workspaceList
  , logHook		= dzenLogHook dzenHandle 
  , manageHook		= myManageHook
  , layoutHook		= myLayoutHook
  , normalBorderColor = winInactiveBorderColor
  , focusedBorderColor = winActiveBorderColor
  , handleEventHook	= myHandleEventHook
  , borderWidth		= allBorderWidth
  , startupHook		= myStartupHook
  }


main = do
  d <- openDisplay ""
  let w = fromIntegral $ displayWidth d 0 :: Int
      h = fromIntegral $ displayHeight d 0 :: Int
  let barHeight = 22
  let trayerWidth = 160
  dzenBarPipe <- spawnPipeDzenBar 0 (h - barHeight) (w `div` 2) barHeight
  spawnStatusBar (w `div` 2) (h - barHeight) (w `div` 2) barHeight
  xmonad $ myConfig dzenBarPipe
