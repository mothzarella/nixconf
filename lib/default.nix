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

  pkgsFor = system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = builtins.attrValues self.overlays.${system};
    };

  # scan paths/modules
  scanTree = {
    filter ? null,
    _depth ? 1,
  }: path: let
    scan = depth: current:
      builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            name: type: let
              path = current + "/${name}";
            in
              if type == "directory"
              then scan (depth + 1) path
              else if filter == null || filter name type path depth
              then [path]
              else []
          ) (builtins.readDir current)
        )
      );
  in
    scan _depth path;
}
