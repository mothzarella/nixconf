{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../. # base configuration

    ../../common/editors

    ./niri
    ./theme
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    packages = with pkgs; [
      libnotify

      # TODO: manage qt with devenv
      kdePackages.qtdeclarative

      nautilus
      nix-search

      terraform
    ];
  };

  xdg.configFile = {
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
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
