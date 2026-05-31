import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_discover.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_header.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_movers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_pairs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_tools.dart';

class MarketListPage extends ConsumerStatefulWidget {
  const MarketListPage({super.key, this.shellRenderMode});

  static const contentKey = MarketListKeys.content;
  static const searchKey = MarketListKeys.search;
  static const sortToggleKey = MarketListKeys.sortToggle;

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
                MarketListHeader(onNavigate: _go),
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
                  MarketListSortSheet(
                    sortOptions: snapshot.screenFilters.sortOptions,
                    activeSort: _sort,
                    onSelected: _setSort,
                  ),
                MarketListCategoryTabs(
                  categories: snapshot.screenFilters.categories,
                  activeCategory: _category,
                  onSelected: _setCategory,
                ),
                if (showMarketSummary) ...[
                  MarketListTopMovers(pairs: snapshot.marketPairs),
                  MarketListTools(onNavigate: _go),
                ],
                MarketListColumnHeader(
                  lastUpdatedLabel: snapshot.lastUpdatedLabel,
                ),
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
                  MarketListPairList(
                    pairs: visiblePairs,
                    favoriteIds: _favoriteIds,
                    onFavoriteToggle: _toggleFavorite,
                    onNavigate: _go,
                  ),
                const MarketListDiscoverMoreSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
