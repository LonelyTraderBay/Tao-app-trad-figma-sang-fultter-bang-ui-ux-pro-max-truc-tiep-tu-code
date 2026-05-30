# Wallet Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 Wallet production path fail-closed without
inventing a remote repository. No remote implementation should be wired from
this document until the backend contract is confirmed by the API owner.

## Required Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Portfolio overview | `GET` | `/wallet/overview` | Must return balances, available/in-order/frozen amounts, asset rows, and enabled actions. |
| Transactions | `GET` | `/wallet/transactions` | Must support filters, detail lookup, network metadata, and masked addresses. |
| Deposit | `GET` | `/wallet/deposit-options` | Must return asset-scoped networks, deposit address, memo rules, fees, and confirmation requirements. |
| Withdraw preview | `POST` | `/wallet/withdrawals/preview` | Must return fee, limits, memo requirements, destination validation, and received amount before confirm. |
| Withdraw confirm | `POST` | `/wallet/withdrawals` | Must require preview id, 2FA/session proof, audit trail id, and idempotency key. |
| Address book | `GET/POST/PATCH` | `/wallet/address-book` | Must support whitelist state, favorite state, network validation, and masked display. |
| Token approvals | `GET/POST` | `/wallet/token-approvals` | Must support active approvals, revoke preview, revoke confirm, and risk labels. |
| Limits/health/tools | `GET` | `/wallet/limits`, `/wallet/health`, `/wallet/tools/*` | Must return read-only status and clear unavailable states. |

## DTOs To Confirm

- Balance DTOs for total, available, in-order, frozen, asset symbol, precision,
  fiat value, and 24h change.
- Deposit/withdraw network DTOs for min/max, fee, memo, confirmation, enabled
  flags, maintenance status, and risk copy.
- Withdraw preview/confirm DTOs with idempotency, 2FA/session proof, fees,
  limits, next steps, and audit trail id.
- Address-book DTOs with masked address, whitelist state, favorite state,
  network/asset, and validation errors.
- Error DTO shape with stable machine codes for insufficient balance, limit
  exceeded, invalid address, memo required, network disabled, timeout/offline,
  rate limit, locked account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Wallet uses
`FailClosedWalletRepository` whenever `enableMockData == false`. The repository
returns empty/error-state snapshots, disables high-risk actions through zero
availability and unavailable network metadata, and never wires mock data into
production.
