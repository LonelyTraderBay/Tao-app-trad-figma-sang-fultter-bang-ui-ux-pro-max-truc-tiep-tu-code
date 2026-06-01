part of '../pages/announcements_page.dart';

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.activeFilterId,
    required this.onChanged,
  });

  final List<AnnouncementFilterDraft> filters;
  final String activeFilterId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: AnnouncementsPage.filtersKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        AppSpacing.x1,
      ),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              filter: filter,
              selected: filter.id == activeFilterId,
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
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

  final AnnouncementFilterDraft filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: AnnouncementsPage.filterKey(filter.id),
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary12 : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary40 : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          filter.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.primary : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
