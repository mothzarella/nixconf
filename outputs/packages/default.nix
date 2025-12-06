{pkgs ? import <nixpkgs> {}, ...}: {
  sddm-silent = pkgs.callPackage ./sddm/silent pkgs;
}
