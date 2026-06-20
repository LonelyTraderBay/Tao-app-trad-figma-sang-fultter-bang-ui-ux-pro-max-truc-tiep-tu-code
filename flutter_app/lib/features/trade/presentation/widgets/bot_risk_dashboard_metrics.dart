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
      crossAxisCount: AppSpacing.tradeBotGridColumns,
      crossAxisSpacing: AppSpacing.x2,
      mainAxisSpacing: AppSpacing.x2,
      childAspectRatio: 1.85,
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
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: AppSpacing.x4),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.value,
            style: AppTextStyles.sectionTitleXs.copyWith(
              color:
                  metric.label == 'Total Exposure' ||
                      metric.label == 'VaR (95%)'
                  ? AppColors.text1
                  : metric.color,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.limit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.badge.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.normal,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
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
    return VitCard(
      density: VitDensity.compact,
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
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '${exposure.percentage}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$${_formatCompact(exposure.exposure)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            _ProgressTrack(
              value: exposure.percentage / 100,
              color: Color(exposure.colorHex),
            ),
            if (exposure != exposures.last)
              const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x3),
          const Divider(
            color: AppColors.borderSolid,
            thickness: AppSpacing.hairlineStroke,
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Diversification Score',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '72/100 (Good)',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
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

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: AppSpacing.x1,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: _riskTrack,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
