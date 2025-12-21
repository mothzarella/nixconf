{
  config,
  pkgs,
  ...
}: let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  programs.fish.enable = true;

  users.users."tar" = {
    isNormalUser = true;
    initialHashedPassword = "$6$8kLu3bAcWeO9SOnt$Su3tvQ/ng.Whtyf/woPFsU0bny.ahg0ya13rTlLhSmBPW/QZkjlrLJG1vn9pBxDxpaaQmyq3f.BXF8BDAOjTH.";
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
}
