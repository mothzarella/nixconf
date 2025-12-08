{lib, ...}: {
  imports = [
    ./docker.nix
    ./qemu.nix
  ];
  # imports =
  #   lib.scanTree {
  #     filter = name: _type: _path: depth:
  #       name == "default.nix" && depth == 1;
  #   }
  #   ./.;
}
