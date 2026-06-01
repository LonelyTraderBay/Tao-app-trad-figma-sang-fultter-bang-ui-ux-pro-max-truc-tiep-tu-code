# Flutter Enterprise Post-E900 AI Execution Prompt

Use this prompt when asking an AI coding agent to continue the post-E900
large-file cleanup in the VitTrade Flutter repository.

```text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute all Post-E900 enterprise refactor packets in order from:

docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md

This is a maintainability refactor, not a redesign. Preserve product behavior,
routing, tests, financial safety copy, module boundaries, provider boundaries,
and existing UI intent.

NON-NEGOTIABLE OUTCOME:
- Packets PE900F-01 through PE500-01 in the Post-E900 guide must end as `[x]`
  or `[!]`.
- Do not stop after one packet.
- Do not only create a plan.
- Continue while any packet in the Post-E900 guide is `[ ]` or `[~]`.
- Resume the first `[~]` packet before starting any `[ ]` packet.
- If forced to stop, final response must end with:
  RESUME FROM: <packet-id> - <packet title>

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md
8. docs/03_DESIGN_SYSTEM/Guidelines.md when UI/layout decisions are involved

GITNEXUS REQUIREMENT:
Use GitNexus to reduce blind edits and catch blast radius before extraction.

Preflight:
1. Check whether GitNexus MCP tools are available.
   - If available, read `gitnexus://repos`, repo context, clusters, and use
     `query`, `context`, `impact`, and `detect_changes`.
2. If MCP tools are not available, run from repo root:
   npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60
   npx -y gitnexus@latest status
3. If embeddings or install are too slow, retry:
   npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60
4. Do not set `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`; this skips Dart parsing.
5. Do not let GitNexus overwrite project instructions. Preserve AGENTS.md.
6. If GitNexus cannot run, continue with `rg`, Dart analyzer, focused tests,
   and record the GitNexus failure in the packet notes.

SOURCE OF TRUTH:
- Flutter package: flutter_app/
- App source: flutter_app/lib/
- Public router facade: flutter_app/lib/app/router/app_router.dart
- Tests: flutter_app/test/
- Primary execution guide:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md

ENTERPRISE TARGETS:
- presentation/pages/*_page.dart: ideal 300-600 lines, hard target below 900.
- presentation/widgets/*.dart: ideal 100-400 lines, hard target below 600.
- data/repositories/*.dart: ideal 200-500 lines, hard target below 900.
- presentation/controllers/*.dart: ideal 150-500 lines, hard target below 800.
- domain/entities/*.dart: ideal 100-500 lines, hard target below 800.
- painter/chart files: ideal 100-400 lines, hard target below 600.

CURRENT PACKET ORDER:
1. PE900F-01 - P2P Hard Page Wave
2. PE900F-02 - P2P Create-Ad Widget Hard Breach
3. PE800-01 - P2P Near-Hard Page Wave
4. PE800-02 - Earn Near-Hard Page Wave
5. PE800-03 - Trade Near-Hard Page Wave
6. PE800-04 - Mixed Near-Hard Page Wave
7. PE600-01 - Soft Page Cleanup Wave
8. PE500-01 - Widget, Repository, Controller, and Domain Soft Cleanup

WORK LOOP:
Repeat until every Post-E900 packet is `[x]` or `[!]`.

1. Run from repo root:
   git status --short

2. Read the Post-E900 guide and choose the next packet:
   - Resume the first `[~]` packet.
   - If none, start the first `[ ]` packet.
   - Mark it `[~]` in the guide before edits.

3. From flutter_app/, confirm current line-count inventory before editing.

   Pages above 900:
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 900) { "$lines $rel" }
     } | Sort-Object {[int](($_ -split ' ')[0])} -Descending

   Pages from 800 to 900:
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -ge 800 -and $lines -le 900) { "$lines $rel" }
     } | Sort-Object {[int](($_ -split ' ')[0])} -Descending

   For PE600-01 and PE500-01, use the scan commands from the guide appendices
   and regenerate current counts before editing.

4. GitNexus analysis before edits:
   - Use `query` for the packet feature and target file names.
   - Use `context` on main page classes, widget classes, repository classes,
     controller classes, and public providers involved in the packet.
   - Use `impact` upstream on public classes, routes, repositories, providers,
     and shared widgets that may be affected.
   - Identify tests, router references, provider reads, imports, and keys that
     must remain stable.
   - Do not use GitNexus `rename` unless doing an actual rename; if used,
     dry-run first.

5. Read target files and symbol boundaries:
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <files>

6. Extraction rules:
   - Keep page state, controllers, provider reads, keys, route navigation, and
     top-level composition in the page.
   - Move visual sections, cards, lists, rows, sheets, tabs, and painters to
     features/<feature>/presentation/widgets/.
   - Keep repository public APIs stable.
   - Keep domain contracts and value objects in domain/.
   - Use `part` files only when preserving private fixture/widget boundaries is
     clearly cleaner than public widget imports.
   - Prefer package imports: package:vit_trade_flutter/...
   - Do not introduce direct presentation imports from features/*/data.
   - Do not introduce runtime `Colors.*`; use theme tokens.

7. Edit the packet fully, not partially:
   - Extract all cohesive sections required for that packet.
   - Keep behavior and copy equivalent.
   - Preserve Prediction Markets vs Open Arena boundaries.
   - Preserve financial safety previews, warnings, fees, limits, and next steps.
   - Preserve loading, empty, error, offline, submitting, and success states.
   - Preserve test keys and accessibility semantics.

8. Format touched Dart files:
   dart format <touched Dart files>

9. Run focused verification for the packet from flutter_app/:
   - Always run:
     flutter analyze
     flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
   - Run feature tests required by the packet in the Post-E900 guide.
   - For Wallet/P2P/Auth/security high-risk flows, also run:
     flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
   - For financial/product copy areas, also run:
     flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact

10. Run direct grep on touched Dart files:
    rg -n "features/.*/data|\bColors\." <touched-files>
    Expected: no new direct data imports from presentation and no new runtime
    Colors usage.

11. GitNexus analysis after edits:
    - Re-run `gitnexus analyze . --skip-agents-md` if the index is stale.
    - Use `detect_changes({scope: "all"})` if MCP is available.
    - Use `impact` on changed public classes/providers/routes when risk is not obvious.
    - If GitNexus reports affected processes/tests, run the relevant tests or
      document why they are not applicable.

12. Update the Post-E900 guide:
    - Change packet status to `[x]` if done and verified.
    - Use `[!]` only for a real blocker or documented exception.
    - Record before/after line counts.
    - Record new files.
    - Record commands and results in packet notes.
    - Record GitNexus findings or fallback reason.

13. Continue immediately to the next packet.

DEFINITION OF DONE PER PACKET:
- Packet status is `[x]` or `[!]`.
- Every touched source file is below target or has a documented exception.
- New files are in the correct feature layer.
- Page owns state/provider/navigation/composition only.
- No new direct imports from features/*/data in presentation.
- No new runtime `Colors.*`.
- Product boundaries are preserved.
- Required tests pass and are logged.
- GitNexus impact/detect-changes findings are handled or documented.

FINAL COMPLETION CRITERIA:
- No packet in the Post-E900 guide remains `[ ]` or `[~]`.
- No presentation page remains above 900 lines.
- No presentation widget remains above 600 lines unless marked `[!]`.
- High-risk pages above the ideal target have documented exceptions or are
  split into cohesive sections.
- Repository, controller, and domain files above soft limits have documented
  review outcomes.
- `flutter analyze` passes.
- `architecture_baseline_guardrails_test.dart` passes.
- Required feature, product copy, and semantics tests pass and are logged.
```

