{catppuccin, ...}: {
  imports = [
    catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    # Keep current explicit enrollment behavior before upstream flips defaults.
    autoEnable = true;
    # The default `enable` value for all available programs.
    enable = true;
    # one of "latte", "frappe", "macchiato", "mocha"
    flavor = "mocha";
    # one of "blue", "flamingo", "green", "lavender", "maroon", "mauve", "peach", "pink", "red", "rosewater", "sapphire", "sky", "teal", "yellow"
    accent = "pink";
  };
}
