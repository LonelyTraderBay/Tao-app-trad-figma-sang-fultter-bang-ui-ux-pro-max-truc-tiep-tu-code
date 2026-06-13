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
      height: 178,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      radius: VitCardRadius.lg,
      borderColor: riskColor.withValues(alpha: .32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded, color: riskColor, size: 21),
              const SizedBox(width: 8),
              Text('\u0110\u00F2n b\u1EA9y', style: AppTextStyles.captionSm),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${preview.leverage}x',
            style: AppTextStyles.jumbo.copyWith(
              color: riskColor,
              height: 1,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: .13),
              borderRadius: AppRadii.xlRadius,
              border: Border.all(color: riskColor.withValues(alpha: .32)),
            ),
            child: Text(
              'R\u1EE7i ro: ${preview.riskLabel}',
              style: AppTextStyles.captionSm.copyWith(
                color: riskColor,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
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
      padding: const EdgeInsets.all(14),
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
          const SizedBox(height: 8),
          Row(
            children: [
              for (var level = 1; level <= 6; level++) ...[
                Expanded(
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: level <= preview.riskLevel
                          ? _segmentColor(level)
                          : _chipBackground,
                      borderRadius: AppRadii.xsRadius,
                    ),
                  ),
                ),
                if (level != 6) const SizedBox(width: 5),
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
