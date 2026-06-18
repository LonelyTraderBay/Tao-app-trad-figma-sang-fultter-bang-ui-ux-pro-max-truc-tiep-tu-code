import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 112
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: AppSpacing.tradeBotSecurityScrollPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      _HighRiskBanner(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotCardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot risk disclosure review',
                              message:
                                  'Past performance, category risks, regulatory notice, acknowledgment and next steps are reviewed before bot access.',
                              contractId: 'bot-risk-disclosure-review',
                            ),
                            SizedBox(height: AppSpacing.tradeBotRowGap),
                            VitStatusPill(
                              label: 'Acknowledgment required',
                              status: VitStatusPillStatus.error,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      VitPageSection(
                        customGap: 0,
                        children: [_PastPerformanceCard(snapshot: snapshot)],
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel(snapshot.riskSectionLabel),
                      const SizedBox(height: AppSpacing.x4),
                      for (final category in snapshot.categories) ...[
                        _RiskCategoryCard(category: category),
                        if (category != snapshot.categories.last)
                          const SizedBox(height: AppSpacing.x4),
                      ],
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel(snapshot.additionalWarningsLabel),
                      const SizedBox(height: AppSpacing.x4),
                      _AdditionalWarningsCard(
                        warnings: snapshot.additionalWarnings,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel(snapshot.regulatoryNoticeLabel),
                      const SizedBox(height: AppSpacing.x4),
                      _RegulatoryNoticeCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel(snapshot.acknowledgmentLabel),
                      const SizedBox(height: AppSpacing.x4),
                      _AcknowledgmentCard(
                        snapshot: snapshot,
                        acknowledged: _acknowledged,
                        onTap: () =>
                            setState(() => _acknowledged = !_acknowledged),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _RiskCta(
                        snapshot: snapshot,
                        acknowledged: _acknowledged,
                        onPressed: () => context.go(snapshot.nextPath),
                      ),
                      const SizedBox(height: AppSpacing.x4),
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
