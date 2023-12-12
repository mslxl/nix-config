
{stdenv,
 dpkg,
 wrapGAppsHook,
 fetchurl, 

 lib,
 glib,
 glibc,
 electron_25, 
 nss,
 libappindicator,
 libsecret,
 libuuid,
 gsettings-desktop-schemas,
 makeWrapper,
 gtk3}:
let
  version = "1.0.80";
in stdenv.mkDerivation  {
  name = "dida365-${version}";
  system = "x86_64-linux";

  nativeBuildInputs = [
    wrapGAppsHook
    dpkg
  ];
  src = fetchurl {
    url = "https://cdn.dida365.cn/download/linux/linux_deb_x64/dida-1.0.80-amd64.deb";
    hash = "sha256-PK5cDA9JGQ83eVJ9rpksPwpFqfCs/tsi4jOXZSdQ5kc=";
  };
  buildInputs = [
    nss
    libappindicator
    libsecret
    libuuid
    makeWrapper
    glib
    glibc
    gsettings-desktop-schemas
    gtk3
  ];
  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  # Extract and copy executable in $out/bin
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share $out/opt
    mv opt/dida/resources $out/opt/dida
    mv usr/share/{applications,icons,doc} $out/share/
    sed -i "s|Exec=.*|Exec=$out/bin/dida|" $out/share/applications/*.desktop
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_25}/bin/electron $out/bin/dida \
        --add-flags $out/opt/dida/app.asar \
        "''${gappsWrapperArgs[@]}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "Dida365";
    homepage = https://dida365.com;
    # license = licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}