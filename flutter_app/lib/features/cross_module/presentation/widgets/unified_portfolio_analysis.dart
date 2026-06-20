import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_common.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_painters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class UnifiedPortfolioAnalysis extends StatelessWidget {
  const UnifiedPortfolioAnalysis({super.key, required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    final ranked = [...modules]
      ..sort(
        (a, b) => unifiedReturnPercent(b).compareTo(unifiedReturnPercent(a)),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: AppSpacing.crossModuleCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'P&L by Module',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              SizedBox(
                height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
                child: CustomPaint(
                  painter: UnifiedPnlBarPainter(modules: modules),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Performance Ranking',
          children: [
            for (var i = 0; i < ranked.length; i++)
              _RankingRow(rank: i + 1, module: ranked[i]),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitCard(
          radius: VitCardRadius.lg,
          padding: AppSpacing.crossModuleCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Allocation Analysis',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final module in modules) ...[
                _AllocationRow(module: module, totalValue: snapshot.totalValue),
                if (module != modules.last)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.rank, required this.module});

  final int rank;
  final UnifiedPortfolioModuleDraft module;

  @override
  Widget build(BuildContext context) {
    final returnPercent = unifiedReturnPercent(module);
    return VitCard(
      padding: AppSpacing.crossModuleCardPadding,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonCompact,
            child: rank == 1
                ? const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  )
                : Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.x3),
          UnifiedPortfolioModuleIcon(id: module.id),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unifiedShortModuleName(module),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  unifiedFormatUsd(module.value),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: returnPercent >= 0 ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                unifiedFormatSignedUsd(module.pnl),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.module, required this.totalValue});

  final UnifiedPortfolioModuleDraft module;
  final int totalValue;

  @override
  Widget build(BuildContext context) {
    final allocation = totalValue == 0 ? 0.0 : module.value / totalValue * 100;
    final returnPercent = unifiedReturnPercent(module);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                unifiedShortModuleName(module),
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            VitStatusPill(
              label:
                  '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(1)}%',
              status: returnPercent >= 0
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              '${allocation.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: LinearProgressIndicator(
            value: allocation / 100,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface3,
            color: unifiedModuleAccent(module.id),
          ),
        ),
      ],
    );
  }
}
