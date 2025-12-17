{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  default = mkShellNoCC {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = [
      nix
      home-manager
      git
    ];
  };

  # languages
  dev = import ./dev pkgs;
}
