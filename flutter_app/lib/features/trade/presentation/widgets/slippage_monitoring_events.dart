part of '../pages/slippage_monitoring_page.dart';

class _RealtimeTab extends StatelessWidget {
  const _RealtimeTab({required this.events});

  final List<TradeSlippageEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Recent Slippage Events'),
        const SizedBox(height: 12),
        for (final event in events) ...[
          _SlippageEventCard(event: event),
          if (event != events.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SlippageEventCard extends StatelessWidget {
  const _SlippageEventCard({required this.event});

  final TradeSlippageEvent event;

  @override
  Widget build(BuildContext context) {
    final style = _severityStyle(event.severity);
    return VitCard(
      key: SlippageMonitoringPage.eventKey(event.id),
      padding: const EdgeInsets.all(13),
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: .15),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  event.instrument,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.text1,
                                    fontSize: 13,
                                    fontWeight: AppTextStyles.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _SidePill(side: event.side),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Text(
                            '${event.provider} · ${event.time}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SeverityPill(style: style),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Expected',
                        value: _formatPrice(event.expectedPrice),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Executed',
                        value: _formatPrice(event.executedPrice),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Slippage',
                        value: '${event.slippagePct.toStringAsFixed(3)}%',
                        color: style.color,
                        background: style.color.withValues(alpha: .13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _slipPanel2,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cost Impact:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        '\$${((event.executedPrice - event.expectedPrice).abs() * event.volume).toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
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

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text2,
    this.background = _slipPanel2,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
