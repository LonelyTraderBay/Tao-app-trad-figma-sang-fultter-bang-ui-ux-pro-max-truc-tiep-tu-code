import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_common.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_painters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

class UnifiedPortfolioHistory extends StatelessWidget {
  const UnifiedPortfolioHistory({super.key, required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: CrossModuleSpacingTokens.crossModuleCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Portfolio Growth History',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              SizedBox(
                height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
                child: CustomPaint(
                  painter: UnifiedHistoryLinePainter(points: snapshot.history),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Module Growth (6 months)',
          children: [
            for (final module in modules)
              _GrowthRow(module: module, history: snapshot.history),
          ],
        ),
      ],
    );
  }
}

class _GrowthRow extends StatelessWidget {
  const _GrowthRow({required this.module, required this.history});

  final UnifiedPortfolioModuleDraft module;
  final List<UnifiedPortfolioHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    final oldValue = unifiedHistoryValue(history.first, module.id);
    final growth = oldValue == 0
        ? 0.0
        : (module.value - oldValue) / oldValue * 100;
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              module.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: growth >= 0 ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${unifiedFormatUsd(oldValue)} -> ${unifiedFormatUsd(module.value)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
