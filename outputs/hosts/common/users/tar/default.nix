{
  config,
  pkgs,
  ...
}: let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users."tar" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifGroupExist [
      "wheel"

      # extra groups
      "audio"
      "docker"
      "git"
      "libvirtd"
      "network"
      "video"
      "wireshark"
    ];
  };

  programs.fish.enable = true;
}
