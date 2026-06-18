# VitTrade Home UI Rollout Playbook

**Status:** Design-system rollout guide
**Source foundation:** `SC-007 HomePage`
**Audience:** AI agents, designers, and engineers updating Flutter UI
**Purpose:** Turn Home into a reusable UI standard for other modules without copying Home business logic.

For rollout execution tracking, use
`docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md`.

---

## 1. Operating Rule

Home is the visual foundation for VitTrade's dark, dense, financial mobile UI.
Use its hierarchy, spacing rhythm, shared primitives, and safety treatment. Do
not copy Home-specific product order, campaign copy, route data, portfolio
state, or Prediction/Arena bridge logic into unrelated modules.

Default page contract:

```text
module header
-> module hero or primary context
-> primary action cluster
-> resume/status/safety card
-> tools or filters
-> dense lists/records/data
-> secondary discovery
-> bottom-nav-safe content end
```

Required shared primitives when they fit:

| Need | Use |
| --- | --- |
| Page shell | `VitPageLayout`, `VitPageContent`, `VitInsetScrollView` |
| Header/chrome | `VitHeader`, `VitTopChrome`, `VitAutoHideHeaderScaffold` only for Home-like root behavior |
| Surface/card | `VitCard`, `VitHeroGlow`, `VitSheetPanel`, `VitSheetHandle` |
| CTA/action | `VitCtaButton`, `VitIconButton`, `VitInlineIconAction`, `VitActionTileGrid`, `VitServiceTile` |
| Text hierarchy | `AppTextStyles`, `VitSectionHeader` |
| State/status | `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill` |
| Market/data | `VitMarketTickerStrip`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline` |
| Forms/search | `VitInput`, `VitSearchBar`, `VitTabBar` |
| UX states | `VitSkeleton`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`, `VitHighRiskStatePanel` |
| Cross-module discovery | `VitDiscoveryActionCard` only when boundaries are explicit |

Do not create a local scaffold, card, pill, sparkline, avatar, bottom-sheet
handle, section header, or action grid when a shared primitive already covers
the behavior.

## 1.1 Home UI Baseline

Use Home as a pattern library, not as business logic to copy. The current Home
baseline is:

```text
compact announcement
-> portfolio financial hero
-> next action
-> compact market ticker
-> products/action launcher
-> recent products
-> Prediction/Arena discovery
-> full market sections and ranked lists
-> bottom-nav-safe content end
```

Baseline patterns to reuse when the module has the matching need:

| Home baseline pattern | Reuse rule |
| --- | --- |
| Financial hero | Use one hero-weight value card, masking for sensitive balances, `VitMetricDeltaPill`, tabular numbers, and direct money CTAs. |
| Next action | Use `VitNextActionCard` for the single most important resumable task or safety action. |
| Market ticker | Use `VitMarketTickerStrip` near the top of market/trading surfaces so price discovery appears before long tables. |
| Action launcher | Use `VitActionTileGrid` with density/max-visible policy instead of hand-built grids. Phone compact defaults to 6 primary actions; comfortable defaults to 9; overflow goes to a shared sheet. |
| Compact discovery | Use `VitDiscoveryActionCard.compact` for cross-module discovery, with explicit copy boundaries. |
| Dense market rows | Use `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, and `VitSparkline` instead of large repeated cards for price lists. |
| Announcement | Use `VitAnnouncementBanner.compact` for short operational/campaign/security/risk notices. Campaign can be session-hidden after scroll; security/risk should remain visible until dismissed. |
| Bottom clearance | Use `VitInsetScrollView` and shell-aware bottom insets so bottom nav/fixed chrome never covers text, CTAs, receipts, forms, or disclosures. |

Shared visuals, local business adapter:

- Keep a composition local when it owns provider state, route decisions, copy
  boundaries, financial safety, or Arena points-only language.
- Even when composition stays local, use shared visual primitives inside it when
  the visual pattern matches.
- Record the L3 local reason in the rollout batch log. A local composition
  without a reason is not considered aligned.

GitNexus is required during rollout:

- Use `gitnexus-cli` preflight before implementation batches so the dependency
  graph is fresh enough to trust.
- Use GitNexus `context` for target screens to identify route, provider,
  controller, entity, local widget, shared widget, and test dependencies before
  editing.
- Use GitNexus `impact` before editing any shared primitive, router file,
  provider, controller, domain entity, repository contract, or helper that may
  be reused outside the active screen.
- Use GitNexus `detect_changes` after edits to record actual affected symbols
  and processes in the batch log.
- Use graph output to reduce missed dependencies, not to overrule Flutter
  source, financial safety, copy boundaries, tests, or audits.

Headroom is optional during rollout:

- Use MCP Headroom only to compress long GitNexus output, analyzer logs, test
  logs, audit output, route reports, diffs, or previous-batch evidence.
- Do not use Headroom as the source of truth for the prompt, execution plan,
  playbook, current source files, tests, financial safety rules, or
  Prediction/Arena boundaries.
- If Headroom is used, retrieve the relevant hash before acting on compressed
  information and record durable evidence in the execution plan.

---

## 2. Module Rollout Matrix

| Module | Layout pattern | Required shared components | Token rules | Safety rules | Test/audit |
| --- | --- | --- | --- | --- | --- |
| Wallet | Financial command center: balance hero, money CTAs, assets/history, tools | `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitCard`, `VitCtaButton`, `VitMetricDeltaPill`, `VitActionTileGrid`, `VitSectionHeader`, `VitInsetScrollView`, `VitStatusPill` | Use `AppModuleAccents.wallet`; `heroNumber` for total balance; `tabularFigures` for money/percent; no local colors/radii/spacing | Preserve masking, available/in-order/frozen balances, fees, limits, risk, preview/confirm, next steps | `flutter test test/features/wallet --reporter=compact`; `dart run tool/design_token_consistency_audit.dart --check`; responsive QA when first viewport changes |
| Markets | Market discovery: ticker, tabs, pair rows, ranked lists, pair detail entry | `VitTabBar`, `VitMarketTickerStrip`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline`, `VitSearchBar`, `VitSectionHeader` | Use `AppModuleAccents.markets`; use `buy`/`sell` only for movement; `tabularFigures` for price/volume/percent | Do not use hype or casino copy; color cannot be the only movement indicator; keep pair routes intact | `flutter test test/features/markets --reporter=compact`; `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact` |
| Trade | Order workspace: instrument context, order form, risk summary, receipt/history | `VitHeader`/instrument chrome, `VitTabBar`, `VitInput`, `VitCtaButton`, `VitCard`, `VitStatusPill`, `VitHighRiskStatePanel`, `VitErrorState`, `VitOfflineBanner` | Use `AppModuleAccents.trade`; `buy`/`sell` for side only; `tabularFigures` for price/amount/percent; no viewport-scaled fonts | Preserve order preview, fees, risk, leverage/margin disclosures, limits, confirmation, and receipt state | `flutter test test/features/trade --reporter=compact`; `dart run tool/design_token_consistency_audit.dart --check`; high-risk guardrail if touched |
| P2P | Escrow command center: wallet actions, orders, payment methods, transfer flows | `VitCard`, `VitCtaButton`, `VitInput`, `VitStatusPill`, `VitHighRiskStatePanel`, `VitActionTileGrid`, `VitSectionHeader`, `VitInsetScrollView` | Use `AppModuleAccents.p2p`; warning/amber for escrow/risk; tabular money and limits | Preserve escrow release preview/confirm, payment-method confirmation, phone/account masking, limits, fees, next steps | `flutter test test/features/p2p --reporter=compact`; `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` |
| Profile | Account/security hub: identity, KYC, settings, security actions, support routes | `VitHeader`, `VitCard`, `VitSectionHeader`, `VitStatusPill`, `VitActionTileGrid`, `VitCtaButton`, `VitOfflineBanner` | Use `AppModuleAccents.profile`; neutral surfaces; warning only for risk/security state | Mask email/phone/account identifiers; preview/confirm security changes; keep KYC state clear | `flutter test test/features/profile --reporter=compact`; top-header guardrails if header actions change |
| Arena | Points-only social/competition surface: points hero, challenges, fair-play state | `VitCard`, `VitSectionHeader`, `VitStatusPill`, `VitActionTileGrid`, `VitDiscoveryActionCard`, `VitEmptyState`, `VitErrorState` | Use `AppModuleAccents.arena`; warning/amber or neutral points tone; never use wallet-value tokens | Points-only language: Arena Points, points pool, resolution, challenge, completion; never wallet, payout, profit, stake-return | `flutter test test/features/arena --reporter=compact`; copy review for points-only language |
| Predictions | Prediction market surface: event hero, probability, positions, orders, receipts | `VitCard`, `VitTabBar`, `VitStatusPill`, `VitCtaButton`, `VitMarketPairRow`-style dense rows when applicable, `VitHighRiskStatePanel` | Use `AppModuleAccents.predictions`; `tabularFigures` for probability, odds, P/L; buy/sell only for movement/side | Keep wallet-value language separate from Arena; preserve positions, probability, receipt, P/L, risk copy | `flutter test test/features/predictions --reporter=compact`; design-token audit |
| Earn | Yield/product hub: balance context, product cards, risk tiers, history | `VitCard`, `VitSectionHeader`, `VitStatusPill`, `VitCtaButton`, `VitActionTileGrid`, `VitSkeleton`, `VitEmptyState` | Use `AppModuleAccents.earn`; tabular APY/amounts; warning for lock/risk | Show lock terms, risk, fee/limit, next steps; avoid guaranteed-return copy | `flutter test test/features/earn --reporter=compact`; responsive QA for product grids |
| DCA | Recurring investment flow: plan setup, preview, schedule, history | `VitInput`, `VitCtaButton`, `VitCard`, `VitStatusPill`, `VitHighRiskStatePanel`, `VitSectionHeader` | Use module accent from parent trading/investment context; tabular amount, interval, estimate | Preserve preview, frequency, budget, fee, risk, and cancellation state | `flutter test test/features/dca --reporter=compact`; design-token audit |
| Launchpad | Campaign/detail surface: project hero, eligibility, allocation, claim receipt | `VitCard`, `VitCtaButton`, `VitStatusPill`, `VitSectionHeader`, `VitMetricDeltaPill`, `VitSkeleton`, `VitEmptyState` | Use `AppModuleAccents.launchpad`; primary for trust, warning for eligibility/risk; tabular allocation | Show eligibility, lock, risk, claim/receipt state; avoid hype/FOMO copy | `flutter test test/features/launchpad --reporter=compact`; responsive QA for campaign cards |
| Discovery/Search | Cross-module search and topic discovery | `VitSearchBar`, `VitCard`, `VitDiscoveryActionCard`, `VitSectionHeader`, `VitStatusPill`, `VitEmptyState`, `VitErrorState` | Use `AppModuleAccents.crossModule`; accent only to separate domains; avoid one-color pages | Prediction/Arena bridges must show separate currency/performance/history boundaries | `flutter test test/features/discovery --reporter=compact`; route/search tests if navigation changes |
| Notifications/News/Support | Info and support surfaces: inbox, notices, help topics, status details | `VitHeader`, `VitCard`, `VitSectionHeader`, `VitStatusPill`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` | Use module accent from context; warning/error only for actual risk/state | Security/risk notices must be explicit; support flows must not hide next steps | `flutter test test/features/notifications test/features/news test/features/support --reporter=compact` |
| Admin/Dev | Internal dashboards: operational metrics, QA routes, design-system previews | `VitPageLayout`, `VitPageContent`, `VitCard`, `VitSectionHeader`, `VitStatusPill`, `VitTabBar`, `VitSkeleton` | Use neutral/admin accents; tabular metrics; no local palette experiments in production routes | Do not expose internal-only actions in user routes; keep states explicit | `flutter test test/features/admin test/features/dev --reporter=compact`; full suite if shared preview changes |

---

## 3. Pattern Matrix

| Screen type | Use this Home-derived pattern | Required shared components | Acceptance check |
| --- | --- | --- | --- |
| Command center | Header, hero context, primary CTAs, next action, compact tools, dense lists | `VitPageLayout`, `VitHeader`, `VitCard`, `VitCtaButton`, `VitSectionHeader`, `VitInsetScrollView` | First viewport shows module identity, main value/state, primary action, and no bottom-nav overlap |
| Financial hero | One hero-weight card only, large number, masking if sensitive, CTA row | `VitCard(variant: hero)`, `VitHeroGlow`, `VitMetricDeltaPill`, `VitInlineIconAction`, `VitCtaButton` | Value uses `heroNumber`; financial figures use `tabularFigures`; masking remains reachable |
| Market/data list | Compact ticker or tabs above dense rows; rows stay scannable | `VitMarketTickerStrip`, `VitTabBar`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitSparkline` | Price/change visible at 360dp; no oversized row cards for dense market data |
| High-risk form | Inputs, risk panel, preview summary, explicit confirmation CTA | `VitInput`, `VitHighRiskStatePanel`, `VitCard`, `VitCtaButton`, `VitOfflineBanner` | Fees, limits, risk, and next steps visible before confirmation |
| Confirmation/receipt | Outcome state, transaction facts, next actions, support path | `VitCard`, `VitStatusPill`, `VitCtaButton`, `VitSectionHeader` | Receipt values are tabular; copy states what happened and what to do next |
| Profile/settings | Grouped setting sections, status pills, direct but safe actions | `VitSectionHeader`, `VitCard`, `VitStatusPill`, `VitActionTileGrid` | Security/account changes use preview/confirm and masked identifiers |
| Points-only/social | Points hero, challenge context, fair-play/status copy | `VitCard`, `VitStatusPill`, `VitDiscoveryActionCard`, `VitEmptyState` | No wallet, payout, profit, stake-return, or P/L language |
| Support/info | Search/help entry, status notices, topic cards, offline/error states | `VitSearchBar`, `VitCard`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` | User can see state, next step, and support route without guessing |

---

## 4. Token And Copy Rules

- Use `AppColors`, `AppSpacing`, `AppTextStyles`, `AppModuleAccents`, and
  shared component variants before adding new tokens.
- Use `AppTextStyles.tabularFigures` for money, price, amount, probability,
  APY, P/L, percentage, volume, balance, and limits.
- Use `AppColors.buy`/`AppColors.sell` only for direction, side, or state that
  is semantically positive/negative. Do not use green/red as decoration.
- Module accent is an accent layer only. Do not turn a module into a one-color
  palette.
- Module pages must not copy `VitTopChromeType.rootBrand` unless they are true
  app-root surfaces. Use module identity headers for module routes.
- Do not use emojis as UI icons. Use Material/Lucide-equivalent Flutter icons
  already accepted by the module.
- Do not add local `TextStyle(fontSize: ...)`, raw `EdgeInsets`, local
  `BorderRadius.circular`, or local color constants in page bundles when token
  or shared primitives cover the need.
- Keep Home-specific financial copy local to Home. Only reuse visual hierarchy,
  primitives, and safety standards.

---

## 5. Acceptance Checklist

Before marking a page as aligned with the Home UI standard:

- [ ] Uses shared layout primitives instead of a local scaffold.
- [ ] Uses shared cards, section headers, pills, CTAs, inputs, tabs, and state
      widgets where available.
- [ ] First viewport at `360dp` shows module identity, primary context, and at
      least one primary action.
- [ ] First viewport follows the closest Home baseline rhythm: hero/context,
      next action or primary CTA, then tools/ticker/list content as appropriate.
- [ ] Bottom nav or fixed chrome does not cover text, CTAs, receipts, form
      controls, or critical disclosures.
- [ ] Typography uses `AppTextStyles`; market, trade, wallet, earn, DCA,
      launchpad, prediction, and money numbers use `tabularFigures`.
- [ ] Spacing, radii, icons, and surfaces come from tokens/shared components.
- [ ] Any local composition has an explicit L3 reason: provider state, route
      logic, copy boundary, financial safety, or points-only semantics.
- [ ] GitNexus evidence is recorded: index status, screen `context`, required
      `impact` checks, and post-edit `detect_changes`.
- [ ] Headroom hashes are recorded if Headroom was used for long GitNexus,
      test, audit, route, or diff output.
- [ ] Loading, empty, error, offline, submitting, and success states exist where
      the flow can enter those states.
- [ ] High-risk actions show fee/risk/limit/next-step copy before confirmation.
- [ ] Arena and Prediction Markets remain visibly and semantically separate.
- [ ] No route, provider, masking, financial safety, or copy boundary changes
      are made as a side effect of visual cleanup.

Recommended verification for UI code changes:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test test/features/<module> --reporter=compact
```

Run responsive visual QA or emulator screenshots when changing first viewport,
bottom chrome clearance, shared layout, dense grids, market rows, or high-risk
forms.

For docs-only changes to this playbook:

```bash
git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md
```

---

## 6. How To Use This Playbook

1. Read the execution plan's actual audit snapshot and next batch queue before
   selecting screens. The queue decides resume order; this playbook decides the
   UI pattern.
2. Identify the target module row in the module matrix.
3. Pick the closest screen type from the pattern matrix.
4. Keep the module's business logic, routes, copy boundaries, and safety rules.
5. Replace local repeated visuals with the listed shared components.
6. Verify token usage and first-viewport behavior before widening the cleanup.
7. Update tests or QA artifacts only for the module being changed.

This playbook is intentionally stricter than a visual inspiration document. If
it conflicts with Flutter source, current source wins. If it conflicts with
financial safety, financial safety wins.
