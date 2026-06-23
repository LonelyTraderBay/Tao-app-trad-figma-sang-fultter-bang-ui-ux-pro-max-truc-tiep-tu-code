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
      placeholder: 'Search events...',
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
    final tabs = [
      _FilterTabMeta(
        PredictionFilterTab.trending,
        'Trending',
        Icons.local_fire_department_outlined,
        PredictionsHomePage.trendingFilterKey,
      ),
      _FilterTabMeta(
        PredictionFilterTab.newEvents,
        'New',
        Icons.auto_awesome_rounded,
        PredictionsHomePage.newFilterKey,
      ),
      _FilterTabMeta(
        PredictionFilterTab.popular,
        'Popular',
        Icons.group_outlined,
        const Key('sc027_filter_popular'),
      ),
      _FilterTabMeta(
        PredictionFilterTab.liquid,
        'Liquid',
        Icons.bar_chart_rounded,
        const Key('sc027_filter_liquid'),
      ),
      _FilterTabMeta(
        PredictionFilterTab.ending,
        'Ending Soon',
        Icons.schedule_rounded,
        const Key('sc027_filter_ending'),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _FilterTabButton(
              key: tabs[index].key,
              meta: tabs[index],
              active: active == tabs[index].filter,
              onTap: () => onSelected(tabs[index].filter),
            ),
            if (index != tabs.length - 1) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

final class _FilterTabMeta {
  const _FilterTabMeta(this.filter, this.label, this.icon, this.key);

  final PredictionFilterTab filter;
  final String label;
  final IconData icon;
  final Key key;
}

class _FilterTabButton extends StatelessWidget {
  const _FilterTabButton({
    super.key,
    required this.meta,
    required this.active,
    required this.onTap,
  });

  final _FilterTabMeta meta;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: meta.label,
      selected: active,
      onTap: onTap,
      accentColor: _marketPrimary,
      height: VitDensity.compact.controlHeight - AppSpacing.x2,
      padding: AppSpacing.predictionHomeFilterPadding,
      leading: Icon(meta.icon, size: AppSpacing.predictionHomeFilterIcon),
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
            label: 'All',
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
