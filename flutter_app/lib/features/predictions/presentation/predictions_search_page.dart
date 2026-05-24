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
import '../data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsSearchPage extends ConsumerStatefulWidget {
  const PredictionsSearchPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc028_predictions_search_content');
  static const searchFieldKey = Key('sc028_search_field');
  static const filtersToggleKey = Key('sc028_filters_toggle');
  static const sortTrendingKey = Key('sc028_sort_trending');
  static const sortLiquidityKey = Key('sc028_sort_liquidity');
  static const statusActiveKey = Key('sc028_status_active');
  static const statusResolvedKey = Key('sc028_status_resolved');
  static const statusAllKey = Key('sc028_status_all');
  static const categoryLiveCryptoKey = Key('sc028_category_live_crypto');
  static const clearFiltersKey = Key('sc028_clear_filters');

  static Key resultKey(String id) => Key('sc028_result_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsSearchPage> createState() =>
      _PredictionsSearchPageState();
}

class _PredictionsSearchPageState extends ConsumerState<PredictionsSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  PredictionSearchSort _sort = PredictionSearchSort.trending;
  PredictionStatusFilter _status = PredictionStatusFilter.active;
  String? _category;
  bool _showFilters = true;

  bool get _hasActiveFilters =>
      _sort != PredictionSearchSort.trending ||
      _status != PredictionStatusFilter.active ||
      _category != null ||
      _searchController.text.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getSearch(
          sort: _sort,
          status: _status,
          category: _category,
          searchQuery: _searchController.text,
        );
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
      semanticLabel: 'SC-028 PredictionsSearchPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Search Events',
              subtitle: 'Tìm kiếm · Prediction',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsSearchPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 14,
                    children: [
                      _SearchControl(
                        controller: _searchController,
                        showFilters: _showFilters,
                        onChanged: () => setState(() {}),
                        onClear: () => setState(_searchController.clear),
                        onToggleFilters: () => setState(() {
                          _showFilters = !_showFilters;
                        }),
                      ),
                      if (_showFilters)
                        _FilterPanel(
                          sort: _sort,
                          status: _status,
                          categories: snapshot.categories,
                          selectedCategory: _category,
                          hasActiveFilters: _hasActiveFilters,
                          onSortSelected: (value) => setState(() {
                            _sort = value;
                          }),
                          onStatusSelected: (value) => setState(() {
                            _status = value;
                          }),
                          onCategorySelected: (value) => setState(() {
                            _category = value;
                          }),
                          onClear: _clearFilters,
                        ),
                      Text(
                        _resultsLabel(snapshot.results.length),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                        ),
                      ),
                      if (snapshot.results.isEmpty)
                        const _SearchEmptyState()
                      else
                        for (final event in snapshot.results)
                          _SearchResultCard(
                            key: PredictionsSearchPage.resultKey(event.id),
                            event: event,
                            onTap: () => context.go(
                              AppRoutePaths.marketsPredictionEvent(event.id),
                            ),
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

  void _clearFilters() {
    setState(() {
      _sort = PredictionSearchSort.trending;
      _status = PredictionStatusFilter.active;
      _category = null;
      _searchController.clear();
    });
  }
}

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
                    : Colors.transparent,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .12)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .30)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _predictionPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isResolved = event.status == PredictionEventStatus.resolved;
    final chanceColor = isResolved
        ? AppColors.text3
        : topOutcome.chance >= 50
        ? AppColors.buy
        : AppColors.sell;
    final changeColor = event.change24h >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chanceColor.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              '${topOutcome.chance}%',
              style: AppTextStyles.body.copyWith(
                color: chanceColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(label: event.category),
                    if (isResolved) _TinyBadge(label: 'RESOLVED', muted: true),
                    _MetaText('Vol ${_formatVolume(event.volume24h)}'),
                    _MetaText(_timeRemaining(event.endDate)),
                    if (event.change24h != 0)
                      Text(
                        _formatPercent(event.change24h),
                        style: AppTextStyles.caption.copyWith(
                          color: changeColor,
                          fontSize: 16,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label, this.muted = false});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: muted
            ? AppColors.surface2
            : _predictionPrimary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: muted ? AppColors.text3 : _predictionPrimary,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 10),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.text3.withValues(alpha: .42),
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'No events match filters',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

String _resultsLabel(int count) {
  return '$count event${count == 1 ? '' : 's'} found';
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Ended';
  final days = diff.inDays;
  if (days > 30) return '${days ~/ 30} tháng';
  if (days > 0) return '$days ngày';
  return '${diff.inHours}h';
}
