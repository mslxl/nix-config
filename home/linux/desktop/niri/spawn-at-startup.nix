{
  niri,
  config,
  pkgs,
  ...
}: {
  programs.niri.config = let
    inherit
      (niri.lib.kdl)
      node
      plain
      leaf
      flag
      ;
  in
    [
      (leaf "spawn-at-startup" ["swww-daemon"])

      (leaf "spawn-at-startup"
        (let
          prog-seq = pkgs.writeShellScript "delay-launch-msg-prog" (builtins.concatStringsSep "\nsleep 1\n" [
            "thunderbird &"
            "AyuGram &"
            "${pkgs.gtk3}/bin/gtk-launch wechat &"
            "qq &"
            "sleep 1; niri msg action focus-workspace 2"
          ]);
        in ["${prog-seq}"]))
    ]
    ++ (
      builtins.map (prog: (leaf "spawn-at-startup" [prog])) config.modules.desktop.exec.once
    )
    ++ (
      builtins.map (prog: (leaf "spawn" [prog])) config.modules.desktop.exec.always
    );
}
