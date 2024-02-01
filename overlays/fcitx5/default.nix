_: (_: super:{
  rime-data = ./rime-data-flypy;
  fcitx5-rime = super.fcitx5-rime.override {rimeDataPkgs = [./rime];};
})
