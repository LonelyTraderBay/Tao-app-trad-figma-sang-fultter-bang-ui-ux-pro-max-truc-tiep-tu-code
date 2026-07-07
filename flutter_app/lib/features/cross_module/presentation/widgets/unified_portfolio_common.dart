import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class UnifiedPortfolioSummaryMetric extends StatelessWidget {
  const UnifiedPortfolioSummaryMetric({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class UnifiedPortfolioPnlInline extends StatelessWidget {
  const UnifiedPortfolioPnlInline({
    super.key,
    required this.value,
    required this.percent,
    required this.positive,
  });

  final int value;
  final double percent;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          '${unifiedFormatSignedUsd(value)} (${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%)',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class UnifiedPortfolioModuleIcon extends StatelessWidget {
  const UnifiedPortfolioModuleIcon({super.key, required this.id});

  final UnifiedPortfolioModuleId id;

  @override
  Widget build(BuildContext context) {
    final accent = unifiedModuleAccent(id);
    return SizedBox.square(
      dimension: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accent.withValues(alpha: .14),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        ),
        child: Center(
          child: Icon(
            unifiedModuleIcon(id),
            color: accent,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class UnifiedArenaBoundaryPill extends StatelessWidget {
  const UnifiedArenaBoundaryPill({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: AppSpacing.crossModuleSelectorPadding,
      child: Text(
        'Arena Points Only - Not included in portfolio value',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.warn,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String unifiedFormatUsd(int value) {
  final negative = value < 0;
  final raw = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${negative ? '-' : ''}\$${buffer.toString()}';
}

String unifiedFormatSignedUsd(int value) => value >= 0
    ? '+${unifiedFormatUsd(value)}'
    : '-${unifiedFormatUsd(value.abs()).replaceFirst('-', '')}';

String unifiedShortModuleName(UnifiedPortfolioModuleDraft module) {
  switch (module.id) {
    case UnifiedPortfolioModuleId.wallet:
      return 'Wallet';
    case UnifiedPortfolioModuleId.trading:
      return 'Trading';
    case UnifiedPortfolioModuleId.p2p:
      return 'P2P';
    case UnifiedPortfolioModuleId.predictions:
      return 'Prediction';
    case UnifiedPortfolioModuleId.arena:
      return 'Arena';
    case UnifiedPortfolioModuleId.dca:
      return 'DCA';
  }
}

double unifiedReturnPercent(UnifiedPortfolioModuleDraft module) {
  final principal = module.value - module.pnl;
  if (principal == 0) return 0;
  return module.pnl / principal * 100;
}

Color unifiedModuleAccent(UnifiedPortfolioModuleId id) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return AppModuleAccents.wallet;
    case UnifiedPortfolioModuleId.trading:
      return AppColors.buy;
    case UnifiedPortfolioModuleId.p2p:
      return AppModuleAccents.p2p;
    case UnifiedPortfolioModuleId.predictions:
      return AppModuleAccents.predictions;
    case UnifiedPortfolioModuleId.arena:
      return AppModuleAccents.arena;
    case UnifiedPortfolioModuleId.dca:
      return AppColors.accent;
  }
}

IconData unifiedModuleIcon(UnifiedPortfolioModuleId id) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return Icons.account_balance_wallet_outlined;
    case UnifiedPortfolioModuleId.trading:
      return Icons.bar_chart_rounded;
    case UnifiedPortfolioModuleId.p2p:
      return Icons.shopping_cart_outlined;
    case UnifiedPortfolioModuleId.predictions:
      return Icons.adjust_rounded;
    case UnifiedPortfolioModuleId.arena:
      return Icons.bolt_rounded;
    case UnifiedPortfolioModuleId.dca:
      return Icons.timeline_rounded;
  }
}

int unifiedHistoryValue(
  UnifiedPortfolioHistoryPoint point,
  UnifiedPortfolioModuleId id,
) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return point.wallet;
    case UnifiedPortfolioModuleId.trading:
      return point.trading;
    case UnifiedPortfolioModuleId.p2p:
      return point.p2p;
    case UnifiedPortfolioModuleId.predictions:
      return point.predictions;
    case UnifiedPortfolioModuleId.dca:
      return point.dca;
    case UnifiedPortfolioModuleId.arena:
      return 0;
  }
}
