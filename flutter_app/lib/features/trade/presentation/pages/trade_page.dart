import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _tradePrimary = AppColors.primary;
const _fieldBackground = AppColors.surface2;

enum TradeChartVariant { defaultRoute, pairRoute }

class TradePage extends ConsumerStatefulWidget {
  const TradePage({
    super.key,
    this.pairId = 'btcusdt',
    this.chartVariant = TradeChartVariant.defaultRoute,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc048_trade_scroll_content');
  static const chartTabKey = Key('sc048_trade_chart_tab');
  static const orderBookTabKey = Key('sc048_trade_orderbook_tab');
  static const tradesTabKey = Key('sc048_trade_trades_tab');
  static const orderTabKey = Key('sc048_trade_order_tab');
  static const openOrdersTabKey = Key('sc048_trade_open_orders_tab');
  static const historyTabKey = Key('sc048_trade_history_tab');
  static const buySideKey = Key('sc048_trade_buy_side');
  static const sellSideKey = Key('sc048_trade_sell_side');
  static const amountFieldKey = Key('sc048_trade_amount_field');
  static const submitKey = Key('sc048_trade_submit');

  static Key orderTypeKey(TradeOrderType type) =>
      Key('sc048_order_${type.name}');
  static Key quickNavKey(String id) => Key('sc048_quick_$id');
  static Key pctKey(int pct) => Key('sc048_pct_$pct');

  final String pairId;
  final TradeChartVariant chartVariant;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradePage> createState() => _TradePageState();
}

class _TradePageState extends ConsumerState<TradePage> {
  TradeOrderSide _side = TradeOrderSide.buy;
  TradeOrderType _orderType = TradeOrderType.limit;
  String _dataTab = 'chart';
  String _activeTab = 'order';
  final _priceController = TextEditingController(text: '67543.21');
  final _amountController = TextEditingController();
  bool _tpslEnabled = false;

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getTrade(pairId: widget.pairId);
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? pair.price;
    final draft = TradeOrderDraft(
      pairId: pair.id,
      side: _side,
      type: _orderType,
      price: price,
      amount: amount,
    );
    final preview = ref.watch(tradeRepositoryProvider).previewOrder(draft);
    final canSubmit = amount > 0 && price > 0;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-048 TradePage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: TradePage.contentKey,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TradeHeader(pair: pair),
              _QuickNavRow(pair: pair),
              _DataTabs(
                active: _dataTab,
                onSelected: (value) => setState(() => _dataTab = value),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _MarketDataPanel(
                  active: _dataTab,
                  snapshot: snapshot,
                  chartVariant: widget.chartVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _OrderTabs(
                  active: _activeTab,
                  openCount: snapshot.orders.length + 2,
                  onSelected: (value) => setState(() => _activeTab = value),
                ),
              ),
              const SizedBox(height: 20),
              if (_activeTab == 'order')
                _OrderForm(
                  side: _side,
                  orderType: _orderType,
                  pair: pair,
                  balances: snapshot.balances,
                  priceController: _priceController,
                  amountController: _amountController,
                  tpslEnabled: _tpslEnabled,
                  preview: preview,
                  canSubmit: canSubmit,
                  onSideChanged: (side) => setState(() => _side = side),
                  onTypeChanged: (type) => setState(() => _orderType = type),
                  onPct: (pct) => setState(() {
                    final available = _side == TradeOrderSide.buy
                        ? snapshot.balances.usdtAvailable / price
                        : snapshot.balances.baseAvailable;
                    _amountController.text = (available * pct / 100)
                        .toStringAsFixed(6);
                  }),
                  onTpslChanged: (value) =>
                      setState(() => _tpslEnabled = value),
                  onChanged: () => setState(() {}),
                  onSubmit: () {
                    final receipt = ref
                        .read(tradeRepositoryProvider)
                        .submitOrder(draft);
                    context.go(AppRoutePaths.tradeOrderReceipt);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã gửi ${receipt.orderId}')),
                    );
                  },
                )
              else if (_activeTab == 'open')
                _OpenOrdersList(orders: snapshot.orders)
              else
                _HistoryList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: logoColor.withValues(alpha: .20),
              shape: BoxShape.circle,
            ),
            child: Text(
              pair.baseAsset.substring(0, 3),
              style: AppTextStyles.micro.copyWith(
                color: logoColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
              borderRadius: AppRadii.mdRadius,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      pair.symbol,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 21),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text2,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.buy,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    letterSpacing: .6,
                  ),
                ),
                Text(
                  '+${pair.changePct.toStringAsFixed(2)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
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

class _QuickNavRow extends StatelessWidget {
  const _QuickNavRow({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        children: [
          _QuickNavChip(
            key: TradePage.quickNavKey('convert'),
            icon: Icons.swap_horiz_rounded,
            label: 'Convert',
            color: AppColors.buy,
            onTap: () => context.go(AppRoutePaths.tradeConvert),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('dca'),
            icon: Icons.repeat_rounded,
            label: 'Mua định kỳ',
            color: AppColors.accent,
            highlighted: true,
            onTap: () => context.go(AppRoutePaths.dca),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('futures'),
            icon: Icons.bar_chart_rounded,
            label: 'Futures',
            color: AppColors.sell,
            onTap: () => context.go(AppRoutePaths.tradeFutures(pair.id)),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('positions'),
            icon: Icons.work_outline_rounded,
            label: 'Vị thế',
            color: _tradePrimary,
            onTap: () => context.go('/trade/positions'),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('settings'),
            icon: Icons.settings_outlined,
            label: 'Cài đặt',
            color: AppColors.text3,
            onTap: () => context.go('/trade/settings'),
          ),
        ],
      ),
    );
  }
}

class _QuickNavChip extends StatelessWidget {
  const _QuickNavChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: highlighted
                  ? color.withValues(alpha: .10)
                  : AppColors.surface2,
              border: Border.all(
                color: highlighted
                    ? color.withValues(alpha: .25)
                    : AppColors.borderSolid.withValues(alpha: .72),
              ),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 15),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: highlighted ? color : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DataTabs extends StatelessWidget {
  const _DataTabs({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      ('chart', 'Chart', TradePage.chartTabKey),
      ('orderbook', 'Sổ lệnh', TradePage.orderBookTabKey),
      ('trades', 'Giao dịch', TradePage.tradesTabKey),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Container(
        height: 34,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _fieldBackground,
          borderRadius: AppRadii.lgRadius,
        ),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: _SegmentButton(
                  key: tab.$3,
                  label: tab.$2,
                  active: active == tab.$1,
                  onTap: () => onSelected(tab.$1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MarketDataPanel extends StatelessWidget {
  const _MarketDataPanel({
    required this.active,
    required this.snapshot,
    required this.chartVariant,
  });

  final String active;
  final TradeScreenSnapshot snapshot;
  final TradeChartVariant chartVariant;

  @override
  Widget build(BuildContext context) {
    if (active == 'orderbook') return _OrderBookPanel(book: snapshot.orderBook);
    if (active == 'trades') return _TradesPanel(trades: snapshot.trades);
    return _ChartPanel(variant: chartVariant);
  }
}

class _ChartPanel extends StatelessWidget {
  const _ChartPanel({required this.variant});

  final TradeChartVariant variant;

  @override
  Widget build(BuildContext context) {
    final pairRoute = variant == TradeChartVariant.pairRoute;
    return Container(
      height: 122,
      decoration: BoxDecoration(
        color: const Color(0xFF201926),
        border: Border.all(color: _tradePrimary.withValues(alpha: .35)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: pairRoute
                  ? _PairRouteChartPainter()
                  : _CandlestickPainter(),
            ),
          ),
          Positioned(
            left: 10,
            top: 12,
            child: pairRoute
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sell.withValues(alpha: .20),
                      border: Border.all(
                        color: AppColors.sell.withValues(alpha: .55),
                      ),
                      borderRadius: AppRadii.lgRadius,
                    ),
                    child: Text(
                      '24H',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.sell.withValues(alpha: .30),
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
          Positioned(
            left: 12,
            bottom: 8,
            child: Text(
              'TV',
              style: AppTextStyles.sectionTitle.copyWith(
                color: Colors.white,
                fontSize: 28,
                fontFamily: 'monospace',
              ),
            ),
          ),
          if (pairRoute) ...[
            Positioned(
              right: 10,
              top: 46,
              child: Text(
                '70000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 22,
              child: Text(
                '68000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
          ],
          Positioned(
            right: 8,
            top: pairRoute ? 18 : 38,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67545.13',
              color: AppColors.sell,
            ),
          ),
          Positioned(
            right: 8,
            top: pairRoute ? 40 : 60,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67254.13',
              color: AppColors.buy,
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: _PriceBadge(
              label: pairRoute ? '70.39K' : '252.58K',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: AppRadii.xsRadius),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontFamily: 'monospace',
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.book});

  final TradeOrderBook book;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _BookHeader(),
          for (final ask in book.asks.reversed)
            _BookRow(level: ask, color: AppColors.sell),
          const Divider(color: AppColors.divider, height: 16),
          for (final bid in book.bids)
            _BookRow(level: bid, color: AppColors.buy),
        ],
      ),
    );
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BookCell('Giá', color: AppColors.text3),
        _BookCell('KL', color: AppColors.text3),
        _BookCell('Tổng', color: AppColors.text3, alignEnd: true),
      ],
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({required this.level, required this.color});

  final TradeBookLevel level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          _BookCell(level.price.toStringAsFixed(2), color: color),
          _BookCell(level.amount.toStringAsFixed(3)),
          _BookCell(level.total.toStringAsFixed(0), alignEnd: true),
        ],
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell(
    this.label, {
    this.color = AppColors.text2,
    this.alignEnd = false,
  });

  final String label;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontFamily: 'monospace',
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TradesPanel extends StatelessWidget {
  const _TradesPanel({required this.trades});

  final List<TradeTapePrint> trades;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          for (final trade in trades)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      trade.price.toStringAsFixed(2),
                      style: AppTextStyles.caption.copyWith(
                        color: trade.isBuy ? AppColors.buy : AppColors.sell,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trade.amount.toStringAsFixed(3),
                      style: AppTextStyles.caption,
                    ),
                  ),
                  Text(trade.time, style: AppTextStyles.micro),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({
    required this.active,
    required this.openCount,
    required this.onSelected,
  });

  final String active;
  final int openCount;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('order', 'Đặt lệnh', TradePage.orderTabKey),
      ('open', 'Đang mở ($openCount)', TradePage.openOrdersTabKey),
      ('history', 'Lịch sử', TradePage.historyTabKey),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _fieldBackground,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SegmentButton(
                key: tab.$3,
                label: tab.$2,
                active: active == tab.$1,
                activeColor: _tradePrimary,
                onTap: () => onSelected(tab.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderForm extends StatelessWidget {
  const _OrderForm({
    required this.side,
    required this.orderType,
    required this.pair,
    required this.balances,
    required this.priceController,
    required this.amountController,
    required this.tpslEnabled,
    required this.preview,
    required this.canSubmit,
    required this.onSideChanged,
    required this.onTypeChanged,
    required this.onPct,
    required this.onTpslChanged,
    required this.onChanged,
    required this.onSubmit,
  });

  final TradeOrderSide side;
  final TradeOrderType orderType;
  final TradePair pair;
  final TradeBalances balances;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final bool tpslEnabled;
  final TradeOrderPreview preview;
  final bool canSubmit;
  final ValueChanged<TradeOrderSide> onSideChanged;
  final ValueChanged<TradeOrderType> onTypeChanged;
  final ValueChanged<int> onPct;
  final ValueChanged<bool> onTpslChanged;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final available = side == TradeOrderSide.buy
        ? balances.usdtAvailable
        : balances.baseAvailable;
    final availableAsset = side == TradeOrderSide.buy ? 'USDT' : pair.baseAsset;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SideSwitch(side: side, onChanged: onSideChanged),
          const SizedBox(height: 16),
          _OrderTypeRow(active: orderType, onSelected: onTypeChanged),
          const SizedBox(height: 16),
          _LabelValue(
            label: 'Khả dụng',
            value: '${_formatMoney(available)} $availableAsset',
          ),
          const SizedBox(height: 14),
          _TradeInput(
            label: 'Giá đặt (USDT)',
            suffix: 'USDT',
            controller: priceController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 14),
          _TradeInput(
            key: TradePage.amountFieldKey,
            label: 'Khối lượng (${pair.baseAsset})',
            suffix: pair.baseAsset,
            controller: amountController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final pct in const [25, 50, 75, 100]) ...[
                Expanded(
                  child: _PctButton(
                    key: TradePage.pctKey(pct),
                    pct: pct,
                    onTap: () => onPct(pct),
                  ),
                ),
                if (pct != 100) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _TpslSwitch(value: tpslEnabled, onChanged: onTpslChanged),
          const SizedBox(height: 16),
          _FeeCard(preview: preview),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: TradePage.submitKey,
              onPressed: canSubmit ? onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor: side == TradeOrderSide.buy
                    ? AppColors.buy
                    : AppColors.sell,
                disabledBackgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Text(
                canSubmit
                    ? (side == TradeOrderSide.buy ? 'Mua BTC' : 'Bán BTC')
                    : 'Nhập thông tin lệnh',
                style: AppTextStyles.baseMedium.copyWith(
                  color: canSubmit ? Colors.white : AppColors.text3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Kiểm tra kỹ trước khi xác nhận.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeOrderSide side;
  final ValueChanged<TradeOrderSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _fieldBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SideButton(
              key: TradePage.buySideKey,
              label: 'MUA',
              color: AppColors.buy,
              active: side == TradeOrderSide.buy,
              onTap: () => onChanged(TradeOrderSide.buy),
            ),
          ),
          Expanded(
            child: _SideButton(
              key: TradePage.sellSideKey,
              label: 'BÁN',
              color: AppColors.sell,
              active: side == TradeOrderSide.sell,
              onTap: () => onChanged(TradeOrderSide.sell),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _OrderTypeRow extends StatelessWidget {
  const _OrderTypeRow({required this.active, required this.onSelected});

  final TradeOrderType active;
  final ValueChanged<TradeOrderType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _OrderTypeChip(
          type: TradeOrderType.market,
          active: active == TradeOrderType.market,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        _OrderTypeChip(
          type: TradeOrderType.limit,
          active: active == TradeOrderType.limit,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        _OrderTypeChip(
          type: TradeOrderType.stop,
          active: active == TradeOrderType.stop,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: _fieldBackground,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _OrderTypeChip extends StatelessWidget {
  const _OrderTypeChip({
    required this.type,
    required this.active,
    required this.onSelected,
  });

  final TradeOrderType type;
  final bool active;
  final ValueChanged<TradeOrderType> onSelected;

  String get label => switch (type) {
    TradeOrderType.market => 'Thị trường',
    TradeOrderType.limit => 'Giới hạn',
    TradeOrderType.stop => 'Dừng lỗ',
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        key: TradePage.orderTypeKey(type),
        onTap: () => onSelected(type),
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 39,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppColors.buy.withValues(alpha: .09)
                : _fieldBackground,
            border: Border.all(
              color: active
                  ? AppColors.buy.withValues(alpha: .75)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.buy : AppColors.text2,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TradeInput extends StatelessWidget {
  const _TradeInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: _fieldBackground,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.cardRadius,
          ),
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            style: AppTextStyles.baseMedium.copyWith(
              fontFamily: 'monospace',
              fontSize: 18,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              suffixText: suffix,
              suffixStyle: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PctButton extends StatelessWidget {
  const _PctButton({super.key, required this.pct, required this.onTap});

  final int pct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _fieldBackground,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text('$pct%', style: AppTextStyles.caption),
      ),
    );
  }
}

class _TpslSwitch extends StatelessWidget {
  const _TpslSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _fieldBackground,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 16),
          const SizedBox(width: 8),
          Text(
            'TP/SL',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Take Profit / Stop Loss',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  const _FeeCard({required this.preview});

  final TradeOrderPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _LabelValue(
            label: 'Thành tiền',
            value: '\$${preview.total.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Phí (Maker)',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadii.xsRadius,
                ),
                child: Text(
                  'VIP 1',
                  style: AppTextStyles.micro.copyWith(
                    color: Colors.black,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '  -5%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '0.085% ≈ \$${preview.fee.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OpenOrdersList extends StatelessWidget {
  const _OpenOrdersList({required this.orders});

  final List<TradeOpenOrder> orders;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      customGap: 12,
      children: [
        for (final order in orders)
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValue(
                  label: order.symbol,
                  value: order.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
                ),
                const SizedBox(height: 8),
                Text(
                  '${order.amount} @ ${order.price.toStringAsFixed(2)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      customGap: 12,
      children: [
        for (final label in const [
          'BTC/USDT · MUA · Đã khớp',
          'ETH/USDT · BÁN · Một phần',
        ])
          VitCard(
            onTap: () => context.go(AppRoutePaths.tradeOrderReceipt),
            padding: const EdgeInsets.all(14),
            child: Text(label, style: AppTextStyles.body),
          ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? (activeColor ?? AppColors.bg) : Colors.transparent,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.text1 : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _PairRouteChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .07)
      ..strokeWidth = 1;
    for (final y in [size.height * .35, size.height * .55, size.height * .75]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final dash = Paint()
      ..color = _tradePrimary.withValues(alpha: .35)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .36),
        Offset(x + 5, size.height * .36),
        dash,
      );
    }

    final points = <Offset>[
      Offset(size.width * .02, size.height * .66),
      Offset(size.width * .10, size.height * .60),
      Offset(size.width * .18, size.height * .56),
      Offset(size.width * .27, size.height * .48),
      Offset(size.width * .36, size.height * .34),
      Offset(size.width * .46, size.height * .38),
      Offset(size.width * .56, size.height * .22),
      Offset(size.width * .66, size.height * .26),
      Offset(size.width * .76, size.height * .39),
      Offset(size.width * .86, size.height * .47),
      Offset(size.width * .96, size.height * .39),
    ];
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.buy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final candlePaint = Paint();
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final green = i == 0 || i == 1 || i == 2 || i == 3 || i == 5 || i == 10;
      candlePaint.color = green ? AppColors.buy : AppColors.sell;
      canvas.drawRect(
        Rect.fromCenter(center: point, width: 9, height: green ? 10 : 12),
        candlePaint,
      );
    }

    for (var i = 0; i < 28; i++) {
      final h = 5.0 + ((i * 5) % 10) * 2.4;
      candlePaint.color = i % 4 == 0
          ? AppColors.sell.withValues(alpha: .55)
          : AppColors.buy.withValues(alpha: .58);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 13, size.height - 10 - h, 9, h),
        candlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CandlestickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _tradePrimary.withValues(alpha: .22)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .57),
        Offset(x + 5, size.height * .57),
        grid,
      );
    }

    final candles = <(double, double, double, double, bool)>[
      (.18, .13, .31, .24, false),
      (.12, .11, .42, .34, false),
      (.32, .30, .48, .38, false),
      (.39, .38, .47, .42, false),
      (.42, .36, .50, .44, true),
      (.35, .28, .45, .36, true),
      (.26, .24, .38, .33, false),
      (.31, .30, .45, .37, false),
      (.39, .37, .48, .42, false),
      (.44, .43, .55, .48, false),
      (.48, .40, .56, .44, true),
      (.43, .39, .51, .47, false),
      (.48, .43, .57, .50, true),
      (.41, .38, .50, .46, true),
      (.39, .35, .53, .48, false),
      (.43, .37, .55, .47, true),
      (.45, .37, .61, .52, false),
      (.51, .47, .62, .55, false),
      (.55, .49, .64, .58, true),
      (.49, .43, .61, .54, true),
      (.45, .40, .58, .52, false),
    ];
    final bodyWidth = 10.0;
    final step = (size.width - 88) / (candles.length - 1);
    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = 18.0 + i * step;
      final color = c.$5 ? AppColors.buy : AppColors.sell;
      final paint = Paint()..color = color;
      canvas.drawLine(
        Offset(x + bodyWidth / 2, size.height * c.$1),
        Offset(x + bodyWidth / 2, size.height * c.$3),
        paint..strokeWidth = 2,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * c.$2,
          bodyWidth,
          size.height * (c.$4 - c.$2).abs().clamp(.05, .18),
        ),
        paint,
      );
    }

    final volumePaint = Paint()..color = AppColors.buy.withValues(alpha: .65);
    for (var i = 0; i < 22; i++) {
      final h = 7.0 + ((i * 3) % 7) * 3;
      volumePaint.color = i.isEven
          ? AppColors.buy.withValues(alpha: .55)
          : AppColors.sell.withValues(alpha: .55);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 16, size.height - 10 - h, 12, h),
        volumePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _formatPrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatMoney(double value) => _formatPrice(value);
