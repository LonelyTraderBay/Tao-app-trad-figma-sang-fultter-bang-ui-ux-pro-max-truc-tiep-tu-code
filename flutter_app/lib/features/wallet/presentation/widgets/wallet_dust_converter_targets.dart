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
    return VitSegmentedChoice.withPrimaryAccent<String>(
      selected: selected,
      onChanged: onSelected,
      height: AppSpacing.buttonCompact,
      options: [
        for (final target in targets)
          VitSegmentedChoiceOption<String>(
            key: DustConverterPage.targetKey(target.symbol),
            value: target.symbol,
            label: target.symbol,
          ),
      ],
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

class _DustAssetList extends StatelessWidget {
  const _DustAssetList({
    required this.assets,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<WalletDustAsset> assets;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++) ...[
            _DustAssetRow(
              asset: assets[i],
              selected: selectedIds.contains(assets[i].id),
              onTap: () => onToggle(assets[i].id),
            ),
            if (i < assets.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}
