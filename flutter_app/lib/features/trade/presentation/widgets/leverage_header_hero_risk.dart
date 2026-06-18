part of '../pages/leverage_page.dart';

class _LeverageTopChromeHeader extends StatelessWidget {
  const _LeverageTopChromeHeader({
    required this.currentLeverage,
    required this.onBack,
  });

  final int currentLeverage;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.detail,
      title: '\u0110i\u1EC1u ch\u1EC9nh \u0111\u00F2n b\u1EA9y',
      subtitle: 'Hi\u1EC7n t\u1EA1i: ${currentLeverage}x',
      showBack: true,
      backKey: LeveragePage.backKey,
      onBack: onBack,
    );
  }
}

class _LeverageHero extends StatelessWidget {
  const _LeverageHero({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.leverageHeroHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x5,
        top: AppSpacing.x5,
        right: AppSpacing.x5,
        bottom: AppSpacing.x5,
      ),
      radius: VitCardRadius.lg,
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
              Text('\u0110\u00F2n b\u1EA9y', style: AppTextStyles.captionSm),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '${preview.leverage}x',
            style: AppTextStyles.jumbo.copyWith(
              color: riskColor,
              height: AppSpacing.leverageHeroValueLineHeight,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.rowPy),
          VitAccentPill(
            label: 'R\u1EE7i ro: ${preview.riskLabel}',
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
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        top: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
        bottom: AppSpacing.rowPy,
      ),
      borderColor: riskColor.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'M\u1EE9c r\u1EE7i ro',
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
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (var level = 1; level <= 6; level++) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.xsRadius,
                    child: SizedBox(
                      height: AppSpacing.transferTileGap,
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
