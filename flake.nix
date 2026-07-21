{
  description = "Ian Holloway's personal Nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [ treefmt-nix.flakeModule ];

      flake = {
        overlays.default = final: _prev: import ./pkgs { pkgs = final; };
        legacyPackages = builtins.listToAttrs (
          map
            (system: {
              name = system;
              value = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ inputs.self.overlays.default ];
              };
            })
            [
              "x86_64-linux"
              "aarch64-linux"
              "aarch64-darwin"
            ]
        );
      };

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          packagePkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          packages = import ./pkgs { pkgs = packagePkgs; };
          update = pkgs.writeShellApplication {
            name = "update-packages";
            runtimeInputs = [ pkgs.python3 ];
            text = ''
              exec python "$PWD/scripts/update-packages.py" "$@"
            '';
          };
        in
        {
          inherit packages;
          apps.update = {
            type = "app";
            program = "${update}/bin/update-packages";
          };
          checks.formatting = config.treefmt.build.check inputs.self;
          devShells.default = pkgs.mkShellNoCC {
            packages = [
              pkgs.actionlint
              pkgs.deadnix
              pkgs.just
              pkgs.nixfmt
              pkgs.ruff
              pkgs.statix
              pkgs.ty
              pkgs.yamlfmt
              pkgs.zizmor
            ];
          };
          formatter = config.treefmt.build.wrapper;
          treefmt.programs = {
            actionlint.enable = true;
            deadnix.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
            yamlfmt.enable = true;
          };
        };
    };
}
