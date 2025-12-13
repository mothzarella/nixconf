{
  lib,
  pkgs,
  ...
}:
with lib; {
  home = {
    username = mkDefault "tar";
    homeDirectory = mkDefault (
      if pkgs.stdenv.isDarwin
      then "/Users/tar"
      else "/home/tar"
    );

    stateVersion = mkDefault "25.05";
  };

  programs.home-manager.enable = mkDefault true;

  systemd.user.startServices = mkDefault "sd-switch";
}
