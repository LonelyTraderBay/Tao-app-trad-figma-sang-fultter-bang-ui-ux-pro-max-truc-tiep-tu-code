part of '../pages/predictions_home_page.dart';

class _PredictionsHero extends StatelessWidget {
  const _PredictionsHero({
    required this.openEventCount,
    required this.openPositionCount,
    required this.onPositionsTap,
  });

  final int openEventCount;
  final int openPositionCount;
  final VoidCallback onPositionsTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _HeroKpi(
                  label: 'Sự kiện mở',
                  value: '$openEventCount',
                  caption: 'Thị trường đang giao dịch',
                  valueColor: AppColors.text1,
                ),
              ),
              Container(
                width: 1,
                height: AppSpacing.x6,
                color: AppColors.border,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.x4),
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      key: PredictionsHomePage.myPredictionsKey,
                      onTap: onPositionsTap,
                      borderRadius: AppRadii.smRadius,
                      child: _HeroKpi(
                        label: 'Vị thế của tôi',
                        value: '$openPositionCount',
                        caption: 'Xem danh mục vị thế',
                        valueColor: _marketPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: () =>
                context.go(AppRoutePaths.marketsPredictionsBreaking),
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.bolt_outlined),
            child: const Text('Xem Breaking'),
          ),
        ],
      ),
    );
  }
}

class _HeroKpi extends StatelessWidget {
  const _HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

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
          value,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _BreakingMoversStrip extends StatelessWidget {
  const _BreakingMoversStrip({required this.snapshot, required this.onTap});

  final PredictionHomeSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (snapshot.breakingMovers.isEmpty) {
      return const SizedBox.shrink();
    }

    final movers = snapshot.breakingMovers.take(2).toList();
    return Material(
      key: PredictionsHomePage.breakingMoversKey,
      color: AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: PredictionsSpacingTokens.predictionHomeCategoryPadding,
          child: Row(
            children: [
              const Icon(
                Icons.bolt_outlined,
                color: AppColors.warn,
                size: PredictionsSpacingTokens.predictionHomeHighlightIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biến động 24h',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      movers
                          .map((mover) => _formatPercent(mover.change24h))
                          .join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionHomeHighlightCtaIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArenaBridgeCard extends StatelessWidget {
  const _ArenaBridgeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomePage.arenaBridgeKey,
      onTap: onTap,
      density: VitDensity.compact,
      child: Row(
        children: [
          const _HighlightIconBox(
            icon: Icons.sports_esports_outlined,
            color: AppColors.text2,
            background: AppColors.surface2,
            iconSize: PredictionsSpacingTokens.predictionHomeHighlightIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Thử thách cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallBadge(
                      label: 'Arena Points only',
                      color: AppColors.text3,
                      background: AppColors.surface2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Khám phá room social points-only trong Open Arena',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: PredictionsSpacingTokens.predictionHomeHighlightCtaIcon,
          ),
        ],
      ),
    );
  }
}

class _RiskDisclaimer extends StatelessWidget {
  const _RiskDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Vị thế dự đoán không đảm bảo kết quả. Xác suất thay đổi theo thị trường; '
      'xem quy tắc resolution trước khi mở vị thế.',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      textAlign: TextAlign.center,
    );
  }
}

class _HighlightIconBox extends StatelessWidget {
  const _HighlightIconBox({
    required this.icon,
    required this.color,
    required this.background,
    required this.iconSize,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: VitDensity.compact.controlHeight - AppSpacing.x2,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
