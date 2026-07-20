"""PreToolUse hook: dem tan suat goi Agent/Skill/Task.

Ghi 1 dong JSONL vao .claude/data/usage-log.jsonl moi lan mot subagent hoac
skill duoc goi, de sau vai tuan biet agent/skill nao "e" (description viet
chua trung) va cai nao gánh viec. File log nam trong .claude/ (gitignored).

Luon exit 0 — hook do luong khong bao gio duoc chan tool call.
"""

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path


def main() -> int:
    try:
        event = json.loads(sys.stdin.buffer.read().decode("utf-8"))
    except Exception:
        return 0

    tool = event.get("tool_name") or ""
    tool_input = event.get("tool_input") or {}
    if tool in ("Agent", "Task"):
        target = tool_input.get("subagent_type") or "general-purpose"
    elif tool == "Skill":
        target = tool_input.get("skill") or ""
    else:
        return 0

    root = os.environ.get("CLAUDE_PROJECT_DIR") or event.get("cwd") or "."
    # Phien worktree co CLAUDE_PROJECT_DIR = thu muc worktree — log o do se bi
    # xoa cung worktree va phan manh so lieu. Gop ve checkout chinh.
    normalized = str(root).replace("\\", "/")
    marker = "/.claude/worktrees/"
    if marker in normalized:
        root = normalized.split(marker, 1)[0]
    log_path = Path(root) / ".claude" / "data" / "usage-log.jsonl"
    record = {
        "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "tool": tool,
        "target": target,
        "session": (event.get("session_id") or "")[:8],
    }
    try:
        log_path.parent.mkdir(parents=True, exist_ok=True)
        with open(log_path, "a", encoding="utf-8", newline="\n") as fh:
            fh.write(json.dumps(record, ensure_ascii=False) + "\n")
    except OSError as exc:
        print(f"usage_log: khong ghi duoc log: {exc}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
