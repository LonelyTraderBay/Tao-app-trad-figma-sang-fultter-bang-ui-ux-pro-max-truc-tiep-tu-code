import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

const _marketPrimary = AppColors.primary;
const _predictionPurple = AppColors.accent;
const _arenaOrange = AppColors.caution;

class MarketListPage extends ConsumerStatefulWidget {
  const MarketListPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc008_markets_scroll_content');
  static const searchKey = Key('sc008_markets_search');
  static const sortToggleKey = Key('sc008_markets_sort_toggle');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketListPage> createState() => _MarketListPageState();
}

class _MarketListPageState extends ConsumerState<MarketListPage> {
  final _searchController = TextEditingController();

  late Set<String> _favoriteIds;
  String _category = 'Tất cả';
  String _sort = 'default';
  bool _showSort = false;

  @override
  void initState() {
    super.initState();
    _favoriteIds = {
      ...ref.read(marketControllerProvider).getMarketList().watchlist,
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setCategory(String value) {
    setState(() => _category = value);
  }

  void _setSort(String value) {
    setState(() {
      _sort = value;
      _showSort = false;
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  void _go(String path) {
    context.go(path);
  }

  List<MarketPair> _filteredPairs(List<MarketPair> pairs) {
    final query = _searchController.text.trim().toLowerCase();
    Iterable<MarketPair> list = pairs;

    if (query.isNotEmpty) {
      list = list.where((pair) {
        return pair.symbol.toLowerCase().contains(query) ||
            pair.baseAsset.toLowerCase().contains(query);
      });
    }

    if (_category != 'Tất cả') {
      list = list.where((pair) => pair.category == _category);
    }

    final sorted = list.toList();
    switch (_sort) {
      case 'price_desc':
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case 'price_asc':
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case 'change_desc':
        sorted.sort((a, b) => b.change24h.compareTo(a.change24h));
      case 'change_asc':
        sorted.sort((a, b) => a.change24h.compareTo(b.change24h));
      case 'volume_desc':
        sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case 'default':
      default:
        break;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketControllerProvider).getMarketList();
    final shellRenderMode = widget.shellRenderMode ?? defaultShellRenderMode();
    final nativeShell = !shellRenderMode.usesVisualQaFrame;
    final bottomChrome = shellRenderMode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomScrollInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (nativeShell ? 18 : 40);
    final filtered = _filteredPairs(snapshot.marketPairs);
    final visiblePairs = filtered.take(8).toList();
    final searchActive = _searchController.text.trim().isNotEmpty;
    final showMarketSummary = !searchActive && _category == 'Tất cả';

    return VitPageLayout(
      variant: nativeShell ? VitPageVariant.flush : VitPageVariant.defaultPage,
      semanticLabel: 'SC-008 MarketListPage',
      child: Material(
        type: MaterialType.transparency,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            key: MarketListPage.contentKey,
            padding: EdgeInsets.only(bottom: bottomScrollInset),
            child: VitPageContent(
              padding: VitContentPadding.compact,
              gap: VitContentGap.defaultGap,
              children: [
                _MarketHeader(onNavigate: _go),
                VitSearchBar(
                  key: MarketListPage.searchKey,
                  controller: _searchController,
                  placeholder: 'Tìm kiếm BTC, ETH...',
                  filterActive: _showSort || _sort != 'default',
                  filterInline: true,
                  onChanged: (_) => setState(() {}),
                  onClear: () => setState(() {}),
                  onFilterTap: () => setState(() => _showSort = !_showSort),
                ),
                if (_showSort)
                  _SortSheet(
                    sortOptions: snapshot.screenFilters.sortOptions,
                    activeSort: _sort,
                    onSelected: _setSort,
                  ),
                _CategoryTabs(
                  categories: snapshot.screenFilters.categories,
                  activeCategory: _category,
                  onSelected: _setCategory,
                ),
                if (showMarketSummary) ...[
                  _TopMovers(pairs: snapshot.marketPairs),
                  _MarketTools(onNavigate: _go),
                ],
                _ColumnHeader(lastUpdatedLabel: snapshot.lastUpdatedLabel),
                if (filtered.isEmpty)
                  VitEmptyState(
                    icon: Icons.search_rounded,
                    title: searchActive
                        ? 'Không tìm thấy "${_searchController.text.trim()}"'
                        : 'Không có kết quả',
                    message: 'Thử thay đổi bộ lọc hoặc tìm kiếm từ khóa khác',
                    actionLabel: 'Xóa bộ lọc',
                    onAction: () {
                      setState(() {
                        _searchController.clear();
                        _category = 'Tất cả';
                        _sort = 'default';
                      });
                    },
                  )
                else
                  _MarketPairList(
                    pairs: visiblePairs,
                    favoriteIds: _favoriteIds,
                    onFavoriteToggle: _toggleFavorite,
                    onNavigate: _go,
                  ),
                const _DiscoverMoreSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketHeader extends StatelessWidget {
  const _MarketHeader({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Thị trường',
            style: AppTextStyles.pageTitle.copyWith(fontSize: 30, height: 1.15),
          ),
        ),
        _HeaderActionButton(
          icon: Icons.monitor_heart_outlined,
          tooltip: 'Tổng quan thị trường',
          onTap: () => onNavigate('/markets/overview'),
        ),
        const SizedBox(width: 8),
        _HeaderActionButton(
          icon: Icons.trending_up_rounded,
          tooltip: 'Biến động',
          onTap: () => onNavigate('/markets/movers'),
        ),
        const SizedBox(width: 8),
        _HeaderActionButton(
          icon: Icons.layers_rounded,
          tooltip: 'Ngành',
          onTap: () => onNavigate('/markets/sectors'),
        ),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(icon, color: AppColors.text2, size: 17),
          ),
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({
    required this.sortOptions,
    required this.activeSort,
    required this.onSelected,
  });

  final List<MarketSortOption> sortOptions;
  final String activeSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in sortOptions)
            _FilterChipButton(
              label: option.label,
              active: option.id == activeSort,
              onTap: () => onSelected(option.id),
            ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _FilterChipButton(
            key: Key('sc008_category_$category'),
            label: category,
            active: category == activeCategory,
            activeColor: _marketPrimary,
            minHeight: 36,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor = _marketPrimary,
    this.minHeight = 34,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color activeColor;
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
                ? activeColor.withValues(alpha: 0.16)
                : AppColors.transparent,
            border: Border.all(
              color: active
                  ? activeColor.withValues(alpha: 0.42)
                  : AppColors.transparent,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? activeColor : AppColors.text2,
              fontWeight: AppTextStyles.medium,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopMovers extends StatelessWidget {
  const _TopMovers({required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final gainers = pairs.where((pair) => pair.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = pairs.where((pair) => pair.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    return Row(
      children: [
        Expanded(
          child: _MoverCard(
            title: 'Tăng mạnh',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            pairs: gainers.take(3).toList(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MoverCard(
            title: 'Giảm mạnh',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            pairs: losers.take(3).toList(),
          ),
        ),
      ],
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.pairs,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 130,
      borderColor: color.withValues(alpha: 0.18),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final pair in pairs) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    pair.baseAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: 1.25,
                    ),
                  ),
                ),
                Text(
                  _formatPct(pair.change24h),
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (pair != pairs.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _MarketTools extends StatelessWidget {
  const _MarketTools({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  static const tools = [
    _MarketTool(
      icon: Icons.filter_alt_outlined,
      label: 'Bộ lọc',
      route: 'screener',
      color: _marketPrimary,
    ),
    _MarketTool(
      icon: Icons.balance_outlined,
      label: 'So sánh',
      route: 'compare',
      color: _predictionPurple,
    ),
    _MarketTool(
      icon: Icons.calendar_month_outlined,
      label: 'Sự kiện',
      route: 'calendar',
      color: _arenaOrange,
    ),
    _MarketTool(
      icon: Icons.bolt_outlined,
      label: 'Phái sinh',
      route: 'derivatives',
      color: AppColors.sell,
    ),
    _MarketTool(
      icon: Icons.forum_outlined,
      label: 'Tâm lý',
      route: 'social-sentiment',
      color: AppAssetColors.cyanChain,
    ),
    _MarketTool(
      icon: Icons.pie_chart_outline_rounded,
      label: 'Danh mục',
      route: 'portfolio-tracker',
      color: AppColors.buy,
    ),
    _MarketTool(
      icon: Icons.article_outlined,
      label: 'Tin tức',
      route: 'news',
      color: AppColors.text3,
    ),
    _MarketTool(
      icon: Icons.show_chart_rounded,
      label: 'Phân tích',
      route: 'advanced-charts',
      color: AppAssetColors.skyChain,
    ),
    _MarketTool(
      icon: Icons.lock_open_rounded,
      label: 'Unlock',
      route: 'unlocks',
      color: AppAssetColors.violetChain,
    ),
    _MarketTool(
      icon: Icons.radio_button_checked,
      label: 'Tín hiệu',
      route: 'signals',
      color: AppColors.riskHigh,
    ),
    _MarketTool(
      icon: Icons.account_tree_outlined,
      label: 'Tương quan',
      route: 'correlations',
      color: AppAssetColors.tealChain,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tools.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tool = tools[index];
          return _ToolChip(
            tool: tool,
            onTap: () => onNavigate('/markets/${tool.route}'),
          );
        },
      ),
    );
  }
}

class _MarketTool {
  const _MarketTool({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String route;
  final Color color;
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.tool, required this.onTap});

  final _MarketTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: tool.color.withValues(alpha: 0.08),
          border: Border.all(color: tool.color.withValues(alpha: 0.22)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(tool.icon, color: tool.color, size: 14),
            const SizedBox(width: 7),
            Text(
              tool.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({required this.lastUpdatedLabel});

  final String lastUpdatedLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Cập nhật $lastUpdatedLabel',
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 38,
              child: Text(
                'Cặp giao dịch',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Expanded(
              flex: 26,
              child: Text(
                'Biểu đồ',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Expanded(
              flex: 36,
              child: Text(
                'Giá / Thay đổi',
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketPairList extends StatelessWidget {
  const _MarketPairList({
    required this.pairs,
    required this.favoriteIds,
    required this.onFavoriteToggle,
    required this.onNavigate,
  });

  final List<MarketPair> pairs;
  final Set<String> favoriteIds;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pair in pairs)
          _MarketPairRow(
            key: Key('sc008_pair_${pair.id}'),
            pair: pair,
            favorite: favoriteIds.contains(pair.id),
            onFavoriteToggle: () => onFavoriteToggle(pair.id),
            onTap: () => onNavigate('/pair/${pair.id}'),
          ),
      ],
    );
  }
}

class _MarketPairRow extends StatelessWidget {
  const _MarketPairRow({
    super.key,
    required this.pair,
    required this.favorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final MarketPair pair;
  final bool favorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _CoinAvatar(pair: pair),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.baseAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pair.quoteAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              height: 32,
              child: CustomPaint(
                painter: _SparklinePainter(
                  values: pair.sparklineData,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 74,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPrice(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: positive ? AppColors.buy15 : AppColors.sell15,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      _formatPct(pair.change24h),
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: favorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
              child: Semantics(
                button: true,
                label: favorite
                    ? 'Bỏ yêu thích ${pair.baseAsset}'
                    : 'Thêm vào yêu thích ${pair.baseAsset}',
                child: InkResponse(
                  onTap: onFavoriteToggle,
                  radius: 18,
                  child: SizedBox(
                    width: 28,
                    height: 32,
                    child: Icon(
                      favorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: favorite ? _arenaOrange : AppColors.text3,
                      size: 18,
                    ),
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

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.15),
        border: Border.all(
          color: pair.logoColor.withValues(alpha: 0.30),
          width: 1.5,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(
          0,
          pair.baseAsset.length < 3 ? pair.baseAsset.length : 3,
        ),
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

class _DiscoverMoreSection extends StatelessWidget {
  const _DiscoverMoreSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          title: 'Khám phá thêm',
          accentColor: _predictionPurple,
        ),
        const SizedBox(height: 8),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _DiscoverRow(
                icon: Icons.gps_fixed_rounded,
                title: 'Prediction Markets',
                subtitle: 'Dự đoán sự kiện · Xác suất · Vị thế',
                badge: 'Real positions',
                color: _predictionPurple,
                onTap: () => context.go('/markets/predictions'),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              _DiscoverRow(
                icon: Icons.sports_esports_outlined,
                title: 'Open Arena',
                subtitle: 'Creator modes · Thách đấu · Arena Points',
                badge: 'Points only',
                color: _arenaOrange,
                onTap: () => context.go('/arena'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.accentColor});

  final String title;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _DiscoverRow extends StatelessWidget {
  const _DiscoverRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: AppRadii.xsRadius,
                        ),
                        child: Text(
                          badge,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontSize: 8,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
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
        colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
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

String _formatPct(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
