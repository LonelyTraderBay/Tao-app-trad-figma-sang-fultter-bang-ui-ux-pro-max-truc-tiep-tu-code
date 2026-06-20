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

import '../widgets/trade_body_review_widgets.dart';

const _targetBackground = AppColors.bg;
const _targetPrimary = AppColors.primary;
const _targetGreen = AppColors.buy;
const _targetRed = AppColors.sell;
const double _targetFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _targetNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _targetSummaryIconExtent = AppSpacing.buttonCompact;

class TargetMarketDefinitionPage extends ConsumerWidget {
  const TargetMarketDefinitionPage({
    super.key,
    this.productId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc101_target_market_content');
  static Key dimensionKey(String id) => Key('sc101_dimension_$id');

  final String? productId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTargetMarketDefinition(productId: productId ?? 'prod-1');
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _targetFramedScrollClearance
            : _targetNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-101 TargetMarketDefinitionPage',
      child: Material(
        color: _targetBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Target Market Definition',
            subtitle: snapshot.product.name,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyProductGovernance),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: contentKey,
                  bottomInset: scrollEndClearance,
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _SummaryCard(snapshot: snapshot),
                      const VitSectionHeader(
                        title: 'Target Market Criteria',
                        variant: VitSectionHeaderVariant.accentBar,
                      ),
                      for (final dimension in snapshot.dimensions)
                        _DimensionCard(dimension: dimension),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Target market review',
                          message:
                              'Suitable audience, exclusions, knowledge level, capital capacity and distribution limits are reviewed before product action.',
                          contractId: 'target-market-review',
                          density: VitDensity.compact,
                        ),
                      ),
                      const TradeBodyReviewSection(
                        title: 'Target market body review',
                        message: 'Target market definition body reviewed',
                        detail:
                            'Product summary, suitability criteria, exclusions, review, empty, and result states stay visible.',
                        primary:
                            'Product summary stays above target-market criteria.',
                        secondary:
                            'Suitable and unsuitable audience criteria remain visibly separated.',
                        tertiary:
                            'Distribution limits stay framed as governance review, not execution advice.',
                      ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final TradeTargetMarketDefinitionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            width: _targetSummaryIconExtent,
            height: _targetSummaryIconExtent,
            alignment: Alignment.center,
            borderColor: _targetPrimary.withValues(alpha: .18),
            child: Icon(
              Icons.gps_fixed_rounded,
              color: _targetPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snapshot.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'High-risk product requiring advanced knowledge and '
                  'significant capital.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension});

  final TradeTargetMarketDimension dimension;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TargetMarketDefinitionPage.dimensionKey(dimension.id),
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dimension.category,
            style: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _CriteriaGroup(
            label: 'Suitable for:',
            color: _targetGreen,
            icon: Icons.check_circle_outline,
            values: dimension.suitableFor,
          ),
          const SizedBox(height: AppSpacing.x2),
          _CriteriaGroup(
            label: 'Not suitable for:',
            color: _targetRed,
            icon: Icons.info_outline,
            values: dimension.notSuitableFor,
          ),
        ],
      ),
    );
  }
}

class _CriteriaGroup extends StatelessWidget {
  const _CriteriaGroup({
    required this.label,
    required this.color,
    required this.icon,
    required this.values,
  });

  final String label;
  final Color color;
  final IconData icon;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.micro.copyWith(color: color)),
        const SizedBox(height: AppSpacing.x1),
        for (final value in values) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.normal,
                  ),
                ),
              ),
            ],
          ),
          if (value != values.last) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}
