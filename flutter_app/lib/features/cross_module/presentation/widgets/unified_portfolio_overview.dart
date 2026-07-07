import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_common.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_painters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

class UnifiedPortfolioOverview extends StatelessWidget {
  const UnifiedPortfolioOverview({
    super.key,
    required this.snapshot,
    required this.refreshKey,
    required this.moduleKey,
    required this.onRefresh,
    required this.onOpenRoute,
  });

  final UnifiedPortfolioSnapshot snapshot;
  final Key refreshKey;
  final Key Function(UnifiedPortfolioModuleId id) moduleKey;
  final VoidCallback onRefresh;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TotalValueCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _DistributionCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Module Breakdown',
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            for (final module in snapshot.modules)
              _ModuleCard(
                cardKey: moduleKey(module.id),
                module: module,
                totalValue: snapshot.totalValue,
                onOpenRoute: onOpenRoute,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _RefreshButton(refreshKey: refreshKey, onPressed: onRefresh),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _BoundaryInfoCard(),
      ],
    );
  }
}

class _TotalValueCard extends StatelessWidget {
  const _TotalValueCard({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlPositive = snapshot.totalPnl >= 0;
    return VitCard(
      radius: VitCardRadius.large,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              Text(
                unifiedFormatUsd(snapshot.totalValue),
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              UnifiedPortfolioPnlInline(
                value: snapshot.totalPnl,
                percent: snapshot.totalPnlPercent,
                positive: pnlPositive,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: UnifiedPortfolioSummaryMetric(
                  label: 'Total Positions',
                  value: '${snapshot.totalPositions}',
                ),
              ),
              Expanded(
                child: UnifiedPortfolioSummaryMetric(
                  label: 'Active Modules',
                  value: '${snapshot.activeModules}',
                ),
              ),
              Expanded(
                child: UnifiedPortfolioSummaryMetric(
                  label: 'Total P&L',
                  value: unifiedFormatSignedUsd(snapshot.totalPnl),
                  valueColor: pnlPositive ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    return VitCard(
      radius: VitCardRadius.large,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Distribution',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: CustomPaint(
              painter: UnifiedDonutDistributionPainter(
                modules: modules,
                total: snapshot.totalValue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Wrap(
            spacing: AppSpacing.x6,
            runSpacing: AppSpacing.x3,
            children: [
              for (final module in modules) _LegendItem(module: module),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.module});

  final UnifiedPortfolioModuleDraft module;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonHero + AppSpacing.x7,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.x4,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: unifiedModuleAccent(module.id),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              unifiedShortModuleName(module),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.cardKey,
    required this.module,
    required this.totalValue,
    required this.onOpenRoute,
  });

  final Key cardKey;
  final UnifiedPortfolioModuleDraft module;
  final int totalValue;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final accent = unifiedModuleAccent(module.id);
    return Semantics(
      button: true,
      label: 'Open ${module.name} module',
      child: VitCard(
        key: cardKey,
        radius: VitCardRadius.large,
        padding: CrossModuleSpacingTokens.crossModuleCardPadding,
        clip: true,
        onTap: () => onOpenRoute(module.route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UnifiedPortfolioModuleIcon(id: module.id),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.name,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '${module.activePositions} active positions',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            if (module.pointsOnly)
              const UnifiedArenaBoundaryPill()
            else ...[
              Row(
                children: [
                  Expanded(
                    child: UnifiedPortfolioSummaryMetric(
                      label: 'Value',
                      value: unifiedFormatUsd(module.value),
                    ),
                  ),
                  Expanded(
                    child: UnifiedPortfolioSummaryMetric(
                      label: '24h Change',
                      value:
                          '${module.change24h >= 0 ? '+' : ''}${module.change24h.toStringAsFixed(1)}%',
                      valueColor: module.change24h >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                  Expanded(
                    child: UnifiedPortfolioSummaryMetric(
                      label: 'P&L',
                      value: unifiedFormatSignedUsd(module.pnl),
                      valueColor: module.pnl >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ClipRRect(
                borderRadius: AppRadii.xlRadius,
                child: LinearProgressIndicator(
                  value: totalValue == 0 ? 0 : module.value / totalValue,
                  minHeight: AppSpacing.x2,
                  backgroundColor: AppColors.surface3,
                  color: accent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.refreshKey, required this.onPressed});

  final Key refreshKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: refreshKey,
      variant: VitCtaButtonVariant.ghost,
      onPressed: onPressed,
      leading: const Icon(Icons.refresh_rounded),
      child: const Text('Refresh Data'),
    );
  }
}

class _BoundaryInfoCard extends StatelessWidget {
  const _BoundaryInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Arena Points are not included in portfolio value as they are points-only and not financial assets. Each module maintains separate accounting.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
