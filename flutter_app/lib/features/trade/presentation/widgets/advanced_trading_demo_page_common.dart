part of '../pages/advanced_trading_demo_page.dart';

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab({required this.snapshot});

  final TradeAdvancedTradingDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricsCard(title: 'PnL Summary', metrics: snapshot.pnlSummary),
        const SizedBox(height: 14),
        _MetricsCard(
          title: 'Performance Stats',
          metrics: snapshot.performanceMetrics,
        ),
      ],
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.title, required this.metrics});

  final String title;
  final List<TradeAdvancedDemoMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final metric in metrics) ...[
            _ValueRow(
              label: metric.label,
              value: metric.value,
              tone: metric.tone,
            ),
            if (metric != metrics.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      variant: active ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: active ? AppColors.primary : null,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    this.tone = TradeAdvancedMetricTone.neutral,
  });

  final String label;
  final String value;
  final TradeAdvancedMetricTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _toneColor(tone),
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

class _DemoSheet extends StatelessWidget {
  const _DemoSheet({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom:
                  DeviceMetrics.nativeBottomChrome +
                  MediaQuery.paddingOf(context).bottom +
                  24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VitCard(
                  padding: const EdgeInsets.all(20),
                  radius: VitCardRadius.lg,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.onAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Demo control state only. Backend execution stays in draft mode for SC-088.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      VitCtaButton(
                        onPressed: onClose,
                        height: 44,
                        child: Text(
                          'Đóng',
                          style: AppTextStyles.body.copyWith(
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
        ),
      ),
    );
  }
}

Color _toneColor(TradeAdvancedMetricTone tone) {
  return switch (tone) {
    TradeAdvancedMetricTone.positive => _advancedGreen,
    TradeAdvancedMetricTone.negative => _advancedRed,
    TradeAdvancedMetricTone.warning => AppColors.warn,
    TradeAdvancedMetricTone.accent => _advancedPrimary,
    TradeAdvancedMetricTone.neutral => AppColors.text1,
  };
}
