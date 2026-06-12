part of '../pages/slippage_monitoring_page.dart';

class _ProvidersTab extends StatelessWidget {
  const _ProvidersTab({required this.providers});

  final List<TradeSlippageProviderStats> providers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Provider Performance'),
        const SizedBox(height: 12),
        for (final provider in providers) ...[
          _Card(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.provider,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${provider.avgSlippage.toStringAsFixed(1)} bps',
                      style: AppTextStyles.body.copyWith(
                        color: provider.criticalCount > 0
                            ? _slipRed
                            : _slipGreen,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Events',
                        value: provider.eventCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Max Slippage',
                        value: '${provider.maxSlippage.toStringAsFixed(1)} bps',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Cost Impact',
                        value: '\$${_formatInt(provider.totalImpact)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (provider != providers.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.history});

  final List<TradeSlippageHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Slippage Trends (Last 7 Days)'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              for (final point in history) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 46,
                      child: Text(
                        point.date,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              const ColoredBox(color: _slipPanel2),
                              FractionallySizedBox(
                                widthFactor: (point.max / 120)
                                    .clamp(0, 1)
                                    .toDouble(),
                                child: const ColoredBox(color: _slipRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${point.max.toStringAsFixed(1)} bps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
                if (point != history.last) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Alert Configuration'),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Critical Slippage Alert',
          subtitle: 'Notify when slippage exceeds 1%',
          value: 'Current Threshold: 100 bps (1.0%)',
          enabled: true,
        ),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Warning Slippage Alert',
          subtitle: 'Notify when slippage exceeds 0.5%',
          value: 'Current Threshold: 50 bps (0.5%)',
          enabled: true,
        ),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Daily Summary Email',
          subtitle: 'Receive daily slippage report at 9:00 AM',
          value: 'Disabled',
          enabled: false,
        ),
      ],
    );
  }
}

class _AlertSetting extends StatelessWidget {
  const _AlertSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
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
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SwitchVisual(enabled: enabled),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _slipPanel2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}
