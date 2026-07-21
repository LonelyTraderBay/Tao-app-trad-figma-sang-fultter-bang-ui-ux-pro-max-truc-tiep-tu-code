# Button Wiring Baseline Ledger

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Purpose: baseline matrix for non-navigation `onPressed` / `onTap` dead-handler discovery (complements `route_coverage_audit` + `navigation_edge_audit`).  
**Status: baseline pending until Phase P6** (STEP-P6.1 / P6.2).

## Command hint (`flutter-button-wiring-auditor`)

Claude Code agent: [`.claude/agents/flutter-button-wiring-auditor.md`](../../../../.claude/agents/flutter-button-wiring-auditor.md)

Scope one module at a time under `flutter_app/lib/features/<module>/` (or `presentation/` subtree). Exhaustive grep patterns:

```text
onPressed:\s*\(\)\s*\{\s*\}
onTap:\s*\(\)\s*\{\s*\}
onPressed:\s*\(\)\s*async\s*\{\s*\}
onTap:\s*\(\)\s*async\s*\{\s*\}
onPressed:\s*null
onTap:\s*null
```

Classify each hit: `broken` | `needs_review` | `legitimate` (dev demos, conditional disabled, `VitHeaderActionButton` null-disabled).

Persist findings to:

```text
flutter_app/run-artifacts/button-wiring-audit-<scope>-<date>.md
```

Cursor sessions: follow the same agent runbook manually (read-only); do not invent parallel tooling.

## Scope matrix by module

| Module | Feature path (scope) | Priority sweep STEP | Empty stubs (baseline) | Verdict | Status |
|--------|----------------------|---------------------|-----------------------:|---------|--------|
| home | `flutter_app/lib/features/home/` | P6.2 (after P1 Home) | TBD | — | **baseline pending (P6)** |
| profile | `flutter_app/lib/features/profile/` | P6.2 (after P1 Profile) | TBD | — | **baseline pending (P6)** |
| markets | `flutter_app/lib/features/markets/` | **P6.1** | TBD | — | **baseline pending (P6)** |
| trade | `flutter_app/lib/features/trade/` (+ bots/copy/margin as touched) | **P6.1** | TBD | — | **baseline pending (P6)** |
| wallet | `flutter_app/lib/features/wallet/` | **P6.1** | TBD | — | **baseline pending (P6)** |
| earn | `flutter_app/lib/features/earn/` | **P6.2** | TBD | — | **baseline pending (P6)** |
| p2p | `flutter_app/lib/features/p2p/` | **P6.2** | TBD | — | **baseline pending (P6)** |
| arena | `flutter_app/lib/features/arena/` | **P6.2** | TBD | — | **baseline pending (P6)** |
| predictions | `flutter_app/lib/features/predictions/` | **P6.2** | TBD | — | **baseline pending (P6)** |

## Prior sample (historical, not P6 baseline)

| Module | Empty onPressed/onTap stubs | Verdict | Note |
|--------|----------------------------:|---------|------|
| home | 0 (spot sample 2026-07-21) | PASS (sample) | Not a substitute for P6 sweep |
| profile | 0 (spot sample 2026-07-21) | PASS (sample) | Not a substitute for P6 sweep |

Repo known **legitimate** stubs: DEV design-system demos + copy demo widgets — keep classified `legitimate` when re-auditing.

## Exit criteria (P6)

- Each module row above has dated ledger artifact + counts for `broken` / `needs_review` / `legitimate`.
- `broken` count = 0 on production scopes, or deferred with issue ID.
- Program gate: playbook **STEP-P6.5**.
