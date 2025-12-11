{
  self,
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
}
