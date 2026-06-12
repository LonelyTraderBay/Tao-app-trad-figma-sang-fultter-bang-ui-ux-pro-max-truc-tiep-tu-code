part of '../pages/dust_converter_page.dart';

class _DustHero extends StatelessWidget {
  const _DustHero({
    required this.snapshot,
    required this.targetSymbol,
    required this.foundCount,
    required this.selectedCount,
    required this.selectedValue,
  });

  final WalletDustConverterSnapshot snapshot;
  final String targetSymbol;
  final int foundCount;
  final int selectedCount;
  final double selectedValue;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.walletDustHeroPadding,
      borderColor: _dustHeroBorder,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.walletDustHeroIconBox,
                height: AppSpacing.walletDustHeroIconBox,
                decoration: BoxDecoration(
                  color: _dustAmber.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: _dustAmber.withValues(alpha: .5)),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: _dustAmber,
                  size: AppSpacing.walletDustHeroIconGlyph,
                ),
              ),
              const SizedBox(width: AppSpacing.walletDustHeroHeaderGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'D\u1ECDn d\u1EB9p v\u00ED',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletDustHeroTitleGap),
                    Text(
                      'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF (d\u01B0\u1EDBi ${_formatUsd(snapshot.dustThresholdUsd)}) sang $targetSymbol',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(color: _dustMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletDustHeroStatsGap),
          Row(
            children: [
              _HeroStat(
                value: foundCount.toString(),
                label: 'Dust t\u00ECm th\u1EA5y',
                color: _dustAmber,
              ),
              const SizedBox(width: AppSpacing.walletDustHeroStatGap),
              _HeroStat(
                value: selectedCount.toString(),
                label: '\u0110\u00E3 ch\u1ECDn',
                color: _dustPrimary,
              ),
              const SizedBox(width: AppSpacing.walletDustHeroStatGap),
              _HeroStat(
                value: _formatUsd(selectedValue),
                label: 'Gi\u00E1 tr\u1ECB',
                color: _dustGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: AppSpacing.walletDustHeroStatHeight,
        padding: AppSpacing.walletDustHeroStatPadding,
        decoration: BoxDecoration(
          color: AppColors.surface3,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.walletDustTextGap),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ),
    );
  }
}
