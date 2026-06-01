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
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
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
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
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
            _FilterChip(
              item: item,
              active: item.filter == active,
              onTap: () => onChanged(item.filter),
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final ReferralFilterDraft item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ReferralHistoryPage.filterKey(item.filter),
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary40 : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          '${item.label} (${item.count})',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.primary : AppColors.text2,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
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
          const Icon(Icons.swap_vert_rounded, color: AppColors.text3, size: 15),
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
    return InkWell(
      key: ReferralHistoryPage.sortOptionKey(option.sort),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          option.label,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.primary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}
