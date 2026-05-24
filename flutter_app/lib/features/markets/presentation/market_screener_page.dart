import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class MarketScreenerPage extends ConsumerStatefulWidget {
  const MarketScreenerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc015_market_screener_scroll_content');
  static const searchKey = Key('sc015_search');
  static const advancedFiltersKey = Key('sc015_advanced_filters');
  static const resetFiltersKey = Key('sc015_reset_filters');

  static Key presetKey(String id) => Key('sc015_preset_$id');

  static Key sortKey(MarketScreenerSort sort) => Key('sc015_sort_$sort');

  static Key rowKey(String id) => Key('sc015_row_$id');

  static Key categoryKey(String category) => Key('sc015_category_$category');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketScreenerPage> createState() => _MarketScreenerPageState();
}

class _MarketScreenerPageState extends ConsumerState<MarketScreenerPage> {
  final TextEditingController _searchController = TextEditingController();
  MarketScreenerQuery _query = MarketScreenerQuery.defaults;
  String? _activePresetId;
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters {
    return _activePresetId != null ||
        _query.categories.isNotEmpty ||
        _query.minPrice != null ||
        _query.maxPrice != null ||
        _query.minMarketCap != null ||
        _query.maxMarketCap != null ||
        _query.minVolume24h != null ||
        _query.maxVolume24h != null ||
        _query.minChange24h != null ||
        _query.maxChange24h != null ||
        _searchController.text.isNotEmpty;
  }

  void _applyPreset(MarketScreenerPreset preset) {
    setState(() {
      _activePresetId = preset.id;
      _query = preset.query.copyWith(searchQuery: _searchController.text);
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = MarketScreenerQuery.defaults;
      _activePresetId = null;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (category == 'Tất cả') {
        _query = _query.copyWith(categories: const []);
      } else {
        final categories = [..._query.categories];
        if (categories.contains(category)) {
          categories.remove(category);
        } else {
          categories.add(category);
        }
        _query = _query.copyWith(categories: categories);
      }
      _activePresetId = null;
    });
  }

  void _toggleSort(MarketScreenerSort sort) {
    setState(() {
      final direction =
          _query.sortBy == sort &&
              _query.sortDirection == MarketSortDirection.desc
          ? MarketSortDirection.asc
          : MarketSortDirection.desc;
      _query = _query.copyWith(sortBy: sort, sortDirection: direction);
      _activePresetId = null;
    });
  }

  void _updateRange({
    double? minPrice,
    double? maxPrice,
    double? minVolume24h,
    double? minChange24h,
    double? maxChange24h,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinVolume24h = false,
    bool clearMinChange24h = false,
    bool clearMaxChange24h = false,
  }) {
    setState(() {
      _query = _query.copyWith(
        minPrice: minPrice,
        maxPrice: maxPrice,
        minVolume24h: minVolume24h,
        minChange24h: minChange24h,
        maxChange24h: maxChange24h,
        clearMinPrice: clearMinPrice,
        clearMaxPrice: clearMaxPrice,
        clearMinVolume24h: clearMinVolume24h,
        clearMinChange24h: clearMinChange24h,
        clearMaxChange24h: clearMaxChange24h,
      );
      _activePresetId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseSnapshot = ref
        .watch(marketRepositoryProvider)
        .getMarketScreener();
    final appliedQuery = _query.copyWith(searchQuery: _searchController.text);
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getMarketScreener(query: appliedQuery);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-015 MarketScreenerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Bộ lọc thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketScreenerPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      VitSearchBar(
                        key: MarketScreenerPage.searchKey,
                        controller: _searchController,
                        placeholder: 'Tìm kiếm token...',
                        filterInline: true,
                        filterActive: _hasActiveFilters,
                        onChanged: (_) => setState(() {}),
                        onClear: () => setState(() {}),
                        onFilterTap: () {
                          setState(() => _showFilters = !_showFilters);
                        },
                      ),
                      _PresetScroller(
                        presets: baseSnapshot.presets,
                        activePresetId: _activePresetId,
                        onPresetSelected: _applyPreset,
                      ),
                      if (_showFilters)
                        _AdvancedFiltersCard(
                          query: _query,
                          categories: baseSnapshot.screenFilters.categories,
                          onCategorySelected: _toggleCategory,
                          onRangeChanged: _updateRange,
                          onReset: _resetFilters,
                        ),
                      _SortScroller(
                        query: _query,
                        resultCount: snapshot.marketPairs.length,
                        onSortSelected: _toggleSort,
                      ),
                      if (snapshot.marketPairs.isEmpty)
                        _ScreenerEmptyState(onReset: _resetFilters)
                      else
                        _ScreenerResults(
                          pairs: snapshot.marketPairs,
                          onPairTap: (pair) => context.go('/pair/${pair.id}'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetScroller extends StatelessWidget {
  const _PresetScroller({
    required this.presets,
    required this.activePresetId,
    required this.onPresetSelected,
  });

  final List<MarketScreenerPreset> presets;
  final String? activePresetId;
  final ValueChanged<MarketScreenerPreset> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: presets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final preset = presets[index];
          final active = preset.id == activePresetId;
          final chipWidth = switch (preset.id) {
            'high-volume' => 124.0,
            'gainers' => 116.0,
            'bargains' => 104.0,
            _ => 106.0,
          };
          return InkWell(
            key: MarketScreenerPage.presetKey(preset.id),
            onTap: () => onPresetSelected(preset),
            borderRadius: AppRadii.lgRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: chipWidth,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: active
                    ? _marketPrimary.withValues(alpha: .15)
                    : AppColors.surface3,
                border: Border.all(
                  color: active
                      ? _marketPrimary.withValues(alpha: .38)
                      : Colors.transparent,
                ),
                borderRadius: AppRadii.lgRadius,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      preset.icon,
                      size: 14,
                      color: active ? _marketPrimary : AppColors.text2,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      preset.name,
                      style: AppTextStyles.caption.copyWith(
                        color: active ? _marketPrimary : AppColors.text2,
                        fontSize: 13,
                        fontWeight: AppTextStyles.medium,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AdvancedFiltersCard extends StatelessWidget {
  const _AdvancedFiltersCard({
    required this.query,
    required this.categories,
    required this.onCategorySelected,
    required this.onRangeChanged,
    required this.onReset,
  });

  final MarketScreenerQuery query;
  final List<String> categories;
  final ValueChanged<String> onCategorySelected;
  final void Function({
    double? minPrice,
    double? maxPrice,
    double? minVolume24h,
    double? minChange24h,
    double? maxChange24h,
    bool clearMinPrice,
    bool clearMaxPrice,
    bool clearMinVolume24h,
    bool clearMinChange24h,
    bool clearMaxChange24h,
  })
  onRangeChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarketScreenerPage.advancedFiltersKey,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc nâng cao',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              TextButton.icon(
                key: MarketScreenerPage.resetFiltersKey,
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: const Text('Đặt lại'),
                style: TextButton.styleFrom(
                  foregroundColor: _marketPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Danh mục',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                _CategoryChip(
                  key: MarketScreenerPage.categoryKey(category),
                  label: category,
                  active: category == 'Tất cả'
                      ? query.categories.isEmpty
                      : query.categories.contains(category),
                  onTap: () => onCategorySelected(category),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RangeInput(
                  label: 'Giá min',
                  value: query.minPrice,
                  onChanged: (value, clear) =>
                      onRangeChanged(minPrice: value, clearMinPrice: clear),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RangeInput(
                  label: 'Giá max',
                  value: query.maxPrice,
                  onChanged: (value, clear) =>
                      onRangeChanged(maxPrice: value, clearMaxPrice: clear),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _RangeInput(
                  label: 'KL 24h min',
                  value: query.minVolume24h,
                  onChanged: (value, clear) => onRangeChanged(
                    minVolume24h: value,
                    clearMinVolume24h: clear,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RangeInput(
                  label: '% đổi min',
                  value: query.minChange24h,
                  onChanged: (value, clear) => onRangeChanged(
                    minChange24h: value,
                    clearMinChange24h: clear,
                  ),
                ),
              ),
            ],
          ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .36)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _RangeInput extends StatelessWidget {
  const _RangeInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double? value;
  final void Function(double? value, bool clear) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-${value ?? 'empty'}'),
      initialValue: value == null ? '' : value!.toStringAsFixed(0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (raw) {
        final normalized = raw.trim();
        if (normalized.isEmpty) {
          onChanged(null, true);
          return;
        }
        onChanged(double.tryParse(normalized), false);
      },
      cursorColor: _marketPrimary,
      style: AppTextStyles.caption.copyWith(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
        filled: true,
        fillColor: AppColors.surface2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderSolid),
          borderRadius: AppRadii.smRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _marketPrimary),
          borderRadius: AppRadii.smRadius,
        ),
      ),
    );
  }
}

class _SortScroller extends StatelessWidget {
  const _SortScroller({
    required this.query,
    required this.resultCount,
    required this.onSortSelected,
  });

  final MarketScreenerQuery query;
  final int resultCount;
  final ValueChanged<MarketScreenerSort> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final options = [
      (MarketScreenerSort.marketCap, 'Vốn hóa'),
      (MarketScreenerSort.volume, 'Khối lượng'),
      (MarketScreenerSort.change24h, 'Thay đổi 24h'),
      (MarketScreenerSort.price, 'Giá'),
    ];

    return SizedBox(
      height: 38,
      child: Row(
        children: [
          for (var index = 0; index < options.length; index++) ...[
            Expanded(
              flex: switch (options[index].$1) {
                MarketScreenerSort.marketCap => 18,
                MarketScreenerSort.volume => 24,
                MarketScreenerSort.change24h => 28,
                MarketScreenerSort.price => 13,
              },
              child: _SortChip(
                sort: options[index].$1,
                label: options[index].$2,
                active: query.sortBy == options[index].$1,
                direction: query.sortDirection,
                onTap: () => onSortSelected(options[index].$1),
              ),
            ),
            if (index != options.length - 1) const SizedBox(width: 4),
          ],
          const SizedBox(width: 6),
          SizedBox(
            width: 62,
            child: Text(
              '$resultCount kết quả',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.sort,
    required this.label,
    required this.active,
    required this.direction,
    required this.onTap,
  });

  final MarketScreenerSort sort;
  final String label;
  final bool active;
  final MarketSortDirection direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = direction == MarketSortDirection.desc
        ? Icons.keyboard_arrow_down_rounded
        : Icons.keyboard_arrow_up_rounded;

    return InkWell(
      key: MarketScreenerPage.sortKey(sort),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .10)
              : Colors.transparent,
          borderRadius: AppRadii.lgRadius,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? _marketPrimary : AppColors.text3,
                  fontSize: 12,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                  height: 1,
                ),
              ),
              if (active) ...[
                const SizedBox(width: 2),
                Icon(icon, color: _marketPrimary, size: 15),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenerResults extends StatelessWidget {
  const _ScreenerResults({required this.pairs, required this.onPairTap});

  final List<MarketPair> pairs;
  final ValueChanged<MarketPair> onPairTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < pairs.length; index++) ...[
          _ScreenerRow(
            pair: pairs[index],
            rank: index + 1,
            onTap: () => onPairTap(pairs[index]),
          ),
          if (index != pairs.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _ScreenerRow extends StatelessWidget {
  const _ScreenerRow({
    required this.pair,
    required this.rank,
    required this.onTap,
  });

  final MarketPair pair;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final up = pair.change24h >= 0;
    final color = up ? AppColors.buy : AppColors.sell;

    return InkWell(
      key: MarketScreenerPage.rowKey(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 62,
        padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _ScreenerAvatar(pair: pair),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.baseAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatCompactUsd(pair.marketCap),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 58,
              height: 24,
              child: CustomPaint(
                painter: _ScreenerSparklinePainter(
                  values: pair.sparklineData,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_formatPrice(pair.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            up
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: color,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${up ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontSize: 12,
                              fontWeight: AppTextStyles.medium,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenerAvatar extends StatelessWidget {
  const _ScreenerAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(0, pair.baseAsset.length < 2 ? 1 : 2),
        style: AppTextStyles.caption.copyWith(
          color: pair.logoColor,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ScreenerEmptyState extends StatelessWidget {
  const _ScreenerEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
      child: Column(
        children: [
          const Icon(
            Icons.filter_alt_off_rounded,
            color: AppColors.text3,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy kết quả phù hợp',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(foregroundColor: _marketPrimary),
            child: const Text('Đặt lại bộ lọc'),
          ),
        ],
      ),
    );
  }
}

class _ScreenerSparklinePainter extends CustomPainter {
  const _ScreenerSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final span = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();

    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final normalized = (values[i] - minValue) / span;
      final y = size.height - normalized * (size.height - 4) - 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final glowPaint = Paint()
      ..color = color.withValues(alpha: .14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScreenerSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000000) {
    return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
  }
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String _formatPrice(double value) {
  final fractionDigits = value >= 1000
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
