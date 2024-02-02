{
  stdenv,
  lib,
  fetchFromGitHub,
  crudini,
  backgroundPicture,
  ...
}:
let
  buildTheme = { name, version, src, themeIni ? [] }:
    stdenv.mkDerivation rec {
      pname = "sddm-theme-${name}";
      inherit version src;

      buildCommand = ''
        dir=$out/share/sddm/themes/${name}
        doc=$out/share/doc/${pname}

        mkdir -p $dir $doc
        if [ -d $src/${name} ]; then
          srcDir=$src/${name}
        else
          srcDir=$src
        fi
        cp -r $srcDir/* $dir/
        for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
          test -f $f && mv $f $doc/
        done
        chmod 777 $dir/theme.conf

        ${lib.concatMapStringsSep "\n" (e: ''
          ${crudini}/bin/crudini --set --inplace $dir/theme.conf \
            "${e.section}" "${e.key}" "${e.value}"
        '') themeIni}
      '';
    };
in {
  sddm-sugar-dark = buildTheme rec {
    name = "sugar-dark";
    version = "1.2";
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
    themeIni = [
      { section = "General"; key = "background"; value = backgroundPicture; }
      { section = "General"; key = "MainColor"; value = "white"; }
      { section = "General"; key = "AccentColor"; value = "#fb884f"; }
      { section = "General"; key = "BackgroundColor"; value = "#444"; }
    ];
  };
}
