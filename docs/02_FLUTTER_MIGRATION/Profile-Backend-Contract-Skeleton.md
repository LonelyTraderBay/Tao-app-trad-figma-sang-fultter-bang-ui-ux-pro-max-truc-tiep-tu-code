# Profile Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 Profile / KYC / Security production path
fail-closed without inventing a remote repository. No remote implementation
should be wired from this document until the backend contract is confirmed by
the API owner.

P0 scope is Profile read plus KYC/Security high-risk changes (preview/confirm
where applicable), per `ke-hoach-san-sang-production.md`.

## Required Endpoints

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Profile read | `GET` | `/profile` | Must return masked identity/contact fields and compliance/KYC summary flags. |
| KYC status | `GET` | `/profile/kyc` | Must return verification tier, outstanding requirements, and next-step routing. |
| Security settings | `GET` | `/profile/security` | Must return 2FA state, password policy flags, trusted devices/sessions summary. |
| Password change preview | `POST` | `/profile/security/password/preview` | Must validate current credential binding and new password policy before confirm. |
| Password change confirm | `POST` | `/profile/security/password/confirm` | Must require preview binding, challenge/OTP where required, audit trail, and idempotency. |
| 2FA change preview | `POST` | `/profile/security/2fa/preview` | Must describe enable/disable/rotate impact and backup-code acknowledgement needs. |
| 2FA change confirm | `POST` | `/profile/security/2fa/confirm` | Must require preview binding, factor proof, audit trail, and idempotency. |

## DTOs To Confirm

- Request DTOs for password change, 2FA enable/disable/rotate purpose, OTP or
  factor challenge binding, and backup-code acknowledgement.
- Response DTOs for profile snapshot, KYC status, security settings, password
  change result, and 2FA change result including audit requirement flags.
- Preview/confirm DTOs with preview id, risk labels, challenge requirements,
  audit trail id, and idempotency key.
- Error DTO shape with stable machine codes for invalid credentials, invalid
  OTP/factor, expired challenge, password policy violation, rate limit, locked
  account, offline/timeout, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Profile uses
`FailClosedProfileRepository` whenever `enableMockData == false`. That
repository throws `ProfileBackendContractMissingException` and the presentation
layer renders a controlled error state instead of using mock data or crashing
on provider read.
