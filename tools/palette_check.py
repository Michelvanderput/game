#!/usr/bin/env python3
"""Check that every exported sprite only uses colours from assets/art/palette.png.

Pixels must be fully transparent or fully opaque, and opaque pixels must match a
palette colour exactly. Exits with code 1 and lists the offending files otherwise.

Usage: python tools/palette_check.py [folder ...]   (default: assets/art/export)
"""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PALETTE_PNG = ROOT / "assets" / "art" / "palette.png"
DEFAULT_DIRS = [ROOT / "assets" / "art" / "export"]
MAX_REPORTED = 5


def load_palette() -> set[tuple[int, int, int]]:
    with Image.open(PALETTE_PNG) as image:
        rgba = image.convert("RGBA")
        pixels = rgba.load()
        return {pixels[x, y][:3] for y in range(rgba.height) for x in range(rgba.width) if pixels[x, y][3] == 255}


def check_file(path: Path, palette: set[tuple[int, int, int]]) -> list[str]:
    problems: list[str] = []
    with Image.open(path) as image:
        rgba = image.convert("RGBA")
        pixels = rgba.load()
        coords = ((x, y) for y in range(rgba.height) for x in range(rgba.width))
        for x, y in coords:
            r, g, b, a = pixels[x, y]
            if a == 0:
                continue
            if a != 255:
                problems.append(f"({x}, {y}) semi-transparent (alpha {a})")
            elif (r, g, b) not in palette:
                problems.append(f"({x}, {y}) colour #{r:02x}{g:02x}{b:02x} not in palette")
            if len(problems) >= MAX_REPORTED:
                problems.append("...")
                break
    return problems


def main() -> int:
    if not PALETTE_PNG.exists():
        print(f"error: {PALETTE_PNG.relative_to(ROOT)} missing; run tools/sprites/make_sprites.py", file=sys.stderr)
        return 1
    palette = load_palette()
    folders = [Path(arg) for arg in sys.argv[1:]] or DEFAULT_DIRS
    files = sorted(p for folder in folders for p in folder.rglob("*.png"))
    failed = 0
    for path in files:
        problems = check_file(path, palette)
        if problems:
            failed += 1
            print(f"FAIL {path}")
            for problem in problems:
                print(f"     {problem}")
    print(f"palette check: {len(files) - failed}/{len(files)} files ok ({len(palette)} colours)")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
