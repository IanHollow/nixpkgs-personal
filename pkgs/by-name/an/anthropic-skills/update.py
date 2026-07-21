#!/usr/bin/env python3
"""Update the pinned Anthropic Agent Skills catalog."""

from __future__ import annotations

import runpy
from pathlib import Path

main = runpy.run_path(
    str(Path(__file__).resolve().parents[4] / "scripts" / "agent-skills-updater.py")
)["main"]


if __name__ == "__main__":
    raise SystemExit(main("anthropics", "skills", Path(__file__).resolve().parent))
