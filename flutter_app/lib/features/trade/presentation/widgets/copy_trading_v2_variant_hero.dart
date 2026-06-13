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
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.palette_outlined, color: _copyPrimary, size: 18),
          const SizedBox(width: 12),
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
            if (variant != variants.last) const SizedBox(width: 8),
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
        height: 30,
        constraints: const BoxConstraints(minWidth: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        variant: active ? VitCardVariant.standard : VitCardVariant.ghost,
        borderColor: active ? _copyPrimary : AppColors.cardBorder,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
    return Container(
      height: 286,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface3, AppColors.surface],
        ),
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -52,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.accent20, AppColors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CopyIconBox(),
              const SizedBox(height: 20),
              Text(
                'Copy Trading',
                style: AppTextStyles.sectionTitle.copyWith(height: 1.2),
              ),
              const SizedBox(height: 7),
              Text(
                'Sao chép giao dịch từ trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'COPIERS',
                      value: _formatCompactNumber(snapshot.totalCopiers),
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: 12),
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
    return Container(
      height: 256,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent, AppColors.primarySoft],
        ),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.onAccent.withValues(alpha: .20),
              borderRadius: AppRadii.xlRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.copy_rounded,
                  color: AppColors.onAccent,
                  size: 14,
                ),
                const SizedBox(width: 7),
                Text(
                  'COPY TRADING',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Sao chép trader hàng đầu',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: 4),
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
              const SizedBox(width: 12),
              Expanded(
                child: _BoldStatCard(
                  label: 'COPIERS',
                  value: _formatCompactNumber(snapshot.totalCopiers),
                  color: _copyPrimary,
                ),
              ),
              const SizedBox(width: 12),
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
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent20,
        border: Border.all(color: AppColors.portfolioBtnGhostBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: const Icon(Icons.copy_rounded, color: _copyPrimary, size: 23),
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
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      borderColor: AppColors.onAccent.withValues(alpha: .08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
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
      height: 70,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .80),
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.extraBold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
