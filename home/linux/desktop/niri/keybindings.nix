niri: {
  programs.niri.config = let
    inherit
      (niri.lib.kdl)
      node
      plain
      leaf
      flag
      ;
  in [
    (plain "binds" [
      # Keys consist of modifiers separated by + signs, followed by an XKB key name
      # in the end. To find an XKB name for a particular key, you may use a program
      # like wev.
      #
      # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
      # when running as a winit window.
      #
      # Most actions that you can bind here can also be invoked programmatically with
      # `niri msg action do-something`.

      # Mod-Shift-/, which is usually the same as Mod-?,
      # shows a list of important hotkeys.
      (plain "Mod+Shift+Slash" [(flag "show-hotkey-overlay")])

      # Suggested binds for running programs: terminal, app launcher, screen locker.
      (plain "Mod+Return" [(leaf "spawn" ["kitty"])])
      (plain "Mod+Ctrl+Return" [(leaf "spawn" ["anyrun"])])
      (plain "Mod+E" [(leaf "spawn" ["kitty yazi"])])
      (plain "Ctrl+Alt+L" [(leaf "spawn" ["swaylock"])])

      # You can also use a shell:
      # (plain "Mod+T" [(leaf "spawn" [ "bash" "-c" "notify-send hello && exec alacritty" ])])

      # Example volume keys mappings for PipeWire & WirePlumber.
      (plain "XF86AudioRaiseVolume" [
        (leaf "spawn" [
          "pactl"
          "set-sink-volume"
          "@DEFAULT_SINK@"
          "+5%"
        ])
      ])
      (plain "XF86AudioLowerVolume" [
        (leaf "spawn" [
          "pactl"
          "set-sink-volume"
          "@DEFAULT_SINK@"
          "-5%"
        ])
      ])
      (plain "XF86AudioMute" [
        (leaf "spawn" [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ])
      ])

      (plain "XF86MonBrightnessUp" [
        (leaf "spawn" [
          "brightnessctl"
          "-q"
          "s"
          "+10%"
        ])
      ])
      (plain "XF86MonBrightnessDown" [
        (leaf "spawn" [
          "brightnessctl"
          "-q"
          "s"
          "10%-"
        ])
      ])

      (plain "Mod+Shift+C" [(flag "close-window")])

      (plain "Mod+Left" [(flag "focus-column-left")])
      (plain "Mod+Down" [(flag "focus-window-down")])
      (plain "Mod+Up" [(flag "focus-window-up")])
      (plain "Mod+Right" [(flag "focus-column-right")])
      (plain "Mod+H" [(flag "focus-column-left")])
      (plain "Mod+J" [(flag "focus-window-down")])
      (plain "Mod+K" [(flag "focus-window-up")])
      (plain "Mod+L" [(flag "focus-column-right")])

      (plain "Mod+Shift+Left" [(flag "move-column-left")])
      (plain "Mod+Shift+Down" [(flag "move-window-down")])
      (plain "Mod+Shift+Up" [(flag "move-window-up")])
      (plain "Mod+Shift+Right" [(flag "move-column-right")])
      (plain "Mod+Shift+H" [(flag "move-column-left")])
      (plain "Mod+Shift+J" [(flag "move-window-down")])
      (plain "Mod+Shift+K" [(flag "move-window-up")])
      (plain "Mod+Shift+L" [(flag "move-column-right")])

      # Alternative commands that move across workspaces when reaching
      # the first or last window in a column.
      # (plain "Mod+J"      [(flag "focus-window-or-workspace-down")])
      # (plain "Mod+K"      [(flag "focus-window-or-workspace-up")])
      # (plain "Mod+Ctrl+J" [(flag "move-window-down-or-to-workspace-down")])
      # (plain "Mod+Ctrl+K" [(flag "move-window-up-or-to-workspace-up")])

      (plain "Mod+Home" [(flag "focus-column-first")])
      (plain "Mod+End" [(flag "focus-column-last")])
      (plain "Mod+Ctrl+Home" [(flag "move-column-to-first")])
      (plain "Mod+Ctrl+End" [(flag "move-column-to-last")])

      (plain "Mod+Ctrl+Left" [(flag "focus-monitor-left")])
      (plain "Mod+Ctrl+Down" [(flag "focus-monitor-down")])
      (plain "Mod+Ctrl+Up" [(flag "focus-monitor-up")])
      (plain "Mod+Ctrl+Right" [(flag "focus-monitor-right")])
      (plain "Mod+Ctrl+H" [(flag "focus-monitor-left")])
      (plain "Mod+Ctrl+J" [(flag "focus-monitor-down")])
      (plain "Mod+Ctrl+K" [(flag "focus-monitor-up")])
      (plain "Mod+Ctrl+L" [(flag "focus-monitor-right")])

      (plain "Mod+Shift+Ctrl+Left" [(flag "move-column-to-monitor-left")])
      (plain "Mod+Shift+Ctrl+Down" [(flag "move-column-to-monitor-down")])
      (plain "Mod+Shift+Ctrl+Up" [(flag "move-column-to-monitor-up")])
      (plain "Mod+Shift+Ctrl+Right" [(flag "move-column-to-monitor-right")])
      (plain "Mod+Shift+Ctrl+H" [(flag "move-column-to-monitor-left")])
      (plain "Mod+Shift+Ctrl+J" [(flag "move-column-to-monitor-down")])
      (plain "Mod+Shift+Ctrl+K" [(flag "move-column-to-monitor-up")])
      (plain "Mod+Shift+Ctrl+L" [(flag "move-column-to-monitor-right")])

      # Alternatively, there are commands to move just a single window:
      # (plain "Mod+Shift+Ctrl+Left" [(flag "move-window-to-monitor-left")])
      # ...

      # And you can also move a whole workspace to another monitor:
      # (plain "Mod+Shift+Ctrl+Left" [(flag "move-workspace-to-monitor-left")])
      # ...

      (plain "Mod+Page_Down" [(flag "focus-workspace-down")])
      (plain "Mod+Page_Up" [(flag "focus-workspace-up")])
      (plain "Mod+I" [(flag "focus-workspace-down")])
      (plain "Mod+U" [(flag "focus-workspace-up")])
      (plain "Mod+Shift+Page_Down" [(flag "move-column-to-workspace-down")])
      (plain "Mod+Shift+Page_Up" [(flag "move-column-to-workspace-up")])
      (plain "Mod+Shift+I" [(flag "move-column-to-workspace-down")])
      (plain "Mod+Shift+U" [(flag "move-column-to-workspace-up")])

      # Alternatively, there are commands to move just a single window:
      # (plain "Mod+Ctrl+Page_Down" [(flag "move-window-to-workspace-down")])
      # ...

      (plain "Mod+Ctrl+Page_Down" [(flag "move-workspace-down")])
      (plain "Mod+Ctrl+Page_Up" [(flag "move-workspace-up")])
      (plain "Mod+Ctrl+I" [(flag "move-workspace-down")])
      (plain "Mod+Ctrl+U" [(flag "move-workspace-up")])

      # You can refer to workspaces by index. However, keep in mind that
      # niri is a dynamic workspace system, so these commands are kind of
      # "best effort". Trying to refer to a workspace index bigger than
      # the current workspace count will instead refer to the bottommost
      # (empty) workspace.
      #
      # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
      # will all refer to the 3rd workspace.
      (plain "Mod+1" [(leaf "focus-workspace" 1)])
      (plain "Mod+2" [(leaf "focus-workspace" 2)])
      (plain "Mod+3" [(leaf "focus-workspace" 3)])
      (plain "Mod+4" [(leaf "focus-workspace" 4)])
      (plain "Mod+5" [(leaf "focus-workspace" 5)])
      (plain "Mod+6" [(leaf "focus-workspace" 6)])
      (plain "Mod+7" [(leaf "focus-workspace" 7)])
      (plain "Mod+8" [(leaf "focus-workspace" 8)])
      (plain "Mod+9" [(leaf "focus-workspace" 9)])
      (plain "Mod+0" [(leaf "focus-workspace" "0other")])
      (plain "Mod+Shift+1" [(leaf "move-column-to-workspace" 1)])
      (plain "Mod+Shift+2" [(leaf "move-column-to-workspace" 2)])
      (plain "Mod+Shift+3" [(leaf "move-column-to-workspace" 3)])
      (plain "Mod+Shift+4" [(leaf "move-column-to-workspace" 4)])
      (plain "Mod+Shift+5" [(leaf "move-column-to-workspace" 5)])
      (plain "Mod+Shift+6" [(leaf "move-column-to-workspace" 6)])
      (plain "Mod+Shift+7" [(leaf "move-column-to-workspace" 7)])
      (plain "Mod+Shift+8" [(leaf "move-column-to-workspace" 8)])
      (plain "Mod+Shift+9" [(leaf "move-column-to-workspace" 9)])
      (plain "Mod+Shift+0" [(leaf "move-column-to-workspace" 0)])

      # Alternatively, there are commands to move just a single window:
      # (plain "Mod+Ctrl+1" [(leaf "move-window-to-workspace" 1)])

      (plain "Mod+Comma" [(flag "consume-window-into-column")])
      (plain "Mod+Period" [(flag "expel-window-from-column")])

      # There are also commands that consume or expel a single window to the side.
      # (plain "Mod+BracketLeft"  [(flag "consume-or-expel-window-left")])
      # (plain "Mod+BracketRight" [(flag "consume-or-expel-window-right")])

      (plain "Mod+R" [(flag "switch-preset-column-width")])
      (plain "Mod+F" [(flag "maximize-column")])
      (plain "Mod+Shift+F" [(flag "fullscreen-window")])
      (plain "Mod+C" [(flag "center-column")])

      # Finer width adjustments.
      # This command can also:
      # * set width in pixels: "1000"
      # * adjust width in pixels: "-5" or "+5"
      # * set width as a percentage of screen width: "25%"
      # * adjust width as a percentage of screen width: "-10%" or "+10%"
      # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
      # (leaf "set-column-width" "100") will make the column occupy 200 physical screen pixels.
      (plain "Mod+Minus" [(leaf "set-column-width" "-10%")])
      (plain "Mod+Equal" [(leaf "set-column-width" "+10%")])

      # Finer height adjustments when in column with other windows.
      (plain "Mod+Shift+Minus" [(leaf "set-window-height" "-10%")])
      (plain "Mod+Shift+Equal" [(leaf "set-window-height" "+10%")])

      # Actions to switch layouts.
      # Note: if you uncomment these, make sure you do NOT have
      # a matching layout switch hotkey configured in xkb options above.
      # Having both at once on the same hotkey will break the switching,
      # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
      # (plain "Mod+Space"       [(leaf "switch-layout" "next")])
      # (plain "Mod+Shift+Space" [(leaf "switch-layout" "prev")])

      # Take an area screenshot. Select the area to screenshot with mouse
      (plain "Print" [(flag "screenshot")])
      # Take a screenshot of the focused monitor
      (plain "Ctrl+Print" [(flag "screenshot-screen")])
      # Take a screenshot of the focused window
      (plain "Alt+Print" [(flag "screenshot-window")])

      (plain "Mod+Shift+E" [(leaf "spawn" ["wlogout"])])

      (plain "Mod+Shift+P" [(flag "power-off-monitors")])

      # This debug bind will tint all surfaces green, unless they are being
      # directly scanned out. It's therefore useful to check if direct scanout
      # is working.
      # (plain "Mod+Shift+Ctrl+T" [(flag "toggle-debug-tint")])
    ])
  ];
}
