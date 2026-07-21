# Auth / Onboarding Shell Spec

Generated: 2026-07-21  
Sources: `02-auth.md`, `auth_routes.dart`, `AuthRouteShell`.

## Model

Auth/onboarding routes are **top-level** (outside `VitAppShell`): no bottom nav, no global header chrome.

```text
onboarding → register/login → OTP → 2FA setup → /home
forgot → reset → login
```

| Item | Spec |
|------|------|
| Login GIỮ | `/auth/login` EP-35 |
| Post-auth landing | `/home` |
| Gates | maintenance / force-update redirect |

## Note

Mock UI may boot straight to `/home` without auth guard — document as mock reality; do not invent fake login walls in reorg Phase 1.
