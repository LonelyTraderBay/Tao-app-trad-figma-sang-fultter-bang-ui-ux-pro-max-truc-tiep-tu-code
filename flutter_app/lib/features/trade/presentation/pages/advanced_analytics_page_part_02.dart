part of 'advanced_analytics_page.dart';

class _SignalCard extends StatelessWidget {
  const _SignalCard({required this.signal});

  final TradeAiSignal signal;

  @override
  Widget build(BuildContext context) {
    final isLong = signal.direction == 'long';
    final tone = isLong ? _advancedGreen : _advancedRed;
    final icon = isLong
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    final confidenceColor = signal.confidence >= 80
        ? _advancedGreen
        : _advancedPrimary;
    final rrColor = signal.riskReward >= 3 ? _advancedGreen : _advancedPrimary;

    return VitCard(
      constraints: const BoxConstraints(minHeight: 232),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      borderColor: tone.withValues(alpha: .28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(icon, color: tone, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _SignalBadge(
                          label: signal.direction.toUpperCase(),
                          color: tone,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          signal.timeframe,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ConfidenceBox(
                  confidence: signal.confidence,
                  color: confidenceColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Risk/Reward',
                  value: '1:${signal.riskReward.toStringAsFixed(1)}',
                  valueColor: rrColor,
                  alignLeft: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PriceTarget(
                  label: 'Entry',
                  value: signal.entryPrice,
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _PriceTarget(
                  label: 'Target',
                  value: signal.targetPrice,
                  color: _advancedGreen,
                ),
              ),
              Expanded(
                child: _PriceTarget(
                  label: 'Stop Loss',
                  value: signal.stopLoss,
                  color: _advancedRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final reason in signal.reasoning.take(2)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: tone, size: 13),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (reason != signal.reasoning.take(2).last)
              const SizedBox(height: 7),
          ],
          const SizedBox(height: 13),
          Container(height: 1, color: _advancedBorder.withValues(alpha: .72)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.psychology_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GPT-4 + TradingView v2.1',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${signal.accuracy}% accuracy',
                style: AppTextStyles.micro.copyWith(
                  color: signal.accuracy >= 70
                      ? _advancedGreen
                      : _advancedAmber,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBox extends StatelessWidget {
  const _ConfidenceBox({required this.confidence, required this.color});

  final int confidence;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 62,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      variant: VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Confidence',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 6,
                    child: Stack(
                      children: [
                        const ColoredBox(color: _advancedBorder),
                        FractionallySizedBox(
                          widthFactor: confidence / 100,
                          child: ColoredBox(color: color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '$confidence%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignLeft = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
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

class _MiniStatBox extends StatelessWidget {
  const _MiniStatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
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

class _PriceTarget extends StatelessWidget {
  const _PriceTarget({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '\$${_formatPrice(value)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SignalBadge extends StatelessWidget {
  const _SignalBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: label == 'LONG'
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'AI Prediction Disclaimer',
      message:
          'Signals are predictions, not guarantees. Always conduct your own research and risk management. Past accuracy does not guarantee future results.',
    );
  }
}
