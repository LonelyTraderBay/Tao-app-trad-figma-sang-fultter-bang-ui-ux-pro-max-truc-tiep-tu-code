part of '../pages/margin_trading_page.dart';

class _SideToggle extends StatelessWidget {
  const _SideToggle({required this.side, required this.onChanged});

  final String side;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 55,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.hairlineStroke * 2,
        top: AppSpacing.hairlineStroke * 2,
        right: AppSpacing.hairlineStroke * 2,
        bottom: AppSpacing.hairlineStroke * 2,
      ),
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          _SideButton(
            id: 'long',
            label: 'Long',
            icon: Icons.trending_up_rounded,
            color: _marginGreen,
            active: side == 'long',
            onTap: () => onChanged('long'),
          ),
          const SizedBox(width: AppSpacing.x3),
          _SideButton(
            id: 'short',
            label: 'Short',
            icon: Icons.trending_down_rounded,
            color: AppColors.text3,
            active: side == 'short',
            onTap: () => onChanged('short'),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = active ? color : AppColors.text3;
    return Expanded(
      child: VitCard(
        key: MarginTradingPage.sideKey(id),
        onTap: onTap,
        alignment: Alignment.center,
        variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
        borderColor: active
            ? color.withValues(alpha: .35)
            : AppColors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: resolvedColor, size: AppSpacing.inputPrefixIcon),
            const SizedBox(width: AppSpacing.transferTileGap),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: resolvedColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeverageSelector extends StatelessWidget {
  const _LeverageSelector({
    required this.leverage,
    required this.expanded,
    required this.onTap,
  });

  final int leverage;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: AppSpacing.zeroInsets,
      child: InkWell(
        key: MarginTradingPage.leverageKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: AppSpacing.zeroInsets.copyWith(
            left: AppSpacing.walletAssetSectionGap,
            top: AppSpacing.x4,
            right: AppSpacing.walletAssetSectionGap,
            bottom: AppSpacing.x4,
          ),
          child: Row(
            children: [
              const _MarginIconSurface(
                icon: Icons.tune_rounded,
                color: _marginAmber,
                size: AppSpacing.buttonCompact,
                iconSize: AppSpacing.inputPrefixIcon,
              ),
              const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đòn bẩy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.hairlineStroke * 2),
                    Text(
                      'Nhân ${leverage}x giá trị vị thế',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _MiniBadge(
                label: '${leverage}x',
                color: _marginAmber,
                large: true,
              ),
              const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: AppSpacing.inputPrefixIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSheet extends StatelessWidget {
  const _LeverageSheet({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [2, 3, 5, 10, 20, 50];
    return _Panel(
      color: AppColors.surface2,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        top: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
        bottom: AppSpacing.rowPy,
      ),
      child: Wrap(
        spacing: AppSpacing.x3,
        runSpacing: AppSpacing.x3,
        children: [
          for (final option in options)
            SizedBox(
              width: AppSpacing.x7,
              child: VitStatusPill(
                label: '${option}x',
                status: selected == option
                    ? VitStatusPillStatus.info
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.lg,
                onTap: () => onChanged(option),
              ),
            ),
        ],
      ),
    );
  }
}
