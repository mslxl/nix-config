{stdenv,
 fetchurl, 

 lib,
 appimageTools,
 makeDesktopItem
 }:
let
  pname = "qqnt";
  version = "3.2.2";
  name = "${pname}-${version}";
  hash = "sha256-UUkuO5eY9kunPEc/uIcTVpUWi2awoUHb1vFPmzppR/o=";

  src = fetchurl {
    url = "https://dldir1.qq.com/qqfile/qq/QQNT/fd2e886e/linuxqq_3.2.2-18394_x86_64.AppImage";
    inherit hash;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "QQ";
    exec = pname;
    icon = "qq";
    categories = [
      "Chat"
      "Network"
      "InstantMessaging"
    ];
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  # multiArch = false;

  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}

    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
    chmod -R +w $out/share
  '';

  meta = with lib; {
    description = "QQ";
    homepage = https://im.qq.com;
    # license = licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}