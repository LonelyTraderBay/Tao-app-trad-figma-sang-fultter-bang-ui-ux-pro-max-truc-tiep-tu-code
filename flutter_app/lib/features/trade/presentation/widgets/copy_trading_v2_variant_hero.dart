part of '../pages/copy_trading_v2_page.dart';

class _VariantSwitcher extends StatelessWidget {
  const _VariantSwitcher({
    required this.variants,
    required this.selected,
    required this.onChanged,
  });

  final List<String> variants;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.cardBorder,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.copyTradingV2VariantMinHeight,
      ),
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          const Icon(
            Icons.palette_outlined,
            color: _copyPrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
          Expanded(
            child: Text(
              'Card Style:',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          for (final variant in variants) ...[
            _VariantButton(
              key: CopyTradingV2Page.variantKey(variant),
              label: _titleCase(variant),
              active: selected == variant,
              onTap: () => onChanged(variant),
            ),
            if (variant != variants.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _VariantButton extends StatelessWidget {
  const _VariantButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        height: AppSpacing.copyTradingV2VariantButtonHeight,
        constraints: const BoxConstraints(
          minWidth: AppSpacing.copyTradingV2VariantButtonMinWidth,
        ),
        alignment: Alignment.center,
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.walletAssetHeroTopGap,
          right: AppSpacing.walletAssetHeroTopGap,
        ),
        variant: active ? VitCardVariant.standard : VitCardVariant.ghost,
        borderColor: active ? _copyPrimary : AppColors.cardBorder,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot, required this.variant});

  final TradeCopyTradingSnapshot snapshot;
  final String variant;

  @override
  Widget build(BuildContext context) {
    if (variant == 'bold') return _BoldHero(snapshot: snapshot);
    return _GlassHero(snapshot: snapshot);
  }
}

class _GlassHero extends StatelessWidget {
  const _GlassHero({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.copyTradingV2GlassHeroHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.contentPad,
        top: AppSpacing.contentPad,
        right: AppSpacing.contentPad,
        bottom: AppSpacing.contentPad,
      ),
      radius: VitCardRadius.lg,
      borderColor: AppColors.accent20,
      background: const VitHeroGlow(
        center: Alignment(0.94, -0.88),
        colors: [
          AppColors.accent20,
          AppColors.primary08,
          AppColors.transparent,
        ],
      ),
      clip: true,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CopyIconBox(),
              const SizedBox(height: AppSpacing.contentPad),
              Text('Copy Trading', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.transferTileGap),
              Text(
                'Sao chép giao dịch từ trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.groups_2_outlined,
                      label: 'TRADERS',
                      value: '${snapshot.traders.length}',
                      color: _copyPurple,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'COPIERS',
                      value: _formatCompactNumber(snapshot.totalCopiers),
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.trending_up_rounded,
                      label: 'AUM',
                      value: _formatCompact(snapshot.totalAum, prefix: r'$'),
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoldHero extends StatelessWidget {
  const _BoldHero({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.copyTradingV2BoldHeroHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.contentPad,
        top: AppSpacing.contentPad,
        right: AppSpacing.contentPad,
        bottom: AppSpacing.contentPad,
      ),
      radius: VitCardRadius.lg,
      variant: VitCardVariant.hero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitStatusPill(
            label: 'COPY TRADING',
            status: VitStatusPillStatus.info,
            icon: Icons.copy_rounded,
            size: VitStatusPillSize.lg,
          ),
          const SizedBox(height: AppSpacing.rowPy),
          Text(
            'Sao chép trader hàng đầu',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.hairlineStroke * 2),
          Text(
            'Tự động · Minh bạch · Kiểm soát rủi ro',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent.withValues(alpha: .90),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _BoldStatCard(
                  label: 'TRADERS',
                  value: '${snapshot.traders.length}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
              Expanded(
                child: _BoldStatCard(
                  label: 'COPIERS',
                  value: _formatCompactNumber(snapshot.totalCopiers),
                  color: _copyPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
              Expanded(
                child: _BoldStatCard(
                  label: 'AUM',
                  value: _formatCompact(snapshot.totalAum, prefix: r'$'),
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyIconBox extends StatelessWidget {
  const _CopyIconBox();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.copyTradingV2HeroIconBox,
      height: AppSpacing.copyTradingV2HeroIconBox,
      alignment: Alignment.center,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.portfolioBtnGhostBorder,
      background: const ColoredBox(color: AppColors.accent20),
      clip: true,
      child: const Icon(
        Icons.copy_rounded,
        color: _copyPrimary,
        size: AppSpacing.copyTradingV2HeroIconGlyph,
      ),
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  const _GlassStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: AppSpacing.copyTradingV2GlassStatHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x3,
        top: AppSpacing.rowPy,
        right: AppSpacing.x3,
        bottom: AppSpacing.rowPy,
      ),
      borderColor: AppColors.onAccent.withValues(alpha: .08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VitCard(
            width: AppSpacing.copyTradingV2GlassStatIconBox,
            height: AppSpacing.copyTradingV2GlassStatIconBox,
            alignment: Alignment.center,
            radius: VitCardRadius.lg,
            variant: VitCardVariant.ghost,
            background: ColoredBox(color: color.withValues(alpha: .16)),
            clip: true,
            child: Icon(
              icon,
              color: color,
              size: AppSpacing.copyTradingV2GlassStatIconGlyph,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
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
        ],
      ),
    );
  }
}

class _BoldStatCard extends StatelessWidget {
  const _BoldStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .88),
      height: AppSpacing.copyTradingV2BoldStatHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetChartBottomGap,
        top: AppSpacing.walletAssetChartBottomGap,
        right: AppSpacing.walletAssetChartBottomGap,
        bottom: AppSpacing.walletAssetChartBottomGap,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .80),
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
