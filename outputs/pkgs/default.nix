{pkgs ? import <nixpkgs> {}, ...}:
with pkgs; {
  sddm-silent = callPackage ./sddm/silent pkgs;
  mignon-icon-theme = callPackage ./mignon pkgs;
  nix-search = callPackage ./nix-search pkgs;
}
