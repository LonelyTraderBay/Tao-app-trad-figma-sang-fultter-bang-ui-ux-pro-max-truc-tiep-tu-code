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
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _marginBackground = AppColors.bg;
const _marginCard = AppColors.surface;
const _marginPanel = AppColors.surface2;
const _marginHero = AppColors.surface;
const _marginHeroBorder = AppColors.primary20;
const _marginPrimary = AppColors.primary;
const _marginGreen = Color(0xFF10B981);
const _marginAmber = Color(0xFFF59E0B);
const _marginRed = Color(0xFFEF4444);

class MarginTradingPage extends ConsumerStatefulWidget {
  const MarginTradingPage({
    super.key,
    this.pairId = 'btcusdt',
    this.pairRouteVariant = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc085_margin_trading_content');
  static Key modeKey(String id) => Key('sc085_mode_$id');
  static Key tabKey(String id) => Key('sc085_tab_$id');
  static Key sideKey(String id) => Key('sc085_side_$id');
  static Key orderTypeKey(String id) => Key('sc085_order_type_$id');
  static const leverageKey = Key('sc085_leverage');
  static const maxAmountKey = Key('sc085_max_amount');
  static const submitKey = Key('sc085_submit');

  final String pairId;
  final bool pairRouteVariant;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarginTradingPage> createState() => _MarginTradingPageState();
}

class _MarginTradingPageState extends ConsumerState<MarginTradingPage> {
  late String _mode = 'cross';
  late String _tab = 'trade';
  late String _side = 'long';
  late int _leverage = 5;
  late String _orderType = 'limit';
  String _amount = '0.00';
  bool _showLeverageSheet = false;
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getMarginTrading(
          pairId: widget.pairId,
          pairRouteVariant: widget.pairRouteVariant,
        );
    final modePositions = snapshot.positions
        .where((position) => position.mode == _mode)
        .toList(growable: false);
    final totalPnl = modePositions.fold<double>(
      0,
      (total, position) => total + position.pnl,
    );

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.pairRouteVariant
          ? 'SC-086 MarginTradingPage'
          : 'SC-085 MarginTradingPage',
      child: Material(
        color: _marginBackground,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Margin Trading',
                  subtitle: 'Ký quỹ · Giao dịch',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: MarginTradingPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ClientCategoryCard(category: snapshot.clientCategory),
                        const SizedBox(height: 18),
                        _SegmentedTabs(
                          tabs: snapshot.modeTabs,
                          activeId: _mode,
                          activeColor: _marginPrimary,
                          height: 50,
                          onChanged: (id) => setState(() => _mode = id),
                          keyBuilder: MarginTradingPage.modeKey,
                        ),
                        const SizedBox(height: 16),
                        _AccountHero(
                          account: snapshot.account,
                          totalPnl: totalPnl,
                        ),
                        const SizedBox(height: 18),
                        _SegmentedTabs(
                          tabs: [
                            for (final tab in snapshot.contentTabs)
                              TradeMarginTab(
                                id: tab.id,
                                label: tab.id == 'positions'
                                    ? '${tab.label} (${modePositions.length})'
                                    : tab.label,
                              ),
                          ],
                          activeId: _tab,
                          activeColor: _marginPrimary,
                          height: 46,
                          onChanged: (id) => setState(() => _tab = id),
                          keyBuilder: MarginTradingPage.tabKey,
                        ),
                        const SizedBox(height: 16),
                        if (_tab == 'trade')
                          _TradeTab(
                            snapshot: snapshot,
                            side: _side,
                            leverage: _leverage,
                            orderType: _orderType,
                            amount: _amount,
                            showLeverageSheet: _showLeverageSheet,
                            onSideChanged: (side) =>
                                setState(() => _side = side),
                            onLeverageToggle: () => setState(
                              () => _showLeverageSheet = !_showLeverageSheet,
                            ),
                            onLeverageChanged: (leverage) => setState(() {
                              _leverage = leverage;
                              _showLeverageSheet = false;
                            }),
                            onOrderTypeChanged: (type) =>
                                setState(() => _orderType = type),
                            onMaxAmount: () => setState(() {
                              _amount =
                                  (snapshot.account.availableMargin *
                                          _leverage /
                                          snapshot.pair.price)
                                      .toStringAsFixed(6);
                            }),
                            onNotice: (notice) =>
                                setState(() => _notice = notice),
                          )
                        else if (_tab == 'positions')
                          _PositionsTab(positions: modePositions)
                        else
                          const _OrdersTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_notice != null)
              _NoticeSheet(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _ClientCategoryCard extends StatelessWidget {
  const _ClientCategoryCard({required this.category});

  final TradeMarginClientCategory category;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .28),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _marginAmber.withValues(alpha: .13),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _marginAmber,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.body.copyWith(
                          color: _marginAmber,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _marginAmber.withValues(alpha: .13),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Text(
                        category.badgeLabel,
                        style: AppTextStyles.micro.copyWith(
                          color: _marginAmber,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  category.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                for (final limit in category.limits) ...[
                  _Bullet(text: limit, color: _marginAmber),
                  if (limit != category.limits.last) const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.activeId,
    required this.activeColor,
    required this.height,
    required this.onChanged,
    required this.keyBuilder,
  });

  final List<TradeMarginTab> tabs;
  final String activeId;
  final Color activeColor;
  final double height;
  final ValueChanged<String> onChanged;
  final Key Function(String id) keyBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: keyBuilder(tab.id),
                onTap: () => onChanged(tab.id),
                borderRadius: AppRadii.inputRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tab.id == activeId
                        ? activeColor
                        : Colors.transparent,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: tab.id == activeId
                          ? Colors.white
                          : AppColors.text3,
                      fontSize: 12,
                      fontWeight: tab.id == activeId
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({required this.account, required this.totalPnl});

  final TradeMarginAccount account;
  final double totalPnl;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginHero,
      borderColor: _marginHeroBorder,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng vốn ký quỹ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatMoney(account.totalEquity),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _marginGreen.withValues(alpha: .13),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: _marginGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+${_formatMoneyCompact(totalPnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: _marginGreen,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _HeroStat(
                label: 'Margin đã dùng',
                value: _formatMoneyCompact(account.totalMargin),
                color: _marginAmber,
              ),
              const SizedBox(width: 10),
              _HeroStat(
                label: 'Khả dụng',
                value: _formatMoney(account.availableMargin),
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              _HeroStat(
                label: 'PnL chưa chốt',
                value: '+${_formatMoneyCompact(totalPnl)}',
                color: _marginGreen,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Text(
                'Margin Level',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${account.marginLevel.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: _marginGreen,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: LinearProgressIndicator(
              minHeight: 7,
              value: (account.marginLevel / 300).clamp(0, 1),
              backgroundColor: Colors.white.withValues(alpha: .13),
              valueColor: const AlwaysStoppedAnimation(_marginGreen),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '0%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                '300%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 58,
        padding: const EdgeInsets.fromLTRB(10, 11, 8, 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.15,
              ),
            ),
            const Spacer(),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeTab extends StatelessWidget {
  const _TradeTab({
    required this.snapshot,
    required this.side,
    required this.leverage,
    required this.orderType,
    required this.amount,
    required this.showLeverageSheet,
    required this.onSideChanged,
    required this.onLeverageToggle,
    required this.onLeverageChanged,
    required this.onOrderTypeChanged,
    required this.onMaxAmount,
    required this.onNotice,
  });

  final TradeMarginTradingSnapshot snapshot;
  final String side;
  final int leverage;
  final String orderType;
  final String amount;
  final bool showLeverageSheet;
  final ValueChanged<String> onSideChanged;
  final VoidCallback onLeverageToggle;
  final ValueChanged<int> onLeverageChanged;
  final ValueChanged<String> onOrderTypeChanged;
  final VoidCallback onMaxAmount;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PriceComparison(prices: snapshot.referencePrices),
        const SizedBox(height: 13),
        _PairCard(snapshot: snapshot),
        const SizedBox(height: 13),
        _SideToggle(side: side, onChanged: onSideChanged),
        const SizedBox(height: 15),
        _LeverageSelector(
          leverage: leverage,
          expanded: showLeverageSheet,
          onTap: onLeverageToggle,
        ),
        if (showLeverageSheet) ...[
          const SizedBox(height: 10),
          _LeverageSheet(selected: leverage, onChanged: onLeverageChanged),
        ],
        const SizedBox(height: 13),
        _SegmentedTabs(
          tabs: snapshot.orderDraft.orderTypes,
          activeId: orderType,
          activeColor: _marginPrimary.withValues(alpha: .16),
          height: 46,
          onChanged: onOrderTypeChanged,
          keyBuilder: MarginTradingPage.orderTypeKey,
        ),
        const SizedBox(height: 12),
        if (orderType == 'limit') _PriceInput(price: snapshot.orderDraft.price),
        if (orderType == 'limit') const SizedBox(height: 12),
        _AmountInput(amount: amount, onMaxAmount: onMaxAmount),
        const SizedBox(height: 14),
        _OrderSummary(
          available: snapshot.account.availableMargin,
          liquidationPrice: snapshot.orderDraft.liquidationPriceLabel,
        ),
        const SizedBox(height: 13),
        _SubmitButton(
          side: side,
          leverage: leverage,
          pairSymbol: snapshot.pair.symbol,
          disabled: amount == '0.00',
        ),
        const SizedBox(height: 14),
        _RiskWarningCard(warning: snapshot.riskWarning),
        const SizedBox(height: 14),
        _NegativeBalanceCard(disclosure: snapshot.negativeBalance),
        const SizedBox(height: 14),
        _BestExecutionCard(
          disclosure: snapshot.bestExecution,
          onTap: () => onNotice('Best Execution Report placeholder.'),
        ),
      ],
    );
  }
}

class _PriceComparison extends StatelessWidget {
  const _PriceComparison({required this.prices});

  final TradeMarginReferencePrices prices;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _marginPrimary,
            title: 'Giá tham chiếu',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .06),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PriceColumn(
                    label: 'Mark Price',
                    value: _formatPriceWithDollar(prices.markPrice),
                    large: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .12),
                    border: Border.all(
                      color: _marginPrimary.withValues(alpha: .35),
                    ),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Dùng cho thanh lý',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 9,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Last Price',
                  value: _formatPriceWithDollar(prices.lastPrice),
                ),
              ),
              Text(
                'Giá khớp lệnh gần nhất',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Index Price',
                  value: _formatPriceWithDollar(prices.indexPrice),
                  dim: true,
                ),
              ),
              Text(
                'Avg của các sàn',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _InfoBanner(
            text:
                'Mark Price được dùng để tính PnL và thanh lý, giúp tránh manipulation từ flash crash.',
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.value,
    this.large = false,
    this.dim = false,
  });

  final String label;
  final String value;
  final bool large;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: dim ? AppColors.text2 : Colors.white,
            fontSize: large ? 20 : 16,
            fontWeight: large ? AppTextStyles.bold : AppTextStyles.medium,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.snapshot});

  final TradeMarginTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 104,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                snapshot.pair.symbol,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 17,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: snapshot.defaultMode.toUpperCase(),
                color: _marginPrimary,
              ),
              const Spacer(),
              Container(
                width: 14,
                height: 8,
                decoration: BoxDecoration(
                  color: _marginRed.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Text(
                '--',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                snapshot.pair.quoteAsset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideToggle extends StatelessWidget {
  const _SideToggle({required this.side, required this.onChanged});

  final String side;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _SideButton(
            id: 'long',
            label: 'Long',
            icon: Icons.trending_up_rounded,
            color: _marginGreen,
            active: side == 'long',
            onTap: () => onChanged('long'),
          ),
          const SizedBox(width: 8),
          _SideButton(
            id: 'short',
            label: 'Short',
            icon: Icons.trending_down_rounded,
            color: AppColors.text3,
            active: side == 'short',
            onTap: () => onChanged('short'),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = active ? color : AppColors.text3;
    return Expanded(
      child: InkWell(
        key: MarginTradingPage.sideKey(id),
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .13) : Colors.transparent,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: active ? color.withValues(alpha: .35) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: resolvedColor, size: 17),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: resolvedColor,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSelector extends StatelessWidget {
  const _LeverageSelector({
    required this.leverage,
    required this.expanded,
    required this.onTap,
  });

  final int leverage;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: InkWell(
        key: MarginTradingPage.leverageKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _marginAmber.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: _marginAmber,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đòn bẩy',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhân ${leverage}x giá trị vị thế',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              _MiniBadge(
                label: '${leverage}x',
                color: _marginAmber,
                large: true,
              ),
              const SizedBox(width: 10),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSheet extends StatelessWidget {
  const _LeverageSheet({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [2, 3, 5, 10, 20, 50];
    return _Panel(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in options)
            InkWell(
              onTap: () => onChanged(option),
              borderRadius: AppRadii.mdRadius,
              child: Container(
                width: 55,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == option ? _marginPrimary : _marginCard,
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  '${option}x',
                  style: AppTextStyles.caption.copyWith(
                    color: selected == option ? Colors.white : AppColors.text2,
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

class _PriceInput extends StatelessWidget {
  const _PriceInput({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return _InputCard(label: 'Giá đặt lệnh', suffix: 'USDT', value: price);
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.amount, required this.onMaxAmount});

  final String amount;
  final VoidCallback onMaxAmount;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 97,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số lượng (BTC)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              InkWell(
                key: MarginTradingPage.maxAmountKey,
                onTap: onMaxAmount,
                borderRadius: AppRadii.smRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .08),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    'Tối đa',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            amount,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontSize: 21,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.label,
    required this.suffix,
    required this.value,
  });

  final String label;
  final String suffix;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 90,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                suffix,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.available,
    required this.liquidationPrice,
  });

  final double available;
  final String liquidationPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _SummaryRow('Margin khả dụng', _formatMoney(available), Colors.white),
          const SizedBox(height: 9),
          _SummaryRow('Giá thanh lý (ước tính)', liquidationPrice, _marginRed),
          const SizedBox(height: 9),
          const _SummaryRow('Phí giao dịch (0.05%)', '--', AppColors.text2),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.side,
    required this.leverage,
    required this.pairSymbol,
    required this.disabled,
  });

  final String side;
  final int leverage;
  final String pairSymbol;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: MarginTradingPage.submitKey,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled
            ? _marginPrimary.withValues(alpha: .06)
            : (side == 'long' ? _marginGreen : _marginRed),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        'Mở ${side == 'long' ? 'Long' : 'Short'} $pairSymbol (${leverage}x)',
        style: AppTextStyles.body.copyWith(
          color: disabled
              ? AppColors.text3.withValues(alpha: .45)
              : Colors.white,
          fontSize: 15,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.warning});

  final TradeMarginRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .35),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _marginAmber,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in warning.items) ...[
                  _Bullet(text: item, color: _marginAmber),
                  if (item != warning.items.last) const SizedBox(height: 9),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NegativeBalanceCard extends StatelessWidget {
  const _NegativeBalanceCard({required this.disclosure});

  final TradeMarginSafetyDisclosure disclosure;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginGreen.withValues(alpha: .07),
      borderColor: _marginGreen.withValues(alpha: .18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginGreen.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _marginGreen,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: _marginGreen,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  disclosure.footer,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
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

class _BestExecutionCard extends StatelessWidget {
  const _BestExecutionCard({required this.disclosure, required this.onTap});

  final TradeMarginBestExecutionDisclosure disclosure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _marginPrimary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in disclosure.items) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _marginPrimary,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item != disclosure.items.last) const SizedBox(height: 5),
                ],
                const SizedBox(height: 12),
                InkWell(
                  onTap: onTap,
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _marginPrimary.withValues(alpha: .12),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      disclosure.actionLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: _marginPrimary,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
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

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeMarginPosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return _Panel(
        padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 16),
        child: Column(
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.text3,
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              'Chưa có vị thế',
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final TradeMarginPosition position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? _marginGreen : _marginRed;
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                position.pair,
                style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: '${position.side.toUpperCase()} ${position.leverage}x',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ValueText('PnL', _signedMoney(position.pnl), color),
              ),
              Expanded(
                child: _ValueText(
                  'Liq. Price',
                  _formatPrice(position.liquidationPrice),
                  _marginRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 16),
      child: Column(
        children: [
          const Icon(Icons.adjust_rounded, color: AppColors.text3, size: 34),
          const SizedBox(height: 12),
          Text(
            'Không có lệnh chờ',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Các lệnh limit đang chờ khớp sẽ hiển thị tại đây',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 15,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: _marginPrimary.withValues(alpha: .07),
        border: Border.all(color: _marginPrimary.withValues(alpha: .28)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _marginPrimary,
            size: 13,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _marginPrimary,
                fontSize: 10,
                height: 1.45,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.color = _marginCard,
    this.borderColor = AppColors.cardBorder,
    this.padding,
    this.minHeight,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
    required this.color,
    this.large = false,
  });

  final String label;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 8,
        vertical: large ? 7 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(large ? 13 : 9),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: large ? 15 : 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 11,
            height: 1.45,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText(this.label, this.value, this.color);

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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _NoticeSheet extends StatelessWidget {
  const _NoticeSheet({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0x99000000)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Margin trading',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: onClose,
                  borderRadius: AppRadii.inputRadius,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _marginPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
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

String _formatMoney(double value) {
  return '\$${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}';
}

String _formatMoneyCompact(double value) => _formatMoney(value);

String _signedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatMoney(value.abs())}';
}

String _formatPriceWithDollar(double value) => '\$${_formatPrice(value)}';

String _formatPrice(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
