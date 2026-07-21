# App Shell & Bottom Nav Spec

Generated: 2026-07-21  
Sources: `root_routes.dart`, `vit_app_shell.dart`, `vit_bottom_nav.dart`, `visual_qa_route_metadata.dart` (`_activeDestinationForPath`), `00-INDEX.md`, `17-HOME-PROFILE-MENU-WIREFRAME.md`.

## 1. Shell model (current = recommended baseline)

```text
GoRouter
├─ topLevelRoutes .......... Auth / Onboarding / maintenance / force-update
│                            (NO VitAppShell, NO bottom nav)
└─ ShellRoute → VitAppShell
   ├─ Status bar (visual QA frame only)
   ├─ Child page (feature content)
   └─ VitBottomNav (5 destinations)
```

**Decision (locked):** Keep single `ShellRoute` + 5-tab bottom nav. Do **not** add a 6th tab.

## 2. Bottom Nav destinations (GIỮ)

| Destination | Label | Path | EP |
|-------------|-------|------|----|
| home | Trang chủ | `/home` | EP-01 |
| markets | Thị trường | `/markets` | EP-02 |
| trade | Giao dịch | `/trade` | EP-03 |
| wallet | Ví | `/wallet` | EP-04 |
| profile | Tôi | `/profile` | EP-05 |

Reselect: `context.go(destination.routePath)`.

## 3. Active-tab highlight policy (current code)

| Path prefix / route | Active tab |
|---------------------|------------|
| `/home`, news, search, notifications, topics, support* | **Home** |
| `/markets*`, `/pair/*`, predictions under markets | **Markets** |
| `/trade*`, `/earn*`, `/p2p*`, `/arena*`, `/dca*`, `/launchpad*`, `/rewards`, referral*, unified portfolio*, admin*, many DEV | **Trade** |
| `/wallet*` | **Wallet** |
| `/profile*`, `/settings/security*` | **Profile** |

**Locked for readiness pack:** Option **A** (keep Trade highlight for secondary products). Option B (Home highlight) deferred to Phase 1 shell batch if product prefers.

## 4. Global header actions

| Action | Path | EP | Active tab when open |
|--------|------|----|----------------------|
| Search | `/search` | EP-06 | Home |
| Notifications | `/notifications` | EP-07 | Home |
| News | `/news` | EP-30 | Home |

**Gap:** News is IA GIỮ but may be missing on Home chrome — track in Home Phase 1.

## 5. File mapping

| Concern | File |
|---------|------|
| Router shell | `flutter_app/lib/app/router/route_groups/root_routes.dart` |
| Active tab | `flutter_app/lib/app/router/visual_qa_route_metadata.dart` |
| Chrome | `flutter_app/lib/shared/layout/vit_app_shell.dart` |
| Nav UI | `flutter_app/lib/shared/layout/vit_bottom_nav.dart` |

## 6. Open decisions

1. Keep Trade-tab highlight (A) vs switch to Home (B)?
2. Add News icon to Home header in Phase 1?
3. Deposit/Withdraw dual entry (Home hero + Wallet) — yes per EP-08/09?
