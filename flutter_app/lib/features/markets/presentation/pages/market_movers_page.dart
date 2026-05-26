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

class MarketMoversPage extends ConsumerStatefulWidget {
  const MarketMoversPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc010_market_movers_scroll_content');
  static const gainersTabKey = Key('sc010_tab_gainers');
  static const losersTabKey = Key('sc010_tab_losers');
  static const activeTabKey = Key('sc010_tab_active');
  static const unusualTabKey = Key('sc010_tab_unusual');
  static const newListingsTabKey = Key('sc010_tab_new_listings');
  static const timeframe24hKey = Key('sc010_timeframe_24h');
  static const categoryDropdownKey = Key('sc010_category_dropdown');
  static const sortChangeKey = Key('sc010_sort_change');
  static const sortVolumeKey = Key('sc010_sort_volume');
  static const sortMarketCapKey = Key('sc010_sort_market_cap');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketMoversPage> createState() => _MarketMoversPageState();
}

class _MarketMoversPageState extends ConsumerState<MarketMoversPage> {
  String _tab = 'Tăng mạnh';
  String _timeframe = '24h';
  String _category = 'Tất cả';
  String _sort = 'change';
  bool _showCategories = false;

  void _setTab(String value) {
    setState(() {
      _tab = value;
      _showCategories = false;
      if (_tab == 'Hoạt động') _sort = 'volume';
      if (_tab == 'Mới niêm yết' || _tab == 'Tăng mạnh') _sort = 'change';
      if (_tab == 'KL bất thường') _sort = 'volume';
    });
  }

  void _setCategory(String value) {
    setState(() {
      _category = value;
      _showCategories = false;
    });
  }

  List<MarketMover> _visibleMovers(MarketMoversSnapshot snapshot) {
    Iterable<MarketMover> movers = snapshot.movers;

    if (_category != 'Tất cả') {
      movers = movers.where((mover) => mover.category == _category);
    }

    switch (_tab) {
      case 'Giảm mạnh':
        movers = movers.where((mover) => _changeFor(mover) < 0);
      case 'Hoạt động':
        movers = movers;
      case 'KL bất thường':
        movers = movers.where((mover) => mover.volumeChange24h > 0);
      case 'Mới niêm yết':
        movers = movers.where((mover) => mover.isNew);
      case 'Tăng mạnh':
      default:
        movers = movers.where((mover) => _changeFor(mover) > 0);
    }

    final sorted = movers.toList();
    switch (_sort) {
      case 'volume':
        if (_tab == 'KL bất thường') {
          sorted.sort((a, b) => b.volumeChange24h.compareTo(a.volumeChange24h));
        } else {
          sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
        }
      case 'market_cap':
        sorted.sort((a, b) => b.marketCap.compareTo(a.marketCap));
      case 'change':
      default:
        if (_tab == 'Giảm mạnh') {
          sorted.sort((a, b) => _changeFor(a).compareTo(_changeFor(b)));
        } else {
          sorted.sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
        }
    }

    if (_tab == 'Hoạt động' && _sort == 'change') {
      sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    }

    return sorted;
  }

  double _changeFor(MarketMover mover) {
    return switch (_timeframe) {
      '1h' => mover.change1h,
      '7d' => mover.change7d,
      _ => mover.change24h,
    };
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketRepositoryProvider).getMarketMovers();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 42 : 22);
    final movers = _visibleMovers(snapshot);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-010 MarketMoversPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Biến động thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketMoversPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _MoverTabs(
                        tabs: snapshot.tabs,
                        activeTab: _tab,
                        onSelected: _setTab,
                      ),
                      if (_tab != 'Mới niêm yết')
                        _TimeframeSelector(
                          timeframes: snapshot.timeframes,
                          activeTimeframe: _timeframe,
                          onSelected: (value) {
                            setState(() => _timeframe = value);
                          },
                        ),
                      _CategoryDropdown(
                        category: _category,
                        expanded: _showCategories,
                        onTap: () {
                          setState(() => _showCategories = !_showCategories);
                        },
                      ),
                      if (_showCategories)
                        _CategoryPicker(
                          categories: snapshot.screenFilters.categories,
                          activeCategory: _category,
                          onSelected: _setCategory,
                        ),
                      _SortSelector(
                        options: snapshot.screenFilters.sortOptions,
                        activeSort: _sort,
                        onSelected: (value) {
                          setState(() {
                            _sort = value;
                            _showCategories = false;
                          });
                        },
                      ),
                      _ResultSummary(
                        count: movers.length,
                        sortLabel: _sortLabel,
                        timeframe: _timeframe,
                      ),
                      if (movers.isEmpty)
                        VitEmptyState(
                          icon: Icons.trending_flat_rounded,
                          title: 'Không có kết quả',
                          message:
                              'Thử đổi tab, danh mục hoặc khung thời gian khác',
                          actionLabel: 'Xóa bộ lọc',
                          onAction: () {
                            setState(() {
                              _tab = 'Tăng mạnh';
                              _timeframe = '24h';
                              _category = 'Tất cả';
                              _sort = 'change';
                              _showCategories = false;
                            });
                          },
                        )
                      else
                        _MoverListCard(
                          movers: movers,
                          tab: _tab,
                          changeFor: _changeFor,
                          onTap: (mover) => context.go('/pair/${mover.id}usdt'),
                        ),
                      const _DataRefreshFooter(),
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

  String get _sortLabel {
    return switch (_sort) {
      'volume' => 'Khối lượng',
      'market_cap' => 'Market Cap',
      _ => '% thay đổi',
    };
  }
}

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

class _MoverListCard extends StatelessWidget {
  const _MoverListCard({
    required this.movers,
    required this.tab,
    required this.changeFor,
    required this.onTap,
  });

  final List<MarketMover> movers;
  final String tab;
  final double Function(MarketMover mover) changeFor;
  final ValueChanged<MarketMover> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < movers.length; index++)
            _MoverRow(
              key: Key('sc010_mover_${movers[index].id}'),
              rank: index + 1,
              mover: movers[index],
              tab: tab,
              change: changeFor(movers[index]),
              last: index == movers.length - 1,
              onTap: () => onTap(movers[index]),
            ),
        ],
      ),
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    super.key,
    required this.rank,
    required this.mover,
    required this.tab,
    required this.change,
    required this.last,
    required this.onTap,
  });

  final int rank;
  final MarketMover mover;
  final String tab;
  final double change;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metric = _metricForTab();
    final metricColor = metric.positive ? AppColors.buy : AppColors.sell;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _ListRankBadge(rank: rank),
            const SizedBox(width: 8),
            _CoinAvatar(mover: mover),
            const SizedBox(width: 10),
            Expanded(child: _MoverIdentity(mover: mover)),
            const SizedBox(width: 8),
            SizedBox(
              width: 66,
              height: 30,
              child: CustomPaint(
                painter: _SparklinePainter(
                  values: mover.sparkline,
                  color: metricColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 74,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPrice(mover.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    metric.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: metricColor,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
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

  _MoverMetric _metricForTab() {
    if (tab == 'Hoạt động') {
      return _MoverMetric(
        label: _formatCompact(mover.volume24h, prefix: r'$'),
        positive: true,
      );
    }
    if (tab == 'KL bất thường') {
      return _MoverMetric(
        label: 'KL ${_formatSignedPercent(mover.volumeChange24h)}',
        positive: mover.volumeChange24h >= 0,
      );
    }
    return _MoverMetric(
      label: _formatSignedPercent(change),
      positive: change >= 0,
    );
  }
}

class _MoverMetric {
  const _MoverMetric({required this.label, required this.positive});

  final String label;
  final bool positive;
}

class _ListRankBadge extends StatelessWidget {
  const _ListRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
          height: 1,
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    final labelLength = mover.symbol.length < 3 ? mover.symbol.length : 3;
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: mover.color.withValues(alpha: 0.16),
        border: Border.all(color: mover.color.withValues(alpha: 0.32)),
        shape: BoxShape.circle,
      ),
      child: Text(
        mover.symbol.substring(0, labelLength),
        style: AppTextStyles.micro.copyWith(
          color: mover.color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MoverIdentity extends StatelessWidget {
  const _MoverIdentity({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                mover.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 5),
            _MarketCapRankBadge(rank: mover.marketCapRank),
            if (mover.isNew) ...[const SizedBox(width: 5), const _NewBadge()],
          ],
        ),
        const SizedBox(height: 7),
        Text(
          mover.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MarketCapRankBadge extends StatelessWidget {
  const _MarketCapRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        '#$rank',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: _marketPrimary.withValues(alpha: 0.15),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        'MỚI',
        style: AppTextStyles.micro.copyWith(
          color: _marketPrimary,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _DataRefreshFooter extends StatelessWidget {
  const _DataRefreshFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dữ liệu cập nhật mỗi 30 giây',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3, height: 1),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
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

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.24), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.45
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String _formatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_formatFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_formatFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_formatFixed(value / 1000, 2)}K';
  }
  return '$prefix${_formatFixed(value, 2)}';
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
