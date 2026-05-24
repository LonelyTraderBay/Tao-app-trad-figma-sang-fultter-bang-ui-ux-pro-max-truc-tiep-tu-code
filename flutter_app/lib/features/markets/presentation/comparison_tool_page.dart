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
const _comparePurple = Color(0xFF8B5CF6);
const _maxCompare = 4;

class ComparisonToolPage extends ConsumerStatefulWidget {
  const ComparisonToolPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc016_compare_scroll_content');
  static const addTokenKey = Key('sc016_add_token');
  static const pickerKey = Key('sc016_token_picker');
  static const pickerSearchKey = Key('sc016_picker_search');

  static Key tokenKey(String id) => Key('sc016_token_$id');

  static Key removeTokenKey(String id) => Key('sc016_remove_$id');

  static Key pickerTokenKey(String id) => Key('sc016_picker_token_$id');

  static Key pickerQuickTokenKey(String id) =>
      Key('sc016_picker_quick_token_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComparisonToolPage> createState() => _ComparisonToolPageState();
}

class _ComparisonToolPageState extends ConsumerState<ComparisonToolPage> {
  final TextEditingController _pickerSearchController = TextEditingController();
  late List<String> _selectedIds;
  bool _showPicker = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = [
      ...ref
          .read(marketRepositoryProvider)
          .getMarketComparison()
          .selectedPairIds,
    ];
  }

  @override
  void dispose() {
    _pickerSearchController.dispose();
    super.dispose();
  }

  void _addToken(String id) {
    if (_selectedIds.length >= _maxCompare || _selectedIds.contains(id)) return;
    setState(() {
      _selectedIds = [..._selectedIds, id];
      _showPicker = false;
      _pickerSearchController.clear();
    });
  }

  void _removeToken(String id) {
    if (_selectedIds.length <= 2) return;
    setState(() {
      _selectedIds = _selectedIds.where((value) => value != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketRepositoryProvider).getMarketComparison();
    final selectedPairs = [
      for (final id in _selectedIds)
        if (_findPair(snapshot.marketPairs, id) != null)
          _findPair(snapshot.marketPairs, id)!,
    ];
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
      semanticLabel: 'SC-016 ComparisonToolPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'So sánh',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ComparisonToolPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 18,
                    children: [
                      _SelectedTokensStrip(
                        selectedPairs: selectedPairs,
                        canAdd: _selectedIds.length < _maxCompare,
                        canRemove: _selectedIds.length > 2,
                        onAdd: () => setState(() => _showPicker = true),
                        onRemove: _removeToken,
                      ),
                      if (_showPicker)
                        _TokenPickerCard(
                          snapshot: snapshot,
                          selectedIds: _selectedIds,
                          controller: _pickerSearchController,
                          onChanged: () => setState(() {}),
                          onClose: () => setState(() {
                            _showPicker = false;
                            _pickerSearchController.clear();
                          }),
                          onTokenSelected: _addToken,
                        ),
                      if (selectedPairs.length >= 2)
                        _SparklineComparisonCard(pairs: selectedPairs),
                      if (selectedPairs.length >= 2)
                        _MetricComparisonSection(
                          pairs: selectedPairs,
                          metrics: snapshot.metrics,
                        ),
                      if (selectedPairs.length >= 2)
                        _VolumeDistributionCard(pairs: selectedPairs),
                      if (selectedPairs.length >= 2)
                        _MarketCapDistributionCard(pairs: selectedPairs),
                      if (selectedPairs.length < 2) const _NeedMoreTokensCard(),
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

class _SelectedTokensStrip extends StatelessWidget {
  const _SelectedTokensStrip({
    required this.selectedPairs,
    required this.canAdd,
    required this.canRemove,
    required this.onAdd,
    required this.onRemove,
  });

  final List<MarketPair> selectedPairs;
  final bool canAdd;
  final bool canRemove;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: selectedPairs.length + (canAdd ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == selectedPairs.length) {
            return InkWell(
              key: ComparisonToolPage.addTokenKey,
              onTap: onAdd,
              borderRadius: AppRadii.cardRadius,
              child: Container(
                width: 82,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _marketPrimary.withValues(alpha: .38),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: AppColors.text3,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Thêm',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final pair = selectedPairs[index];
          return Container(
            key: ComparisonToolPage.tokenKey(pair.id),
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                _CompareAvatar(pair: pair, size: 28),
                const SizedBox(width: 9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pair.baseAsset,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatPercent(pair.change24h),
                      style: AppTextStyles.micro.copyWith(
                        color: pair.change24h >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                if (canRemove) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    key: ComparisonToolPage.removeTokenKey(pair.id),
                    onTap: () => onRemove(pair.id),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.text3,
                      size: 14,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TokenPickerCard extends StatelessWidget {
  const _TokenPickerCard({
    required this.snapshot,
    required this.selectedIds,
    required this.controller,
    required this.onChanged,
    required this.onClose,
    required this.onTokenSelected,
  });

  final MarketComparisonSnapshot snapshot;
  final List<String> selectedIds;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onClose;
  final ValueChanged<String> onTokenSelected;

  @override
  Widget build(BuildContext context) {
    final search = controller.text.trim().toLowerCase();
    final availablePairs = [
      for (final pair in snapshot.marketPairs)
        if (!selectedIds.contains(pair.id) &&
            (search.isEmpty ||
                pair.baseAsset.toLowerCase().contains(search) ||
                pair.symbol.toLowerCase().contains(search)))
          pair,
    ];

    return VitCard(
      key: ComparisonToolPage.pickerKey,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chọn token so sánh',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: AppRadii.smRadius,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            key: ComparisonToolPage.pickerSearchKey,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.smRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (_) => onChanged(),
                    autofocus: true,
                    cursorColor: _marketPrimary,
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Tìm BTC, ETH...',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (search.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final id in snapshot.popularPairIds)
                    if (!selectedIds.contains(id))
                      Builder(
                        builder: (context) {
                          final pair = _findPair(snapshot.marketPairs, id);
                          if (pair == null) return const SizedBox.shrink();
                          return _PickerQuickChip(
                            pair: pair,
                            onTap: () => onTokenSelected(id),
                          );
                        },
                      ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 190),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final pair in availablePairs)
                    _PickerRow(
                      pair: pair,
                      onTap: () => onTokenSelected(pair.id),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerQuickChip extends StatelessWidget {
  const _PickerQuickChip({required this.pair, required this.onTap});

  final MarketPair pair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ComparisonToolPage.pickerQuickTokenKey(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: pair.logoColor.withValues(alpha: .12),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          pair.baseAsset,
          style: AppTextStyles.caption.copyWith(
            color: pair.logoColor,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.pair, required this.onTap});

  final MarketPair pair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ComparisonToolPage.pickerTokenKey(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _CompareAvatar(pair: pair, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                pair.baseAsset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Text(
              '\$${_formatPrice(pair.price)}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklineComparisonCard extends StatelessWidget {
  const _SparklineComparisonCard({required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biểu đồ giá 24h',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final pair in pairs) ...[
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48,
                        child: CustomPaint(
                          painter: _CompareSparklinePainter(
                            values: pair.sparklineData,
                            color: pair.change24h >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        pair.baseAsset,
                        style: AppTextStyles.micro.copyWith(
                          color: pair.logoColor,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pair != pairs.last) const SizedBox(width: 18),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricComparisonSection extends StatelessWidget {
  const _MetricComparisonSection({required this.pairs, required this.metrics});

  final List<MarketPair> pairs;
  final List<MarketComparisonMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: _comparePurple,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'So sánh chi tiết',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final metric in metrics) ...[
          _MetricCard(metric: metric, pairs: pairs),
          if (metric != metrics.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.pairs});

  final MarketComparisonMetric metric;
  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final values = [for (final pair in pairs) _metricValue(pair, metric.key)];
    final bestIndex = _bestIndex(values, metric.highlight);

    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var index = 0; index < pairs.length; index++) ...[
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _formatMetric(values[index], metric.format),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color:
                              metric.format ==
                                      MarketComparisonMetricFormat.percent &&
                                  metric.key == 'chg'
                              ? (values[index] >= 0
                                    ? AppColors.buy
                                    : AppColors.sell)
                              : index == bestIndex
                              ? _marketPrimary
                              : AppColors.text1,
                          fontSize: 15,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1,
                        ),
                      ),
                      if (index == bestIndex) ...[
                        const SizedBox(height: 9),
                        Text(
                          'TỐT NHẤT',
                          style: AppTextStyles.micro.copyWith(
                            color: _marketPrimary,
                            fontSize: 8,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _VolumeDistributionCard extends StatelessWidget {
  const _VolumeDistributionCard({required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final total = pairs.fold<double>(0, (sum, pair) => sum + pair.volume24h);
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ khối lượng 24h',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  for (final pair in pairs)
                    Expanded(
                      flex: ((pair.volume24h / total) * 1000).round(),
                      child: ColoredBox(
                        color: pair.logoColor.withValues(alpha: .72),
                        child: const SizedBox.expand(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final pair in pairs)
                _LegendEntry(
                  color: pair.logoColor,
                  label:
                      '${pair.baseAsset} ${((pair.volume24h / total) * 100).toStringAsFixed(1)}%',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarketCapDistributionCard extends StatelessWidget {
  const _MarketCapDistributionCard({required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final total = pairs.fold<double>(0, (sum, pair) => sum + pair.marketCap);
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ vốn hóa',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final pair in pairs) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    pair.baseAsset,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                Text(
                  '${_formatCompactUsd(pair.marketCap)} (${((pair.marketCap / total) * 100).toStringAsFixed(1)}%)',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface3),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: pair.marketCap / total,
                      child: ColoredBox(
                        color: pair.logoColor.withValues(alpha: .82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pair != pairs.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _NeedMoreTokensCard extends StatelessWidget {
  const _NeedMoreTokensCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.balance_rounded, color: AppColors.text3, size: 42),
          const SizedBox(height: 12),
          Text(
            'Chọn ít nhất 2 token để so sánh',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _CompareAvatar extends StatelessWidget {
  const _CompareAvatar({required this.pair, required this.size});

  final MarketPair pair;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(0, pair.baseAsset.length < 2 ? 1 : 2),
        style: AppTextStyles.micro.copyWith(
          color: pair.logoColor,
          fontSize: size <= 26 ? 10 : 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CompareSparklinePainter extends CustomPainter {
  const _CompareSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final span = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final normalized = (values[i] - minValue) / span;
      final y = size.height - normalized * (size.height - 10) - 5;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .22), color.withValues(alpha: .02)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _CompareSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

double _metricValue(MarketPair pair, String key) {
  return switch (key) {
    'price' => pair.price,
    'mcap' => pair.marketCap,
    'vol' => pair.volume24h,
    'chg' => pair.change24h,
    'high' => pair.high24h,
    'low' => pair.low24h,
    'range' => ((pair.high24h - pair.low24h) / pair.low24h) * 100,
    'volmcap' => (pair.volume24h / pair.marketCap) * 100,
    _ => 0,
  };
}

int _bestIndex(List<double> values, MarketComparisonHighlight? highlight) {
  if (highlight == null || values.length < 2) return -1;
  final target = highlight == MarketComparisonHighlight.high
      ? values.reduce((a, b) => a > b ? a : b)
      : values.reduce((a, b) => a < b ? a : b);
  return values.indexOf(target);
}

String _formatMetric(double value, MarketComparisonMetricFormat format) {
  return switch (format) {
    MarketComparisonMetricFormat.price => '\$${_formatPrice(value)}',
    MarketComparisonMetricFormat.compact => _formatCompactUsd(value),
    MarketComparisonMetricFormat.percent => _formatPercent(value),
    MarketComparisonMetricFormat.raw => value.toStringAsFixed(2),
  };
}

String _formatPercent(double value) {
  return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
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
  final fractionDigits = value >= 100
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
