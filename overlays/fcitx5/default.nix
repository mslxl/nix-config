_: (_: super: let
  using-rime-data = ./rime-data-tigger;
in {
  rime-data = using-rime-data;
  fcitx5-rime = super.fcitx5-rime.override {rimeDataPkgs = [using-rime-data];};
})
