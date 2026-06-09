part of '../pages/arm_integration_status_page.dart';

class _LatencyCard extends StatelessWidget {
  const _LatencyCard({required this.points});

  final List<TradeArmLatencyPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _LatencyPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: _armBorder),
          const SizedBox(height: 13),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(label: 'REGIS-TR', color: _armGreen),
              SizedBox(width: 18),
              _LegendDot(label: 'UnaVista', color: _armPrimary),
              SizedBox(width: 18),
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
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          _ProgressRow(
            label: 'Uptime Target (99.9%)',
            value: '${sla.uptime.toStringAsFixed(2)}%',
            factor: sla.uptime / 100,
          ),
          const SizedBox(height: 17),
          _ProgressRow(
            label: 'Latency Target (<100ms)',
            value: '${sla.latencyAvg}ms avg',
            factor: sla.latencyAvg / 100,
          ),
          const SizedBox(height: 17),
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
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: _armGreen,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
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
        const SizedBox(width: 12),
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
      height: 44,
      leading: Icon(icon, color: color, size: 17),
      trailing: const Icon(Icons.chevron_right_rounded, size: 17),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
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
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _armPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
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
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
      ],
    );
  }
}
