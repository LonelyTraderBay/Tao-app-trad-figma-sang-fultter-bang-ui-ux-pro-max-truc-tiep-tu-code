part of '../pages/leverage_page.dart';

class _LeverageHero extends StatelessWidget {
  const _LeverageHero({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: _leverageHeroHeight,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x4,
        top: AppSpacing.x4,
        right: AppSpacing.x4,
        bottom: AppSpacing.x4,
      ),
      radius: VitCardRadius.large,
      borderColor: riskColor.withValues(alpha: .32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt_rounded,
                color: riskColor,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text('Đòn bẩy', style: AppTextStyles.captionSm),
            ],
          ),
          const SizedBox(height: _leverageSpace),
          Text(
            '${preview.leverage}x',
            style: AppTextStyles.jumbo.copyWith(
              color: riskColor,
              height: _leverageHeroValueLineHeight,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _leverageSpace),
          VitAccentPill(
            label: 'Rủi ro: ${preview.riskLabel}',
            accentColor: riskColor,
            size: VitStatusPillSize.md,
          ),
        ],
      ),
    );
  }
}

class _RiskMeter extends StatelessWidget {
  const _RiskMeter({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _leverageCardSpace,
        top: _leverageCardSpace,
        right: _leverageCardSpace,
        bottom: _leverageCardSpace,
      ),
      borderColor: riskColor.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mức rủi ro',
                style: AppTextStyles.captionSm.copyWith(color: AppColors.text3),
              ),
              Text(
                preview.riskLabel,
                style: AppTextStyles.captionSm.copyWith(
                  color: riskColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _leverageSpace),
          Row(
            children: [
              for (var level = 1; level <= 6; level++) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.xsRadius,
                    child: SizedBox(
                      height: _leverageMeterSegmentHeight,
                      child: ColoredBox(
                        color: level <= preview.riskLevel
                            ? _segmentColor(level)
                            : _chipBackground,
                      ),
                    ),
                  ),
                ),
                if (level != 6) const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _segmentColor(int level) {
    if (level <= 2) return AppColors.buy;
    if (level <= 4) return AppColors.caution;
    return AppColors.sell;
  }
}
