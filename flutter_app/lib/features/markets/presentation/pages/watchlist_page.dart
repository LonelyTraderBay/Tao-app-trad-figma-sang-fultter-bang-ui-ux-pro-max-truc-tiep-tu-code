import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part '../widgets/watchlist_toolbar.dart';
part '../widgets/watchlist_cards.dart';
part '../widgets/watchlist_common_painter.dart';

const _marketPrimary = AppColors.primary;

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc012_watchlist_scroll_content');
  static const searchKey = Key('sc012_watchlist_search');
  static const addPairKey = Key('sc012_add_pair');

  static Key cardKey(String pairId) => Key('sc012_watchlist_card_$pairId');

  static Key tradeKey(String pairId) => Key('sc012_trade_$pairId');

  static Key pairLinkKey(String pairId) => Key('sc012_pair_link_$pairId');

  static Key noteKey(String entryId) => Key('sc012_note_$entryId');

  static Key removeKey(String entryId) => Key('sc012_remove_$entryId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  final _searchController = TextEditingController();
  late List<MarketWatchlistEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = [
      ...ref.read(marketControllerProvider).getMarketWatchlist().entries,
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_WatchlistItem> _filteredItems(MarketWatchlistSnapshot snapshot) {
    final query = _searchController.text.trim().toLowerCase();
    final items = <_WatchlistItem>[];
    for (final entry in _entries) {
      final pair = _findPair(snapshot.marketPairs, entry.pairId);
      if (pair == null) continue;
      if (query.isNotEmpty &&
          !pair.symbol.toLowerCase().contains(query) &&
          !pair.baseAsset.toLowerCase().contains(query)) {
        continue;
      }
      items.add(_WatchlistItem(entry: entry, pair: pair));
    }
    return items;
  }

  void _removeEntry(String id) {
    setState(() {
      _entries = _entries.where((entry) => entry.id != id).toList();
    });
  }

  Future<void> _editNote(MarketWatchlistEntry entry) async {
    final controller = TextEditingController(text: entry.note ?? '');
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
            style: AppTextStyles.baseMedium,
          ),
          content: VitInput(
            controller: controller,
            autofocus: true,
            semanticLabel: 'Watchlist note',
            hintText: 'Nhap ghi chu',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (note == null) return;

    final trimmed = note.trim();
    setState(() {
      _entries = [
        for (final current in _entries)
          if (current.id == entry.id)
            MarketWatchlistEntry(
              id: current.id,
              pairId: current.pairId,
              note: trimmed.isEmpty ? null : trimmed,
            )
          else
            current,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketControllerProvider).getMarketWatchlist();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 42 : 18);
    final items = _filteredItems(snapshot);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-012 WatchlistPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Danh sách theo dõi',
            subtitle: 'Theo dõi · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WatchlistToolbar(
                controller: _searchController,
                count: _entries.length,
                onChanged: (_) => setState(() {}),
                onClear: () => setState(() {}),
                onAddPair: () => context.go(AppRoutePaths.markets),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: WatchlistPage.contentKey,
                    padding: AppSpacing.marketScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.watchlistSectionGap,
                      children: [
                        items.isEmpty
                            ? _EmptyWatchlist(
                                searchActive: _searchController.text
                                    .trim()
                                    .isNotEmpty,
                                onAddPair: () =>
                                    context.go(AppRoutePaths.markets),
                              )
                            : Column(
                                children: [
                                  for (var i = 0; i < items.length; i++) ...[
                                    _WatchlistCard(
                                      item: items[i],
                                      onPairTap: () => context.go(
                                        AppRoutePaths.pairDetail(
                                          items[i].pair.id,
                                        ),
                                      ),
                                      onTradeTap: () => context.go(
                                        AppRoutePaths.tradePair(
                                          items[i].pair.id,
                                        ),
                                      ),
                                      onNoteTap: () =>
                                          _editNote(items[i].entry),
                                      onRemoveTap: () =>
                                          _removeEntry(items[i].entry.id),
                                    ),
                                    if (i != items.length - 1)
                                      const SizedBox(
                                        height: AppSpacing.watchlistSectionGap,
                                      ),
                                  ],
                                ],
                              ),
                        const MarketBodyReviewSection(
                          title: 'Watchlist state review',
                          message: 'Watchlist data reviewed',
                          detail:
                              'Search, add, note, remove, empty, and refresh states remain visible for tracked pairs.',
                          primary:
                              'Toolbar search and add-pair actions stay above watched assets.',
                          secondary:
                              'Note editing and remove actions preserve the selected pair context.',
                          tertiary:
                              'Empty watchlist recovery stays visible before market navigation.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
