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
    return VitSearchBar(
      key: PredictionsSearchPage.searchFieldKey,
      controller: controller,
      placeholder: 'Search by title, tag, category...',
      autofocus: true,
      filterKey: PredictionsSearchPage.filtersToggleKey,
      filterActive: showFilters,
      filterInline: true,
      onChanged: (_) => onChanged(),
      onClear: onClear,
      onFilterTap: onToggleFilters,
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
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterLabel('Sort by'),
          const SizedBox(height: AppSpacing.x1),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
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
          const SizedBox(height: AppSpacing.x3),
          _FilterLabel('Event Status'),
          const SizedBox(height: AppSpacing.x1),
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
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _StatusChip(
                  key: PredictionsSearchPage.statusResolvedKey,
                  label: 'Resolved',
                  active: status == PredictionStatusFilter.resolved,
                  onTap: () =>
                      onStatusSelected(PredictionStatusFilter.resolved),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x3),
          _FilterLabel('Category'),
          const SizedBox(height: AppSpacing.x1),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
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
            const SizedBox(height: AppSpacing.x3),
            VitCard(
              key: PredictionsSearchPage.clearFiltersKey,
              onTap: onClear,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.sm,
              height: VitDensity.compact.controlHeight,
              padding: AppSpacing.zeroInsets,
              clip: true,
              borderColor: AppColors.sell20,
              background: const ColoredBox(color: AppColors.sell10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.close_rounded,
                    color: AppColors.sell,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
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
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      height: VitDensity.compact.controlHeight,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
      leading: Icon(icon),
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
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      height: VitDensity.compact.controlHeight,
    );
  }
}
