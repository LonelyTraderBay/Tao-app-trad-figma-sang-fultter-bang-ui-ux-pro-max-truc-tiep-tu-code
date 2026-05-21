import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketBlue = Color(0xFF3B82F6);

enum _PairView { chart, orderBook, trades }

class PairDetailPage extends ConsumerStatefulWidget {
  const PairDetailPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc044_pair_detail_content');
  static const chartTabKey = Key('sc044_view_chart');
  static const orderBookTabKey = Key('sc044_view_orderbook');
  static const tradesTabKey = Key('sc044_view_trades');
  static const infoButtonKey = Key('sc044_token_info');
  static const depthButtonKey = Key('sc044_market_depth');
  static const dcaButtonKey = Key('sc044_dca_button');
  static const buyButtonKey = Key('sc044_buy');
  static const sellButtonKey = Key('sc044_sell');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PairDetailPage> createState() => _PairDetailPageState();
}

class _PairDetailPageState extends ConsumerState<PairDetailPage> {
  _PairView _activeView = _PairView.chart;
  String _timeframe = '1H';
  final Set<String> _indicators = {'MA', 'Vol'};
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = true;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getPairDetail(widget.pairId);
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-044 PairDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _PairHeader(
              pair: pair,
              favorite: _favorite,
              onBack: () => context.go(AppRoutePaths.home),
              onPairTap: () => context.go(AppRoutePaths.markets),
              onFavorite: () => setState(() => _favorite = !_favorite),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PairDetailPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PriceOverview(pair: pair),
                      _ViewTabs(
                        activeView: _activeView,
                        onChanged: (view) => setState(() => _activeView = view),
                      ),
                      if (_activeView == _PairView.chart) ...[
                        _TimeframeRow(
                          active: _timeframe,
                          onChanged: (value) =>
                              setState(() => _timeframe = value),
                        ),
                        _IndicatorRow(
                          active: _indicators,
                          onToggle: (value) => setState(() {
                            if (_indicators.contains(value)) {
                              _indicators.remove(value);
                            } else {
                              _indicators.add(value);
                            }
                          }),
                          onAdvanced: () => context.go(
                            AppRoutePaths.tradeAdvancedChart(pair.id),
                          ),
                        ),
                        _PairChart(series: snapshot.activeChartSeries),
                      ] else if (_activeView == _PairView.orderBook) ...[
                        _OrderBookPanel(snapshot: snapshot),
                      ] else ...[
                        _TradesPanel(trades: snapshot.recentTrades),
                      ],
                      const _RiskWarning(),
                      _LinkCard(
                        key: PairDetailPage.dcaButtonKey,
                        icon: Icons.repeat_rounded,
                        iconColor: AppColors.accent,
                        title: 'Mua dinh ky BTC',
                        subtitle:
                            'Tu dong mua theo lich - Giam rui ro bien dong',
                        onTap: () => context.go(AppRoutePaths.dca),
                      ),
                      _LinkCard(
                        key: PairDetailPage.infoButtonKey,
                        icon: Icons.info_outline_rounded,
                        iconColor: _marketBlue,
                        title: 'Thong tin ${pair.baseAsset}',
                        subtitle: 'Tokenomics - On-chain - Du an',
                        onTap: () =>
                            context.go(AppRoutePaths.pairInfo(pair.id)),
                      ),
                      _LinkCard(
                        key: PairDetailPage.depthButtonKey,
                        icon: Icons.layers_rounded,
                        iconColor: const Color(0xFF06B6D4),
                        title: 'Do sau thi truong',
                        subtitle: 'Depth chart - Whale alerts - So lenh',
                        onTap: () =>
                            context.go(AppRoutePaths.pairDepth(pair.id)),
                      ),
                      _TradeCtas(pairId: pair.id),
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
}

class _PairHeader extends StatelessWidget {
  const _PairHeader({
    required this.pair,
    required this.favorite,
    required this.onBack,
    required this.onPairTap,
    required this.onFavorite,
  });

  final MarketPair pair;
  final bool favorite;
  final VoidCallback onBack;
  final VoidCallback onPairTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _HeaderButton(icon: Icons.chevron_left_rounded, onTap: onBack),
              const Spacer(),
              InkWell(
                onTap: onPairTap,
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: pair.logoColor.withValues(alpha: .15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          pair.baseAsset,
                          style: AppTextStyles.micro.copyWith(
                            color: pair.logoColor,
                            fontWeight: AppTextStyles.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        pair.symbol,
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text2,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 76,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _HeaderSmallIcon(
                      onTap: onFavorite,
                      icon: Icon(
                        favorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 24,
                      ),
                    ),
                    const _HeaderSmallIcon(
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColors.text3,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSmallIcon extends StatelessWidget {
  const _HeaderSmallIcon({required this.icon, this.onTap});

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 38,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.mdRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Icon(icon, color: AppColors.text1, size: 22),
        ),
      ),
    );
  }
}

class _PriceOverview extends StatelessWidget {
  const _PriceOverview({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _formatPrice(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heroNumber.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 31,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: positive ? AppColors.buy15 : AppColors.sell15,
                  borderRadius: AppRadii.smRadius,
                ),
                child: Text(
                  '${positive ? '▲' : '▼'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: positive ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _PriceStat(
                  label: '24h Cao',
                  value: _formatPrice(pair.high24h),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _PriceStat(
                  label: '24h Thap',
                  value: _formatPrice(pair.low24h),
                  color: AppColors.sell,
                ),
              ),
              Expanded(
                child: _PriceStat(
                  label: 'KL 24h',
                  value: '${_formatCompact(pair.volume24h)}B',
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceStat extends StatelessWidget {
  const _PriceStat({
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'monospace',
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ViewTabs extends StatelessWidget {
  const _ViewTabs({required this.activeView, required this.onChanged});

  final _PairView activeView;
  final ValueChanged<_PairView> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PairDetailPage.chartTabKey,
        view: _PairView.chart,
        icon: Icons.show_chart_rounded,
        label: 'Bieu do',
      ),
      (
        key: PairDetailPage.orderBookTabKey,
        view: _PairView.orderBook,
        icon: Icons.bar_chart_rounded,
        label: 'So lenh',
      ),
      (
        key: PairDetailPage.tradesTabKey,
        view: _PairView.trades,
        icon: Icons.currency_exchange_rounded,
        label: 'Giao dich',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        children: [
          for (final tab in tabs) ...[
            Expanded(
              child: _ViewTab(
                key: tab.key,
                selected: activeView == tab.view,
                icon: tab.icon,
                label: tab.label,
                onTap: () => onChanged(tab.view),
              ),
            ),
            if (tab.view != _PairView.trades) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ViewTab extends StatelessWidget {
  const _ViewTab({
    super.key,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _marketBlue.withValues(alpha: .2) : Colors.transparent,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: selected
                  ? _marketBlue.withValues(alpha: .45)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? _marketBlue : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? _marketBlue : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
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

class _TimeframeRow extends StatelessWidget {
  const _TimeframeRow({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = ['15m', '1H', '4H', '1D', '1W', '1M'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 20, 5),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(item),
                borderRadius: AppRadii.cardRadius,
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == item
                        ? _marketBlue.withValues(alpha: .2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item,
                    style: AppTextStyles.micro.copyWith(
                      color: active == item ? _marketBlue : AppColors.text3,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
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

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.active,
    required this.onToggle,
    required this.onAdvanced,
  });

  final Set<String> active;
  final ValueChanged<String> onToggle;
  final VoidCallback onAdvanced;

  @override
  Widget build(BuildContext context) {
    const items = ['MA', 'EMA', 'BOLL', 'MACD', 'RSI', 'Vol'];
    return SizedBox(
      height: 42,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          for (final item in items) ...[
            _IndicatorChip(
              label: item,
              selected: active.contains(item),
              onTap: () => onToggle(item),
            ),
            const SizedBox(width: 8),
          ],
          _AdvancedChip(onTap: onAdvanced),
        ],
      ),
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  const _IndicatorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _marketBlue.withValues(alpha: .2) : AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? _marketBlue.withValues(alpha: .5)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? _marketBlue : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdvancedChip extends StatelessWidget {
  const _AdvancedChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warn.withValues(alpha: .12),
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.warn.withValues(alpha: .32)),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            'Nang cao',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.warn,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _PairChart extends StatelessWidget {
  const _PairChart({required this.series});

  final List<double> series;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: CustomPaint(
        painter: _PairChartPainter(series),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .08),
        border: Border.all(color: AppColors.warn.withValues(alpha: .24)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Giao dich crypto co rui ro cao. Chi dau tu so tien ban co the chiu mat.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
      child: VitCard(
        borderColor: iconColor.withValues(alpha: .18),
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: iconColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeCtas extends StatelessWidget {
  const _TradeCtas({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: _TradeButton(
              key: PairDetailPage.buyButtonKey,
              label: 'MUA',
              color: AppColors.buy,
              shadowColor: AppColors.buy,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=buy'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TradeButton(
              key: PairDetailPage.sellButtonKey,
              label: 'BAN',
              color: AppColors.sell,
              shadowColor: AppColors.sell,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=sell'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeButton extends StatelessWidget {
  const _TradeButton({
    super.key,
    required this.label,
    required this.color,
    required this.shadowColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color shadowColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadii.cardRadius,
      elevation: 0,
      shadowColor: shadowColor.withValues(alpha: .3),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: 55,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.snapshot});

  final MarketPairDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: VitCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'So lenh ${snapshot.pair.symbol}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Mid ${_formatPrice(snapshot.depth.midPrice)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final level in snapshot.depth.asks.take(4).toList().reversed)
              _DepthRow(level: level, side: MarketOrderSide.sell),
            const Divider(color: AppColors.divider, height: 20),
            for (final level in snapshot.depth.bids.take(4))
              _DepthRow(level: level, side: MarketOrderSide.buy),
          ],
        ),
      ),
    );
  }
}

class _DepthRow extends StatelessWidget {
  const _DepthRow({required this.level, required this.side});

  final MarketDepthLevel level;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(level.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontFamily: 'monospace',
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              level.quantity.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Expanded(
            child: Text(
              level.cumulative.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradesPanel extends StatelessWidget {
  const _TradesPanel({required this.trades});

  final List<MarketRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: VitCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const _TradeHeader(),
            for (final trade in trades) _TradeRow(trade: trade),
          ],
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text('Gia', style: _tableHeaderStyle())),
          Expanded(
            child: Text(
              'Khoi luong',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            child: Text(
              'Thoi gian',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  const _TradeRow({required this.trade});

  final MarketRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final color = trade.side == MarketOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(trade.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontFamily: 'monospace',
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.amount.toStringAsFixed(4),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Expanded(
            child: Text(
              trade.time,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairChartPainter extends CustomPainter {
  const _PairChartPainter(this.series);

  final List<double> series;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(52, 12, size.width - 64, size.height - 42);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(
      color: AppColors.text3,
      fontSize: 10,
    );
    final values = series.isEmpty ? [0.0, 1.0] : series;
    final minValue = values.reduce(math.min) - 120;
    final maxValue = values.reduce(math.max) + 120;

    for (var i = 0; i < 4; i += 1) {
      final y = plot.top + (plot.height / 3) * i;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final value = maxValue - ((maxValue - minValue) / 3) * i;
      _drawText(
        canvas,
        value.toStringAsFixed(0),
        Offset(28, y - 8),
        labelStyle,
      );
    }

    final path = Path();
    for (var i = 0; i < values.length; i += 1) {
      final x = plot.left + (plot.width / (values.length - 1)) * i;
      final normalized = (values[i] - minValue) / (maxValue - minValue);
      final y = plot.bottom - normalized * plot.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(plot.right, plot.bottom)
      ..lineTo(plot.left, plot.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x3310B981), Color(0x0010B981)],
      ).createShader(plot);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    const times = ['23:00', '09:00', '19:00', '05:00', '15:00'];
    for (var i = 0; i < times.length; i += 1) {
      final x = plot.left + (plot.width / (times.length - 1)) * i;
      _drawText(canvas, times[i], Offset(x - 14, plot.bottom + 8), labelStyle);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _PairChartPainter oldDelegate) {
    return oldDelegate.series != series;
  }
}

TextStyle _tableHeaderStyle() {
  return AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 10);
}

String _formatPrice(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}

String _formatCompact(double value) {
  if (value >= 1000000000) {
    return (value / 1000000000).toStringAsFixed(2);
  }
  if (value >= 1000000) {
    return (value / 1000000).toStringAsFixed(2);
  }
  return value.toStringAsFixed(0);
}
