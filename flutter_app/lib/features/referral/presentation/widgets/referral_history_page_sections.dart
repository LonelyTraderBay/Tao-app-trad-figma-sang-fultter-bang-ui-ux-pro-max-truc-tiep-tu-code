part of '../pages/referral_history_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final ReferralStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ReferralHistoryPage.statsKey,
      children: [
        Expanded(
          child: _StatCard(
            value: stats.totalFriends,
            label: 'Tổng bạn bè',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            value: stats.kycCompleted,
            label: 'Đã KYC',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            value: stats.activeFriends,
            label: 'Hoạt động',
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: ReferralSpacingTokens.referralHeroMetricPadding,
        child: Column(
          children: [
            Text(
              '$value',
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferralFriendFilters extends StatelessWidget {
  const _ReferralFriendFilters({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralFilterDraft> filters;
  final ReferralFriendFilter active;
  final ValueChanged<ReferralFriendFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralHistoryPage.filtersKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in filters) ...[
            VitChoicePill(
              key: ReferralHistoryPage.filterKey(item.filter),
              label: '${item.label} (${item.count})',
              selected: item.filter == active,
              onTap: () => onChanged(item.filter),
              accentColor: AppColors.primary,
              height: ReferralSpacingTokens.referralHistoryFilterHeight,
              padding: ReferralSpacingTokens.referralFilterChipPadding,
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _SortRail extends StatelessWidget {
  const _SortRail({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralSortDraft> options;
  final ReferralHistorySort active;
  final ValueChanged<ReferralHistorySort> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralHistoryPage.sortKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(
            Icons.swap_vert_rounded,
            color: AppColors.text3,
            size: ReferralSpacingTokens.referralSortIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Sắp xếp:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          for (final option in options) ...[
            _SortChip(
              option: option,
              active: option.sort == active,
              onTap: () => onChanged(option.sort),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ReferralSortDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: ReferralHistoryPage.sortOptionKey(option.sort),
      label: option.label,
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      height: ReferralSpacingTokens.referralStepBox,
      padding: ReferralSpacingTokens.referralSortChipPadding,
    );
  }
}
