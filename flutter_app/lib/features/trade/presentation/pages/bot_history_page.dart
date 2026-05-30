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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _historyBackground = AppColors.bg;
const _historyPanel = AppColors.surface;
const _historyPanel2 = AppColors.surface2;
const _historyPrimary = AppColors.primary;
const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;

enum _HistoryFilter { all, buy, sell }

class BotHistoryPage extends ConsumerStatefulWidget {
  const BotHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc123_bot_history_content');
  static const exportHeaderKey = Key('sc123_bot_history_export_header');
  static const exportAllKey = Key('sc123_bot_history_export_all');

  static Key filterKey(String id) => Key('sc123_bot_history_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotHistoryPage> createState() => _BotHistoryPageState();
}

class _BotHistoryPageState extends ConsumerState<BotHistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotHistory();
    final filteredTrades = _filtered(snapshot.trades);
    final totalPnL = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.pnl,
    );
    final totalFees = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.fee,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 28
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-123 BotHistoryPage',
      child: Material(
        color: _historyBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Trade History',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
              trailing: _HeaderExportButton(onTap: _handleExport),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotHistoryPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatsCard(
                      totalTrades: filteredTrades.length,
                      totalPnL: totalPnL,
                      totalFees: totalFees,
                    ),
                    const SizedBox(height: 16),
                    const _SearchBox(),
                    const SizedBox(height: 16),
                    _FilterTabs(
                      filter: _filter,
                      trades: snapshot.trades,
                      onChanged: (filter) => setState(() => _filter = filter),
                    ),
                    const SizedBox(height: 18),
                    _SectionLabel('Trades (${filteredTrades.length})'),
                    const SizedBox(height: 10),
                    if (filteredTrades.isEmpty)
                      const _EmptyHistory()
                    else
                      for (final trade in filteredTrades) ...[
                        _TradeCard(trade: trade),
                        if (trade != filteredTrades.last)
                          const SizedBox(height: 10),
                      ],
                    const SizedBox(height: 18),
                    _ExportNote(onTap: _handleExport),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TradeBotHistoryTrade> _filtered(List<TradeBotHistoryTrade> trades) {
    return switch (_filter) {
      _HistoryFilter.buy =>
        trades.where((trade) => trade.side == TradeBotHistorySide.buy).toList(),
      _HistoryFilter.sell =>
        trades
            .where((trade) => trade.side == TradeBotHistorySide.sell)
            .toList(),
      _HistoryFilter.all => trades,
    };
  }

  void _handleExport() {
    ref
        .read(tradeReadModelControllerProvider)
        .createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
  }
}

class _HeaderExportButton extends StatelessWidget {
  const _HeaderExportButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotHistoryPage.exportHeaderKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _historyPanel2,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.mdRadius,
        ),
        child: const Icon(
          Icons.download_rounded,
          color: AppColors.text1,
          size: 19,
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.totalTrades,
    required this.totalPnL,
    required this.totalFees,
  });

  final int totalTrades;
  final double totalPnL;
  final double totalFees;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              label: 'Total Trades',
              value: '$totalTrades',
              color: AppColors.text1,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Total PnL',
              value:
                  '${totalPnL >= 0 ? '+' : ''}${totalPnL.toStringAsFixed(2)}',
              color: totalPnL >= 0 ? _historyGreen : _historyRed,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Total Fees',
              value: totalFees.toStringAsFixed(2),
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
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
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontSize: 20,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: _historyPanel,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 19),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Search by bot name or pair...',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text3,
                fontSize: 14,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.filter,
    required this.trades,
    required this.onChanged,
  });

  final _HistoryFilter filter;
  final List<TradeBotHistoryTrade> trades;
  final ValueChanged<_HistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_HistoryFilter.all, 'All (${trades.length})'),
      (
        _HistoryFilter.buy,
        'Buy (${trades.where((t) => t.side == TradeBotHistorySide.buy).length})',
      ),
      (
        _HistoryFilter.sell,
        'Sell (${trades.where((t) => t.side == TradeBotHistorySide.sell).length})',
      ),
    ];

    return Row(
      children: [
        for (final tab in tabs) ...[
          _FilterPill(
            key: BotHistoryPage.filterKey(tab.$1.name),
            label: tab.$2,
            active: tab.$1 == filter,
            onTap: () => onChanged(tab.$1),
          ),
          if (tab != tabs.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
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
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _historyPrimary.withValues(alpha: .12)
              : _historyPanel2,
          border: active
              ? Border.all(color: _historyPrimary.withValues(alpha: .55))
              : null,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _historyPrimary : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeBotHistoryTrade trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.side == TradeBotHistorySide.buy;
    final sideColor = isBuy ? _historyGreen : _historyRed;
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBuy
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: sideColor,
                          size: 15,
                        ),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                          decoration: BoxDecoration(
                            color: sideColor.withValues(alpha: .14),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            trade.side.name.toUpperCase(),
                            style: AppTextStyles.micro.copyWith(
                              color: sideColor,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          trade.pair,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Text(
                      '${trade.botName} - ${trade.strategy}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (trade.pnl != 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trade.pnl >= 0 ? '+' : ''}${trade.pnl.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: trade.pnl >= 0 ? _historyGreen : _historyRed,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PnL',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DetailBox(label: 'Qty', value: _formatQty(trade.qty)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailBox(
                  label: 'Price',
                  value: '\$${_formatNumber(trade.price)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailBox(
                  label: 'Fee',
                  value: '\$${trade.fee.toStringAsFixed(3)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Divider(color: AppColors.borderSolid, height: 1),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Text(
                  trade.timestamp,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                decoration: BoxDecoration(
                  color: _historyGreen.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  trade.status,
                  style: AppTextStyles.micro.copyWith(
                    color: _historyGreen,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 7),
      decoration: BoxDecoration(
        color: _historyPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportNote extends StatelessWidget {
  const _ExportNote({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _historyPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Export Options',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            'Download your complete trade history for tax reporting, accounting, or analysis. Available formats: CSV, PDF, Excel.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              key: BotHistoryPage.exportAllKey,
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: _historyPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              icon: const Icon(Icons.download_rounded, size: 15),
              label: Text(
                'Export All Trades',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.history_rounded, color: AppColors.text3, size: 48),
          const SizedBox(height: 12),
          Text(
            'No trades found',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _historyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _historyPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

String _formatNumber(double value) {
  final hasFraction = (value - value.truncateToDouble()).abs() > 0.0001;
  final raw = hasFraction
      ? value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')
      : value.toStringAsFixed(0);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return buffer.toString();
}

String _formatQty(double value) {
  final text = value.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
