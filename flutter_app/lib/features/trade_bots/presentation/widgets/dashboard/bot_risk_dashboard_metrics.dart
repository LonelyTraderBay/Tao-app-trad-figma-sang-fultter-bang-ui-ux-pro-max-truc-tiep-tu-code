part of '../../pages/dashboard/bot_risk_dashboard_page.dart';

class _CriticalMetricsGrid extends StatelessWidget {
  const _CriticalMetricsGrid({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        icon: Icons.trending_down_rounded,
        label: 'Sụt giảm vốn',
        value: '${snapshot.currentDrawdown.toStringAsFixed(1)}%',
        limit: 'Giới hạn: ${snapshot.maxDrawdownLimit.toStringAsFixed(0)}%',
        color: _riskRed,
        percent: (snapshot.currentDrawdown / snapshot.maxDrawdownLimit).abs(),
      ),
      _MetricData(
        icon: Icons.attach_money_rounded,
        label: 'Lỗ trong ngày',
        value: '-\$${snapshot.dailyLoss.abs().toStringAsFixed(0)}',
        limit:
            'Giới hạn: -\$${snapshot.dailyLossLimit.abs().toStringAsFixed(0)}',
        color: _riskAmber,
        percent: (snapshot.dailyLoss / snapshot.dailyLossLimit).abs(),
      ),
      _MetricData(
        icon: Icons.monitor_heart_outlined,
        label: 'Tổng mức phơi nhiễm',
        value: '\$${_formatCompact(snapshot.totalExposure)}',
        limit: 'Tối đa: \$${_formatCompact(snapshot.maxExposure)}',
        color: _riskPrimary,
        percent: snapshot.totalExposure / snapshot.maxExposure,
      ),
      _MetricData(
        icon: Icons.bolt_rounded,
        label: 'VaR (95%)',
        value: '\$${snapshot.var95.toStringAsFixed(0)}',
        limit: 'Lỗ tối đa 1 ngày (95%)',
        color: _riskPurple,
        percent: .72,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
      crossAxisSpacing: AppSpacing.x2,
      mainAxisSpacing: AppSpacing.x2,
      childAspectRatio: TradeSpacingTokens.tradeBotCriticalMetricAspectRatio,
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
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.value,
            style: AppTextStyles.sectionTitleXs.copyWith(
              color:
                  metric.label == 'Tổng mức phơi nhiễm' ||
                      metric.label == 'VaR (95%)'
                  ? AppColors.text1
                  : metric.color,
              fontFeatures: AppTextStyles.tabularFigures,
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
          VitProgressBar(
            progress: metric.percent,
            color: metric.color,
            height: AppSpacing.x1,
            trackColor: _riskTrack,
            borderRadius: AppRadii.pillRadius,
          ),
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
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
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
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$${_formatCompact(exposure.exposure)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitProgressBar(
              progress: exposure.percentage / 100,
              color: Color(exposure.colorHex),
              height: AppSpacing.x1,
              trackColor: _riskTrack,
              borderRadius: AppRadii.pillRadius,
            ),
            if (exposure != exposures.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            color: AppColors.borderSolid,
            thickness: AppSpacing.hairlineStroke,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm đa dạng hóa',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '72/100 (Tốt)',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
