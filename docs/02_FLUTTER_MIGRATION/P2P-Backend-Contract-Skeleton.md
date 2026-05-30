# P2P Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file keeps the Phase 4 P2P production path fail-closed without inventing a
remote repository. No remote implementation should be wired from this document
until the backend contract is confirmed by the API owner.

## Required Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Marketplace home | `GET` | `/p2p/offers` | Must return filtered buy/sell offers, merchant metadata, payment methods, limits, fees, and route permissions. |
| Express quote | `POST` | `/p2p/express/quote` | Must validate amount, asset, fiat, payment method, risk, fee, and availability before confirm. |
| Order create | `POST` | `/p2p/orders` | Must require quote id, idempotency key, ownership proof where needed, and escrow lock confirmation. |
| Order lifecycle | `GET/POST` | `/p2p/orders/{id}` | Must support timeline, rate, proof upload, cancel, paid, release, appeal, and immutable receipt/audit fields. |
| Chat/evidence | `GET/POST` | `/p2p/orders/{id}/messages`, `/p2p/disputes/*` | Must separate chat, evidence upload, moderation, dispute state, resolution reason, and retention metadata. |
| Ads/merchant | `GET/POST/PATCH` | `/p2p/ads`, `/p2p/merchants/*` | Must support ad preview, merchant onboarding, profile, reviews, analytics, blacklist, and report flows. |
| Payment methods | `GET/POST/PATCH` | `/p2p/payment-methods` | Must require masked account data, ownership verification, cooling period, audit trail, and change confirmation. |
| Escrow/insurance | `GET` | `/p2p/escrow/*`, `/p2p/insurance/*` | Must return locked funds, coverage, claim state, risk score, certificates, and policy copy. |
| KYC/security/compliance | `GET/POST` | `/p2p/kyc/*`, `/p2p/security/*`, `/p2p/compliance/*` | Must expose verification requirements, device/session controls, AML screening, limits, tax reports, and risk assessment. |

## DTOs To Confirm

- Offer DTOs for side, asset, fiat, price, limits, available quantity, payment
  methods, merchant badges, completion rate, SLA, and risk flags.
- Quote/order DTOs for escrow amount, fee, rate, expiry, preview id, order id,
  idempotency, immutable receipt, payment instructions, and next-step state.
- Payment-method DTOs with masked account fields, owner name policy,
  verification state, cooling period, audit id, and edit/delete restrictions.
- Evidence/dispute DTOs for attachment metadata, redaction, retention,
  moderator notes, resolution codes, appeal window, and fund-release outcome.
- Compliance DTOs for KYC tier, AML status, source-of-funds, limits, tax
  jurisdiction, large transaction justification, and risk assessment.
- Error DTO shape with stable machine codes for insufficient escrow, quote
  expired, payment method unavailable, ownership verification required,
  evidence rejected, dispute locked, rate limit, timeout/offline, locked
  account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, P2P uses
`FailClosedP2PRepository` whenever `enableMockData == false`. The repository
throws `P2PBackendContractMissingException` for every read or action, so
production never falls back to mock P2P offers, escrow, payment-method, or
dispute data.
