part of '../pages/slippage_monitoring_page.dart';

class _CriticalAlert extends StatelessWidget {
  const _CriticalAlert({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.critical} Critical Slippage Event Detected',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Slippage exceeded 1% threshold. Review affected trades and consider provider adjustments.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        Icons.monitor_heart_outlined,
        _slipPrimary,
        'Total\nEvents',
        summary.total.toString(),
        'Last 24h',
        AppColors.text3,
      ),
      (
        Icons.track_changes_outlined,
        _slipGreen,
        'Avg\nSlippage',
        '${summary.avgSlippage.toStringAsFixed(1)}\nbps',
        '0.405%',
        AppColors.text3,
      ),
      (
        Icons.trending_up_rounded,
        _slipAmber,
        'Max\nSlippage',
        '${summary.maxSlippage.toStringAsFixed(1)}\nbps',
        '1.18%',
        _slipRed,
      ),
      (
        Icons.warning_amber_rounded,
        _slipRed,
        'Critical',
        summary.critical.toString(),
        '${summary.warning} warning',
        _slipRed,
      ),
    ];

    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(child: _StatCard(card: card)),
          if (card != cards.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final (IconData, Color, String, String, String, Color) card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.fromLTRB(10, 13, 10, 11),
      decoration: BoxDecoration(
        color: _slipPanel,
        border: Border.all(color: _slipBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card.$1, color: card.$2, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  card.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  card.$4,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 19,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1.22,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            card.$5,
            style: AppTextStyles.micro.copyWith(
              color: card.$6,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.activeId,
    required this.summary,
    required this.onChanged,
  });

  final String activeId;
  final TradeSlippageSummary summary;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('realtime', 'Real-time (${summary.total})'),
      ('providers', 'By Provider'),
      ('history', 'History'),
      ('alerts', 'Alerts (${summary.critical + summary.warning})'),
    ];
    return Container(
      height: 53,
      color: _slipPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: SlippageMonitoringPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _slipPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 72 : 0,
                      height: 2,
                      color: _slipPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
