# nixpkgs-personal

Personal Nix packages published as a small, standalone flake. It has no
dependency on the NixOS, nix-darwin, or Home Manager inputs from my personal
configuration.

## Use

Add the flake and make its `nixpkgs` input follow yours:

```nix
inputs.nixpkgs-personal = {
  url = "github:IanHollow/nixpkgs-personal";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Packages are available as `inputs.nixpkgs-personal.packages.${system}`. To add
them to `pkgs`, use `inputs.nixpkgs-personal.overlays.default`.

| Platform                        | Supported outputs                 |
| ------------------------------- | --------------------------------- |
| `x86_64-linux`, `aarch64-linux` | Agent skills and Windows 11 fonts |
| `aarch64-darwin`                | All packages                      |

`x86_64-darwin` is intentionally unsupported because nixpkgs unstable has
dropped that platform. Several packages are proprietary or subject to upstream
terms; this repository packages them but does not redistribute their sources or
provide a public binary cache.

## Development and updates

Run `just check`, `just lint`, and `just update-packages`. Update scripts only
change pinned source metadata and are checked by CI before automated merge. New
packages follow the nixpkgs-style `pkgs/by-name/<prefix>/<name>` layout and must
declare accurate metadata, platform support, tests where feasible, and an
updater when upstream can be safely discovered.
