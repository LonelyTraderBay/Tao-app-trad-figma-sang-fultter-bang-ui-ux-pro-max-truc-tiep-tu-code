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
      padding: AppSpacing.predictionHomeCategoryPadding,
    );
  }
}
