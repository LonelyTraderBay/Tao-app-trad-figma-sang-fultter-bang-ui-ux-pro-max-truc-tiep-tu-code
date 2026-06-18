part of '../pages/bot_equity_curve_page.dart';

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.tradeBotEquityChartHeight,
            child: CustomPaint(
              painter: _EquityPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hdr_strong_rounded,
                color: _equityGreen,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.tradeBotTinyGap),
              Text(
                'Bot',
                style: AppTextStyles.micro.copyWith(
                  color: _equityGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SharpeCard extends StatelessWidget {
  const _SharpeCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    final rolling = points
        .where((point) => point.rollingSharpe != null)
        .toList();
    return _Card(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.tradeBotEquitySharpeChartHeight,
            child: CustomPaint(
              painter: _SharpePainter(rolling),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
          const Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Current',
                  value: '2.08',
                  status: 'Excellent',
                ),
              ),
              SizedBox(width: AppSpacing.tradeBotSmallGap),
              Expanded(
                child: _MiniStat(
                  label: 'Average',
                  value: '1.94',
                  status: 'Good',
                ),
              ),
              SizedBox(width: AppSpacing.tradeBotSmallGap),
              Expanded(
                child: _MiniStat(label: 'Min', value: '1.52', status: 'Fair'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.status,
  });

  final String label;
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: AppSpacing.tradeBotControlPadding,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            status,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MonthlyAlphaCard extends StatelessWidget {
  const _MonthlyAlphaCard({required this.months});

  final List<TradeBotMonthlyReturn> months;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        children: [
          for (final month in months) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    month.month,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  'Bot: +${month.botReturn.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: _equityGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotSmallGap),
                Text(
                  '${month.alpha >= 0 ? '+' : ''}${month.alpha.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.formFieldLabelGap),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: math.min(month.alpha.abs() * .20, 1),
                  child: ColoredBox(
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                    child: const SizedBox(
                      height: AppSpacing.tradeBotProgressHeight,
                    ),
                  ),
                ),
              ),
            ),
            if (month != months.last) const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.stats});

  final List<TradeBotPerformanceStat> stats;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPadding,
      child: GridView.count(
        crossAxisCount: AppSpacing.tradeBotGridColumns,
        crossAxisSpacing: AppSpacing.tradeBotCardGap,
        mainAxisSpacing: AppSpacing.tradeBotCardGap,
        childAspectRatio: AppSpacing.tradeBotEquityPerformanceAspectRatio,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [for (final stat in stats) _PerformanceTile(stat: stat)],
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({required this.stat});

  final TradeBotPerformanceStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    final icon = switch (stat.id) {
      'annualized' => Icons.monitor_heart_outlined,
      'outperformance' => Icons.adjust_rounded,
      'average' => Icons.bar_chart_rounded,
      _ => Icons.trending_up_rounded,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotControlPadding,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  stat.value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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
