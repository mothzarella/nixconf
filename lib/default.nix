inputs: let
  inherit (inputs) self nixpkgs;

  # list of default supported systems
  # @see https://github.com/nix-systems/nix-systems
  defaultSystems = [
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
  ];
in rec {
  inherit defaultSystems inputs;

  eachSystem = systems: f:
    builtins.foldl' (
      attrs: system: let
        ret = f system;
      in
        builtins.foldl' (
          attrs: key:
            attrs
            // {${key} = (attrs.${key} or {}) // {${system} = ret.${key};};}
        )
        attrs (builtins.attrNames ret)
    ) {} (
      if !builtins ? currentSystem || builtins.elem builtins.currentSystem systems
      then systems
      else systems ++ [builtins.currentSystem]
    );

  eachDefaultSystem = f:
    eachSystem defaultSystems f;

  # build pkgs for specific system
  pkgsFor = system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = builtins.attrValues self.overlays.${system};
    };

  scanTree = {
    type ? null,
    regex ? null,
    path,
  }: let
    scan = current:
      builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            _name: _type: let
              p = current + "/${_name}";
              matches =
                (type == null || _type == type)
                && (regex == null || builtins.match regex _name != null);
            in
              if _type == "directory"
              then
                scan p
                ++ (
                  if matches
                  then [p]
                  else []
                )
              else if matches
              then [p]
              else []
          ) (builtins.readDir current)
        )
      );
  in
    scan path;
}
