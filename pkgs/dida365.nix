{
  stdenv,
  fetchurl,
  dpkg,
  lib,
  glib,
  nss,
  nspr,
  cups,
  dbus,
  libdrm,
  mesa,
  buildFHSEnv,
  gtk3,
  libnotify,
  libxkbcommon,
  pango,
  expat,
  cairo,
  libGL,
  libgbm,
  ...
}: let
  pname = "dida365";
  version = "6.0.30";
  src = fetchurl {
    url = "https://cdn.dida365.cn/download/linux/linux_deb_x64/dida-${version}-amd64.deb";
    hash = "sha256-C9zGBV52Br5pOTliXNgABMwTmdAMTl1B3nzHdlniRR4=";
  };

  dida365Base = stdenv.mkDerivation {
    inherit pname version src;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [dpkg];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/opt $out/usr
      mv usr/share $out/usr
      mv opt/dida $out/opt
      ln -s $out/opt/dida/dida $out/bin/dida

      runHook postInstall
    '';
  };

  dida365FHS = buildFHSEnv {
    name = "dida365-fhs";
    targetPkgs = pkgs:
      (with pkgs; [
        dida365Base
        udev
        alsa-lib
        glib
        nss
        nspr
        atk
        cups
        dbus
        gtk3
        libdrm
        mesa
        libnotify
        libxkbcommon
        pango
        cairo
        expat
        libGL
        libgbm
      ])
      ++ (with pkgs.xorg; [
        libX11
        libXcursor
        libXrandr
        libXcomposite
        libXdamage
        libXext
        libXfixes
        libxcb
      ]);
    runScript = ''
      dida $*
    '';
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      ln -s ${dida365FHS}/bin/dida365-fhs $out/bin/dida
      cp -r ${dida365Base}/usr/share/ $out
      chmod -R u+w $out/share/applications/
      sed -i "s@/opt/dida/dida@$out/bin/dida@g" $out/share/applications/*.desktop
      runHook postInstall
    '';

    meta = with lib; {
      description = "滴答清单，一款轻便的待办事项(Todo)、日程管理(GTD)应用，全球逾千万用户的共同选择。它可以帮你制定项目计划、设置会议提醒、 安排行程规划、保持工作专注，还能用于记录备忘、整理购物清单。滴答清单集计划表、备忘录、日程清单、笔记、便签、闹钟、日历、番茄钟、在线协作多种实用功能于一体，是你高效办公、目标管理、习惯养成及便捷生活的得力助手。
";
      homepage = "https://dida365.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [mslxl];
      platforms = ["x86_64-linux"];
      mainProgram = "dida";
    };
  }
