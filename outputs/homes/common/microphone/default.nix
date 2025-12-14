{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    deepfilternet # noise reduction

    # apps
    helvum # pipewire graphs
    pavucontrol # mixer
  ];

  # deepfilter
  xdg.configFile."pipewire/pipewire.conf.d/deepfilter.conf".text = ''
    context.modules = [
      {
        name = libpipewire-module-filter-chain
        args = {
          node.description = "DeepFilter Noise Canceling Source"
          media.name       = "DeepFilter Noise Canceling Source"
          filter.graph     = {
            nodes = [
              {
                type    = ladspa
                name    = "DeepFilter Mono"
                plugin  = ${config.home.homeDirectory}/.nix-profile/lib/ladspa/libdeep_filter_ladspa.so
                label   = deep_filter_mono
                control = {
                  "Attenuation Limit (dB)" 100
                }
              }
            ]
          }
          audio.rate     = 48000
          audio.position = [MONO]
          capture.props  = {
            node.passive = true
          }
          playback.props = {
            media.class = Audio/Source
          }
        }
      }
    ]
  '';
}
