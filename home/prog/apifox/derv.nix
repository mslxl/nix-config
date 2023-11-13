{stdenv,
 fetchzip, 

 lib,
 unzip,
 appimageTools,
 makeDesktopItem
 }:
let
  pname = "apifox";
  version = "3.2.1";
  name = "${pname}-${version}";
  hash = "sha256-14p5i0UgZCBggmdmJQC9NTmHV1zAh6e+piQAXsrq3Ro=";

  src = fetchzip {
    url = "https://cdn.apifox.com/download/Apifox-linux-latest.zip";
    stripRoot=false;
    inherit hash;
  };
  appimage-file = "${src}/Apifox.AppImage";

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "ApiFox";
    exec = pname;
    icon = "apifox";
    categories = [
      "Network"
      "Development"
    ];
  };

  appimageContents = appimageTools.extractType2 {
    inherit name;
    src = appimage-file;
  };
in appimageTools.wrapType2 rec {
  inherit name;

  src = appimage-file;

  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}

    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
    chmod -R +w $out/share
  '';

  meta = with lib; {
    description = "ApiFox";
    homepage = https://apifox.com;
    # license = licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}