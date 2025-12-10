{lib, ...}:
with lib; {
  services = {
    # enable CPU to print documents
    printing.enable = mkDefault true;

    # autodiscover printers
    avahi = {
      enable = mkDefault true;
      nssmdns4 = mkDefault true;
      openFirewall = mkDefault true;
    };
  };
}
