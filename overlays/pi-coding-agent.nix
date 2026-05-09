{lib, ...}: (_: super: {
  pi-coding-agent = super.pi-coding-agent.overrideAttrs (old: {
    postFixup = "wrapProgram $out/bin/pi --prefix PATH : ${
      lib.makeBinPath [super.ripgrep super.nodejs]
    }";
  });
})
