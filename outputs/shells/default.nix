{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  default = pkgs.mkShellNoCC {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
    ];
  };

  # languages
  go = import ./languages/go pkgs;
  terraform = import ./languages/terraform pkgs;
}
