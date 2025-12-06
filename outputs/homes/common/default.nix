{
  lib,
  pkgs,
  ...
}: {
  home = {
    username = lib.mkDefault "tar";
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isDarwin
      then "/Users/tar"
      else "/home/tar"
    );
    stateVersion = lib.mkDefault "25.05";
  };

  programs.home-manager.enable = lib.mkDefault true;
}
