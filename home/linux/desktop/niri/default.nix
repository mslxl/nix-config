{
  mylib,
  pkgs,
  niri,
  lib,
  config,
  ...
} @ args: let
  cfg = config.modules.desktop.niri;
  niri-pkg = niri.packages.${pkgs.system}.niri-stable.overrideAttrs (super: {
    # preBuild =
    #   ''
    #     ulimit -Sn 8192
    #   ''
    #   + (super.preBuild or "");
    patches = [
      # Fix wemeet screenshare
      (pkgs.fetchpatch {
        url = "https://github.com/YaLTeR/niri/pull/1791.patch";
        hash = "sha256-dbxN3aZ2fyokQ5L2v4CO8nt+RbVAY0CArzRMwpybvhk=";
      })
    ];
  });
  # niri-pkg = pkgs.niri;
in {
  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "niri compositor";
    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "niri configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  imports = [
    niri.homeModules.niri
  ];

  config = lib.mkIf (config.modules.desktop.type == "niri") (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          swww
          wl-clipboard # copying and pasting
          hyprpicker # color picker
          brightnessctl
          hyprshot # screen shot
          wf-recorder # screen recording
          # audio
          alsa-utils # provides amixer/alsamixer/...
        ];

        home.activation.swww-refresh = lib.hm.dag.entryAfter ["writeBoundary"] ''
          run bash -c "${pkgs.swww}/bin/swww img ${config.modules.desktop.background.source} || true"
        '';

        # xdg.configFile = let
        #   mkSymlink = config.lib.file.mkOutOfStoreSymlink;
        #   confPath = "${config.home.homeDirectory}/nix/nix-config/home/linux/desktop/niri/conf";
        # in {
        #   "mako".source = mkSymlink "${confPath}/mako";
        #   "waybar".source = mkSymlink "${confPath}/waybar";
        #   "wlogout".source = mkSymlink "${confPath}/wlogout";
        #   "hypr/hypridle.conf".source = mkSymlink "${confPath}/hypridle.conf";
        # };
        xdg.configFile."mako".source = ./conf/mako;
        xdg.configFile."waybar".source = ./conf/waybar;
        xdg.configFile."wlogout".source = ./conf/wlogout;
        xdg.configFile."hypr/hypridle.conf".source = ./conf/hypridle.conf;

        # status bar
        programs.waybar = {
          enable = true;
          systemd.enable = true;
        };
        catppuccin.waybar.enable = false;
        # screen locker
        programs.swaylock.enable = true;

        # Logout Menu
        programs.wlogout.enable = true;
        catppuccin.wlogout.enable = false;
        # Hyprland idle daemon
        services.hypridle.enable = true;

        # notification daemon, the same as dunst
        services.mako.enable = true;
        catppuccin.mako.enable = false;
      }
      {
        home.packages = with pkgs; [
          xwayland-satellite
        ];
        xdg.portal = {
          enable = true;

          config = {
            common = {
              # Use xdg-desktop-portal-gtk for every portal interface...
              default = [
                "gtk"
                "hyprland"
              ];
              # except for the secret portal, which is handled by gnome-keyring
              "org.freedesktop.impl.portal.Secret" = [
                "gnome-keyring"
              ];
            };
          };

          # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
          # This will make xdg-open use the portal to open programs,
          # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
          # xdg-open is used by almost all programs to open a unknown file/uri
          # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
          # and vscode has open like `External Uri Openers`
          xdgOpenUsePortal = true;
          # ls /etc/profiles/per-user/ryan/share/xdg-desktop-portal/portals
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk # for provides file picker / OpenURI
            # xdg-desktop-portal-wlr
            xdg-desktop-portal-hyprland # for Hyprland
          ];
        };

        programs.niri = {
          enable = true;
          config = cfg.settings;
          package = niri-pkg;
        };

        # NOTE: this executable is used by greetd to start a wayland session when system boot up
        # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
        home.file.".wayland-session" = {
          source = pkgs.writeScript "init-session" ''
            # trying to stop a previous niri session
            systemctl --user is-active niri.service && systemctl --user stop niri.service
            # and then we start a new one
            # /run/current-system/sw/bin/niri-session
            ${niri-pkg}/bin/niri-session
          '';
          executable = true;
        };
      }
      (import ./settings.nix niri)
      (import ./keybindings.nix niri)
      (import ./spawn-at-startup.nix args)
      (import ./windowrules.nix niri)
      (import ./apps args)
    ]
  );
}
