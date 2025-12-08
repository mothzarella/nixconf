{
  self,
  pkgs,
  ...
}: {
  imports = [
    self.outputs.nixosModules.virtualisation
  ];

  virtualisation = {
    docker = {
      enable = true;
      compose.enable = true;
    };

    libvirtd = {
      enable = true;
      members = ["tar"];
      allowedBridges = [
        "br0"
        "virbr0"
      ];

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    qemu = {
      enable = true;
      virtManager.enable = true;
    };
  };
}
