# AI Home UI Project-Wide Standardization Deep Autonomous Execution Prompt

> **Shared contract:** [`docs/01_AI_RULES/AI_PROMPT_SHELL.md`](../01_AI_RULES/AI_PROMPT_SHELL.md)

Copy the prompt block below into a fresh AI/Codex/Cursor agent thread when you
want **non-stop execution** of the residual Home UI standardization pass until
Phase 7 closure or a valid handoff.

## How This Prompt Works

The AI **does not maintain progress in chat**. It **reads and writes** the live
Deep Plan file on every batch boundary:

[`VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md`](VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md)

| File | Role |
| --- | --- |
| **Deep Plan** | **Single source of truth** — §4.0 progress, §4.3.1 manifest, §11 next step, §12 ledger |
| [`VitTrade-Home-UI-Standardization-Batch-Log.md`](VitTrade-Home-UI-Standardization-Batch-Log.md) | Mirror of §12.4 rows (optional duplicate; keep in sync with Deep Plan §2.2) |
| Execution Plan §7 | Historical rollout only; do not redo `Done` rows unless audit regresses |

**Scope:** residual debt pass only (Deep Plan §2.1). Wallet is reference, not churn
target except Phase 3 follow-ups.

## Current Resume (2026-07-01)

If the thread has **no** `RESUME FROM:` marker, read Deep Plan **§11** (do not
guess batch id from this file):

```text
RESUME FROM: Phase 1 - P2P-HOME-06
```

1. Read Deep Plan **§4.0** (live progress) and **§11** (next batch targets).
2. Skip Phase 0 if §4.0 shows Phase 0 **Done** and audit baseline unchanged today.
3. Continue from §11 active batch (currently merchant/ads or account/security per
   §4.0 batch tracker).

Already verified Done (do not redo unless audit regresses):

- Phase 0
- P2P-HOME-01 through P2P-HOME-05 (`p0_p2p`: 173 → 72 per §4.0)

**New thread after summarize:** paste only the Copy-Paste Prompt once, then use
**Compact Resume** (below) for follow-up turns.

---

## Compaction-Safe Autonomous Mode

Cursor may **automatically summarize** long threads. The agent cannot trigger
compaction on demand; design execution to **survive summarize** and **resume from
Deep Plan**, not chat memory.

Rules (also embedded in Copy-Paste Prompt below):

- Progress lives only in Deep Plan §4.0, §4.3.1, §11, §12.2, §12.4 (+ batch log).
- After every batch, write resume pointer in §11 (`RESUME FROM: Phase N - BatchID`).
- On summarize or context pressure: re-read §4.0 + §11 + §4.3.1; continue without
  asking user; never re-paste full execution prompt in chat.
- Proactive handoff is valid: sync Deep Plan §2.2, emit `RESUME FROM` marker, stop.
- Between batches: ≤8 lines; no large diffs or tool dumps in chat.

---

## Compact Resume (follow-up turns only)

After the full Copy-Paste Prompt has run once in a thread (or after summarize),
send only:

```text
RESUME FROM: Phase 1 - P2P-HOME-06
Continue existing execution contract from Deep Plan §11. Deep Plan §4.0 sync required after each batch.
```

Replace batch id with the value from Deep Plan §11.

---

## Copy-Paste Prompt

````text
You are working in the VitTrade Flutter repository (repo root).

Follow docs/01_AI_RULES/AI_PROMPT_SHELL.md for all shared rules.

PRIMARY OBJECTIVE:
Execute the residual Home UI standardization pass until Phase 7 closure.

Operational contract lives in AND must be kept current in:

docs/02_FLUTTER_MIGRATION/VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md

You are an EXECUTOR, not a planner. The Deep Plan already exists — implement it,
update its live sections after every batch, and do not stop mid-pass without a
valid handoff.

═══════════════════════════════════════════════════════════════════
DEEP PLAN LIVE WORKFLOW (mandatory every session)
═══════════════════════════════════════════════════════════════════

SESSION START (always, before code):

1. Read Deep Plan §4.0 Execution Progress (Live) — this is your resume pointer.
2. Read Deep Plan §11 Immediate Next Step — this is your active batch.
3. Read Deep Plan §4.3.1 — confirm target bundles and Exec status for the batch.
4. Skim Deep Plan §2.2 Plan Sync Contract — you MUST follow it after every batch.

If user/thread says RESUME FROM: Phase <N> - <BatchID>, trust §4.0 unless it
contradicts the marker; then prefer the marker and fix §4.0 on first sync.

AFTER EVERY BATCH (Done, Blocked, or forced handoff) — same session, before next
batch or before stopping:

Update Deep Plan in this order (Deep Plan §2.2):

  A. §4.0  — phase status, debt delta, batch tracker, Last sync date
  B. §4.2.2 — audit totals if CSV regenerated
  C. §4.3.1 — Exec status column for every touched bundle
  D. §12.2 — per-page Done / In progress / Blocked / Skip
  E. §12.4 — append batch log row
  F. §11   — next batch ID + targets (or Phase 7 closure note)

Also append the same §12.4 row to VitTrade-Home-UI-Standardization-Batch-Log.md
if that file exists.

A batch is NOT Done until Deep Plan §4.0 and §4.3.1 reflect it AND verification
passed (audit + tests + analyze per phase gate).

Never mark Done from code edits alone.

═══════════════════════════════════════════════════════════════════
NON-STOP EXECUTION CONTRACT
═══════════════════════════════════════════════════════════════════

Finish Phase 0 → Phase 1 (all 7 P2P batches) → Phase 2 → Phase 2b → Phase 3 →
Phase 4 → Phase 5 → Phase 6 → Phase 7 in strict order.

Keep executing until exactly ONE of these is true:

1. Phase 7 global closure acceptance criteria pass AND Deep Plan §4.0 shows all
   phases Done.
2. A real blocker remains after ≥3 concrete repair attempts on the same issue AND
   no other eligible batch in the current phase can proceed — mark Blocked in
   §4.0 / §4.3.1 / §12.2, then try next eligible batch if any.
3. Platform/context limit forces handoff — you MUST update Deep Plan §4.0,
   §11, §12.4 first, then emit RESUME FROM marker.

INVALID STOP REASONS (do not stop):

- Token pressure or large remaining scope
- One batch complete (“what next?”)
- Partial debt reduction without plan sync
- Analysis/planning complete without implementation
- User silence
- Wanting confirmation between batches
- Updating only batch log but not Deep Plan

After each verified batch: emit max 8 lines to user, update Deep Plan, start next
batch IN THE SAME TURN. No waiting for user approval between batches.

═══════════════════════════════════════════════════════════════════
COMPACTION-SAFE AUTONOMOUS MODE (mandatory)
═══════════════════════════════════════════════════════════════════

Assume this thread MAY be summarized at any time. Never rely on chat memory as
source of truth.

STATE OWNERSHIP:
- Progress lives ONLY in Deep Plan §4.0, §4.3.1, §11, §12.2, §12.4 (+ batch log).
- After every batch, write resume pointer in §11:
  RESUME FROM: Phase <N> - <BatchID>
  Last verified: p0_p2p=<X>, total_debt=<Y>, plan synced=<date>
  Blockers: <none|exact>

ON SUMMARIZE / CONTEXT PRESSURE:
- Do NOT stop to ask user.
- Re-read Deep Plan §4.0 + §11 + §4.3.1.
- Continue current batch if In progress; else start next batch from §11.
- Never re-paste full execution prompt in chat.
- Never duplicate long tool outputs in chat; keep evidence in plan/batch log only.

PROACTIVE HANDOFF (valid stop):
If remaining work is large OR responses slow OR repeated context loss detected:
1) Finish current micro-step if safe
2) Sync Deep Plan §2.2 fully
3) Emit only:
   RESUME FROM: Phase <N> - <BatchID>
   Last verified: ...
   Blockers: ...
4) Stop (do not start new batch in same turn)

CHAT DISCIPLINE:
- Between batches: max 8 lines
- No full prompt repost
- No large diffs/logs in chat
- No repeated user message blocks

NEW THREAD START (only 2 lines after first full prompt in a prior thread):
RESUME FROM: Phase <N> - <BatchID>
Continue existing execution contract from Deep Plan §11.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:

- Do not create a new plan document.
- Do not only analyze and stop.
- Do not ask which batch to run next — read §4.0 / §11.
- Do not stop after one batch unless valid stop condition above.
- Do not redo batches marked Done in §4.3.1 unless regenerated audit shows new
  debt on that bundle (Deep Plan §2.1).

LANGUAGE:

- Batch logs, evidence, plan updates: English.
- Code symbols, paths, commands, test names: exactly as in source.
- Do not translate product UI copy unless the batch requires it.

RESUME HANDLING:

Thread marker:

  RESUME FROM: Phase <N> - <BatchID>

Steps:

1. Read Deep Plan §4.0 + §12.4 (and batch log mirror if present).
2. If that batch is In progress → continue it (code + verify + plan sync).
3. If Done → start next batch from §11 / §4.0 batch tracker.
4. Skip Phase 0 when §4.0 Phase 0 = Done and same-day audit baseline valid.

Forced handoff format (after Deep Plan sync):

  RESUME FROM: Phase 1 - P2P-HOME-06
  Last verified: p0_p2p=72, Deep Plan §4.0 updated <date>
  Blockers: <none or precise reason>

SOURCE PRIORITY:

1. Current user instruction
2. AGENTS.md
3. docs/00_START_HERE.md
4. Deep Plan §4.0 live progress (over stale narrative elsewhere in the same file)
5. Flutter source and tests
6. VitTrade-Home-UI-Rollout-Playbook.md
7. Wallet-UI-Home-Standardization-Plan.md (reference only)
8. Audit CSV/MD under docs/02_FLUTTER_MIGRATION/

Rules:

- Financial safety beats visual density.
- Use VitTrade-Visual-Density-Risk-Audit.md / .csv — NOT
  VitTrade-Whole-App-Visual-Density-Real-Audit-Report.md (stale).
- Wallet is visual reference; do not churn Wallet except Phase 3 follow-ups.

MINIMAL READ LIST:

Once at session start:

1. AGENTS.md
2. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
3. Deep Plan §2.2, §4.0, §4.3.1, §5.1, §8, §11, §12
4. VitTrade-Home-UI-Rollout-Playbook.md pattern table only

Per batch only:

- Target page/widget files + focused tests
- Matching audit CSV rows for targets
- Wallet reference pages for high-risk P2P payment/escrow only

Do not re-read the full Deep Plan every batch — grep §4.3.1 and audit CSVs.
Do not read Execution Plan full inventory (390 screens).

SKILL ROUTER (max 1–2 skills per batch):

| Trigger | Skill |
| --- | --- |
| GitNexus stale | .codex/skills/gitnexus-cli/SKILL.md |
| Before editing class/method/shared primitive | .codex/skills/gitnexus-impact-analysis/SKILL.md |
| Test/audit failure | gitnexus-debugging + debugging-and-error-recovery |
| Batch touches 3+ files | incremental-implementation |
| Icon-only, forms, a11y | vittrade-ui-checklists |
| Shared UI surfaces | frontend-ui-engineering |
| P2P payment/escrow/security | security-and-hardening |
| Phase 7 closure | code-review-and-quality |
| Scope creep | ponytail |

MCP ROUTER:

| Task | Tool |
| --- | --- |
| Blast radius | GitNexus context, impact, detect_changes |
| flutter analyze/test | user-dart MCP; shell fallback |

GitNexus blocked after 3 attempts → note in §12.4, continue with source/tests.

TOKEN DISCIPLINE:

- Long evidence → Deep Plan §12.3 or batch log, not chat.
- Between batches: ≤8 lines (batch id, debt delta, next batch, plan synced yes/no).
- No full flutter test except Phase 7 or Phase 2b shared widgets.
- No git commit unless user asks.

PHASE ORDER:

Phase 0 → Phase 1 (P2P-HOME-01..07) → Phase 2 → Phase 2b → Phase 3 →
Phase 4 → Phase 5 → Phase 6 → Phase 7

Gates:

- No Phase 2 until all Phase 1 §4.3.1 rows are Done, Skip, or documented L3.
- No Phase 7 until Phase 2b clears p0_markets_debt and scope_shared_widget_debt.

When a phase completes: set Phase status **Done** in Deep Plan §4.0 before
entering next phase.

PHASE 0 — Evidence Freeze

From repo root:
  node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills

From flutter_app/:
  dart run tool/route_coverage_audit.dart --check
  dart run tool/design_token_consistency_audit.dart --check
  dart run tool/visual_density_risk_audit.dart --check
  dart run tool/body_component_consistency_audit.dart --check
  flutter analyze

Regenerate if stale:
  dart run tool/design_token_consistency_audit.dart
  dart run tool/visual_density_risk_audit.dart
  dart run tool/body_component_consistency_audit.dart

Record totals in Deep Plan §4.0 and §4.2.2. Mark Phase 0 Done in §4.0.

PHASE 1 — P2P Token Cleanup (7 batches)

Use §4.3.1 manifest for targets. Batch map:

P2P-HOME-01: payment methods (6 pages)
P2P-HOME-02: escrow/orders (8 pages)
P2P-HOME-03: KYC (5 pages; kyc_requirements may already pass)
P2P-HOME-04: risk/compliance (9 pages)
P2P-HOME-05: merchant/ads (5 pages)
P2P-HOME-06: account/security (11 pages)
P2P-HOME-07: dispute/express/misc (9 pages)

Per-batch verification:
  cd flutter_app
  dart format --output=none --set-exit-if-changed lib/features/p2p test/features/p2p
  dart run tool/design_token_consistency_audit.dart --check
  dart run tool/visual_density_risk_audit.dart --check
  flutter test test/features/p2p --reporter=compact
  flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
  flutter analyze

Gate: p0_p2p_debt decreases each batch until 0 or documented L3 exception.

PHASE 2 — Earn + Trade

Targets: staking_earn_page.dart, kid_generator_page.dart, trade_page.dart (L3)
Batch IDs: DEEP-EARN-01, DEEP-TRADE-01

PHASE 2b — Markets + vit_choice_pill

Batch ID: DEEP-MARKETS-SHARED-01
GitNexus impact on vit_choice_pill.dart mandatory.

PHASE 3 — Medium density (Wallet + Earn notifications)

Batch IDs: DEEP-DENSITY-WALLET-01, DEEP-DENSITY-EARN-01

PHASE 4 — Tool visual QA

Batch ID: DEEP-TOOL-QA-01
Targets: FuturesPage, TradingBotsPage, AdvancedChartPage, EnterpriseStatesPage,
P2PChatPage

PHASE 5 — P3 triage (P2-A ledger first)

PHASE 6 — Copy polish (DEEP-COPY-01/02)

PHASE 7 — Global closure

Full audit + quality tests + flutter test + Enterprise-PR-Review-Checklist.md
GitNexus detect_changes before declaring complete.
Update §4.0: all phases Done, closure metrics, date.

PER-BATCH MICRO-LOOP (Deep Plan §8 + §2.2):

1. Read §4.0 / §11 → select batch
2. GitNexus context + impact on target symbols
3. Scoped action census (rg on target files)
4. Taxonomy §5.1; L0–L2 patterns; L3 with reason
5. Implement minimal diff
6. dart format touched files
7. Phase verification commands
8. navigation_edge_audit --check if nav changed
9. Regenerate audit CSV if --check stale
10. **SYNC DEEP PLAN §2.2** (§4.0, §4.2.2, §4.3.1, §12.2, §12.4, §11)
11. User line: DONE: <batch> | p0_p2p: X→Y | plan synced | NEXT: <batch>
12. Immediately start next batch — same turn

Scoped action census:

rg -n "VitCtaButton|IconButton|VitInlineIconAction|EdgeInsets|onTap:|onPressed:|showModalBottomSheet|showDialog|confirm|preview" <targets>

DEFINITION OF DONE:

Screen: pass/exception audit, tests, analyze, §4.3.1 Exec status updated.
Project: Phase 7 gates + §4.0 all phases Done.

IF TESTS FAIL:

Fix batch regressions → regenerate stale audit → document unrelated failures →
after 3 attempts mark Blocked in plan, continue if another batch eligible.

OUTPUT:

Between batches (≤8 lines). Final summary only at Phase 7 or valid handoff.
Always confirm: "Deep Plan §4.0 updated: yes".

Do not produce redesign essays. Do not paste huge diffs.
````
