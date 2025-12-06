{
  lib,
  ...
}:
with lib; {
  nix = {
    extraOptions = mkDefault ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = mkDefault "25.05";
}
