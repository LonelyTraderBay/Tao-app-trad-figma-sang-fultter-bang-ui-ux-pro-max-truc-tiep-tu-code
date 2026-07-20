"""Stop hook: nhac chay verify neu phien da sua .dart ma chua thay test.

Parse JSON tung dong transcript va chi xet CONTENT BLOCK type=tool_use that
(khong substring-match ca dong — bai hoc tu review doi khang: chuoi
'"stop_reason":"tool_use"' xuat hien tren ca dong thinking/text, va duong dan
.dart co the xuat hien trong noi dung Write cua file KHONG phai Dart).

- Edit that: tool Edit/Write/MultiEdit voi tool_input.file_path ket thuc
  .dart (bo qua .dart_tool/, build/).
- Verify that: Bash/PowerShell co 'flutter test' trong command; Skill
  vt-verify / fix-quality-guardrails; Agent/Task toi cac agent verify.

Chi nhac MOT lan (stop_hook_active=true -> im lang). Thien vi im lang: moi
truong hop khong chac (khong doc duoc transcript, dong khong parse duoc...)
deu bo qua dong do / exit 0. Nudge sai gay phien hon nudge thieu.
"""

import json
import sys

EDIT_TOOLS = {"Edit", "Write", "MultiEdit"}
SHELL_TOOLS = {"Bash", "PowerShell"}
VERIFY_SKILLS = {"vt-verify", "fix-quality-guardrails", "vt-audit"}
VERIFY_AGENTS = {
    "flutter-batch-builder",
    "flutter-pr-gate",
    "flutter-domain-auditor",
    "flutter-test-coverage-auditor",
    "flutter-test-writer",
}
SKIP_PATH_PARTS = (".dart_tool/", "build/")

REASON = (
    "Phien nay da sua file .dart nhung chua thay bang chung chay test/verify "
    "sau lan sua cuoi. Can nhac chay /vt-verify (hoac flutter test cho khu "
    "vuc da sua) truoc khi ket thuc. Neu da can nhac va thay khong can "
    "(vi du: chi sua comment/doc), cu ket thuc va noi ro ly do."
)


def classify(block: dict) -> str:
    """'edit' | 'verify' | '' cho mot content block type=tool_use."""
    name = block.get("name") or ""
    tool_input = block.get("input") or {}
    if not isinstance(tool_input, dict):
        return ""
    if name in EDIT_TOOLS:
        path = str(tool_input.get("file_path") or "").replace("\\", "/")
        if path.endswith(".dart") and not any(
            part in path for part in SKIP_PATH_PARTS
        ):
            return "edit"
        return ""
    if name in SHELL_TOOLS:
        command = str(tool_input.get("command") or "")
        return "verify" if "flutter test" in command else ""
    if name == "Skill":
        return "verify" if tool_input.get("skill") in VERIFY_SKILLS else ""
    if name in ("Agent", "Task"):
        return (
            "verify"
            if tool_input.get("subagent_type") in VERIFY_AGENTS
            else ""
        )
    return ""


def main() -> int:
    try:
        event = json.loads(sys.stdin.buffer.read().decode("utf-8"))
    except Exception:
        return 0

    if event.get("stop_hook_active"):
        return 0

    transcript = event.get("transcript_path") or ""
    if not transcript:
        return 0

    last_edit = -1
    last_verify = -1
    try:
        with open(transcript, encoding="utf-8", errors="replace") as fh:
            for idx, line in enumerate(fh):
                # loc re truoc khi tra gia json.loads cho dong 11MB+
                if '"tool_use"' not in line:
                    continue
                try:
                    obj = json.loads(line)
                except json.JSONDecodeError:
                    continue
                content = (obj.get("message") or {}).get("content") or []
                if not isinstance(content, list):
                    continue
                for block in content:
                    if (
                        not isinstance(block, dict)
                        or block.get("type") != "tool_use"
                    ):
                        continue
                    kind = classify(block)
                    if kind == "edit":
                        last_edit = idx
                    elif kind == "verify":
                        last_verify = idx
    except OSError:
        return 0

    if last_edit >= 0 and last_edit > last_verify:
        print(json.dumps({"decision": "block", "reason": REASON}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
