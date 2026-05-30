# Arena Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file keeps the Phase 4 Open Arena production path fail-closed without
inventing a remote repository. No remote implementation should be wired from
this document until the backend contract is confirmed by the API owner.

## Required Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Arena home/discovery | `GET` | `/arena/home`, `/arena/challenges` | Must return challenge discovery, topic/category context, mode metadata, creator info, fair-play labels, and completion state. |
| Studio/rules | `GET/POST` | `/arena/studio/*`, `/arena/rules/*` | Must support draft challenges, smart rules, preset library, governance gate, moderation requirements, and publish readiness. |
| Challenge detail/join | `GET/POST` | `/arena/challenges/{id}` | Must return rules, Arena Points requirements, participation state, join confirmation, and next steps. |
| Arena Points | `GET` | `/arena/points`, `/arena/points/ledger` | Must return points balance, ledger entries, entry details, completion reasons, and expiry/adjustment copy. |
| Creator/leaderboard | `GET` | `/arena/creators/*`, `/arena/leaderboard` | Must expose creator reputation, completion/fair-play ranking, and verified challenge signals. |
| Safety/resolution | `GET/POST` | `/arena/safety/*`, `/arena/reports/*`, `/arena/resolution/*` | Must support blocked users, report cases, trust breakdown, evidence, resolution status, and appeal windows. |
| Prediction bridge | `GET` | `/arena/prediction-context/*` | Must expose topic/category and event-context bridges only; wallet, PnL, and position data stay in Prediction Markets. |
| Production readiness | `GET` | `/arena/production-readiness`, `/arena/ecosystem` | Must expose operational readiness, dependency status, audit evidence, and release gates. |

## DTOs To Confirm

- Challenge DTOs for mode, topic/category, creator, rules, lifecycle status,
  completion state, Arena Points, fairness labels, and moderation state.
- Studio DTOs for draft fields, smart-rule validation, preset metadata,
  governance requirements, publish readiness, and audit trail id.
- Points DTOs for balance, ledger entry, entry reason, completion source,
  expiry/adjustment, and immutable entry detail.
- Safety DTOs for report case, blocked user, trust breakdown, resolution state,
  evidence metadata, appeal window, and fair-play status.
- Bridge DTOs must carry event context and discovery metadata only. They must
  not include wallet balance, positions, PnL, payout, profit, or stake-return
  language.
- Error DTO shape with stable machine codes for challenge closed, join not
  allowed, points unavailable, fair-play lock, report locked, moderation
  required, timeout/offline, rate limit, locked account, and service
  unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Open Arena uses
`FailClosedArenaRepository` whenever `enableMockData == false`. The repository
throws `ArenaBackendContractMissingException` for every read or action, so
production never falls back to mock challenge, Arena Points, ledger, or
fair-play data.
