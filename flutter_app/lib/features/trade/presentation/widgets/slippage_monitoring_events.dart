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
        const SizedBox(height: AppSpacing.tradeToolSectionHeaderGap),
        for (final event in events) ...[
          _SlippageEventCard(event: event),
          if (event != events.last)
            const SizedBox(height: AppSpacing.tradeToolCardGap),
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
      padding: AppSpacing.tradeToolCardPaddingCompact,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            width: AppSpacing.tradeToolIconTileSm,
            height: AppSpacing.tradeToolIconTileSm,
            alignment: Alignment.center,
            borderColor: style.color.withValues(alpha: .24),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: AppSpacing.x4),
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
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: AppSpacing.tradeToolInlineGap,
                              ),
                              _SidePill(side: event.side),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x3),
                          Text(
                            '${event.provider} · ${event.time}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.tradeToolInlineGap),
                    _SeverityPill(style: style),
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeToolCardGap),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Expected',
                        value: _formatPrice(event.expectedPrice),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.tradeToolInlineGap),
                    Expanded(
                      child: _EventMetric(
                        label: 'Executed',
                        value: _formatPrice(event.executedPrice),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.tradeToolInlineGap),
                    Expanded(
                      child: _EventMetric(
                        label: 'Slippage',
                        value: '${event.slippagePct.toStringAsFixed(3)}%',
                        color: style.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeToolIconGap),
                VitCard(
                  variant: VitCardVariant.inner,
                  height: AppSpacing.tradeToolMetricRowHeight,
                  padding: AppSpacing.tradeToolMetricRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cost Impact:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Text(
                        '\$${((event.executedPrice - event.expectedPrice).abs() * event.volume).toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
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
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.tradeToolMetricHeight,
      padding: AppSpacing.tradeToolMetricPadding,
      borderColor: color == AppColors.text2
          ? null
          : color.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
