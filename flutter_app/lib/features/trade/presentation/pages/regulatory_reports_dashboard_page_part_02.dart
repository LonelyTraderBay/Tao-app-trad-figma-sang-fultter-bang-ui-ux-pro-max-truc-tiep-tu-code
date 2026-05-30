part of 'regulatory_reports_dashboard_page.dart';

class _DistributionLegend extends StatelessWidget {
  const _DistributionLegend({required this.items, required this.total});

  final List<TradeRegulatoryDistributionItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _dashPanel2,
              borderRadius: AppRadii.smRadius,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(item.colorHex),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ),
                Text(
                  _formatInt(item.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (item != items.last) const SizedBox(height: 8),
        ],
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(top: 11),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: _dashBorder)),
          ),
          child: Row(
            children: [
              Text(
                'Total',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                _formatInt(total),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeRegulatoryArmProvider provider;

  @override
  Widget build(BuildContext context) {
    final healthy = provider.status == 'healthy';
    final color = healthy ? _dashGreen : _dashAmber;
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  provider.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${_formatInt(provider.reports)} reports',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Success Rate',
                  value: '${provider.successRate.toStringAsFixed(1)}%',
                  color: _dashGreen,
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Avg Latency',
                  value: '${provider.avgLatency}s',
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Status',
                  value: provider.status,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QueueTab extends StatelessWidget {
  const _QueueTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Submission Queue Summary'),
        const SizedBox(height: 12),
        for (final stat in snapshot.dailyStats.take(4)) ...[
          _Card(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _dashPrimary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    stat.date,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                _SmallPill(
                  label: '${stat.confirmed} confirmed',
                  color: _dashGreen,
                ),
                const SizedBox(width: 8),
                _SmallPill(label: '${stat.failed} failed', color: _dashRed),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('SLA Compliance (T+1)', 100.0, '100%', _dashGreen),
      ('Field Accuracy (RTS 22)', 99.8, '99.8%', _dashGreen),
      (
        'Submission Success Rate',
        totals.successRate,
        '${totals.successRate.toStringAsFixed(1)}%',
        _dashGreen,
      ),
      (
        'Latency Performance (<60s)',
        totals.avgLatency / 60 * 100,
        '${totals.avgLatency.round()}s',
        _dashGreen,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Compliance Metrics'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final item in items) ...[
                _ProgressMetric(
                  label: item.$1,
                  pct: item.$2,
                  value: item.$3,
                  color: item.$4,
                ),
                if (item != items.last) const SizedBox(height: 18),
              ],
              Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  color: _dashGreen.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: _dashGreen,
                      size: 17,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Full regulatory compliance maintained for 90 consecutive days',
                        style: AppTextStyles.caption.copyWith(
                          color: _dashGreen,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExportsTab extends StatelessWidget {
  const _ExportsTab({required this.onNotice});

  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Export Reports'),
        const SizedBox(height: 12),
        _ExportCard(
          title: 'ISO 20022 XML Export',
          subtitle: 'Standard regulatory format',
          icon: Icons.description_outlined,
          color: _dashPrimary,
          onTap: () => onNotice('XML export queued'),
        ),
        const SizedBox(height: 10),
        _ExportCard(
          title: 'Compliance Report (PDF)',
          subtitle: 'Executive summary',
          icon: Icons.bar_chart_rounded,
          color: _dashGreen,
          onTap: () => onNotice('PDF export queued'),
        ),
        const SizedBox(height: 10),
        _ExportCard(
          title: 'Raw Data Export (CSV)',
          subtitle: 'All fields, all reports',
          icon: Icons.storage_outlined,
          color: _dashAmber,
          onTap: () => onNotice('CSV export queued'),
        ),
      ],
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Card(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.download_rounded,
              color: AppColors.text3,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.pct,
    required this.value,
    required this.color,
  });

  final String label;
  final double pct;
  final String value;
  final Color color;

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
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                const ColoredBox(color: _dashPanel2),
                FractionallySizedBox(
                  widthFactor: math.min(pct / 100, 1),
                  child: ColoredBox(color: color),
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
  const _QuickActions({required this.onQueue, required this.onArmStatus});

  final VoidCallback onQueue;
  final VoidCallback onArmStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('queue'),
            label: 'Live Queue',
            icon: Icons.waves_rounded,
            color: _dashPrimary,
            onTap: onQueue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('arm-status'),
            label: 'ARM Status',
            icon: Icons.shield_outlined,
            color: _dashGreen,
            onTap: onArmStatus,
          ),
        ),
      ],
    );
  }
}
