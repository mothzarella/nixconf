{pkgs ? import <nixpkgs> {}, ...}:
with pkgs; {
  sddm-silent = callPackage ./sddm/silent pkgs;
  nix-search = callPackage ./nix-search pkgs;
}
