{lib, ...}:
with lib; {
  imports = [
    ./musnix.nix
  ];

  security.rtkit.enable = mkDefault true;

  services = {
    # PulseAudio disabled in favor of PipeWire
    pulseaudio.enable = mkDefault false;
    pipewire = {
      enable = mkDefault true;
      alsa = {
        enable = mkDefault true;
        support32Bit = mkDefault true;
      };

      pulse.enable = mkDefault true;
      jack.enable = mkDefault true;
    };
  };
}
