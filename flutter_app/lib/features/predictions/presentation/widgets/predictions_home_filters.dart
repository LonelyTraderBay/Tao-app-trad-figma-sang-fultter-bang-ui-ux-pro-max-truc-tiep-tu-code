part of '../pages/predictions_home_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      key: PredictionsHomePage.searchFieldKey,
      controller: controller,
      placeholder: 'Tìm sự kiện...',
      onChanged: onChanged,
      onClear: onClear,
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.active, required this.onSelected});

  final PredictionFilterTab active;
  final ValueChanged<PredictionFilterTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: VitTabBar(
        variant: VitTabBarVariant.pill,
        activeKey: active.name,
        onChanged: (key) => onSelected(PredictionFilterTab.values.byName(key)),
        tabs: const [
          VitTabItem(
            key: 'trending',
            label: 'Xu hướng',
            icon: Icons.trending_up_outlined,
            widgetKey: PredictionsHomePage.trendingFilterKey,
          ),
          VitTabItem(
            key: 'newEvents',
            label: 'Mới',
            icon: Icons.fiber_new_outlined,
            widgetKey: PredictionsHomePage.newFilterKey,
          ),
          VitTabItem(
            key: 'popular',
            label: 'Phổ biến',
            icon: Icons.group_outlined,
            widgetKey: Key('sc027_filter_popular'),
          ),
          VitTabItem(
            key: 'liquid',
            label: 'Thanh khoản',
            icon: Icons.bar_chart_outlined,
            widgetKey: Key('sc027_filter_liquid'),
          ),
          VitTabItem(
            key: 'ending',
            label: 'Sắp đóng',
            icon: Icons.schedule_outlined,
            widgetKey: Key('sc027_filter_ending'),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            key: PredictionsHomePage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.x2),
          for (var index = 0; index < categories.length; index += 1) ...[
            _CategoryChip(
              key: categories[index] == 'Live Crypto'
                  ? PredictionsHomePage.categoryLiveCryptoKey
                  : Key('sc027_category_${categories[index]}'),
              label: categories[index],
              active: activeCategory == categories[index],
              onTap: () => onSelected(
                activeCategory == categories[index] ? null : categories[index],
              ),
            ),
            if (index != categories.length - 1)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
      accentColor: _marketPrimary,
      height: VitDensity.compact.controlHeight - AppSpacing.x3,
      padding: AppSpacing.predictionHomeCategoryPadding,
    );
  }
}
