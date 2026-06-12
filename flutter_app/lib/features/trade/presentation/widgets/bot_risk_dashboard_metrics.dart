part of '../pages/bot_risk_dashboard_page.dart';

class _CriticalMetricsGrid extends StatelessWidget {
  const _CriticalMetricsGrid({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        icon: Icons.trending_down_rounded,
        label: 'Drawdown',
        value: '${snapshot.currentDrawdown.toStringAsFixed(1)}%',
        limit: 'Limit: ${snapshot.maxDrawdownLimit.toStringAsFixed(0)}%',
        color: _riskRed,
        percent: (snapshot.currentDrawdown / snapshot.maxDrawdownLimit).abs(),
      ),
      _MetricData(
        icon: Icons.attach_money_rounded,
        label: 'Daily Loss',
        value: '-\$${snapshot.dailyLoss.abs().toStringAsFixed(0)}',
        limit: 'Limit: -\$${snapshot.dailyLossLimit.abs().toStringAsFixed(0)}',
        color: _riskAmber,
        percent: (snapshot.dailyLoss / snapshot.dailyLossLimit).abs(),
      ),
      _MetricData(
        icon: Icons.monitor_heart_outlined,
        label: 'Total Exposure',
        value: '\$${_formatCompact(snapshot.totalExposure)}',
        limit: 'Max: \$${_formatCompact(snapshot.maxExposure)}',
        color: _riskPrimary,
        percent: snapshot.totalExposure / snapshot.maxExposure,
      ),
      _MetricData(
        icon: Icons.bolt_rounded,
        label: 'VaR (95%)',
        value: '\$${snapshot.var95.toStringAsFixed(0)}',
        limit: 'Max 1-day loss (95%)',
        color: _riskPurple,
        percent: .72,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 13,
      childAspectRatio: 1.52,
      children: [for (final metric in metrics) _MetricCard(metric: metric)],
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.limit,
    required this.color,
    required this.percent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String limit;
  final Color color;
  final double percent;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            metric.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color:
                  metric.label == 'Total Exposure' ||
                      metric.label == 'VaR (95%)'
                  ? AppColors.text1
                  : metric.color,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.limit,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          _ProgressTrack(value: metric.percent, color: metric.color),
        ],
      ),
    );
  }
}

class _ExposureCard extends StatelessWidget {
  const _ExposureCard({required this.exposures});

  final List<TradeBotExposure> exposures;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          for (final exposure in exposures) ...[
            Row(
              children: [
                Text(
                  exposure.asset,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${exposure.percentage}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_formatCompact(exposure.exposure)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ProgressTrack(
              value: exposure.percentage / 100,
              color: Color(exposure.colorHex),
            ),
            if (exposure != exposures.last) const SizedBox(height: 14),
          ],
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderSolid, height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Diversification Score',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '72/100 (Good)',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
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

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: _riskTrack,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
