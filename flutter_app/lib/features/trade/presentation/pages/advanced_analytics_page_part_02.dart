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
      density: VitDensity.compact,
      borderColor: tone.withValues(alpha: .28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: tone.withValues(alpha: .12),
                child: Icon(
                  icon,
                  color: tone,
                  size: AppSpacing.tradeBotDisputeDropdownIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        _SignalBadge(
                          label: signal.direction.toUpperCase(),
                          color: tone,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          signal.timeframe,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
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
                size: AppSpacing.tradeBotDisputeDropdownIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: _ConfidenceBox(
                  confidence: signal.confidence,
                  color: confidenceColor,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x2),
          for (final reason in signal.reasoning.take(2)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: tone,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    reason,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ],
            ),
            if (reason != signal.reasoning.take(2).last)
              const SizedBox(height: AppSpacing.x1),
          ],
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: _advancedBorder.withValues(alpha: .72)),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.psychology_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'GPT-4 + TradingView v2.1',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${signal.accuracy}% accuracy',
                style: AppTextStyles.micro.copyWith(
                  color: signal.accuracy >= 70
                      ? _advancedGreen
                      : _advancedAmber,
                  fontWeight: AppTextStyles.bold,
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
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Confidence',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.pillRadius,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    value: confidence / 100,
                    backgroundColor: _advancedBorder,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '$confidence%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
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
      density: VitDensity.compact,
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
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '\$${_formatPrice(value)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
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
      density: VitDensity.compact,
      title: 'AI Prediction Disclaimer',
      message:
          'Signals are predictions, not guarantees. Always conduct your own research and risk management. Past accuracy does not guarantee future results.',
    );
  }
}
