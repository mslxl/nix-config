{
  niri,
  config,
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
    ] ++ (
      builtins.map (prog: (leaf "spawn-at-startup" [prog])) config.modules.desktop.exec.once
    ) ++ (
      builtins.map (prog: (leaf "spawn" [prog])) config.modules.desktop.exec.always
    );
}
