part of 'advanced_charts_page.dart';

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
