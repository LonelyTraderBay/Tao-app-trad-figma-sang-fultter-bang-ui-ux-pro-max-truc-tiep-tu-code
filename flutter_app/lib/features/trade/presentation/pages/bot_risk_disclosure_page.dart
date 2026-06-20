import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_risk_disclosure_page_sections.dart';
part '../widgets/bot_risk_disclosure_page_common.dart';

const _botRiskBackground = AppColors.bg;
const _botRiskRed = AppColors.sell;
const _botRiskAmber = AppColors.caution;
const _botRiskPurple = AppColors.accent;
const _botRiskPrimary = AppColors.primary;
const _botRiskGreen = AppColors.buy;
const _riskSpace = AppSpacing.x2;
const _riskTinySpace = AppSpacing.x1;
const _riskVisualScrollClearance = 112.0;
const _riskNativeScrollClearance = 72.0;
const _riskIconTile = 34.0;
const _riskActionHeight = 44.0;
const _riskLineTight = 1.2;

class BotRiskDisclosurePage extends ConsumerStatefulWidget {
  const BotRiskDisclosurePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc118_bot_risk_content');
  static const acknowledgmentKey = Key('sc118_bot_risk_acknowledgment');
  static const ctaKey = Key('sc118_bot_risk_cta');
  static Key categoryKey(String id) => Key('sc118_bot_risk_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotRiskDisclosurePage> createState() =>
      _BotRiskDisclosurePageState();
}

class _BotRiskDisclosurePageState extends ConsumerState<BotRiskDisclosurePage> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotRiskDisclosure();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _riskVisualScrollClearance
            : _riskNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-118 BotRiskDisclosurePage',
      child: Material(
        color: _botRiskBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Risk Disclosure',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotRiskDisclosurePage.contentKey,
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.only(bottom: scrollEndClearance),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _HighRiskBanner(snapshot: snapshot),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        padding: AppSpacing.cardPaddingCompact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot risk disclosure review',
                              message:
                                  'Past performance, category risks, regulatory notice, acknowledgment and next steps are reviewed before bot access.',
                              contractId: 'bot-risk-disclosure-review',
                              density: VitDensity.compact,
                            ),
                            SizedBox(height: _riskSpace),
                            VitStatusPill(
                              label: 'Acknowledgment required',
                              status: VitStatusPillStatus.error,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      _PastPerformanceCard(snapshot: snapshot),
                      VitPageSection(
                        label: snapshot.riskSectionLabel,
                        accentColor: _botRiskPrimary,
                        density: VitDensity.compact,
                        children: [
                          for (final category in snapshot.categories)
                            _RiskCategoryCard(category: category),
                        ],
                      ),
                      VitPageSection(
                        label: snapshot.additionalWarningsLabel,
                        accentColor: _botRiskPrimary,
                        density: VitDensity.compact,
                        children: [
                          _AdditionalWarningsCard(
                            warnings: snapshot.additionalWarnings,
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: snapshot.regulatoryNoticeLabel,
                        accentColor: _botRiskPrimary,
                        density: VitDensity.compact,
                        children: [_RegulatoryNoticeCard(snapshot: snapshot)],
                      ),
                      VitPageSection(
                        label: snapshot.acknowledgmentLabel,
                        accentColor: _botRiskPrimary,
                        density: VitDensity.compact,
                        children: [
                          _AcknowledgmentCard(
                            snapshot: snapshot,
                            acknowledged: _acknowledged,
                            onTap: () =>
                                setState(() => _acknowledged = !_acknowledged),
                          ),
                          _RiskCta(
                            snapshot: snapshot,
                            acknowledged: _acknowledged,
                            onPressed: () => context.go(snapshot.nextPath),
                          ),
                        ],
                      ),
                      _HelpCard(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
