#!/usr/bin/env python3
"""Fail when a tracked relative inline Markdown link does not resolve."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit


REPO_ROOT = Path(__file__).resolve().parents[1]
LINK = re.compile(
    r"!?\[[^\]\n]*\]\("
    r"(?P<target><[^>\n]+>|[^\s)]+)"
    r"(?:\s+(?:\"[^\"]*\"|'[^']*'|\([^)]*\)))?"
    r"\)"
)
FENCE = re.compile(r"^\s*(?P<marker>`{3,}|~{3,})")
SCHEME = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")


def markdown_files() -> list[Path]:
    output = subprocess.check_output(
        [
            "git",
            "-C",
            str(REPO_ROOT),
            "ls-files",
            "-z",
            "--",
            "*.md",
        ]
    )
    return sorted(REPO_ROOT / path.decode() for path in output.split(b"\0") if path)


def relative_target(raw: str) -> str | None:
    target = raw[1:-1] if raw.startswith("<") and raw.endswith(">") else raw
    if target.startswith(("#", "/", "//")) or SCHEME.match(target):
        return None
    path = unquote(urlsplit(target).path)
    return path or None


def main() -> int:
    broken: list[str] = []
    checked = 0
    files = markdown_files()

    for markdown in files:
        fence_char: str | None = None
        fence_length = 0
        for line_number, line in enumerate(markdown.read_text(encoding="utf-8").splitlines(), 1):
            fence = FENCE.match(line)
            if fence:
                marker = fence.group("marker")
                if fence_char is None:
                    fence_char, fence_length = marker[0], len(marker)
                elif marker[0] == fence_char and len(marker) >= fence_length:
                    fence_char, fence_length = None, 0
                continue
            if fence_char is not None:
                continue

            for match in LINK.finditer(line):
                target = relative_target(match.group("target"))
                if target is None:
                    continue
                checked += 1
                resolved = (markdown.parent / target).resolve()
                try:
                    resolved.relative_to(REPO_ROOT)
                except ValueError:
                    broken.append(
                        f"{markdown.relative_to(REPO_ROOT)}:{line_number}: "
                        f"relative link escapes repository: {target}"
                    )
                    continue
                if not resolved.exists():
                    broken.append(
                        f"{markdown.relative_to(REPO_ROOT)}:{line_number}: "
                        f"missing relative link target: {target}"
                    )

    if broken:
        print("Broken relative Markdown links:", file=sys.stderr)
        print("\n".join(f"- {item}" for item in broken), file=sys.stderr)
        return 1

    print(f"Relative Markdown links OK ({len(files)} files, {checked} links checked).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
