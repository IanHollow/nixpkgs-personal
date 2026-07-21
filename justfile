set shell := ["/usr/bin/env", "bash", "-c"]

default:
    @just --list

check:
    nix flake check --all-systems --no-build

fmt:
    nix fmt

lint:
    nix develop -c ruff format --check .
    nix develop -c ruff check .
    nix develop -c ty check

update-packages *args:
    nix develop -c python scripts/update-packages.py --all {{ args }}
