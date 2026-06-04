part of '../pages/p2p_blacklist_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot, required this.entries});

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    final counts = _reasonCounts(entries);
    return VitCard(
      key: P2PBlacklistPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _ReasonIconBubble(
                icon: Icons.person_remove_alt_1_outlined,
                color: AppColors.sell,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entries.length} người dùng',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${entries.where((item) => item.recent30d).length} chặn trong 30 ngày qua',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final reason in snapshot.reasons)
                if ((counts[reason.id] ?? 0) > 0)
                  _ReasonCountPill(
                    reason: reason,
                    count: counts[reason.id] ?? 0,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.snapshot,
    required this.entries,
    required this.activeId,
    required this.onChanged,
  });

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final counts = _reasonCounts(entries);
    final filters = [
      P2PBlacklistReasonDraft(
        id: 'all',
        label: 'Tất cả (${entries.length})',
        iconKey: 'info',
        toneKey: 'primary',
      ),
      ...snapshot.reasons
          .where((reason) => (counts[reason.id] ?? 0) > 0)
          .map(
            (reason) => P2PBlacklistReasonDraft(
              id: reason.id,
              label: '${reason.label} (${counts[reason.id]})',
              iconKey: reason.iconKey,
              toneKey: reason.toneKey,
            ),
          ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              filter: filter,
              selected: filter.id == activeId,
              onTap: () => onChanged(filter.id),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final P2PBlacklistReasonDraft filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = filter.id == 'all' ? AppColors.primary : _reasonColor(filter);
    return Material(
      key: P2PBlacklistPage.filterKey(filter.id),
      color: selected ? color.withValues(alpha: .14) : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: .42)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            filter.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? color : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
