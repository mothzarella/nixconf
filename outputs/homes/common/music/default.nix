{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = mkDefault true;
    theme = mkDefault spicePkgs.themes.text;

    enabledExtensions = with spicePkgs.extensions;
      mkDefault [
        adblockify
        hidePodcasts
        shuffle
        skipStats
      ];

    enabledCustomApps = with spicePkgs.apps;
      mkDefault [
        marketplace
        ncsVisualizer
      ];
  };
}
