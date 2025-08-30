{lib, ...}: (_: super: let
  tools = [super.wakatime];
  gcc = [super.gcc super.clang-tools];
  jdk = [super.openjdk_headless super.java-language-server];
  py = [super.python3 super.pylyzer];

  deps = lib.lists.flatten [gcc jdk py tools];
in {
  cpeditor = super.cpeditor.overrideAttrs (super: {
    buildInputs = super.buildInputs ++ deps;

    postFixup =
      super.postFixup
        or ""
      + ''
        wrapProgram "$out/bin/cpeditor" \
          --set PATH ${lib.makeBinPath deps}
      '';
  });
})
