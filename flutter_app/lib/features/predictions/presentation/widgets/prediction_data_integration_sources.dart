part of '../pages/prediction_data_integration_page.dart';

class _DataIntegrationTabBar extends StatelessWidget {
  const _DataIntegrationTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _DataIntegrationTab activeTab;
  final ValueChanged<_DataIntegrationTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionDataIntegrationPage.sourcesTabKey,
        tab: _DataIntegrationTab.sources,
        label: 'Nguon du lieu',
      ),
      (
        key: PredictionDataIntegrationPage.apiKeysTabKey,
        tab: _DataIntegrationTab.apiKeys,
        label: 'API Keys',
      ),
      (
        key: PredictionDataIntegrationPage.webhooksTabKey,
        tab: _DataIntegrationTab.webhooks,
        label: 'Webhooks',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SourcesOverview extends StatelessWidget {
  const _SourcesOverview({required this.snapshot});

  final PredictionDataIntegrationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: .1),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: AppColors.buy,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oracle Data Sources',
                      style: AppTextStyles.base.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'External data feeds for event resolution',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Active',
                  value: '${snapshot.activeSources}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg Reliability',
                  value: '${snapshot.averageReliability.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Events Resolved',
                  value: '${snapshot.eventsResolved}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 17,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.sources});

  final List<PredictionDataSourceDraft> sources;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Configured Sources',
      accentColor: _predictionPrimary,
      children: [for (final source in sources) _SourceCard(source: source)],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.source});

  final PredictionDataSourceDraft source;

  @override
  Widget build(BuildContext context) {
    final color = _sourceStatusColor(source.status);
    return VitCard(
      key: PredictionDataIntegrationPage.sourceKey(source.id),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          source.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _MiniStatusPill(
                          label: _sourceStatusLabel(source.status),
                          color: color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${source.provider} - ${source.category}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Last Sync',
                  value: source.lastSyncLabel,
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Events',
                  value: '${source.eventsResolved}',
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Reliability',
                  value: _formatPercent(source.reliability),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          if (source.apiUrl != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  color: AppColors.text3,
                  size: 12,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    source.apiUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
