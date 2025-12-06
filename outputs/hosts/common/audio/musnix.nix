{
  inputs,
  lib,
  ...
}:
with lib; {
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  musnix = {
    enable = mkDefault true;
    alsaSeq.enable = mkDefault true;
    ffado.enable = mkDefault true;
    rtcqs.enable = mkDefault true;
    kernel.realtime = mkDefault true;
  };
}
