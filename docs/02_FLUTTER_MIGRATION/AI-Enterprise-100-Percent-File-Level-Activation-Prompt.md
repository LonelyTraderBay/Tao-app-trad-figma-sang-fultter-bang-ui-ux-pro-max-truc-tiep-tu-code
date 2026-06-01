# AI Enterprise 100 Percent File-Level Activation Prompt

Generated: 2026-06-01

Use this file when you want an AI agent to continue the VitTrade Flutter
enterprise-grade cleanup without missing any Dart source or test file.

This file works together with the machine-readable manifest:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv`

The CSV is the per-file checklist. This Markdown file is the activation prompt
and operating contract.

## Why This Exists

The earlier E900, Post-E900, and Enterprise Grade trackers raised the codebase
below hard line-count limits. The remaining risk is omission: an AI agent may
review only the obvious large files and skip smaller files, tests, routers,
fixtures, or generated-style parts.

This activation prompt prevents that by forcing every run to:

1. Load the file manifest.
2. Compare the manifest against the current repo file list.
3. Process files by manifest `priority`, not by memory.
4. Mark every file as reviewed, split, or intentionally excepted.
5. Run verification before closing a batch.

## Scope

Primary scope:

- `flutter_app/lib/**/*.dart`
- `flutter_app/test/**/*.dart`

Reference scope:

- `AGENTS.md`
- `docs/00_START_HERE.md`
- `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
- `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md`
- `docs/03_DESIGN_SYSTEM/Guidelines.md`

Do not recreate retired React, Vite, Tailwind, web screenshot, root npm, or
obsolete web-baseline tooling.

## Current Manifest Snapshot

Generated from the current repo on 2026-06-01.

| Check | Result |
| --- | ---: |
| Manifest rows | 2294 |
| `flutter_app/lib` Dart files | 1864 |
| `flutter_app/test` Dart files | 430 |
| Hard breaches | 0 |
| Soft-review files | 236 |
| Audit-only files | 2058 |
| P0 files | 0 |
| P1 files | 178 |
| P2 files | 58 |
| P3 files | 2058 |

These counts are not permanent. Regenerate or update the manifest when files
are added, removed, or moved.

## Manifest Columns

| Column | Meaning |
| --- | --- |
| `id` | Stable row id for this generated manifest. |
| `path` | File path relative to `flutter_app/`. |
| `area` | `lib` or `test`. |
| `feature` | Feature or package area inferred from the path. |
| `layer` | Architecture layer such as `presentation/pages`, `data/repositories`, or `test`. |
| `kind` | File type used for threshold rules. |
| `lines` | Line count at manifest generation time. |
| `soft_limit` | Enterprise soft-review threshold for this kind. |
| `hard_limit` | Enterprise hard threshold for this kind. |
| `threshold_bucket` | `hard_breach`, `soft_review`, or `under_soft_target`. |
| `priority` | `P0`, `P1`, `P2`, or `P3`. |
| `required_action` | Required action for the file. |
| `split_direction` | Extraction direction or no-edit rationale. |
| `verification` | Minimum command set when the file is touched. |
| `status` | Working status; update during execution. |
| `notes` | Evidence, exception, or completion notes. |

## Status Values

Use only these status values in the CSV:

- `pending_audit`: not reviewed in the current 100-percent pass.
- `in_progress`: active file or batch.
- `reviewed_no_edit`: inspected and no source edit was needed.
- `split_done`: source was split or reorganized and verified.
- `fixed_done`: non-split source fix was completed and verified.
- `exception_documented`: intentionally left as-is with evidence.
- `blocked`: cannot proceed without external input or external state.

Do not mark a file complete only because it is small. P3 files still need at
least a no-edit audit decision when the goal is a true 100-percent pass.

## Priority Rules

Process in this exact order:

1. `P0`: hard breaches or safety-critical boundary failures.
2. `P1`: high-risk soft-review files in Auth, Wallet, P2P, Trade, Earn,
   Predictions, Arena, and Profile.
3. `P2`: remaining soft-review files, router files, large tests, charts,
   repositories, domain entities, and other non-high-risk areas.
4. `P3`: audit-only files. Usually no edit; confirm no boundary, color, import,
   or ownership issue when touched by adjacent work.

Within the same priority:

1. Process high-risk user/account/security and money flows first.
2. Then product-boundary-sensitive Predictions and Arena surfaces.
3. Then router, repositories, domain entities, and tests.
4. Then lower-risk display-only pages and small files.

## Absolute Anti-Omission Rule

Before editing any source file, run the manifest coverage check from
`flutter_app/`:

```powershell
$manifest = Import-Csv ..\docs\02_FLUTTER_MIGRATION\Flutter-Enterprise-100-Percent-File-Action-Manifest.csv
$current = Get-ChildItem lib,test -Recurse -Filter *.dart |
  ForEach-Object {
    $_.FullName.Substring((Resolve-Path .).Path.Length + 1).Replace('\','/')
  } |
  Sort-Object
$known = $manifest.path | Sort-Object
Compare-Object -ReferenceObject $known -DifferenceObject $current
```

Expected result: no output.

If there is output:

- `=>` means the file exists in the repo but is missing from the manifest.
- `<=` means the manifest references a file that no longer exists.

Do not start refactoring until the manifest is updated and the coverage check
returns no output.

## Execution Prompt

Copy the prompt below into Codex/AI when you want it to run the 100-percent
file-level enterprise pass.

```text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute a 100-percent file-level Flutter enterprise-grade audit and cleanup
using:

docs/02_FLUTTER_MIGRATION/AI-Enterprise-100-Percent-File-Level-Activation-Prompt.md
docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv

The CSV manifest is the source of truth for file coverage. Do not rely on
memory, previous summaries, or only line-count scans. Every row must eventually
end as reviewed_no_edit, split_done, fixed_done, exception_documented, or
blocked.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/AI-Enterprise-100-Percent-File-Level-Activation-Prompt.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md
8. docs/03_DESIGN_SYSTEM/Guidelines.md when UI, layout, copy, or financial
   safety copy is touched.

NON-NEGOTIABLE COVERAGE:
1. Load the CSV manifest before choosing files.
2. Run the manifest coverage check before any source edit.
3. If the coverage check differs, update the manifest first.
4. Process rows by priority: P0, then P1, then P2, then P3.
5. Within a priority, process pending_audit rows before already completed rows.
6. Do not skip a file because it is small. Small files can be reviewed_no_edit.
7. Do not close the goal while any row remains pending_audit or in_progress
   unless the final response ends with:
   RESUME FROM: <manifest-id> - <path>

ENTERPRISE TARGETS:
- Presentation pages: ideal 300-500, soft review 500+, hard target below 600.
- Presentation widgets: ideal 100-350, soft review 400+, hard target below 600.
- Controllers: ideal 100-300, soft review 350+, hard target below 500.
- Data repositories: ideal 200-500, soft review 400+, hard target below 900.
- Data fixtures: ideal cohesive fixture groups, soft review 500+, hard target below 900.
- Domain entities: ideal 100-500, soft review 500+, hard target below 800.
- Router files: ideal 100-450, soft review 500+, hard target below 700.
- Tests: ideal 100-600, soft review 700+, hard target below 900 unless documented.
- Painter/chart files: ideal 100-350, soft review 400+, hard target below 600.

WORK LOOP:
1. Run git status --short from repo root.
2. Load the CSV and select the first pending row by priority.
3. Mark the active row in_progress before source edits.
4. Read the target file and run:
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-file>
5. Search references before editing:
   rg -n "<ClassName>|<provider>|<route-name>|<visible-copy>" lib test
6. Preserve:
   - route paths and names
   - GoRouter calls
   - Riverpod providers and controller contracts
   - repository public methods and return types
   - domain constructors, fields, equality, and serialization helpers
   - test keys and expected text
   - loading, empty, error, offline, submitting, and success states
   - financial previews, fees, limits, warnings, and next steps
   - sensitive-data masking
   - Prediction Markets wallet, position, probability, receipt, reward, and P/L language
   - Open Arena points-only language
7. Apply the row required_action and split_direction.
8. Format touched Dart files:
   dart format <touched-dart-files>
9. Run the row verification commands.
10. Run direct grep on touched source files:
    rg -n "features/.*/data|\bColors\." <touched-dart-files>
    Expected: no new presentation-to-data imports and no runtime Colors.*.
11. Re-count touched files and update the CSV row notes with:
    - before lines
    - after lines
    - files reviewed
    - files split or fixed
    - new files
    - commands and pass/fail results
    - exception reason if left as-is
12. Set status:
    - reviewed_no_edit if no source edit was required
    - split_done if extraction was completed and verified
    - fixed_done if a non-split fix was completed and verified
    - exception_documented only with evidence
    - blocked only with a real external blocker
13. Continue to the next pending row. Do not hand-pick later rows while earlier
    priority rows are pending.

GITNEXUS:
Use GitNexus MCP tools if available. If unavailable, try the CLI preflight from
the repo root:

npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60
npx -y gitnexus@latest status

If GitNexus fails, continue with rg, analyzer, focused tests, guardrails, and
record the fallback reason in the CSV notes.

FINAL DONE:
The 100-percent pass is done only when:
- no manifest row remains pending_audit or in_progress
- the manifest coverage check returns no output
- no hard threshold breaches remain
- presentation/shared direct features/*/data imports are zero
- runtime Colors.* matches in lib are zero
- flutter analyze passes
- architecture, product copy, and accessibility guardrails pass
- full flutter test passes when broad source, router, shared, or multi-feature
  changes were made
```

## Required Batch Verification

Run these from `flutter_app/` after any batch with Dart source edits:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Run these for final closeout:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

Run full tests when router, shared widgets, package-wide providers, or many
feature modules changed:

```powershell
flutter test --reporter=compact
```

## Direct Guardrail Scans

Run from `flutter_app/`.

Presentation/shared direct data imports:

```powershell
Get-ChildItem lib/features,lib/shared -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\' -or $_.FullName -match '\\shared\\' } |
  Select-String -Pattern 'features/.*/data'
```

Runtime `Colors.*`:

```powershell
rg -n "\bColors\." lib
```

Hard threshold scan:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib,test -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -gt 900) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

## Maintenance Rule

Whenever files are added, removed, moved, split, or merged, update
`Flutter-Enterprise-100-Percent-File-Action-Manifest.csv` in the same change.

The manifest must remain an exact file list for `flutter_app/lib/**/*.dart` and
`flutter_app/test/**/*.dart`. If it is not exact, the 100-percent pass is not
trustworthy.
