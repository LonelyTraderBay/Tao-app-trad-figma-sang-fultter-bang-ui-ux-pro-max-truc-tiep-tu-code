"""PostToolUse hook: auto-format Dart files after Edit/Write/MultiEdit.

Reads the hook event JSON from stdin (always UTF-8 — never the console
codepage: Write payloads carry Vietnamese product copy that cp1252 cannot
decode), extracts the edited file path, and runs `dart format` on it when it
is a Dart source file inside this repo. Formatter config (page width,
trailing commas) is resolved by dart itself from the nearest
analysis_options.yaml/pubspec.yaml, so output matches `dart format .` run
from flutter_app/ and CI.

Always exits 0: a format failure (e.g. transient syntax error mid-edit-chain)
must never block the agent — `flutter analyze` and the test suite own syntax
errors. Diagnostics go to stderr only.
"""

import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

SKIP_DIR_PARTS = {"build", ".dart_tool", ".git"}


def repo_root(event: dict) -> Path:
    root = os.environ.get("CLAUDE_PROJECT_DIR") or event.get("cwd") or "."
    return Path(root).resolve()


def main() -> int:
    try:
        event = json.loads(sys.stdin.buffer.read().decode("utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        print(f"format_dart: unreadable hook input: {exc}", file=sys.stderr)
        return 0

    raw_path = (event.get("tool_input") or {}).get("file_path") or ""
    if not raw_path.endswith(".dart"):
        return 0

    root = repo_root(event)
    path = Path(raw_path)
    if not path.is_absolute():
        path = Path(event.get("cwd") or root) / path
    path = path.resolve()
    if root != path and root not in path.parents:
        return 0  # outside this repo (memory files, scratchpad, other projects)
    if not path.is_file():
        return 0
    if SKIP_DIR_PARTS.intersection(path.parts):
        return 0

    dart = shutil.which("dart")
    if dart is None:
        print("format_dart: dart not found on PATH", file=sys.stderr)
        return 0

    try:
        # List form + shell=False: no cmd.exe metacharacter interpretation.
        # Python 3.12 raises ValueError for .bat args it cannot safely quote.
        result = subprocess.run(
            [dart, "format", str(path)],
            capture_output=True,
            text=True,
            timeout=60,
        )
    except (OSError, ValueError, subprocess.TimeoutExpired) as exc:
        print(f"format_dart: dart format did not run: {exc}", file=sys.stderr)
        return 0

    if result.returncode != 0:
        # Most common cause: file temporarily unparseable between chained edits.
        first_line = (result.stderr or result.stdout).strip().splitlines()
        detail = first_line[0] if first_line else "unknown error"
        print(f"format_dart: skipped {path.name}: {detail}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
