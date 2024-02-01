rec {
  username = "mslxl";
  useremail = "i@mslxl.com";

  allSystemAttrs = {
    x64_system = "x86_64-linux";
  };

  allSystems = builtins.attrValues allSystemAttrs;
}
