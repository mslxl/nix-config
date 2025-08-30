{
  username,
  config,
  ...
}: {
  # Don't allow mutation of users outside the config.
  # users.mutableUsers = false;
  # TODO

  users.groups = {
    "${username}" = {};
    podman = {};
    wireshark = {};
    # for android platform tools's udev rules
    adbusers = {};
    dialout = {};
    # misc
    uinput = {};
  };

  users.users."${username}" = {
    home = "/home/${username}";
    isNormalUser = true;
    extraGroups = [
      username
      "users"
      "networkmanager"
      "wheel"
      "podman"
      "wireshark"
      "adbusers"
      "libvirtd"
    ];
  };
}
