part of '../pages/leverage_page.dart';

class _LeverageHeader extends StatelessWidget {
  const _LeverageHeader({required this.currentLeverage, required this.onBack});

  final int currentLeverage;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          InkWell(
            key: LeveragePage.backKey,
            onTap: onBack,
            borderRadius: AppRadii.cardRadius,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điều chỉnh đòn bẩy',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hiện tại: ${currentLeverage}x',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
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

class _LeverageHero extends StatelessWidget {
  const _LeverageHero({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: .08),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: riskColor.withValues(alpha: .32), width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            riskColor.withValues(alpha: .10),
            riskColor.withValues(alpha: .04),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded, color: riskColor, size: 21),
              const SizedBox(width: 8),
              Text(
                'Đòn bẩy',
                style: AppTextStyles.caption.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${preview.leverage}x',
            style: AppTextStyles.display.copyWith(
              color: riskColor,
              fontSize: 56,
              height: 1,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
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
              'Rủi ro: ${preview.riskLabel}',
              style: AppTextStyles.caption.copyWith(
                color: riskColor,
                fontSize: 12,
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mức rủi ro',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
            Text(
              preview.riskLabel,
              style: AppTextStyles.caption.copyWith(
                color: riskColor,
                fontSize: 12,
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
    );
  }

  Color _segmentColor(int level) {
    if (level <= 2) return AppColors.buy;
    if (level <= 4) return AppColors.caution;
    return AppColors.sell;
  }
}
