import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class MarketHeatmapPage extends ConsumerStatefulWidget {
  const MarketHeatmapPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc013_market_heatmap_scroll_content');
  static const metric24hKey = Key('sc013_metric_24h');
  static const metric7dKey = Key('sc013_metric_7d');
  static const detailButtonKey = Key('sc013_heatmap_detail_button');

  static Key categoryKey(String category) => Key('sc013_category_$category');

  static Key tileKey(String id) => Key('sc013_heatmap_tile_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketHeatmapPage> createState() => _MarketHeatmapPageState();
}

class _MarketHeatmapPageState extends ConsumerState<MarketHeatmapPage> {
  String _category = 'Tất cả';
  String _metric = '24h';
  String? _selectedCoinId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketRepositoryProvider).getMarketHeatmap();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 50 : 20);
    final visibleCoins = _visibleCoins(snapshot);
    final selectedCoin = _findCoin(snapshot.coins, _selectedCoinId);
    final totalMarketCap = visibleCoins.fold<double>(
      0,
      (sum, coin) => sum + coin.marketCap,
    );
    final averageChange = visibleCoins.isEmpty
        ? 0.0
        : visibleCoins.fold<double>(0, (sum, coin) => sum + _changeFor(coin)) /
              visibleCoins.length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-013 MarketHeatmapPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Market Heatmap',
              subtitle: 'Bản đồ · Markets',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketHeatmapPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 28,
                    children: [
                      _SummaryStrip(
                        totalMarketCap: totalMarketCap,
                        averageChange: averageChange,
                        metric: _metric,
                        count: visibleCoins.length,
                      ),
                      _HeatmapControls(
                        metrics: snapshot.metrics,
                        activeMetric: _metric,
                        categories: snapshot.screenFilters.categories,
                        activeCategory: _category,
                        onMetricSelected: (value) {
                          setState(() {
                            _metric = value;
                            _selectedCoinId = null;
                          });
                        },
                        onCategorySelected: (value) {
                          setState(() {
                            _category = value;
                            _selectedCoinId = null;
                          });
                        },
                      ),
                      _HeatmapTreemap(
                        coins: visibleCoins,
                        totalMarketCap: totalMarketCap,
                        metric: _metric,
                        selectedCoinId: _selectedCoinId,
                        onCoinSelected: (coin) {
                          setState(() {
                            _selectedCoinId = _selectedCoinId == coin.id
                                ? null
                                : coin.id;
                          });
                        },
                      ),
                      const _HeatmapLegend(),
                      if (selectedCoin != null)
                        _SelectedCoinCard(
                          coin: selectedCoin,
                          onDetail: () =>
                              context.go('/pair/${selectedCoin.id}usdt'),
                        ),
                      _TrendPanels(coins: visibleCoins, metric: _metric),
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

  List<HeatmapCoin> _visibleCoins(MarketHeatmapSnapshot snapshot) {
    final coins = _category == 'Tất cả'
        ? snapshot.coins
        : snapshot.coins.where((coin) => coin.category == _category).toList();
    return [...coins]..sort((a, b) => b.marketCap.compareTo(a.marketCap));
  }

  double _changeFor(HeatmapCoin coin) {
    return _metric == '7d' ? coin.change7d : coin.change24h;
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.totalMarketCap,
    required this.averageChange,
    required this.metric,
    required this.count,
  });

  final double totalMarketCap;
  final double averageChange;
  final String metric;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Tổng Market Cap',
            value: _formatCompact(totalMarketCap),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'TB thay đổi $metric',
            value: _formatPercent(averageChange),
            valueColor: averageChange >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Số coin',
            value: '$count',
            valueColor: _marketPrimary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(13),
      height: 62,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapControls extends StatelessWidget {
  const _HeatmapControls({
    required this.metrics,
    required this.activeMetric,
    required this.categories,
    required this.activeCategory,
    required this.onMetricSelected,
    required this.onCategorySelected,
  });

  final List<String> metrics;
  final String activeMetric;
  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onMetricSelected;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            children: [
              for (final metric in metrics)
                _FilterChip(
                  key: metric == '7d'
                      ? MarketHeatmapPage.metric7dKey
                      : MarketHeatmapPage.metric24hKey,
                  label: metric,
                  active: metric == activeMetric,
                  onTap: () => onMetricSelected(metric),
                ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _FilterChip(
                  key: MarketHeatmapPage.categoryKey(category),
                  label: category,
                  active: category == activeCategory,
                  onTap: () => onCategorySelected(category),
                  outlined: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: AppRadii.cardRadius,
          border: outlined
              ? Border.all(
                  color: active
                      ? _marketPrimary.withValues(alpha: 0.48)
                      : Colors.transparent,
                )
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _HeatmapTreemap extends StatelessWidget {
  const _HeatmapTreemap({
    required this.coins,
    required this.totalMarketCap,
    required this.metric,
    required this.selectedCoinId,
    required this.onCoinSelected,
  });

  final List<HeatmapCoin> coins;
  final double totalMarketCap;
  final String metric;
  final String? selectedCoinId;
  final ValueChanged<HeatmapCoin> onCoinSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 360,
      clip: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final placements = _buildPlacements(coins, constraints.maxWidth);
          return Stack(
            children: [
              for (final placement in placements)
                Positioned(
                  left: placement.left,
                  top: placement.top,
                  width: placement.width,
                  height: placement.height,
                  child: _HeatmapTile(
                    placement: placement,
                    metric: metric,
                    selected: selectedCoinId == placement.coin.id,
                    onTap: () => onCoinSelected(placement.coin),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<_TilePlacement> _buildPlacements(
    List<HeatmapCoin> sorted,
    double width,
  ) {
    const columns = 5;
    const cellHeight = 50.0;
    const gap = 4.0;
    final cellWidth = (width - (columns - 1) * gap) / columns;
    final occupied = <List<bool>>[];
    final placements = <_TilePlacement>[];

    for (final coin in sorted) {
      final ratio = totalMarketCap <= 0 ? 0 : coin.marketCap / totalMarketCap;
      final columnSpan = ratio > 0.30
          ? 3
          : ratio > 0.10
          ? 2
          : 1;
      final rowSpan = ratio > 0.30
          ? 3
          : ratio > 0.15
          ? 2
          : 1;
      final position = _findSlot(
        occupied,
        columns: columns,
        columnSpan: columnSpan,
        rowSpan: rowSpan,
      );
      _occupy(
        occupied,
        row: position.row,
        column: position.column,
        columnSpan: columnSpan,
        rowSpan: rowSpan,
      );
      placements.add(
        _TilePlacement(
          coin: coin,
          columnSpan: columnSpan,
          rowSpan: rowSpan,
          left: position.column * (cellWidth + gap),
          top: position.row * (cellHeight + gap),
          width: columnSpan * cellWidth + (columnSpan - 1) * gap,
          height: rowSpan * cellHeight + (rowSpan - 1) * gap,
        ),
      );
    }

    return placements;
  }

  _GridPosition _findSlot(
    List<List<bool>> occupied, {
    required int columns,
    required int columnSpan,
    required int rowSpan,
  }) {
    for (var row = 0; ; row++) {
      _ensureRows(occupied, row + rowSpan, columns);
      for (var column = 0; column <= columns - columnSpan; column++) {
        var free = true;
        for (var dy = 0; dy < rowSpan && free; dy++) {
          for (var dx = 0; dx < columnSpan; dx++) {
            if (occupied[row + dy][column + dx]) {
              free = false;
              break;
            }
          }
        }
        if (free) return _GridPosition(row: row, column: column);
      }
    }
  }

  void _occupy(
    List<List<bool>> occupied, {
    required int row,
    required int column,
    required int columnSpan,
    required int rowSpan,
  }) {
    for (var dy = 0; dy < rowSpan; dy++) {
      for (var dx = 0; dx < columnSpan; dx++) {
        occupied[row + dy][column + dx] = true;
      }
    }
  }

  void _ensureRows(List<List<bool>> occupied, int rows, int columns) {
    while (occupied.length < rows) {
      occupied.add(List<bool>.filled(columns, false));
    }
  }
}

class _HeatmapTile extends StatelessWidget {
  const _HeatmapTile({
    required this.placement,
    required this.metric,
    required this.selected,
    required this.onTap,
  });

  final _TilePlacement placement;
  final String metric;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coin = placement.coin;
    final change = metric == '7d' ? coin.change7d : coin.change24h;
    final large = placement.columnSpan >= 2;

    return InkWell(
      key: MarketHeatmapPage.tileKey(coin.id),
      onTap: onTap,
      borderRadius: AppRadii.xsRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: large ? 8 : 4, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _heatmapColor(change),
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: .10),
            width: selected ? 2 : 1,
          ),
          borderRadius: AppRadii.xsRadius,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                coin.symbol,
                style: AppTextStyles.baseMedium.copyWith(
                  color: Colors.white,
                  fontSize: large ? 16 : 13,
                  fontWeight: AppTextStyles.bold,
                  shadows: _textShadow,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatPercent(change),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: .92),
                  fontSize: large ? 12 : 10,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  shadows: _textShadow,
                  height: 1,
                ),
              ),
              if (large) ...[
                const SizedBox(height: 7),
                Text(
                  _formatCompact(coin.marketCap),
                  style: AppTextStyles.micro.copyWith(
                    color: Colors.white.withValues(alpha: .58),
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    shadows: _textShadow,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend();

  @override
  Widget build(BuildContext context) {
    const items = [
      _LegendSpec(label: '<-5%', color: Color(0xBFDC4444)),
      _LegendSpec(label: '-2~0%', color: Color(0x598C2E34)),
      _LegendSpec(label: '0~2%', color: Color(0x59107861)),
      _LegendSpec(label: '2~5%', color: Color(0x8C109969)),
      _LegendSpec(label: '>5%', color: Color(0xBF10B981)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final item in items) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
            if (item != items.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _SelectedCoinCard extends StatelessWidget {
  const _SelectedCoinCard({required this.coin, required this.onDetail});

  final HeatmapCoin coin;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: coin.color.withValues(alpha: .14),
                  shape: BoxShape.circle,
                  border: Border.all(color: coin.color.withValues(alpha: .28)),
                ),
                child: Text(
                  coin.symbol.length <= 3
                      ? coin.symbol
                      : coin.symbol.substring(0, 3),
                  style: AppTextStyles.micro.copyWith(
                    color: coin.color,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: AppTextStyles.baseMedium.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${coin.symbol}/USDT · ${coin.category}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                key: MarketHeatmapPage.detailButtonKey,
                onTap: onDetail,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: _marketPrimary,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Chi tiết',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _CoinMetric(label: 'Giá', value: _formatPrice(coin.price)),
              _CoinMetric(
                label: '24h',
                value: _formatPercent(coin.change24h),
                color: coin.change24h >= 0 ? AppColors.buy : AppColors.sell,
              ),
              _CoinMetric(
                label: '7d',
                value: _formatPercent(coin.change7d),
                color: coin.change7d >= 0 ? AppColors.buy : AppColors.sell,
              ),
              _CoinMetric(
                label: 'MCap',
                value: _formatCompact(coin.marketCap),
                color: AppColors.text2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoinMetric extends StatelessWidget {
  const _CoinMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPanels extends StatelessWidget {
  const _TrendPanels({required this.coins, required this.metric});

  final List<HeatmapCoin> coins;
  final String metric;

  @override
  Widget build(BuildContext context) {
    final sorted = [...coins]
      ..sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
    final gainers = sorted.where((coin) => _changeFor(coin) > 0).take(3);
    final losers = sorted
        .where((coin) => _changeFor(coin) < 0)
        .take(3)
        .toList()
        .reversed;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TrendCard(
            title: 'Top tăng',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            coins: gainers.toList(),
            metric: metric,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TrendCard(
            title: 'Top giảm',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            coins: losers.toList(),
            metric: metric,
          ),
        ),
      ],
    );
  }

  double _changeFor(HeatmapCoin coin) {
    return metric == '7d' ? coin.change7d : coin.change24h;
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.coins,
    required this.metric,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<HeatmapCoin> coins;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 156,
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 7),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < coins.length; i++) ...[
            _TrendRow(index: i + 1, coin: coins[i], metric: metric),
            if (i != coins.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.index,
    required this.coin,
    required this.metric,
  });

  final int index;
  final HeatmapCoin coin;
  final String metric;

  @override
  Widget build(BuildContext context) {
    final change = metric == '7d' ? coin.change7d : coin.change24h;
    final color = change >= 0 ? AppColors.buy : AppColors.sell;

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Text(
            '$index.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              coin.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          Text(
            _formatPercent(change),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

final class _TilePlacement {
  const _TilePlacement({
    required this.coin,
    required this.columnSpan,
    required this.rowSpan,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final HeatmapCoin coin;
  final int columnSpan;
  final int rowSpan;
  final double left;
  final double top;
  final double width;
  final double height;
}

final class _GridPosition {
  const _GridPosition({required this.row, required this.column});

  final int row;
  final int column;
}

final class _LegendSpec {
  const _LegendSpec({required this.label, required this.color});

  final String label;
  final Color color;
}

const _textShadow = [
  Shadow(color: Color(0x99000000), blurRadius: 2, offset: Offset(0, 1)),
];

HeatmapCoin? _findCoin(List<HeatmapCoin> coins, String? id) {
  if (id == null) return null;
  for (final coin in coins) {
    if (coin.id == id) return coin;
  }
  return null;
}

Color _heatmapColor(double change) {
  if (change >= 8) return const Color(0xD9059669);
  if (change >= 5) return const Color(0xBF10B981);
  if (change >= 2) return const Color(0x8C10B981);
  if (change >= 0) return const Color(0x5910B981);
  if (change >= -2) return const Color(0x59EF4444);
  if (change >= -5) return const Color(0x8CEF4444);
  return const Color(0xBFEF4444);
}

String _formatCompact(double value) {
  return '\$${_formatNumber(value / 1000000000, 2)}B';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatPrice(double value) {
  if (value >= 1000) return '\$${_formatNumber(value, 2)}';
  if (value < 1) return '\$${value.toStringAsFixed(4)}';
  return '\$${value.toStringAsFixed(2)}';
}

String _formatNumber(double value, int fractionDigits) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1 || fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
