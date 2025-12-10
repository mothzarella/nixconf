{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {pkgs = final;};

  wayland = inputs.nixpkgs-wayland.overlay;
}
