{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ario
    cli-visualizer
    mpc-cli
  ];
  services.mpd = {
    enable = true;
    package = pkgs-unstable.mpd;
    musicDirectory = "${config.xdg.userDirs.music}";
    extraConfig = ''
      audio_output {
          type     "pipewire"
          name     "PipeWire Sound Server"
          enabled  "yes"
      }
      audio_output {
          type     "fifo"
          name     "my_fifo"
          path     "/tmp/mpd.fifo"
          format   "44100:16:2"
      }
    '';
    network = {
      listenAddress = "any";
      port = 6600;
      startWhenNeeded = false;
    };
  };
  programs.ncmpcpp = {
    enable = true;
    package = pkgs-unstable.ncmpcpp.override {
      visualizerSupport = true;
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
    ];
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "+|";
    };
  };
}
