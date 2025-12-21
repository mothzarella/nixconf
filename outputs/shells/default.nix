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

  # TODO: automatically generate shells for all languages
  python = let
    python = import ./dev/python pkgs;
  in
    mkShellNoCC {
      packages = python.packages;
      shellHook = python.shellHook;
    };

  go = let
    go = import ./dev/go pkgs;
  in
    mkShellNoCC {
      packages = go.packages;
      shellHook = go.shellHook;
    };

  terraform = let
    terraform = import ./dev/terraform pkgs;
  in
    mkShellNoCC {
      packages = terraform.packages;
      shellHook = terraform.shellHook;
    };
}
