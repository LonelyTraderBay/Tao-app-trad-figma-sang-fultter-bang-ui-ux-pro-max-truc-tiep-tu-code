# P2P Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 P2P production path fail-closed without
inventing a remote repository. No remote implementation should be wired from
this document until the backend contract is confirmed by the API owner.

P0 scope is payment method, order, escrow, and dispute only, per
`ke-hoach-san-sang-production.md`.

**Product boundary:** Open Arena points language is **out of scope** for P2P.
P2P copy and DTOs must stay in wallet/fiat/escrow terms — do not reuse Arena
points, points pool, or fair-play ledger vocabulary on these endpoints.

## Required Endpoints

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Payment methods list | `GET` | `/p2p/payment-methods` | Must return masked payment accounts and ownership/verification state. |
| Payment method add preview | `POST` | `/p2p/payment-methods/preview` | Must validate ownership rules and show cooling-period / risk copy before confirm. |
| Payment method add confirm | `POST` | `/p2p/payment-methods/confirm` | Must require preview binding, audit trail, and idempotency. |
| Order create preview | `POST` | `/p2p/orders/preview` | Must validate amount, asset, fiat, payment method, fee, and escrow lock before confirm. |
| Order create confirm | `POST` | `/p2p/orders/confirm` | Must require preview binding, escrow lock confirmation, audit trail, and idempotency. |
| Order detail | `GET` | `/p2p/orders/{id}` | Must return timeline, payment instructions, escrow state, and immutable receipt fields. |
| Escrow status | `GET` | `/p2p/orders/{id}/escrow` | Must return locked funds, release eligibility, and risk flags for the order. |
| Escrow release preview | `POST` | `/p2p/orders/{id}/escrow/release-preview` | Must show release impact and confirmation requirements before confirm. |
| Escrow release confirm | `POST` | `/p2p/orders/{id}/escrow/release-confirm` | Must require preview binding, session proof, audit trail, and idempotency. |
| Dispute open | `POST` | `/p2p/orders/{id}/disputes` | Must open a dispute with reason codes and evidence retention metadata. |
| Dispute detail | `GET` | `/p2p/disputes/{id}` | Must return dispute state, evidence summary, resolution reason, and appeal window. |

## DTOs To Confirm

- Payment-method DTOs with masked account fields, owner name policy,
  verification state, cooling period, preview/confirm ids, and audit id.
- Order preview/confirm DTOs for escrow amount, fee, rate, expiry, preview id,
  order id, idempotency, payment instructions, and next-step state.
- Escrow DTOs for locked amount, release eligibility, risk flags, preview id,
  and release receipt/audit fields.
- Dispute DTOs for reason codes, evidence metadata, redaction/retention,
  resolution codes, appeal window, and fund-release outcome.
- Error DTO shape with stable machine codes for payment method unavailable,
  ownership verification required, insufficient escrow, quote/preview expired,
  evidence rejected, dispute locked, rate limit, offline/timeout, locked
  account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, P2P uses
`FailClosedP2PRepository` whenever `enableMockData == false`. That repository
throws `P2PBackendContractMissingException` and the presentation layer renders
a controlled error state instead of using mock data or crashing on provider
read.
