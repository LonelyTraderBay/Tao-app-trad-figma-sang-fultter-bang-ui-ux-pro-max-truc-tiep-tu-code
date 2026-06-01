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
          if (target != targets.last) const SizedBox(width: 10),
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
      child: Container(
        height: AppSpacing.buttonStandard + AppSpacing.x2,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .11) : _dustPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? color.withValues(alpha: .7) : _dustBorder,
          ),
        ),
        child: Row(
          children: [
            _TokenLogo(symbol: target.symbol, color: color, size: 34),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    target.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _dustMuted,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_outline,
                color: _dustGreen,
                size: 18,
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
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _dustPanel2,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(
              selectedAll && totalCount > 0
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selectedCount > 0 ? _dustPrimary : _dustMuted,
              size: 17,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
