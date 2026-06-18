part of '../pages/arena_points_ledger_page.dart';

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.summary});

  final ArenaPointsLedgerSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPointsLedgerCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số dư hiện tại',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${formatArenaPoints(summary.currentBalance)} pts',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          _BalanceDelta(
            value: '+${formatArenaPoints(summary.pointsEarned)}',
            label: 'Đã nhận',
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.x4),
          _BalanceDelta(
            value: '-${formatArenaPoints(summary.pointsSpent)}',
            label: 'Đã dùng',
            color: AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _BalanceDelta extends StatelessWidget {
  const _BalanceDelta({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<ArenaPointsLedgerFilterDraft> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterButton(
              filter: filter,
              active: filter.id == activeFilter,
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final ArenaPointsLedgerFilterDraft filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaPointsLedgerPage.filterKey(filter.id),
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonCompact,
          ),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: active ? AppColors.primary12 : AppColors.surface2,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
                side: BorderSide(
                  color: active ? AppColors.primary30 : AppColors.borderSolid,
                ),
              ),
            ),
            child: Padding(
              padding: AppSpacing.arenaPointsLedgerFilterPadding,
              child: Center(
                child: Text(
                  filter.label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.primary : AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: AppSpacing.arenaPointsCompactLineHeight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LedgerList extends StatelessWidget {
  const _LedgerList({required this.entries});

  final List<ArenaPointsLedgerEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _LedgerRow(entry: entries[i]),
            if (i < entries.length - 1)
              const Divider(
                height: AppSpacing.arenaPointsDividerHeight,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.entry});

  final ArenaPointsLedgerEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final color = _entryColor(entry.typeId);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaPointsLedgerPage.entryKey(entry.id),
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(AppRoutePaths.arenaLedgerEntry(entry.id));
        },
        child: Padding(
          padding: AppSpacing.arenaPointsLedgerRowPadding,
          child: Row(
            children: [
              _LedgerIcon(typeId: entry.typeId, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        _TypeBadge(label: entry.typeLabel, color: color),
                        const SizedBox(width: AppSpacing.x2),
                        Flexible(
                          child: Text(
                            entry.time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: AppSpacing.arenaPointsCompactLineHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _amountLabel(entry.amount),
                    style: AppTextStyles.caption.copyWith(
                      color: _amountColor(entry.amount),
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.arenaPointsCompactLineHeight,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.arenaPointsLedgerBalanceArrowIcon,
                      ),
                      const SizedBox(
                        width: AppSpacing.arenaPointsLedgerBalanceArrowGap,
                      ),
                      Text(
                        formatArenaPoints(entry.balanceAfter),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.arenaPointsCompactLineHeight,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LedgerIcon extends StatelessWidget {
  const _LedgerIcon({required this.typeId, required this.color});

  final String typeId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.arenaPointsLedgerIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: _entryTint(typeId),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(
            _entryIcon(typeId),
            color: color,
            size: AppSpacing.arenaPointsLedgerGlyph,
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.arenaPointsLedgerBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.arenaPointsCompactLineHeight,
          ),
        ),
      ),
    );
  }
}

class _AuditNotice extends StatelessWidget {
  const _AuditNotice({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPointsLedgerNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: AppSpacing.arenaPointsInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              disclaimer,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.arenaPointsNoticeLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
