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

class AdvancedChartsPage extends ConsumerStatefulWidget {
  const AdvancedChartsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc023_advanced_charts_scroll_content');
  static const indicatorsTabKey = Key('sc023_tab_indicators');
  static const drawingTabKey = Key('sc023_tab_drawing');
  static const signalsTabKey = Key('sc023_tab_signals');
  static const clearAllKey = Key('sc023_clear_all');
  static const categoryAllKey = Key('sc023_category_all');
  static const categoryTrendKey = Key('sc023_category_trend');
  static const drawingLineKey = Key('sc023_drawing_category_line');

  static Key indicatorKey(String id) => Key('sc023_indicator_$id');
  static Key indicatorToggleKey(String id) => Key('sc023_indicator_toggle_$id');
  static Key drawingToolKey(String id) => Key('sc023_drawing_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedChartsPage> createState() => _AdvancedChartsPageState();
}

class _AdvancedChartsPageState extends ConsumerState<AdvancedChartsPage> {
  String _tab = 'indicators';
  String _indicatorCategory = 'all';
  String _drawingCategory = 'all';
  final Set<String> _activeIndicatorIds = {'sma', 'rsi'};
  String? _expandedIndicatorId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getAdvancedCharts(
          indicatorCategory: _indicatorCategory,
          drawingCategory: _drawingCategory,
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
      semanticLabel: 'SC-023 AdvancedChartsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích kỹ thuật',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _AdvancedChartsTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: AdvancedChartsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 12,
                    children: [
                      if (_tab == 'indicators') ...[
                        _ActiveIndicatorSummary(
                          activeCount: _activeIndicatorIds.length,
                          onClearAll: _activeIndicatorIds.isEmpty
                              ? null
                              : () => setState(_activeIndicatorIds.clear),
                        ),
                        if (_activeIndicatorIds.isNotEmpty)
                          _ActiveIndicatorChips(
                            indicators: _activeIndicators(snapshot),
                            onRemove: _toggleIndicator,
                          ),
                        _IndicatorCategoryFilter(
                          categories: snapshot.indicatorCategories,
                          activeCategory: _indicatorCategory,
                          onSelected: (value) => setState(() {
                            _indicatorCategory = value;
                          }),
                        ),
                        _IndicatorList(
                          indicators: snapshot.indicators,
                          categories: snapshot.indicatorCategories,
                          activeIndicatorIds: _activeIndicatorIds,
                          expandedIndicatorId: _expandedIndicatorId,
                          onToggleActive: _toggleIndicator,
                          onToggleExpanded: (indicator) => setState(() {
                            _expandedIndicatorId =
                                _expandedIndicatorId == indicator.id
                                ? null
                                : indicator.id;
                          }),
                        ),
                      ] else if (_tab == 'drawing') ...[
                        const _DrawingInfoCard(),
                        _DrawingCategoryFilter(
                          categories: snapshot.drawingCategories,
                          activeCategory: _drawingCategory,
                          onSelected: (value) => setState(() {
                            _drawingCategory = value;
                          }),
                        ),
                        _DrawingToolsGrid(
                          tools: snapshot.drawingTools,
                          categories: snapshot.drawingCategories,
                        ),
                        const _SectionHeader(
                          label: 'Mẹo sử dụng',
                          accentColor: AppColors.warn,
                        ),
                        const _TipsCard(),
                      ] else ...[
                        const _SignalDisclaimerCard(),
                        for (final signal in snapshot.signalSummaries)
                          _SignalSummaryCard(signal: signal),
                      ],
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

  List<TechnicalIndicator> _activeIndicators(
    MarketAdvancedChartsSnapshot snapshot,
  ) {
    final all = ref.watch(marketRepositoryProvider).getAdvancedCharts();
    return [
      for (final id in _activeIndicatorIds)
        all.indicators.firstWhere(
          (indicator) => indicator.id == id,
          orElse: () => snapshot.indicators.first,
        ),
    ];
  }

  void _toggleIndicator(String id) {
    setState(() {
      if (_activeIndicatorIds.contains(id)) {
        _activeIndicatorIds.remove(id);
      } else {
        _activeIndicatorIds.add(id);
      }
    });
  }
}

class _AdvancedChartsTabs extends StatelessWidget {
  const _AdvancedChartsTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: AdvancedChartsPage.indicatorsTabKey,
              label: 'Chỉ báo',
              value: 'indicators',
              active: activeTab == 'indicators',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: AdvancedChartsPage.drawingTabKey,
              label: 'Công cụ vẽ',
              value: 'drawing',
              active: activeTab == 'drawing',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: AdvancedChartsPage.signalsTabKey,
              label: 'Tín hiệu kỹ thuật',
              value: 'signals',
              active: activeTab == 'signals',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveIndicatorSummary extends StatelessWidget {
  const _ActiveIndicatorSummary({
    required this.activeCount,
    required this.onClearAll,
  });

  final int activeCount;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Đang sử dụng: $activeCount chỉ báo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
        if (onClearAll != null)
          TextButton(
            key: AdvancedChartsPage.clearAllKey,
            onPressed: onClearAll,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Xóa tất cả',
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
      ],
    );
  }
}

class _ActiveIndicatorChips extends StatelessWidget {
  const _ActiveIndicatorChips({
    required this.indicators,
    required this.onRemove,
  });

  final List<TechnicalIndicator> indicators;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final indicator in indicators)
          DecoratedBox(
            decoration: BoxDecoration(
              color: indicator.color.withValues(alpha: .08),
              border: Border.all(color: indicator.color.withValues(alpha: .22)),
              borderRadius: AppRadii.smRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    indicator.shortName,
                    style: AppTextStyles.micro.copyWith(
                      color: indicator.color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => onRemove(indicator.id),
                    child: Icon(
                      Icons.close_rounded,
                      size: 12,
                      color: indicator.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _IndicatorCategoryFilter extends StatelessWidget {
  const _IndicatorCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            key: AdvancedChartsPage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
          ),
          const SizedBox(width: 8),
          for (final category in categories) ...[
            _FilterChipButton(
              key: category.id == 'trend'
                  ? AdvancedChartsPage.categoryTrendKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: category.color,
              onTap: () => onSelected(category.id),
            ),
            if (category != categories.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _DrawingCategoryFilter extends StatelessWidget {
  const _DrawingCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
          ),
          const SizedBox(width: 8),
          for (final category in categories) ...[
            _FilterChipButton(
              key: category.id == 'line'
                  ? AdvancedChartsPage.drawingLineKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: _marketPrimary,
              onTap: () => onSelected(category.id),
            ),
            if (category != categories.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .28) : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    super.key,
    required this.indicator,
    required this.category,
    required this.active,
    required this.expanded,
    required this.onToggleActive,
    required this.onToggleExpanded,
  });

  final TechnicalIndicator indicator;
  final AdvancedChartCategory? category;
  final bool active;
  final bool expanded;
  final VoidCallback onToggleActive;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: indicator.color.withValues(alpha: .08),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      indicator.shortName.length <= 3
                          ? indicator.shortName
                          : indicator.shortName.substring(0, 3),
                      style: AppTextStyles.micro.copyWith(
                        color: indicator.color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              indicator.shortName,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _CategoryBadge(category: category),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          indicator.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _IndicatorToggle(
                    key: AdvancedChartsPage.indicatorToggleKey(indicator.id),
                    active: active,
                    color: indicator.color,
                    onTap: onToggleActive,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) _IndicatorDetails(indicator: indicator),
        ],
      ),
    );
  }
}

class _IndicatorList extends StatelessWidget {
  const _IndicatorList({
    required this.indicators,
    required this.categories,
    required this.activeIndicatorIds,
    required this.expandedIndicatorId,
    required this.onToggleActive,
    required this.onToggleExpanded,
  });

  final List<TechnicalIndicator> indicators;
  final List<AdvancedChartCategory> categories;
  final Set<String> activeIndicatorIds;
  final String? expandedIndicatorId;
  final ValueChanged<String> onToggleActive;
  final ValueChanged<TechnicalIndicator> onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final indicator in indicators) ...[
          _IndicatorCard(
            key: AdvancedChartsPage.indicatorKey(indicator.id),
            indicator: indicator,
            category: _categoryFor(categories, indicator.categoryId),
            active: activeIndicatorIds.contains(indicator.id),
            expanded: expandedIndicatorId == indicator.id,
            onToggleActive: () => onToggleActive(indicator.id),
            onToggleExpanded: () => onToggleExpanded(indicator),
          ),
          if (indicator != indicators.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final AdvancedChartCategory? category;

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? AppColors.text3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        category?.label ?? 'Khác',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 8,
          height: 1.2,
        ),
      ),
    );
  }
}

class _IndicatorToggle extends StatelessWidget {
  const _IndicatorToggle({
    super.key,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .08) : AppColors.surface2,
          border: Border.all(color: active ? color : AppColors.borderSolid),
          borderRadius: AppRadii.smRadius,
        ),
        child: active
            ? Icon(Icons.check_rounded, size: 16, color: color)
            : Text(
                '+',
                style: AppTextStyles.body.copyWith(color: AppColors.text3),
              ),
      ),
    );
  }
}

class _IndicatorDetails extends StatelessWidget {
  const _IndicatorDetails({required this.indicator});

  final TechnicalIndicator indicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            indicator.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (indicator.params.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final param in indicator.params)
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.micro,
                          children: [
                            TextSpan(
                              text: '${param.label}: ',
                              style: const TextStyle(color: AppColors.text3),
                            ),
                            TextSpan(
                              text: '${param.value}',
                              style: const TextStyle(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DrawingInfoCard extends StatelessWidget {
  const _DrawingInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .15),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.edit_rounded, size: 17, color: _marketPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bộ công cụ vẽ chuyên nghiệp',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Chọn công cụ bên dưới để vẽ trên biểu đồ. Hỗ trợ đường xu hướng, kênh giá, Fibonacci và đo lường.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawingToolsGrid extends StatelessWidget {
  const _DrawingToolsGrid({required this.tools, required this.categories});

  final List<AdvancedDrawingTool> tools;
  final List<AdvancedChartCategory> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: .92,
      children: [
        for (final tool in tools)
          VitCard(
            key: AdvancedChartsPage.drawingToolKey(tool.id),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tool.icon, size: 25, color: AppColors.text1),
                const SizedBox(height: 7),
                Text(
                  tool.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _categoryFor(categories, tool.categoryId)?.label ?? '',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  static const _tips = [
    (Icons.timeline_rounded, 'Nhấn giữ để vẽ đường xu hướng trên chart'),
    (Icons.format_list_numbered_rounded, 'Double-tap để đặt điểm Fibonacci'),
    (Icons.zoom_in_rounded, 'Kéo 2 ngón để zoom in/out biểu đồ'),
    (Icons.swipe_rounded, 'Vuốt ngang để di chuyển timeline'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var index = 0; index < _tips.length; index += 1) ...[
            Row(
              children: [
                Icon(_tips[index].$1, size: 18, color: AppColors.text2),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _tips[index].$2,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (index != _tips.length - 1) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }
}

class _SignalDisclaimerCard extends StatelessWidget {
  const _SignalDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn.withValues(alpha: .16),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.warn,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tín hiệu kỹ thuật chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalSummaryCard extends StatelessWidget {
  const _SignalSummaryCard({required this.signal});

  final TechSignalSummaryDraft signal;

  @override
  Widget build(BuildContext context) {
    final signalMeta = _signalMeta(signal.overallSignal);
    final maMeta = _signalMeta(signal.maSummary);
    final oscMeta = _signalMeta(signal.oscSummary);

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: AppRadii.xsRadius,
                      ),
                      child: Text(
                        signal.timeframe,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _SignalPill(meta: signalMeta),
            ],
          ),
          const SizedBox(height: 13),
          _SignalBar(signal: signal),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SignalMetricCard(
                  label: 'Moving Averages',
                  meta: maMeta,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SignalMetricCard(label: 'Oscillators', meta: oscMeta),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Pivot Points',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 7),
          _PivotPoints(points: signal.pivotPoints),
        ],
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({required this.meta});

  final _SignalMeta meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: .08),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        meta.label,
        style: AppTextStyles.caption.copyWith(
          color: meta.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.signal});

  final TechSignalSummaryDraft signal;

  @override
  Widget build(BuildContext context) {
    final total = signal.buyCount + signal.sellCount + signal.neutralCount;
    return Column(
      children: [
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Expanded(
                  flex: signal.buyCount,
                  child: const ColoredBox(color: AppColors.buy),
                ),
                Expanded(
                  flex: signal.neutralCount,
                  child: const ColoredBox(color: AppColors.text3),
                ),
                Expanded(
                  flex: signal.sellCount,
                  child: const ColoredBox(color: AppColors.sell),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CountText(
              label: 'Mua',
              count: signal.buyCount,
              color: AppColors.buy,
            ),
            Text(
              'Trung lập ${signal.neutralCount}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _CountText(
              label: 'Bán',
              count: signal.sellCount,
              color: AppColors.sell,
            ),
          ],
        ),
        Semantics(label: 'Tổng tín hiệu $total'),
      ],
    );
  }
}

class _CountText extends StatelessWidget {
  const _CountText({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label $count',
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _SignalMetricCard extends StatelessWidget {
  const _SignalMetricCard({required this.label, required this.meta});

  final String label;
  final _SignalMeta meta;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: 2),
            Text(
              meta.label,
              style: AppTextStyles.caption.copyWith(
                color: meta.color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PivotPoints extends StatelessWidget {
  const _PivotPoints({required this.points});

  final List<TechPivotPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final point in points) ...[
          Expanded(child: _PivotPointCell(point: point)),
          if (point != points.last) const SizedBox(width: 2),
        ],
      ],
    );
  }
}

class _PivotPointCell extends StatelessWidget {
  const _PivotPointCell({required this.point});

  final TechPivotPointDraft point;

  @override
  Widget build(BuildContext context) {
    final isPivot = point.label == 'Pivot';
    final isSupport = point.label.startsWith('S');
    final color = isPivot
        ? _marketPrimary
        : isSupport
        ? AppColors.buy
        : AppColors.sell;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isPivot ? color.withValues(alpha: .08) : Colors.transparent,
        border: isPivot
            ? Border.all(color: color.withValues(alpha: .20))
            : null,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Column(
        children: [
          Text(
            point.label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontSize: 8,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatPrice(point.value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 8,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

AdvancedChartCategory? _categoryFor(
  List<AdvancedChartCategory> categories,
  String id,
) {
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
}

_SignalMeta _signalMeta(TechSignal signal) {
  return switch (signal) {
    TechSignal.strongBuy => const _SignalMeta('Mua mạnh', Color(0xFF059669)),
    TechSignal.buy => const _SignalMeta('Mua', AppColors.buy),
    TechSignal.neutral => const _SignalMeta('Trung lập', AppColors.text3),
    TechSignal.sell => const _SignalMeta('Bán', AppColors.sell),
    TechSignal.strongSell => const _SignalMeta('Bán mạnh', Color(0xFFDC2626)),
  };
}

final class _SignalMeta {
  const _SignalMeta(this.label, this.color);

  final String label;
  final Color color;
}

String _formatPrice(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return '\$${buffer.toString()}';
}
