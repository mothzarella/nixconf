{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    terraformer
  ];

  programs = {
    # system
    quickshell.enable = mkDefault true; # widgets
    fuzzel.enable = mkDefault true;
    kitty.enable = mkDefault true; # terminal
    direnv = {
      enable = mkDefault true;
      enableFishIntegration = mkDefault true;
      nix-direnv.enable = mkDefault true;
    };

    # apps
    vesktop.enable = mkDefault true; # discord alternative
    chromium = {
      enable = mkDefault true;
      package = mkDefault pkgs.brave; # browser
    };

    fastfetch.enable = mkDefault true;
    btop.enable = mkDefault true;
  };
}
