{
  pkgs,
  mylib,
  ...
}: {
  programs.obs-studio = {
    enable = true;
  };
  xdg.mimeApps.defaultApplications =
    {
      "image/x-xcf" = ["gimp.desktop"];
      "video/*" = ["mpv.desktop"];
    }
    // (mylib.attrs.listToAttrs [
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/webp"
    ] (_: ["com.github.weclaw1.ImageRoll.desktop"]));
  home.packages = [
    pkgs.gimp
    pkgs.image-roll
    pkgs.mpv
  ];
}
