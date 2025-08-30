{pkgs, ...}: {
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # microsoft fonts for school work
      corefonts
      vistafonts

      # icons & emoji
      material-design-icons
      font-awesome
      font-awesome_5
      noto-fonts-emoji

      # 霞鹜文楷 屏幕阅读版
      # https://github.com/lxgw/LxgwWenKai-Screen
      lxgw-wenkai-screen

      # Maple Mono NF CN (连字 未微调版，适用于高分辨率屏幕)
      # Full version, embed with nerdfonts icons, Chinese and Japanese glyphs
      # https://github.com/subframe7536/maple-font
      maple-mono.NF-CN-unhinted

      fira
      jetbrains-mono
      source-sans
      source-serif
      source-han-sans
      source-han-serif
      liberation_ttf_v2

      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];

    fontconfig.defaultFonts = {
      serif = [
        # 西文: 衬线字体（笔画末端有修饰(衬线)的字体，通常用于印刷。）
        "Source Sans 3"
        # 中文: 宋体（港台称明體）
        "Source Han Serif SC" # 思源宋体
        "Source Han Serif TC"
      ];
      sansSerif = [
        # 西文: 无衬线字体（指笔画末端没有修饰(衬线)的字体，通常用于屏幕显示）
        "Source Serif 4"
        # 中文: 黑体
        "LXGW WenKai Screen" # 霞鹜文楷 屏幕阅读版
        "Source Han Sans SC" # 思源黑体
        "Source Han Sans TC"
      ];
      monospace = [
        # 中文
        "Maple Mono NF CN" # 中英文宽度完美 2:1 的字体
        "Source Han Mono SC" # 思源等宽
        "Source Han Mono TC"
        # 西文
        "JetBrainsMono Nerd Font"
      ];
      emoji = ["Noto Color Emoji"];
    };
    fontconfig.antialias = true; # 抗锯齿
  };

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = with pkgs; [
      {
        name = "Maple Mono NF CN";
        package = maple-mono.NF-CN-unhinted;
      }
      {
        name = "JetBrainsMono Nerd Font";
        package = nerd-fonts.jetbrains-mono;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=16";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}
