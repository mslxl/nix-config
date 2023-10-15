
{stdenv,
 dpkg,
 wrapGAppsHook,
 fetchurl, 

 lib,
 glib,
 electron_25, 
 gsettings-desktop-schemas,
 makeWrapper,
 gtk3,
 withPandoc ? true,
 pandoc}:
let
  version = "1.7.4";
in stdenv.mkDerivation  {
  name = "typora-${version}";
  system = "x86_64-linux";

  nativeBuildInputs = [
    wrapGAppsHook
    dpkg
  ];
  src = fetchurl {
    url = "https://download.typora.io/linux/typora_1.7.5_amd64.deb";
    hash = "sha256-4Q+fx1kNu98+nxnI/7hLhE6zOdNsaAiAnW6xVd+hZOI=";
  };
  buildInputs = [
    makeWrapper
    glib
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
    mkdir -p $out/bin $out/share
    {
      cd usr
      mv share/typora/resources $out/share/typora
      mv share/{applications,icons,doc} $out/share/
    }
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_25}/bin/electron $out/bin/typora \
        --add-flags $out/share/typora/app.asar \
        "''${gappsWrapperArgs[@]}" \
        ${lib.optionalString withPandoc ''--prefix PATH : "${lib.makeBinPath [ pandoc ]}"''} \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "Typora";
    homepage = https://typora.io;
    # license = licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}