{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../. # base configuration

    ../../common/editors
    ../../common/microphone
    ../../common/music

    ./niri
    ./theme
  ];

  home = {
    sessionVariables = {
      # niri
      # NOTE: do not set `GDK_BACKEND`
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";

      # nvidia
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    packages = with pkgs; [
      libnotify
      nix-search # overlay
      sonar-scanner-cli-minimal

      # apps
      nemo # cinnamon file explorer

      # TODO: manage qt with devshell
      kdePackages.qtdeclarative
    ];
  };

  xdg.configFile = {
    # uwsm
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    # quickshell
    "quickshell" = {
      source = ./theme/quickshell;
      recursive = true;
    };
  };

  services = {
    mako = {
      enable = true;
      settings = {
        actions = true;
        anchor = "top-right";
        icons = true;
      };
    };
  };
}
