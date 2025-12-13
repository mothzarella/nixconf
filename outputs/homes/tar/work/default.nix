{pkgs, ...}: {
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
    };
  };
}
