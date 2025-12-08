{lib, ...}:
with lib; {
  # GC & optimizations
  nix = {
    gc = {
      automatic = mkDefault true;
      dates = mkDefault "00:01";
      options = mkDefault "--delete-older-than 10d";
    };

    optimise = {
      automatic = mkDefault true;
      dates = mkDefault ["05:00"];
    };
  };

  # maintenance
  system.autoUpgrade = {
    enable = mkDefault true;
    allowReboot = mkDefault true;
    dates = mkDefault "02:00";
    randomizedDelaySec = mkDefault "45min";
  };
}
