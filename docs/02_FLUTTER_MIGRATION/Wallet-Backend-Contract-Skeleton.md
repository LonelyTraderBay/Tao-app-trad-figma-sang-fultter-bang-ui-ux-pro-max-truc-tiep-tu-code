# Wallet Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 Wallet production path fail-closed without
inventing a remote repository. No remote implementation should be wired from
this document until the backend contract is confirmed by the API owner.

P0 scope is taken from `ke-hoach-san-sang-production.md` (Wallet overview,
assets, history, deposit, withdraw, transfer, address book, token approval).

## Required Endpoints

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Overview | `GET` | `/wallet/overview` | Must return portfolio summary and enabled high-risk actions. |
| Assets | `GET` | `/wallet/assets` | Must return asset rows with availability and precision metadata. |
| Transactions | `GET` | `/wallet/transactions` | Must support filters/pagination and masked address display fields. |
| Deposit address | `POST` | `/wallet/deposits/address` | Must return asset/network-scoped deposit address and memo rules. |
| Withdraw preview | `POST` | `/wallet/withdrawals/preview` | Must return fee, limits, risk, received amount, and next steps before confirm. |
| Withdraw confirm | `POST` | `/wallet/withdrawals/confirm` | Must require preview binding, 2FA/session proof, audit trail, and idempotency. |
| Transfer preview | `POST` | `/wallet/transfers/preview` | Must validate destination, amount, fee/limits, and risk before confirm. |
| Transfer confirm | `POST` | `/wallet/transfers/confirm` | Must require preview binding, session proof, audit trail, and idempotency. |
| Address book list | `GET` | `/wallet/address-book` | Must return saved destinations with masked display and network/asset binding. |
| Address book add | `POST` | `/wallet/address-book` | Must validate network/address/memo and support whitelist/favorite semantics. |
| Token approvals list | `GET` | `/wallet/token-approvals` | Must return active approvals with risk labels. |
| Token approval revoke preview | `POST` | `/wallet/token-approvals/revoke-preview` | Must show revoke impact and confirmation requirements before confirm. |
| Token approval revoke confirm | `POST` | `/wallet/token-approvals/revoke-confirm` | Must require preview binding, session proof, audit trail, and idempotency. |

## DTOs To Confirm

- Request DTOs for asset/network selection, deposit address lookup, withdraw
  and transfer amounts, address-book entries, and token-approval revoke ids.
- Response DTOs for overview, asset rows, transaction history, deposit address,
  withdraw/transfer preview and confirm receipts, address-book entries, and
  token-approval rows.
- Preview/confirm DTOs with preview id, fees, limits, risk level, 2FA flags,
  estimated arrival / next steps, audit trail id, and idempotency key.
- Error DTO shape with stable machine codes for insufficient balance, limit
  exceeded, invalid address, memo required, network disabled, preview expired,
  rate limit, locked account, offline/timeout, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Wallet uses
`FailClosedWalletRepository` whenever `enableMockData == false`. That repository
throws `WalletBackendContractMissingException` and the presentation layer
renders a controlled error state instead of using mock data or crashing on
provider read.
