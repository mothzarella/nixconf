{
  lib,
  pkgs,
  ...
}:
with lib; {
  xdg.portal = {
    enable = mkDefault true;
    xdgOpenUsePortal = mkDefault true;
    extraPortals = with pkgs;
      mkDefault [
        xdg-desktop-portal-gnome

        # fallback
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr # overlay
      ];
  };
}
