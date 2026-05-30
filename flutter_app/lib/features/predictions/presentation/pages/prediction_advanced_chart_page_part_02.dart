part of 'prediction_advanced_chart_page.dart';

class _LayerButton extends StatelessWidget {
  const _LayerButton({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? color.withValues(alpha: .08) : AppColors.bg,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            border: Border.all(color: active ? color : AppColors.border),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? color : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                active
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 14,
                color: active ? color : AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RsiCard extends StatelessWidget {
  const _RsiCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'RSI (Relative Strength Index)',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${snapshot.currentRsi}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 124,
            child: CustomPaint(
              painter: _RsiPainter(points: snapshot.priceHistory),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: AppColors.text3,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'RSI > 70: Overbought - RSI < 30: Oversold',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicatorSummarySection extends StatelessWidget {
  const _IndicatorSummarySection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Technical Indicators',
      accentColor: _predictionPrimary,
      children: [
        for (final indicator in snapshot.indicators)
          _IndicatorCard(indicator: indicator),
      ],
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({required this.indicator});

  final PredictionIndicatorSignalDraft indicator;

  @override
  Widget build(BuildContext context) {
    final widthFactor = switch (indicator.strength) {
      'Strong' => .80,
      'Moderate' => .50,
      _ => .25,
    };
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      indicator.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      indicator.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SignalBadge(label: indicator.signal, color: indicator.color),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: ColoredBox(color: indicator.color),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                indicator.strength,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallSignalCard extends StatelessWidget {
  const _OverallSignalCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Overall Signal',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'BULLISH',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
          ),
          const SizedBox(height: 4),
          Text(
            '3/4 indicators show buy signal. Momentum is positive.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderFlowCard extends StatelessWidget {
  const _OrderFlowCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Flow (Buy vs Sell Pressure)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 202,
            child: CustomPaint(
              painter: _OrderFlowPainter(points: snapshot.orderFlow),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _LegendItem(label: 'Buy Volume', color: AppColors.buy),
              ),
              Expanded(
                child: _LegendItem(label: 'Sell Volume', color: AppColors.sell),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportResistanceSection extends StatelessWidget {
  const _SupportResistanceSection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Support & Resistance',
      accentColor: _predictionPrimary,
      children: [
        _LevelCard(
          label: 'Resistance',
          value: snapshot.resistanceLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.resistanceLevel) * 100).toStringAsFixed(1)}% to reach',
          color: AppColors.sell,
        ),
        _LevelCard(
          label: 'Support',
          value: snapshot.supportLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.supportLevel) * 100).toStringAsFixed(1)}% above support',
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  final String label;
  final double value;
  final String helper;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(value * 100).toStringAsFixed(1)}%',
                  style: AppTextStyles.sectionTitle.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  helper,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(Icons.track_changes_rounded, color: color, size: 18),
        ],
      ),
    );
  }
}

class _PatternRecognitionCard extends StatelessWidget {
  const _PatternRecognitionCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pattern Recognition',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          for (final pattern in snapshot.patterns) ...[
            _PatternRow(pattern: pattern),
            if (pattern != snapshot.patterns.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({required this.pattern});

  final PredictionPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    final color = pattern.bullish ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    pattern.name,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Icon(Icons.trending_up_rounded, color: color, size: 12),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: SizedBox(
                  height: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: pattern.confidence / 100,
                      child: ColoredBox(color: color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${pattern.confidence}%',
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AnalysisDisclaimer extends StatelessWidget {
  const _AnalysisDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn.withValues(alpha: .20),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phan tich ky thuat chi mang tinh tham khao. Khong dam bao ket qua tuong lai. Ket hop voi nghien cuu co ban de quyet dinh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
