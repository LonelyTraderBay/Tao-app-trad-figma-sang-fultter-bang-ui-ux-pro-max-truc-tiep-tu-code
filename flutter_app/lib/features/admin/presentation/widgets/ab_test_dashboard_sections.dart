part of '../pages/ab_test_dashboard.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final AdminAbTestsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.science_outlined,
            label: 'Tests đang chạy',
            value: '${snapshot.activeTests}',
            delta: '0.0%',
            timeframe: 'Current tests',
            tint: AppColors.accent15,
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _SummaryCard(
            icon: Icons.workspace_premium_outlined,
            label: 'Có kết quả',
            value: '${snapshot.completedTests}',
            delta: '0.0%',
            timeframe: 'Current tests',
            tint: AppColors.buy15,
            accent: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
    required this.timeframe,
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String delta;
  final String timeframe;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.adminBox40,
            height: AppSpacing.adminBox40,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Icon(icon, color: accent, size: AppSpacing.adminIconXl),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: AppSpacing.adminFontMd,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: AppSpacing.adminFont3xl,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    VitStatusPill(
                      label: delta,
                      status: delta.startsWith('-')
                          ? VitStatusPillStatus.error
                          : VitStatusPillStatus.success,
                      size: VitStatusPillSize.sm,
                    ),
                    Text(
                      timeframe,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: AppSpacing.adminFontSm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _ABTestCard extends StatelessWidget {
  const _ABTestCard({
    required this.test,
    required this.selected,
    required this.onTap,
  });

  final AdminAbTestSummary test;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${test.name} A/B test',
      child: VitCard(
        key: ABTestDashboard.testKey(test.id),
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.x4),
        borderColor: selected ? AppColors.accent30 : AppColors.cardBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TestHeader(test: test),
            const SizedBox(height: AppSpacing.x4),
            _StatsRow(test: test),
            const SizedBox(height: AppSpacing.x4),
            for (final variant in test.variants) ...[
              _VariantResult(variant: variant),
              if (variant != test.variants.last)
                const SizedBox(height: AppSpacing.x3),
            ],
            if (selected) ...[
              const SizedBox(height: AppSpacing.x4),
              const Divider(
                height: AppSpacing.adminDividerHeight,
                color: AppColors.divider,
              ),
              const SizedBox(height: AppSpacing.x4),
              _ExpandedDetails(test: test),
            ],
          ],
        ),
      ),
    );
  }
}

class _TestHeader extends StatelessWidget {
  const _TestHeader({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.science_outlined,
          color: AppColors.accent,
          size: AppSpacing.adminIconMd,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                test.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                test.id,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        VitStatusPill(
          label: test.status == AdminAbTestStatus.active
              ? 'DANG CHAY'
              : 'HOAN THANH',
          status: test.status == AdminAbTestStatus.active
              ? VitStatusPillStatus.info
              : VitStatusPillStatus.success,
          size: VitStatusPillSize.sm,
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStat(label: 'Mẫu', value: '${test.sampleSize}'),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MiniStat(label: 'Độ tin cậy', value: test.confidenceLabel),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MiniStat(label: 'Lift', value: test.liftLabel),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Admin A/B test metric $label: $value',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Column(
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'monospace',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantResult extends StatelessWidget {
  const _VariantResult({required this.variant});

  final AdminAbTestVariant variant;

  @override
  Widget build(BuildContext context) {
    final rate = variant.exposures == 0
        ? 0.0
        : (variant.conversions / variant.exposures).clamp(0.0, 1.0).toDouble();
    return Semantics(
      label:
          '${variant.label} variant conversion rate ${variant.conversionRateLabel}, ${variant.conversions} of ${variant.exposures} conversions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  variant.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                variant.conversionRateLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'monospace',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: SizedBox(
              height: AppSpacing.adminProgressHeight,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.surface2),
                  ),
                  FractionallySizedBox(
                    widthFactor: rate,
                    alignment: Alignment.centerLeft,
                    child: ColoredBox(color: _variantAccent(variant)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${variant.conversions} / ${variant.exposures} conversions',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
