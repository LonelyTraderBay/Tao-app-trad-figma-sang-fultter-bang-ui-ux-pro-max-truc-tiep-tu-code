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
          if (target != targets.last) const SizedBox(width: _dustTinyGap),
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
    return Semantics(
      button: true,
      selected: selected,
      label: '${target.symbol} conversion target',
      child: VitCard(
        key: DustConverterPage.targetKey(target.symbol),
        onTap: onTap,
        density: VitDensity.compact,
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
              size: _dustTokenLogo,
            ),
            const SizedBox(width: _dustInlineGap),
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
                  const SizedBox(height: _dustTinyGap),
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
              const VitStatusPill(
                label: 'Ch\u1ECDn',
                icon: Icons.check_circle_outline,
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
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
    return Semantics(
      button: true,
      selected: selectedAll && totalCount > 0,
      value: '$selectedCount of $totalCount selected',
      child: VitCard(
        key: DustConverterPage.selectAllKey,
        onTap: onTap,
        density: VitDensity.compact,
        variant: VitCardVariant.inner,
        child: Row(
          children: [
            Icon(
              selectedAll && totalCount > 0
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selectedCount > 0 ? AppColors.primary : _dustMuted,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: _dustInlineGap),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitStatusPill(
              label: '$selectedCount/$totalCount',
              status: selectedCount > 0
                  ? VitStatusPillStatus.info
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}
