# Earn, Profile, Notifications Backend Contract Skeleton

Status: skeleton only, pending signed backend contracts.

This file keeps the Phase 4 Earn, Profile, and Notifications production paths
fail-closed without inventing remote repositories. No remote implementation
should be wired from this document until the backend contracts are confirmed by
the API owner.

## Earn Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Savings/staking discovery | `GET` | `/earn/products`, `/earn/staking` | Must return product eligibility, APY/APR disclosure, lock terms, risk copy, and route permissions. |
| Preview/confirm actions | `POST` | `/earn/actions/preview`, `/earn/actions` | Must validate amount, fees, limits, lockup, custody terms, suitability, idempotency, and receipt generation before confirm. |
| Portfolio/history/receipts | `GET` | `/earn/portfolio`, `/earn/history`, `/earn/receipts/{id}` | Must return balances, pending actions, yield history, transaction state, and immutable receipts. |
| Risk/compliance | `GET/POST` | `/earn/risk/*`, `/earn/compliance/*` | Must expose disclosures, suitability, proof-of-reserves, custody, tax/regulatory copy, and audit reports. |
| Automation/tools | `GET/POST` | `/earn/automation/*`, `/earn/tools/*` | Must cover auto-compound, DCA, rebalance, ladder, what-if, backtest, webhooks, exports, and developer console. |

## Profile Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Profile overview | `GET/PATCH` | `/profile` | Must return masked identity, preferences, VIP, compliance flags, and edit confirmation semantics. |
| Security/KYC | `GET/POST` | `/profile/security/*`, `/profile/kyc/*` | Must require preview/confirm for security changes and expose device/session/audit metadata. |
| API/subaccounts | `GET/POST/PATCH` | `/profile/api-keys`, `/profile/subaccounts` | Must support masked keys, scopes, limits, 2FA/session proof, and immutable audit ids. |
| Activity/settings | `GET/PATCH` | `/profile/activity`, `/profile/settings` | Must support filters, notification preferences, privacy controls, and masked contact data. |

## Notifications Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Notification inbox | `GET` | `/notifications` | Must return notification type, severity, read state, action path, created time, and pagination. |
| Notification actions | `POST/PATCH` | `/notifications/{id}` | Must support mark read, archive/clear, action audit, and idempotency where needed. |
| Preferences | `GET/PATCH` | `/notifications/preferences` | Must expose channel preferences, quiet hours, security alerts, and product-specific toggles. |

## DTOs To Confirm

- Earn DTOs for product terms, APY/APR disclosure, eligibility, preview id,
  fees, limits, custody/risk copy, suitability, receipt id, and pending state.
- Profile DTOs for masked account/contact fields, security status, KYC level,
  API-key scopes, device/session metadata, subaccount limits, and audit ids.
- Notification DTOs for category, severity, read state, action path, payload
  summary, pagination cursor, and preference controls.
- Error DTO shape with stable machine codes for unavailable product,
  insufficient balance, limit exceeded, locked account, security proof required,
  KYC required, invalid preference, timeout/offline, rate limit, and service
  unavailable.

## Production Guardrail

Until these contracts are signed and DTO tests exist:

- Earn repository providers use `failClosedEarnRepository` when
  `enableMockData == false`; this throws the typed Earn backend-contract
  exception at provider read instead of returning mock data.
- Profile uses `FailClosedProfileRepository` when `enableMockData == false`.
- Notifications uses `FailClosedNotificationsRepository` when
  `enableMockData == false`.

These repositories throw typed backend-contract exceptions, so production never
falls back to mock Earn, profile, security, or notification data.
