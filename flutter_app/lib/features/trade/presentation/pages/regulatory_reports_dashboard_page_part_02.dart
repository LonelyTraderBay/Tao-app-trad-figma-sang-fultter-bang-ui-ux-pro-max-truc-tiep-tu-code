part of 'regulatory_reports_dashboard_page.dart';

class _DistributionLegend extends StatelessWidget {
  const _DistributionLegend({required this.items, required this.total});

  final List<TradeRegulatoryDistributionItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      children: [
        for (final item in items)
          VitCard(
            density: VitDensity.compact,
            variant: VitCardVariant.inner,
            constraints: BoxConstraints(
              minHeight: VitDensity.compact.controlHeight,
            ),
            child: Row(
              children: [
                VitCard(
                  variant: VitCardVariant.ghost,
                  width: AppSpacing.x3,
                  height: AppSpacing.x3,
                  clip: true,
                  background: ColoredBox(color: Color(item.colorHex)),
                  child: const SizedBox.shrink(),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  _formatInt(item.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        VitCard(
          padding: AppSpacing.tradeBotCompactCardPadding,
          variant: VitCardVariant.ghost,
          borderColor: _dashBorder,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatInt(total),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
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
      padding: AppSpacing.tradeBotInnerPanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitCard(
                variant: VitCardVariant.ghost,
                width: AppSpacing.tradeBotCorrelationLegendDot,
                height: AppSpacing.tradeBotCorrelationLegendDot,
                clip: true,
                background: ColoredBox(color: color),
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  provider.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${_formatInt(provider.reports)} reports',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
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
    return VitPageSection(
      label: 'Submission Queue Summary',
      density: VitDensity.compact,
      children: [
        for (final stat in snapshot.dailyStats.take(4))
          _Card(
            padding: AppSpacing.tradeBotInnerPanelPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _dashPrimary,
                  size: AppSpacing.tradeBotActionIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
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
                const SizedBox(width: AppSpacing.x2),
                _SmallPill(label: '${stat.failed} failed', color: _dashRed),
              ],
            ),
          ),
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
    return VitPageSection(
      label: 'Compliance Metrics',
      density: VitDensity.compact,
      children: [
        _Card(
          padding: AppSpacing.tradeBotCardPadding,
          child: VitPageContent(
            padding: VitContentPadding.none,
            density: VitDensity.compact,
            children: [
              for (final item in items)
                _ProgressMetric(
                  label: item.$1,
                  pct: item.$2,
                  value: item.$3,
                  color: item.$4,
                ),
              VitCard(
                padding: AppSpacing.tradeBotInnerPanelPadding,
                variant: VitCardVariant.inner,
                borderColor: _dashGreen.withValues(alpha: .25),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: _dashGreen,
                      size: AppSpacing.tradeBotMediumIcon,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        'Full regulatory compliance maintained for 90 consecutive days',
                        style: AppTextStyles.caption.copyWith(
                          color: _dashGreen,
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
    return VitPageSection(
      label: 'Export Reports',
      density: VitDensity.compact,
      children: [
        _ExportCard(
          title: 'ISO 20022 XML Export',
          subtitle: 'Standard regulatory format',
          icon: Icons.description_outlined,
          color: _dashPrimary,
          onTap: () => onNotice('XML export queued'),
        ),
        _ExportCard(
          title: 'Compliance Report (PDF)',
          subtitle: 'Executive summary',
          icon: Icons.bar_chart_rounded,
          color: _dashGreen,
          onTap: () => onNotice('PDF export queued'),
        ),
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
    return _Card(
      onTap: onTap,
      padding: AppSpacing.tradeBotInnerPanelPadding,
      child: Row(
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            width: AppSpacing.tradeBotQuestionIconBox,
            height: AppSpacing.tradeBotQuestionIconBox,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .18),
            child: Icon(
              icon,
              color: color,
              size: AppSpacing.tradeBotActionIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              density: VitDensity.compact,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: AppSpacing.tradeBotActionIcon,
          ),
        ],
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
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          variant: VitCardVariant.ghost,
          height: AppSpacing.x2,
          clip: true,
          background: const ColoredBox(color: _dashPanel2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: math.min(pct / 100, 1),
              child: ColoredBox(color: color),
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
        const SizedBox(width: AppSpacing.tradeBotCardGap),
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
