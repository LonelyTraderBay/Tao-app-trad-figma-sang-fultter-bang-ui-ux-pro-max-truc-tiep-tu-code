part of '../pages/predictions_search_page.dart';

class _SearchControl extends StatelessWidget {
  const _SearchControl({
    required this.controller,
    required this.showFilters,
    required this.onChanged,
    required this.onClear,
    required this.onToggleFilters,
  });

  final TextEditingController controller;
  final bool showFilters;
  final VoidCallback onChanged;
  final VoidCallback onClear;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: PredictionsSearchPage.searchFieldKey,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder, width: 1.5),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.searchPlaceholder,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: (_) => onChanged(),
              style: AppTextStyles.base.copyWith(fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search by title, tag, category...',
                hintStyle: AppTextStyles.base.copyWith(
                  color: AppColors.searchPlaceholder,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              onTap: onClear,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.text3,
                size: 14,
              ),
            ),
          const SizedBox(width: 6),
          InkWell(
            key: PredictionsSearchPage.filtersToggleKey,
            onTap: onToggleFilters,
            borderRadius: AppRadii.smRadius,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: showFilters
                    ? _predictionPrimary.withValues(alpha: .16)
                    : AppColors.transparent,
                borderRadius: AppRadii.smRadius,
              ),
              child: Icon(
                Icons.tune_rounded,
                color: showFilters ? _predictionPrimary : AppColors.text3,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.sort,
    required this.status,
    required this.categories,
    required this.selectedCategory,
    required this.hasActiveFilters,
    required this.onSortSelected,
    required this.onStatusSelected,
    required this.onCategorySelected,
    required this.onClear,
  });

  final PredictionSearchSort sort;
  final PredictionStatusFilter status;
  final List<String> categories;
  final String? selectedCategory;
  final bool hasActiveFilters;
  final ValueChanged<PredictionSearchSort> onSortSelected;
  final ValueChanged<PredictionStatusFilter> onStatusSelected;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterLabel('Sort by'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SortChip(
                key: PredictionsSearchPage.sortTrendingKey,
                label: 'Trending',
                icon: Icons.trending_up_rounded,
                active: sort == PredictionSearchSort.trending,
                onTap: () => onSortSelected(PredictionSearchSort.trending),
              ),
              _SortChip(
                key: PredictionsSearchPage.sortLiquidityKey,
                label: 'Liquidity',
                icon: Icons.bar_chart_rounded,
                active: sort == PredictionSearchSort.liquidity,
                onTap: () => onSortSelected(PredictionSearchSort.liquidity),
              ),
              _SortChip(
                label: 'Volume',
                icon: Icons.bar_chart_rounded,
                active: sort == PredictionSearchSort.volume,
                onTap: () => onSortSelected(PredictionSearchSort.volume),
              ),
              _SortChip(
                label: 'Newest',
                icon: Icons.auto_awesome_rounded,
                active: sort == PredictionSearchSort.newest,
                onTap: () => onSortSelected(PredictionSearchSort.newest),
              ),
              _SortChip(
                label: 'Ending Soon',
                icon: Icons.schedule_rounded,
                active: sort == PredictionSearchSort.ending,
                onTap: () => onSortSelected(PredictionSearchSort.ending),
              ),
              _SortChip(
                label: 'Competitive',
                icon: Icons.track_changes_rounded,
                active: sort == PredictionSearchSort.competitive,
                onTap: () => onSortSelected(PredictionSearchSort.competitive),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterLabel('Event Status'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatusChip(
                  key: PredictionsSearchPage.statusActiveKey,
                  label: 'Active',
                  active: status == PredictionStatusFilter.active,
                  onTap: () => onStatusSelected(PredictionStatusFilter.active),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusChip(
                  key: PredictionsSearchPage.statusResolvedKey,
                  label: 'Resolved',
                  active: status == PredictionStatusFilter.resolved,
                  onTap: () =>
                      onStatusSelected(PredictionStatusFilter.resolved),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusChip(
                  key: PredictionsSearchPage.statusAllKey,
                  label: 'All',
                  active: status == PredictionStatusFilter.all,
                  onTap: () => onStatusSelected(PredictionStatusFilter.all),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterLabel('Category'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                _CategoryChip(
                  key: category == 'Live Crypto'
                      ? PredictionsSearchPage.categoryLiveCryptoKey
                      : Key('sc028_category_$category'),
                  label: category,
                  active: selectedCategory == category,
                  onTap: () => onCategorySelected(
                    selectedCategory == category ? null : category,
                  ),
                ),
            ],
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 14),
            InkWell(
              key: PredictionsSearchPage.clearFiltersKey,
              onTap: onClear,
              borderRadius: AppRadii.mdRadius,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sell.withValues(alpha: .10),
                  border: Border.all(
                    color: AppColors.sell.withValues(alpha: .18),
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.close_rounded,
                      color: AppColors.sell,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Clear all filters',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontSize: 11,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .36)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: active ? _predictionPrimary : AppColors.text3,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? _predictionPrimary : AppColors.text2,
                fontSize: 11,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .36)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _predictionPrimary : AppColors.text2,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}
