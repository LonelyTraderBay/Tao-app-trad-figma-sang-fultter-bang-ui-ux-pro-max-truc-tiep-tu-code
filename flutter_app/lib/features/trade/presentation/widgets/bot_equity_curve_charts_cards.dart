part of '../pages/bot_equity_curve_page.dart';

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      child: Column(
        children: [
          SizedBox(
            height: 214,
            child: CustomPaint(
              painter: _EquityPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hdr_strong_rounded,
                color: _equityGreen,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                'Bot',
                style: AppTextStyles.micro.copyWith(
                  color: _equityGreen,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _SharpePainter(rolling),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _MiniStat(
                  label: 'Current',
                  value: '2.08',
                  status: 'Excellent',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  label: 'Average',
                  value: '1.94',
                  status: 'Good',
                ),
              ),
              SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                const SizedBox(width: 8),
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
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: math.min(month.alpha.abs() * .20, 1),
                  child: Container(
                    height: 8,
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                  ),
                ),
              ),
            ),
            if (month != months.last) const SizedBox(height: 13),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.85,
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
      padding: const EdgeInsets.fromLTRB(13, 12, 12, 11),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat.value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
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
