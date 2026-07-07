part of '../pages/performance_monitor.dart';

class _PerformanceScoreCard extends StatelessWidget {
  const _PerformanceScoreCard({required this.snapshot});

  final PerformanceMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.monitor_heart_outlined,
                color: AppColors.primary,
                background: AppColors.primary12,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Score',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      snapshot.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              for (final metric in snapshot.summaryMetrics) ...[
                Expanded(child: _SummaryTile(metric: metric)),
                if (metric != snapshot.summaryMetrics.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.metric});

  final PerformanceSummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(metric.tone);

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: AppSpacing.devTokenCardPadding,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                metric.value,
                maxLines: 1,
                style: AppTextStyles.amountXs.copyWith(color: toneColor),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              metric.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalsCard extends StatelessWidget {
  const _VitalsCard({required this.metrics});

  final List<PerformanceVitalMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          for (final metric in metrics) ...[
            _VitalRow(metric: metric),
            if (metric != metrics.last) const _Divider(),
          ],
        ],
      ),
    );
  }
}

class _VitalRow extends StatelessWidget {
  const _VitalRow({required this.metric});

  final PerformanceVitalMetric metric;

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(metric.tone);

    return Padding(
      padding: AppSpacing.devVerticalPaddingX2,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                ),
              ),
              Text(
                metric.value,
                style: AppTextStyles.caption.copyWith(
                  color: toneColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ProgressBar(progress: metric.progress, color: toneColor),
        ],
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.memory});

  final PerformanceMemoryUsage memory;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.usedLabel,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      memory.limitLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                memory.percentLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _ProgressBar(progress: memory.progress, color: AppColors.buy),
        ],
      ),
    );
  }
}

class _LazyChunksCard extends StatelessWidget {
  const _LazyChunksCard({required this.chunks});

  final List<String> chunks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flash_on_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${chunks.length} chunks loaded on-demand',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final chunk in chunks) ...[
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
              ),
              child: Padding(
                padding: AppSpacing.devTokenCardPadding,
                child: Text(
                  chunk,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
            if (chunk != chunks.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ResourcesCard extends StatelessWidget {
  const _ResourcesCard({required this.resources});

  final List<PerformanceResourceTiming> resources;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          for (final resource in resources) ...[
            _ResourceRow(resource: resource),
            if (resource != resources.last) const _Divider(),
          ],
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final PerformanceResourceTiming resource;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.devVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${resource.type} - ${resource.size}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.chartLabelXs.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            resource.duration,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
