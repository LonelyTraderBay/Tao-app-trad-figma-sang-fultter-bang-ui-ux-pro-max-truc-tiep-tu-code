part of '../pages/margin_trading_page.dart';

class _SideToggle extends StatelessWidget {
  const _SideToggle({required this.side, required this.onChanged});

  final String side;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<String>(
      selected: side,
      onChanged: onChanged,
      options: [
        VitSegmentedChoiceOption(
          key: MarginTradingPage.sideKey('long'),
          value: 'long',
          label: 'Long',
          accentColor: AppColors.buy,
          leading: const Icon(Icons.trending_up_rounded),
          semanticLabel: 'Chon huong Long margin',
        ),
        VitSegmentedChoiceOption(
          key: MarginTradingPage.sideKey('short'),
          value: 'short',
          label: 'Short',
          accentColor: AppColors.sell,
          leading: const Icon(Icons.trending_down_rounded),
          semanticLabel: 'Chon huong Short margin',
        ),
      ],
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
      key: MarginTradingPage.leverageKey,
      onTap: onTap,
      padding: AppSpacing.zeroInsets,
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
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            _MiniBadge(label: '${leverage}x', color: _marginAmber, large: true),
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
