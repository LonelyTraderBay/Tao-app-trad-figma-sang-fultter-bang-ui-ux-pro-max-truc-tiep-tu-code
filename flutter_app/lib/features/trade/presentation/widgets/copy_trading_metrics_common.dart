part of '../pages/copy_trading_page.dart';

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('Win Rate', '${trader.winRate.toStringAsFixed(1)}%', AppColors.buy),
      ('PnL', _formatSignedUsd(trader.totalPnl), AppColors.buy),
      ('Copiers', '${trader.copiers}', AppColors.primary),
      ('Sharpe', trader.sharpeRatio.toStringAsFixed(2), AppColors.caution),
    ];
    return Row(
      children: [
        for (var i = 0; i < metrics.length; i++) ...[
          Expanded(
            child: _MetricCell(
              label: metrics[i].$1,
              value: metrics[i].$2,
              color: metrics[i].$3,
            ),
          ),
          if (i < metrics.length - 1)
            const SizedBox(width: AppSpacing.copyTradingHeroMetricGap),
        ],
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.copyTradingMetricCellGap),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'P/L 7 ngày gần nhất',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.copyTradingWeeklyTitleGap),
        SizedBox(
          height: AppSpacing.copyTradingWeeklyChartHeight,
          child: VitSparkline(
            values: values,
            color: values.isNotEmpty && values.last < values.first
                ? AppColors.sell
                : AppColors.buy,
            strokeWidth: AppSpacing.copyTradingWeeklyStrokeWidth,
          ),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.copyTradingDisclaimerPadding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: AppSpacing.copyTradingDisclaimerLineHeight,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

final class _TierStyle {
  const _TierStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

final class _RiskStyle {
  const _RiskStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_TierStyle _tierFor(int copiers) {
  if (copiers > 3000) {
    return const _TierStyle(
      label: 'Pro Trader',
      color: AppColors.caution,
      icon: Icons.star_rounded,
    );
  }
  if (copiers > 1000) {
    return const _TierStyle(
      label: 'Verified',
      color: AppColors.buy,
      icon: Icons.check_circle_rounded,
    );
  }
  return const _TierStyle(
    label: 'Basic',
    color: AppColors.text3,
    icon: Icons.info_rounded,
  );
}

_RiskStyle _riskFor(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => const _RiskStyle(
      label: 'Thấp',
      color: AppColors.buy,
    ),
    TradeCopyRiskLevel.medium => const _RiskStyle(
      label: 'Trung bình',
      color: AppColors.caution,
    ),
    TradeCopyRiskLevel.high => const _RiskStyle(
      label: 'Cao',
      color: AppColors.sell,
    ),
  };
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatCompact(value.abs(), prefix: r'$')}';
}
