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
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

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
      ...ref.read(marketRepositoryProvider).getMarketWatchlist().entries,
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
          content: TextField(
            controller: controller,
            autofocus: true,
            style: AppTextStyles.body,
            cursorColor: _marketPrimary,
            decoration: InputDecoration(
              hintText: 'Nhập ghi chú',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.text3),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderSolid),
                borderRadius: AppRadii.inputRadius,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _marketPrimary),
                borderRadius: AppRadii.inputRadius,
              ),
            ),
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
    final snapshot = ref.watch(marketRepositoryProvider).getMarketWatchlist();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Danh sách theo dõi',
              subtitle: 'Theo dõi · Markets',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
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
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: items.isEmpty
                        ? _EmptyWatchlist(
                            searchActive: _searchController.text
                                .trim()
                                .isNotEmpty,
                            onAddPair: () => context.go(AppRoutePaths.markets),
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < items.length; i++) ...[
                                _WatchlistCard(
                                  item: items[i],
                                  onPairTap: () =>
                                      context.go('/pair/${items[i].pair.id}'),
                                  onTradeTap: () =>
                                      context.go('/trade/${items[i].pair.id}'),
                                  onNoteTap: () => _editNote(items[i].entry),
                                  onRemoveTap: () =>
                                      _removeEntry(items[i].entry.id),
                                ),
                                if (i != items.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ],
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

class _WatchlistToolbar extends StatelessWidget {
  const _WatchlistToolbar({
    required this.controller,
    required this.count,
    required this.onChanged,
    required this.onClear,
    required this.onAddPair,
  });

  final TextEditingController controller;
  final int count;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 13),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ToolbarSearchField(
                    key: WatchlistPage.searchKey,
                    controller: controller,
                    placeholder: 'Tìm kiếm cặp giao dịch...',
                    onChanged: onChanged,
                    onClear: onClear,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  key: WatchlistPage.addPairKey,
                  onTap: onAddPair,
                  borderRadius: AppRadii.lgRadius,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: _marketPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warn, size: 15),
                const SizedBox(width: 7),
                Text(
                  '$count cặp đang theo dõi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarSearchField extends StatelessWidget {
  const _ToolbarSearchField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: _marketPrimary,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.body.copyWith(fontSize: 14),
              decoration: InputDecoration.collapsed(
                hintText: placeholder,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.searchPlaceholder,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (hasValue)
            InkWell(
              onTap: () {
                controller.clear();
                onChanged('');
                onClear();
              },
              borderRadius: AppRadii.inputRadius,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text3,
                  size: 17,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WatchlistCard extends StatelessWidget {
  const _WatchlistCard({
    required this.item,
    required this.onPairTap,
    required this.onTradeTap,
    required this.onNoteTap,
    required this.onRemoveTap,
  });

  final _WatchlistItem item;
  final VoidCallback onPairTap;
  final VoidCallback onTradeTap;
  final VoidCallback onNoteTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    final pair = item.pair;
    final entry = item.entry;
    final positive = pair.change24h >= 0;
    final changeColor = positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: WatchlistPage.cardKey(pair.id),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                key: WatchlistPage.pairLinkKey(pair.id),
                onTap: onPairTap,
                borderRadius: AppRadii.lgRadius,
                child: _AssetAvatar(pair: pair),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onPairTap,
                  borderRadius: AppRadii.smRadius,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pair.baseAsset,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontSize: 15,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pair.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(pair.price),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        positive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: changeColor,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _formatPercent(pair.change24h),
                        style: AppTextStyles.caption.copyWith(
                          color: changeColor,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 42,
            child: CustomPaint(
              painter: _WatchlistSparklinePainter(
                values: pair.sparklineData,
                color: changeColor,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _WatchlistStat(
                  label: '24h High',
                  value: _formatUsd(pair.high24h),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _WatchlistStat(
                  label: '24h Low',
                  value: _formatUsd(pair.low24h),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          if (entry.note != null) ...[
            const SizedBox(height: 12),
            _NotePill(note: entry.note!),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  key: WatchlistPage.tradeKey(pair.id),
                  label: 'Giao dịch',
                  background: _marketPrimary,
                  foreground: Colors.white,
                  onTap: onTradeTap,
                ),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                key: WatchlistPage.noteKey(entry.id),
                label: entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
                background: AppColors.surface2,
                foreground: AppColors.text2,
                onTap: onNoteTap,
              ),
              const SizedBox(width: 8),
              InkWell(
                key: WatchlistPage.removeKey(entry.id),
                onTap: onRemoveTap,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.sell10,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.sell,
                    size: 18,
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

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.length <= 3
            ? pair.baseAsset
            : pair.baseAsset.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: pair.logoColor,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _WatchlistStat extends StatelessWidget {
  const _WatchlistStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _NotePill extends StatelessWidget {
  const _NotePill({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _marketPrimary.withValues(alpha: 0.07),
        border: Border.all(color: _marketPrimary.withValues(alpha: 0.14)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note_rounded, color: _marketPrimary, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: _marketPrimary,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        constraints: const BoxConstraints(minWidth: 102),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: foreground,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist({required this.searchActive, required this.onAddPair});

  final bool searchActive;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: VitEmptyState(
        icon: Icons.star_border_rounded,
        title: searchActive
            ? 'Không tìm thấy cặp nào'
            : 'Chưa có cặp trong danh sách theo dõi',
        message: searchActive
            ? 'Thử tìm BTC, ETH hoặc SOL'
            : 'Thêm cặp giao dịch để theo dõi nhanh giá và ghi chú.',
        actionLabel: searchActive ? null : 'Thêm cặp giao dịch',
        onAction: searchActive ? null : onAddPair,
      ),
    );
  }
}

class _WatchlistItem {
  const _WatchlistItem({required this.entry, required this.pair});

  final MarketWatchlistEntry entry;
  final MarketPair pair;
}

class _WatchlistSparklinePainter extends CustomPainter {
  const _WatchlistSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.width <= 0 || size.height <= 0) return;

    final firstValue = values.first == 0 ? 1.0 : values.first;
    final baseY = size.height * 0.26;
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final relative = ((values[i] - firstValue) / firstValue).clamp(
        -0.12,
        0.12,
      );
      final y = (baseY - relative * size.height * 0.72).clamp(
        4.0,
        size.height - 6,
      );
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0.0)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WatchlistSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value)}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatNumber(double value) {
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
