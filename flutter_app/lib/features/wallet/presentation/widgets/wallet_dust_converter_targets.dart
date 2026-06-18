part of '../pages/dust_converter_page.dart';

class _TargetSelector extends StatelessWidget {
  const _TargetSelector({
    required this.targets,
    required this.selected,
    required this.onSelected,
  });

  final List<WalletDustTarget> targets;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final target in targets) ...[
          Expanded(
            child: _TargetCard(
              target: target,
              selected: target.symbol == selected,
              onTap: () => onSelected(target.symbol),
            ),
          ),
          if (target != targets.last)
            const SizedBox(width: AppSpacing.walletDustTargetGap),
        ],
      ],
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.target,
    required this.selected,
    required this.onTap,
  });

  final WalletDustTarget target;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(target.colorHex);
    return GestureDetector(
      key: DustConverterPage.targetKey(target.symbol),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: VitCard(
        height: AppSpacing.walletDustTargetHeight,
        padding: AppSpacing.walletDustTargetPadding,
        variant: VitCardVariant.ghost,
        borderColor: selected ? color.withValues(alpha: .7) : _dustBorder,
        background: ColoredBox(
          color: selected ? color.withValues(alpha: .11) : _dustPanel2,
        ),
        clip: true,
        child: Row(
          children: [
            _TokenLogo(
              symbol: target.symbol,
              color: color,
              size: AppSpacing.walletDustTokenLogo,
            ),
            const SizedBox(width: AppSpacing.walletDustTargetLogoGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletDustTargetTextGap),
                  Text(
                    target.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: _dustMuted),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_outline,
                color: _dustGreen,
                size: AppSpacing.walletDustCheckboxIcon,
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectAllRow extends StatelessWidget {
  const _SelectAllRow({
    required this.selectedAll,
    required this.selectedCount,
    required this.totalCount,
    required this.onTap,
  });

  final bool selectedAll;
  final int selectedCount;
  final int totalCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = selectedAll && totalCount > 0
        ? 'B\u1ECF ch\u1ECDn t\u1EA5t c\u1EA3'
        : 'Ch\u1ECDn t\u1EA5t c\u1EA3';
    return GestureDetector(
      key: DustConverterPage.selectAllKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: VitCard(
        height: AppSpacing.walletDustSelectAllHeight,
        padding: AppSpacing.walletDustSelectAllPadding,
        variant: VitCardVariant.inner,
        child: Row(
          children: [
            Icon(
              selectedAll && totalCount > 0
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selectedCount > 0 ? _dustPrimary : _dustMuted,
              size: AppSpacing.walletDustSelectAllIcon,
            ),
            const SizedBox(width: AppSpacing.walletDustSelectAllGap),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
