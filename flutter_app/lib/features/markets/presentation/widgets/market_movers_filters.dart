part of '../pages/market_movers_page.dart';

class _MoverTabs extends StatelessWidget {
  const _MoverTabs({
    required this.tabs,
    required this.activeTab,
    required this.onSelected,
  });

  final List<String> tabs;
  final String activeTab;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final tab in tabs) ...[
              _FilterChipButton(
                key: _tabKey(tab),
                label: tab,
                active: tab == activeTab,
                onTap: () => onSelected(tab),
              ),
              if (tab != tabs.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Key _tabKey(String tab) {
    return switch (tab) {
      'Giảm mạnh' => MarketMoversPage.losersTabKey,
      'Hoạt động' => MarketMoversPage.activeTabKey,
      'KL bất thường' => MarketMoversPage.unusualTabKey,
      'Mới niêm yết' => MarketMoversPage.newListingsTabKey,
      _ => MarketMoversPage.gainersTabKey,
    };
  }
}

class _TimeframeSelector extends StatelessWidget {
  const _TimeframeSelector({
    required this.timeframes,
    required this.activeTimeframe,
    required this.onSelected,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Khung thời gian:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: timeframes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final timeframe = timeframes[index];
                return _FilterChipButton(
                  key: timeframe == '24h'
                      ? MarketMoversPage.timeframe24hKey
                      : Key('sc010_timeframe_$timeframe'),
                  label: timeframe,
                  active: timeframe == activeTimeframe,
                  minHeight: 32,
                  onTap: () => onSelected(timeframe),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final String category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: MarketMoversPage.categoryDropdownKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Danh mục: $category',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final category in categories)
            _FilterChipButton(
              key: Key('sc010_category_$category'),
              label: category,
              active: category == activeCategory,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({
    required this.options,
    required this.activeSort,
    required this.onSelected,
  });

  final List<MarketSortOption> options;
  final String activeSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _FilterChipButton(
            key: _sortKey(option.id),
            label: option.label,
            active: option.id == activeSort,
            minHeight: 34,
            onTap: () => onSelected(option.id),
          ),
      ],
    );
  }

  Key _sortKey(String id) {
    return switch (id) {
      'volume' => MarketMoversPage.sortVolumeKey,
      'market_cap' => MarketMoversPage.sortMarketCapKey,
      _ => MarketMoversPage.sortChangeKey,
    };
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.count,
    required this.sortLabel,
    required this.timeframe,
  });

  final int count;
  final String sortLabel;
  final String timeframe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count kết quả',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.buy10,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            'LIVE',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            'Sắp xếp theo $sortLabel $timeframe',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.minHeight = 36,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? _marketPrimary.withValues(alpha: 0.18)
                : AppColors.surface2,
            border: Border.all(
              color: active
                  ? _marketPrimary.withValues(alpha: 0.55)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? _marketPrimary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
