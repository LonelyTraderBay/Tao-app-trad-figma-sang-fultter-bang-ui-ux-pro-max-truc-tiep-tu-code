part of '../pages/funnel_dashboard.dart';

class _WaterfallCard extends StatelessWidget {
  const _WaterfallCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.filter_alt_outlined,
            title: 'Funnel Waterfall',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _WaterfallStep(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _WaterfallStep extends StatelessWidget {
  const _WaterfallStep({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StepNumber(index: index),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                step.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${step.reached}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'monospace',
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  step.completionRateLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.inputRadius,
          child: const SizedBox(
            height: AppSpacing.adminBox32,
            child: ColoredBox(
              color: AppColors.surface2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                  child: Text(
                    'hoàn thành',
                    style: TextStyle(
                      color: AppColors.text1,
                      fontSize: AppSpacing.adminFontMd,
                      fontWeight: FontWeight.w700,
                      height: AppSpacing.adminLineHeightShort,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.adminIconXs,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${step.completionRateLabel} hoàn thành',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _DropoutChartCard extends StatelessWidget {
  const _DropoutChartCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    final hasDropout = funnel.steps.any((step) => step.reached > 0);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_down_rounded,
            title: 'Tỷ lệ rời bỏ theo bước',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.adminFunnelWaterfallHeight,
            child: Semantics(
              label: hasDropout
                  ? '${funnel.name} dropout chart'
                  : '${funnel.name} dropout chart has no sessions',
              child: CustomPaint(
                painter: _DropoutChartPainter(steps: funnel.steps),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          if (!hasDropout) ...[
            const SizedBox(height: AppSpacing.x3),
            const AdminInlineEmptyState(
              icon: Icons.trending_down_rounded,
              title: 'No dropout data',
              message: 'Dropout rates appear after sessions enter this funnel.',
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDetailsCard extends StatelessWidget {
  const _StepDetailsCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Chi tiết từng bước',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _StepDetailRow(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StepDetailRow extends StatelessWidget {
  const _StepDetailRow({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StepNumber(index: index),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    step.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.adminIconMd,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Tiếp cận',
                    value: '${step.reached}',
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Hoàn thành',
                    value: '${step.completed}',
                    valueColor: AppColors.buy,
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Tỷ lệ',
                    value: step.completionRateLabel,
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Thời gian',
                    value: step.avgTimeLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'monospace',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
