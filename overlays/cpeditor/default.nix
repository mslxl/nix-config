{lib, ...}: (_: super: let 
  tools = with super; [ wakatime ];
  gcc = with super; [ gcc clang-tools ];
  jdk = with super; [ openjdk_headless java-language-server ];
  py = with super; [ python3 pylyzer ];
in {
  cpeditor = super.cpeditor.overrideAttrs (super:{
      buildInputs = super.buildInputs ++ [ gcc jdk py ];

      postFixup =
        super.postFixup
        or ""
        + ''
          wrapProgram "$out/bin/cpeditor" \
            --set JAVA_HOME ${jdk} \
            --set PATH ${lib.makeBinPath (lib.lists.flatten [ gcc jdk py tools ])}
        '';
  });
})



