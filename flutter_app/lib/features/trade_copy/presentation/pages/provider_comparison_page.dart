import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';

const _comparisonPrimary = AppColors.primary;
const _comparisonRed = AppColors.sell;
const _comparisonAmber = AppColors.caution;
const _comparisonGreen = AppColors.buy;

class ProviderComparisonPage extends ConsumerWidget {
  const ProviderComparisonPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc076_provider_comparison_content');
  static const addProviderActionKey = Key('sc076_add_provider_action');
  static const addProviderLinkKey = Key('sc076_add_provider_link');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeProviderComparisonProvider);

    return VitTradeHubScaffold(
      title: 'So sánh Providers',
      semanticLabel: 'SC-076 ProviderComparisonPage',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          key: addProviderActionKey,
          type: VitHeaderActionType.add,
          onPressed: () => context.push(AppRoutePaths.tradeCopyTrading),
        ),
      ],
      children: [
        VitTradeSection(
          title: 'Disclaimer',
          child: _WarningBanner(text: snapshot.disclaimer),
        ),
        VitTradeSection(
          title: 'So sánh',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Đang so sánh ${snapshot.selectedCount}/${snapshot.maxProviders} providers',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  if (snapshot.selectedCount < snapshot.maxProviders)
                    VitCtaButton(
                      key: addProviderLinkKey,
                      onPressed: () =>
                          context.push(AppRoutePaths.tradeCopyTrading),
                      variant: VitCtaButtonVariant.ghost,
                      fullWidth: false,
                      height: AppSpacing.buttonCompact,
                      padding: AuthSpacingTokens.authInlineTextButtonPadding,
                      leading: const Icon(Icons.add_rounded),
                      child: const Text('+ Thêm provider'),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _ComparisonTable(snapshot: snapshot),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Chú thích',
          child: _LegendPanel(text: snapshot.legend),
        ),
        VitTradeComplianceSection(
          title: 'Compliance review',
          statusPill: const VitStatusPill(
            label: 'Review required',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: const [
            VitTradeComplianceItem(
              label: 'Scope',
              value: 'Performance, risk, execution, fees, drawdown',
            ),
            VitTradeComplianceItem(
              label: 'Action',
              value: 'Review before adding or copying',
            ),
          ],
        ),
        const TradeBodyReviewSection(
          title: 'Provider comparison body review',
          message: 'Provider comparison body reviewed',
          detail:
              'Disclaimer, selected providers, metrics, legend, add action, and review states stay visible.',
          primary: 'Disclaimer remains before provider comparison metrics.',
          secondary:
              'Risk, execution, cost, and performance groups stay separated for scanning.',
          tertiary:
              'Add-provider actions remain gated by comparison limits and review copy.',
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.warningBorder,
      padding: TradeSpacingTokens.providerComparisonPanelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningText,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warningText,
                height: TradeSpacingTokens.providerComparisonWarningLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.snapshot});

  final TradeProviderComparisonSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: TradeSpacingTokens.providerComparisonMetricHeaderPadding,
          child: Text(
            'Metric',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
        ),
        for (final group in TradeProviderComparisonCategory.values) ...[
          _CategoryRow(category: group),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final metric in snapshot.metrics.where(
            (metric) => metric.category == group,
          )) ...[
            Padding(
              padding: TradeSpacingTokens.providerComparisonMetricLabelPadding,
              child: SizedBox(
                height: AppSpacing.x5 + AppSpacing.x2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    metric.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ],
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final TradeProviderComparisonCategory category;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (category) {
      TradeProviderComparisonCategory.performance => (
        'Performance',
        _comparisonPrimary,
        Icons.trending_up_rounded,
      ),
      TradeProviderComparisonCategory.risk => (
        'Risk',
        _comparisonRed,
        Icons.shield_outlined,
      ),
      TradeProviderComparisonCategory.execution => (
        'Execution',
        _comparisonPrimary,
        Icons.show_chart_rounded,
      ),
      TradeProviderComparisonCategory.cost => (
        'Cost',
        _comparisonAmber,
        Icons.attach_money_rounded,
      ),
    };

    return Padding(
      padding: TradeSpacingTokens.providerComparisonCategoryPadding,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.heavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendPanel extends StatelessWidget {
  const _LegendPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.providerComparisonPanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: _comparisonGreen,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '= Giá trị tốt nhất trong nhóm',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: TradeSpacingTokens.providerComparisonLegendLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
