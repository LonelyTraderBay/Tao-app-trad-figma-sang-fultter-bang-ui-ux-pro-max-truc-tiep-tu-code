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
        height: AppSpacing.predictionDataTabBarHeight,
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
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: AppSpacing.predictionDataTabIndicatorHeight,
                        width: activeTab == item.tab
                            ? AppSpacing.predictionDataTabIndicatorWidth
                            : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: AppRadii.hairlineRadius,
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
      padding: AppSpacing.predictionDataCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.predictionDataHeroIconBox,
                height: AppSpacing.predictionDataHeroIconBox,
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: .1),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.predictionDataHeroIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.predictionDataHeroGap),
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
                    const SizedBox(
                      height: AppSpacing.predictionDataHeroTitleGap,
                    ),
                    Text(
                      'External data feeds for event resolution',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.predictionDataOverviewMetricsGap),
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.predictionDataMetricValueGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
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
      padding: AppSpacing.predictionDataCardPadding,
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
                      spacing: AppSpacing.predictionDataHeaderWrapGap,
                      runSpacing: AppSpacing.predictionDataHeaderRunGap,
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
                    const SizedBox(
                      height: AppSpacing.predictionDataSmallTopGap,
                    ),
                    Text(
                      '${source.provider} - ${source.category}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSpacing.predictionDataIconBubble,
                height: AppSpacing.predictionDataIconBubble,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.predictionDataIconBubbleIcon,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.predictionDataSourceMetricsGap),
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
            const SizedBox(height: AppSpacing.predictionDataSourceUrlGap),
            Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.predictionDataSourceLinkIcon,
                ),
                const SizedBox(width: AppSpacing.predictionDataSourceLinkGap),
                Expanded(
                  child: Text(
                    source.apiUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
