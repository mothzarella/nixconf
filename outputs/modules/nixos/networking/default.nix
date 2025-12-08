{...}: {
  # imports =
  #   lib.scanTree {
  #     filter = name: type: path: depth:
  #       type == "regular" && name == "default.nix" && depth == 1;
  #   }
  #   ./.;
  imports = [
    ./dns.nix
    ./optimization.nix
  ];
}
