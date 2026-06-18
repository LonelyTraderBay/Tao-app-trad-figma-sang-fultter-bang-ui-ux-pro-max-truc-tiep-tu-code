part of '../pages/arm_integration_status_page.dart';

class _LatencyCard extends StatelessWidget {
  const _LatencyCard({required this.points});

  final List<TradeArmLatencyPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.armIntegrationLatencyPadding,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.armIntegrationChartHeight,
            child: CustomPaint(
              painter: _LatencyPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.armIntegrationMetricRowGap),
          const Divider(
            height: AppSpacing.armIntegrationDividerHeight,
            color: _armBorder,
          ),
          const SizedBox(height: AppSpacing.x4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(label: 'REGIS-TR', color: _armGreen),
              SizedBox(width: AppSpacing.armIntegrationLegendGap),
              _LegendDot(label: 'UnaVista', color: _armPrimary),
              SizedBox(width: AppSpacing.armIntegrationLegendGap),
              _LegendDot(label: 'Bloomberg', color: _armAmber),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlaCard extends StatelessWidget {
  const _SlaCard({required this.sla});

  final TradeArmSlaMetrics sla;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.armIntegrationSlaPadding,
      child: Column(
        children: [
          _ProgressRow(
            label: 'Uptime Target (99.9%)',
            value: '${sla.uptime.toStringAsFixed(2)}%',
            factor: sla.uptime / 100,
          ),
          const SizedBox(height: AppSpacing.armIntegrationSlaGap),
          _ProgressRow(
            label: 'Latency Target (<100ms)',
            value: '${sla.latencyAvg}ms avg',
            factor: sla.latencyAvg / 100,
          ),
          const SizedBox(height: AppSpacing.armIntegrationSlaGap),
          _ProgressRow(
            label: 'Failover Readiness',
            value: '${sla.failoverReadiness}%',
            factor: sla.failoverReadiness / 100,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.factor,
  });

  final String label;
  final String value;
  final double factor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.armIntegrationLineHeightTight,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: _armGreen,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
                height: AppSpacing.armIntegrationLineHeightTight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.armIntegrationProgressLabelGap),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.armIntegrationProgressHeight,
            child: Stack(
              children: [
                const ColoredBox(color: _armPanel2),
                FractionallySizedBox(
                  widthFactor: factor.clamp(0, 1).toDouble(),
                  child: const ColoredBox(color: _armGreen),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onQueue, required this.onDashboard});

  final VoidCallback onQueue;
  final VoidCallback onDashboard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            key: ArmIntegrationStatusPage.actionKey('queue'),
            label: 'Live Queue',
            icon: Icons.monitor_heart_outlined,
            color: _armPrimary,
            onTap: onQueue,
          ),
        ),
        const SizedBox(width: AppSpacing.armIntegrationInlineGap),
        Expanded(
          child: _QuickAction(
            key: ArmIntegrationStatusPage.actionKey('dashboard'),
            label: 'Dashboard',
            icon: Icons.shield_outlined,
            color: _armGreen,
            onTap: onDashboard,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      height: AppSpacing.searchBarCompactHeight,
      leading: Icon(
        icon,
        color: color,
        size: AppSpacing.armIntegrationQuickActionIcon,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: AppSpacing.armIntegrationQuickActionIcon,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.armIntegrationLineHeightTight,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSectionHeader(
            title: text,
            variant: VitSectionHeaderVariant.accentBar,
            accentColor: _armPrimary,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: AppSpacing.x3),
        const SizedBox(width: AppSpacing.x3),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.armIntegrationLineHeightTight,
          ),
        ),
      ],
    );
  }
}
