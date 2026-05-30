# Auth Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 Auth production path fail-closed without
inventing a remote repository. No remote implementation should be wired from
this document until the backend contract is confirmed by the API owner.

## Required Endpoints

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Login | `POST` | `/auth/login` | Must return session metadata and auth token delivery semantics. |
| Register | `POST` | `/auth/register` | Must create an OTP challenge before any trusted session is granted. |
| Verify factor | `POST` | `/auth/factors/verify` | Must support register, 2FA, password reset, and generic verify purposes. |
| Setup 2FA | `POST` | `/auth/2fa/setup` | Must require backup-code acknowledgement and audit metadata. |
| Request password reset | `POST` | `/auth/password-reset/request` | Must not leak account existence. |
| Confirm password reset | `POST` | `/auth/password-reset/confirm` | Must require OTP/challenge binding and new password policy validation. |

## DTOs To Confirm

- Request DTOs for identifier, password, contact type, OTP purpose, OTP code,
  2FA secret/challenge id, backup-code acknowledgement, and password reset.
- Response DTOs for session, registration draft, OTP challenge, device trust,
  2FA setup result, password reset result, and audit requirement flags.
- Error DTO shape with stable machine codes for invalid credentials, invalid
  OTP, expired challenge, rate limit, locked account, offline/timeout, and
  service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Auth uses
`FailClosedAuthRepository` whenever `enableMockData == false`. That repository
throws `AuthBackendContractMissingException` and the presentation layer renders
a controlled error state instead of using mock data or crashing on provider
read.
