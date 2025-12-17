{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    # git
    sourcegit
    git-graph
  ];

  programs = {
    # system
    quickshell.enable = mkDefault true; # widgets
    fuzzel.enable = mkDefault true;
    kitty.enable = mkDefault true; # terminal
    direnv = {
      enable = mkDefault true;
      nix-direnv.enable = mkDefault true;
    };

    # apps
    vesktop.enable = mkDefault true; # discord alternative
    chromium = {
      enable = mkDefault true;
      package = mkDefault pkgs.brave;
    };

    btop.enable = mkDefault true; # system monitor
    gh.enable = mkDefault true; # github cli
    fastfetch.enable = mkDefault true; # system info
    fd.enable = mkDefault true; # file finder
    fzf.enable = mkDefault true; # fuzzy finder
    ripgrep.enable = mkDefault true; # file search
    zoxide.enable = mkDefault true; # directory navigation
  };
}
