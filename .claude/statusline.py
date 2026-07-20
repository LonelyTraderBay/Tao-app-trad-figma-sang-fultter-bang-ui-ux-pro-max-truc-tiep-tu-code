"""Status line: model | branch | % context + canh bao dumb-zone.

Claude Code goi script nay voi JSON tren stdin (UTF-8) va hien thi dong
stdout dau tien lam status line. Nguong theo kinh nghiem cong dong:
duoi 40% context = vung thong minh; 40-60% = chuan bi goi viec / compact
chu dong kem hint; tren 60% = nen /compact hoac mo session moi.

Phong thu voi schema: ten field trong `context_window` khac nhau giua cac
ban CLI, nen do tat ca cac ten da biet roi moi tinh %. Script luon exit 0
va luon in ra MOT dong gi do — status line hong khong duoc pha session.
"""

import json
import subprocess
import sys

GREEN, YELLOW, RED, DIM, RESET = (
    "\x1b[32m",
    "\x1b[33m",
    "\x1b[31m",
    "\x1b[2m",
    "\x1b[0m",
)


def context_percent(data: dict):
    cw = data.get("context_window")
    if not isinstance(cw, dict):
        return None
    for key in ("used_percentage", "percent_used", "usage_percent", "percentage"):
        value = cw.get(key)
        if isinstance(value, (int, float)):
            return float(value)
    for key in ("remaining_percentage", "percent_remaining"):
        value = cw.get(key)
        if isinstance(value, (int, float)):
            return 100.0 - float(value)
    used = next(
        (
            cw[k]
            for k in ("used_tokens", "input_tokens", "tokens_used", "used")
            if isinstance(cw.get(k), (int, float))
        ),
        None,
    )
    total = next(
        (
            cw[k]
            for k in ("max_tokens", "context_size", "total_tokens", "limit", "size")
            if isinstance(cw.get(k), (int, float)) and cw[k]
        ),
        None,
    )
    if used is not None and total:
        return used / total * 100.0
    return None


def git_branch(cwd: str):
    try:
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=cwd or None,
        )
        return result.stdout.strip() or None
    except Exception:
        return None


def main() -> int:
    try:
        data = json.loads(sys.stdin.buffer.read().decode("utf-8"))
    except Exception:
        data = {}

    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

    model = (data.get("model") or {}).get("display_name") or (
        data.get("model") or {}
    ).get("id") or "Claude"
    workspace = data.get("workspace") or {}
    cwd = workspace.get("current_dir") or data.get("cwd") or ""
    branch = git_branch(cwd)

    parts = [model]
    if branch:
        parts.append(f"{DIM}git:{RESET}{branch}")

    pct = context_percent(data)
    if pct is not None:
        pct = max(0.0, min(100.0, pct))
        filled = int(round(pct / 10))
        bar = "#" * filled + "-" * (10 - filled)
        if pct < 40:
            parts.append(f"{GREEN}ctx {pct:.0f}% [{bar}]{RESET}")
        elif pct < 60:
            parts.append(
                f"{YELLOW}ctx {pct:.0f}% [{bar}] gan dumb-zone — /compact kem hint{RESET}"
            )
        else:
            parts.append(
                f"{RED}ctx {pct:.0f}% [{bar}] qua 60% — goi viec / session moi{RESET}"
            )
    else:
        parts.append(f"{DIM}ctx: n/a{RESET}")

    print(" | ".join(parts))
    return 0


if __name__ == "__main__":
    sys.exit(main())
