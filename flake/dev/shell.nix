_: {
  perSystem =
    { config, pkgs, ... }:
    let
      inherit (config.pre-commit.settings) enabledPackages package shellHook;
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        inherit shellHook;
        packages =
          enabledPackages
          ++ [ package ]
          ++ (with pkgs; [
            actionlint
            cargo-nextest
            deadnix
            direnv
            editorconfig-checker
            gitleaks
            keep-sorted
            just
            nixd
            nixf-diagnose
            nixfmt
            prek
            pinact
            prettier
            rumdl
            rust-analyzer
            shellcheck
            shfmt
            statix
            taplo
            treefmt
            typos
            yamlfmt
            yamllint
            zizmor
          ]);
      };
    };
}
