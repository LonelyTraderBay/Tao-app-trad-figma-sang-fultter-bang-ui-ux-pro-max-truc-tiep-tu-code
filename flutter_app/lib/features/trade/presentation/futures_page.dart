import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _tradeBlue = Color(0xFF3B82F6);
const _futuresRed = Color(0xFFEF4444);
const _futuresGreen = Color(0xFF10B981);
const _panelBg = Color(0xFF121721);
const _chipBg = Color(0xFF1D263B);
const _warningBg = Color(0x1AF59E0B);
const _warningBorder = Color(0x33F59E0B);

class FuturesPage extends ConsumerStatefulWidget {
  const FuturesPage({super.key, required this.pairId, this.shellRenderMode});

  static const closeKey = Key('sc057_close');
  static const chartKey = Key('sc057_chart');
  static const leverageKey = Key('sc057_leverage');
  static const marginFieldKey = Key('sc057_margin_field');
  static const takeProfitKey = Key('sc057_take_profit');
  static const stopLossKey = Key('sc057_stop_loss');
  static const submitKey = Key('sc057_submit');

  static Key tabKey(String id) => Key('sc057_tab_$id');
  static Key sideKey(String id) => Key('sc057_side_$id');
  static Key orderTypeKey(String id) => Key('sc057_order_type_$id');
  static Key pctKey(int pct) => Key('sc057_pct_$pct');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FuturesPage> createState() => _FuturesPageState();
}

class _FuturesPageState extends ConsumerState<FuturesPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  TradeFuturesOrderType _orderType = TradeFuturesOrderType.market;
  String _tab = 'trade';
  final int _leverage = 10;
  bool _takeProfit = false;
  bool _stopLoss = false;
  TradeFuturesReceipt? _receipt;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getFutures(pairId: widget.pairId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-057 FuturesPage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FuturesHeader(
                pair: snapshot.pair,
                onClose: () =>
                    context.go(AppRoutePaths.tradePair(widget.pairId)),
                onChart: () =>
                    context.go(AppRoutePaths.tradeAdvancedChart(widget.pairId)),
              ),
              const SizedBox(height: 20),
              _FuturesTabs(
                active: _tab,
                positionCount: snapshot.positions.length,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              const SizedBox(height: 12),
              if (_tab == 'trade')
                _TradeTab(
                  snapshot: snapshot,
                  pairId: widget.pairId,
                  side: _side,
                  orderType: _orderType,
                  leverage: _leverage,
                  marginController: _marginController,
                  takeProfit: _takeProfit,
                  stopLoss: _stopLoss,
                  receipt: _receipt,
                  onSideChanged: (side) => setState(() {
                    _side = side;
                    _receipt = null;
                  }),
                  onOrderTypeChanged: (type) => setState(() {
                    _orderType = type;
                    _receipt = null;
                  }),
                  onLeverage: () => context.go(
                    AppRoutePaths.tradeFuturesLeverage(widget.pairId),
                  ),
                  onPercent: _setPercent,
                  onChanged: () => setState(() => _receipt = null),
                  onTakeProfit: () =>
                      setState(() => _takeProfit = !_takeProfit),
                  onStopLoss: () => setState(() => _stopLoss = !_stopLoss),
                  onSubmit: _submit,
                )
              else if (_tab == 'positions')
                _PositionsTab(snapshot: snapshot)
              else
                _OrdersTab(onTrade: () => setState(() => _tab = 'trade')),
            ],
          ),
        ),
      ),
    );
  }

  void _setPercent(int pct) {
    final value = 5000 * pct / 100;
    setState(() {
      _marginController.text = value.toStringAsFixed(0);
      _receipt = null;
    });
  }

  void _submit() {
    final margin = double.tryParse(_marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: widget.pairId,
      side: _side,
      type: _orderType,
      margin: margin,
      leverage: _leverage,
    );
    final preview = ref
        .read(tradeRepositoryProvider)
        .previewFuturesOrder(draft);
    if (!preview.canOpen) return;
    setState(() {
      _receipt = ref.read(tradeRepositoryProvider).submitFuturesOrder(draft);
      _marginController.clear();
    });
  }
}

class _FuturesHeader extends StatelessWidget {
  const _FuturesHeader({
    required this.pair,
    required this.onClose,
    required this.onChart,
  });

  final TradePair pair;
  final VoidCallback onClose;
  final VoidCallback onChart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          InkWell(
            key: FuturesPage.closeKey,
            onTap: onClose,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.close_rounded, color: AppColors.text1),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pair.symbol,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 17),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _futuresRed.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'FUTURES',
                        style: AppTextStyles.micro.copyWith(
                          color: _futuresRed,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatMoney(pair.price)} (+${pair.changePct.toStringAsFixed(2)}%)',
                  style: AppTextStyles.caption.copyWith(
                    color: _futuresGreen,
                    fontSize: 13,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            key: FuturesPage.chartKey,
            onTap: onChart,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: AppColors.text2,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturesTabs extends StatelessWidget {
  const _FuturesTabs({
    required this.active,
    required this.positionCount,
    required this.onChanged,
  });

  final String active;
  final int positionCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('trade', 'Giao dịch', Icons.bolt_rounded),
      ('positions', 'Vị thế ($positionCount)', Icons.bar_chart_rounded),
      ('orders', 'Lệnh', Icons.receipt_long_rounded),
    ];
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: FuturesPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                borderRadius: BorderRadius.circular(15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == tab.$1 ? _tradeBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.$3,
                        color: active == tab.$1
                            ? Colors.white
                            : AppColors.text3,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab.$1
                                ? Colors.white
                                : AppColors.text3,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TradeTab extends ConsumerWidget {
  const _TradeTab({
    required this.snapshot,
    required this.pairId,
    required this.side,
    required this.orderType,
    required this.leverage,
    required this.marginController,
    required this.takeProfit,
    required this.stopLoss,
    required this.receipt,
    required this.onSideChanged,
    required this.onOrderTypeChanged,
    required this.onLeverage,
    required this.onPercent,
    required this.onChanged,
    required this.onTakeProfit,
    required this.onStopLoss,
    required this.onSubmit,
  });

  final TradeFuturesSnapshot snapshot;
  final String pairId;
  final TradeFuturesSide side;
  final TradeFuturesOrderType orderType;
  final int leverage;
  final TextEditingController marginController;
  final bool takeProfit;
  final bool stopLoss;
  final TradeFuturesReceipt? receipt;
  final ValueChanged<TradeFuturesSide> onSideChanged;
  final ValueChanged<TradeFuturesOrderType> onOrderTypeChanged;
  final VoidCallback onLeverage;
  final ValueChanged<int> onPercent;
  final VoidCallback onChanged;
  final VoidCallback onTakeProfit;
  final VoidCallback onStopLoss;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final margin = double.tryParse(marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: pairId,
      side: side,
      type: orderType,
      margin: margin,
      leverage: leverage,
    );
    final preview = ref
        .watch(tradeRepositoryProvider)
        .previewFuturesOrder(draft);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MarketStats(snapshot: snapshot),
        const SizedBox(height: 12),
        _SideSwitch(side: side, onChanged: onSideChanged),
        const SizedBox(height: 12),
        _OrderTypeAndLeverage(
          orderType: orderType,
          leverage: leverage,
          onOrderTypeChanged: onOrderTypeChanged,
          onLeverage: onLeverage,
        ),
        const SizedBox(height: 12),
        _MarginInput(controller: marginController, onChanged: onChanged),
        const SizedBox(height: 12),
        _PercentRow(onPercent: onPercent),
        const SizedBox(height: 12),
        if (margin > 0) ...[
          _PreviewCard(pair: snapshot.pair, preview: preview),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: _ToggleChip(
                key: FuturesPage.takeProfitKey,
                label: 'Take Profit',
                icon: Icons.gps_fixed_rounded,
                active: takeProfit,
                activeColor: _futuresGreen,
                onTap: onTakeProfit,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleChip(
                key: FuturesPage.stopLossKey,
                label: 'Stop Loss',
                icon: Icons.shield_outlined,
                active: stopLoss,
                activeColor: _futuresRed,
                onTap: onStopLoss,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SubmitButton(
          side: side,
          enabled: preview.canOpen,
          receipt: receipt,
          leverage: leverage,
          onTap: onSubmit,
        ),
        const SizedBox(height: 14),
        const _RiskWarning(),
      ],
    );
  }
}

class _MarketStats extends StatelessWidget {
  const _MarketStats({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Mark Price', _formatMoney(snapshot.markPrice), AppColors.text1),
      ('Index', '\$${snapshot.indexPrice.toStringAsFixed(2)}', AppColors.text1),
      ('Funding', '+${snapshot.fundingRate.toStringAsFixed(2)}%', _futuresRed),
    ];
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _panelBg,
                border: Border.all(color: Colors.white.withValues(alpha: .06)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontSize: 20,
                      fontFamily: 'monospace',
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeFuturesSide side;
  final ValueChanged<TradeFuturesSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _SideButton(
            key: FuturesPage.sideKey('long'),
            label: 'Long',
            icon: Icons.trending_up_rounded,
            active: side == TradeFuturesSide.long,
            color: _futuresGreen,
            onTap: () => onChanged(TradeFuturesSide.long),
          ),
          _SideButton(
            key: FuturesPage.sideKey('short'),
            label: 'Short',
            icon: Icons.trending_down_rounded,
            active: side == TradeFuturesSide.short,
            color: _futuresRed,
            onTap: () => onChanged(TradeFuturesSide.short),
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
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? Colors.white : AppColors.text2,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.baseMedium.copyWith(
                  color: active ? Colors.white : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTypeAndLeverage extends StatelessWidget {
  const _OrderTypeAndLeverage({
    required this.orderType,
    required this.leverage,
    required this.onOrderTypeChanged,
    required this.onLeverage,
  });

  final TradeFuturesOrderType orderType;
  final int leverage;
  final ValueChanged<TradeFuturesOrderType> onOrderTypeChanged;
  final VoidCallback onLeverage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _chipBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _OrderTypeButton(
                  key: FuturesPage.orderTypeKey('market'),
                  label: 'Thị trường',
                  active: orderType == TradeFuturesOrderType.market,
                  onTap: () => onOrderTypeChanged(TradeFuturesOrderType.market),
                ),
                _OrderTypeButton(
                  key: FuturesPage.orderTypeKey('limit'),
                  label: 'Giới hạn',
                  active: orderType == TradeFuturesOrderType.limit,
                  onTap: () => onOrderTypeChanged(TradeFuturesOrderType.limit),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          key: FuturesPage.leverageKey,
          onTap: onLeverage,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _tradeBlue.withValues(alpha: .13),
              border: Border.all(color: _tradeBlue.withValues(alpha: .35)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: _tradeBlue, size: 17),
                const SizedBox(width: 6),
                Text(
                  '${leverage}x',
                  style: AppTextStyles.caption.copyWith(
                    color: _tradeBlue,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _tradeBlue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderTypeButton extends StatelessWidget {
  const _OrderTypeButton({
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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? _tradeBlue.withValues(alpha: .18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? _tradeBlue : AppColors.text2,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MarginInput extends StatelessWidget {
  const _MarginInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border.all(color: _tradeBlue.withValues(alpha: .26)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ký quỹ (USDT)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: FuturesPage.marginFieldKey,
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,4}'),
                      ),
                    ],
                    onChanged: (_) => onChanged(),
                    cursorColor: _tradeBlue,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Nhập số tiền ký quỹ',
                      hintStyle: AppTextStyles.base.copyWith(
                        color: AppColors.text2.withValues(alpha: .72),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                Text(
                  'USDT',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentRow extends StatelessWidget {
  const _PercentRow({required this.onPercent});

  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final pct in const [10, 25, 50, 100]) ...[
          Expanded(
            child: InkWell(
              key: FuturesPage.pctKey(pct),
              onTap: () => onPercent(pct),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _chipBg,
                  border: Border.all(color: _tradeBlue.withValues(alpha: .18)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$pct%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          if (pct != 100) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.pair, required this.preview});

  final TradePair pair;
  final TradeFuturesPreview preview;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Giá trị hợp đồng', _formatMoney(preview.positionSize), AppColors.text1),
      (
        'Số lượng',
        '${preview.contractQty.toStringAsFixed(4)} ${pair.baseAsset}',
        AppColors.text1,
      ),
      ('Giá thanh lý', _formatMoney(preview.liquidationPrice), _futuresRed),
      (
        'Phí mở vị thế',
        '\$${preview.openFee.toStringAsFixed(4)}',
        AppColors.primary,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(row.$1, style: AppTextStyles.caption),
                  const Spacer(),
                  Text(
                    row.$2,
                    style: AppTextStyles.caption.copyWith(
                      color: row.$3,
                      fontFamily: 'monospace',
                      fontWeight: AppTextStyles.bold,
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

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: .12) : _chipBg,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: .35)
                : _tradeBlue.withValues(alpha: .18),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? activeColor : AppColors.text2, size: 14),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? activeColor : AppColors.text2,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.side,
    required this.enabled,
    required this.receipt,
    required this.leverage,
    required this.onTap,
  });

  final TradeFuturesSide side;
  final bool enabled;
  final TradeFuturesReceipt? receipt;
  final int leverage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = side == TradeFuturesSide.long ? _futuresGreen : _futuresRed;
    final label = receipt == null
        ? enabled
              ? 'Mở ${leverage}x ${side == TradeFuturesSide.long ? 'Long' : 'Short'}'
              : 'Nhập ký quỹ'
        : 'Đã gửi ${receipt!.orderId}';
    return InkWell(
      key: FuturesPage.submitKey,
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? color : const Color(0xFF101827),
          gradient: enabled
              ? LinearGradient(
                  colors: [color, Color.lerp(color, Colors.black, .18)!],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: .30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled
                ? Colors.white
                : AppColors.text3.withValues(alpha: .32),
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _warningBg,
        border: Border.all(color: _warningBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Giao dịch hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ. Chỉ giao dịch số tiền bạn có thể chấp nhận mất.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in snapshot.positions) ...[
          _PositionCard(position: position),
          const SizedBox(height: 12),
        ],
        _FuturesAccountCard(snapshot: snapshot),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final TradeFuturesPosition position;

  @override
  Widget build(BuildContext context) {
    final color = position.side == TradeFuturesSide.long
        ? _futuresGreen
        : _futuresRed;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatusPill(
                label: position.side == TradeFuturesSide.long
                    ? 'LONG'
                    : 'SHORT',
                color: color,
              ),
              const SizedBox(width: 8),
              Text(position.symbol, style: AppTextStyles.baseMedium),
              const SizedBox(width: 8),
              _StatusPill(label: '${position.leverage}x', color: _tradeBlue),
              const Spacer(),
              Text(
                '${position.pnl >= 0 ? '+' : '-'}\$${position.pnl.abs().toStringAsFixed(2)}',
                style: AppTextStyles.caption.copyWith(
                  color: position.pnl >= 0 ? _futuresGreen : _futuresRed,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _PositionMetric(
                label: 'Ký quỹ',
                value: _formatMoney(position.margin),
              ),
              _PositionMetric(
                label: 'Giá vào',
                value: _formatMoney(position.entryPrice),
              ),
              _PositionMetric(
                label: 'Thanh lý',
                value: _formatMoney(position.liquidPrice),
                color: _futuresRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
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
          Text(label, style: AppTextStyles.micro),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontFamily: 'monospace',
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturesAccountCard extends StatelessWidget {
  const _FuturesAccountCard({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tài khoản Futures', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          _AccountRow(
            label: 'Số dư',
            value: _formatMoney(snapshot.accountBalance),
          ),
          _AccountRow(
            label: 'Ký quỹ đang dùng',
            value: _formatMoney(snapshot.usedMargin),
          ),
          _AccountRow(
            label: 'Khả dụng',
            value: _formatMoney(snapshot.accountBalance - snapshot.usedMargin),
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.caption),
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
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.onTrade});

  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.text3,
            size: 38,
          ),
          const SizedBox(height: 12),
          Text('Chưa có lệnh Futures', style: AppTextStyles.baseMedium),
          const SizedBox(height: 6),
          Text(
            'Lệnh chờ sẽ hiển thị tại đây.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onTrade,
            child: const Text('Quay lại giao dịch'),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final left = whole.length - i;
    buffer.write(whole[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
