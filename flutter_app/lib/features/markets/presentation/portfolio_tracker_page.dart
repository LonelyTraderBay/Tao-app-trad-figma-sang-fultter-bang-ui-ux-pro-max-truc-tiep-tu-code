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
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;
const _heroPrimary = Color(0xFF0E1D49);

class PortfolioTrackerPage extends ConsumerStatefulWidget {
  const PortfolioTrackerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc021_portfolio_tracker_scroll_content');
  static const overviewTabKey = Key('sc021_tab_overview');
  static const assetsTabKey = Key('sc021_tab_assets');
  static const performanceTabKey = Key('sc021_tab_performance');
  static const hideBalanceKey = Key('sc021_hide_balance');

  static Key sortKey(MarketPortfolioSort sort) =>
      Key('sc021_sort_${sort.name}');

  static Key holdingKey(String id) => Key('sc021_holding_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioTrackerPage> createState() =>
      _PortfolioTrackerPageState();
}

class _PortfolioTrackerPageState extends ConsumerState<PortfolioTrackerPage> {
  String _tab = 'overview';
  String _timeFilter = '30d';
  bool _hideBalance = false;
  MarketPortfolioSort _sortBy = MarketPortfolioSort.value;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getPortfolioTracker(sortBy: _sortBy);
    final overviewHoldings = _overviewHoldings(snapshot.holdings);
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
      semanticLabel: 'SC-021 PortfolioTrackerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Danh mục',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _PortfolioTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PortfolioTrackerPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 12,
                    children: [
                      if (_tab == 'overview') ...[
                        _TotalValueHero(
                          stats: snapshot.stats,
                          hidden: _hideBalance,
                          onToggleHidden: () => setState(() {
                            _hideBalance = !_hideBalance;
                          }),
                        ),
                        _QuickStats(
                          stats: snapshot.stats,
                          hidden: _hideBalance,
                        ),
                        _AllocationCard(holdings: overviewHoldings),
                        const _SectionHeader(
                          label: 'Tài sản chính',
                          accentColor: _marketPrimary,
                        ),
                        _TopHoldings(
                          holdings: overviewHoldings.take(4).toList(),
                          hidden: _hideBalance,
                          onTap: (holding) =>
                              context.go('/pair/${holding.id}usdt'),
                        ),
                        _RiskCard(stats: snapshot.stats),
                      ] else if (_tab == 'assets') ...[
                        _SortChips(
                          active: _sortBy,
                          onSelected: (value) => setState(() {
                            _sortBy = value;
                          }),
                        ),
                        for (final holding in snapshot.holdings)
                          _HoldingDetailCard(
                            key: PortfolioTrackerPage.holdingKey(holding.id),
                            holding: holding,
                            hidden: _hideBalance,
                            onTap: () => context.go('/pair/${holding.id}usdt'),
                          ),
                      ] else ...[
                        _TimeFilterChips(
                          active: _timeFilter,
                          onSelected: (value) => setState(() {
                            _timeFilter = value;
                          }),
                        ),
                        _PerformanceChartCard(
                          stats: snapshot.stats,
                          points: snapshot.performance,
                        ),
                        const _SectionHeader(
                          label: 'Lãi/Lỗ theo tài sản',
                          accentColor: AppColors.buy,
                        ),
                        _PnlBreakdown(
                          holdings: overviewHoldings
                              .where((holding) => holding.symbol != 'USDT')
                              .toList(),
                          hidden: _hideBalance,
                        ),
                        _SummaryStats(
                          stats: snapshot.stats,
                          hidden: _hideBalance,
                        ),
                      ],
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

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: PortfolioTrackerPage.overviewTabKey,
              label: 'Tổng quan',
              value: 'overview',
              active: activeTab == 'overview',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: PortfolioTrackerPage.assetsTabKey,
              label: 'Tài sản',
              value: 'assets',
              active: activeTab == 'assets',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: PortfolioTrackerPage.performanceTabKey,
              label: 'Hiệu suất',
              value: 'performance',
              active: activeTab == 'performance',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalValueHero extends StatelessWidget {
  const _TotalValueHero({
    required this.stats,
    required this.hidden,
    required this.onToggleHidden,
  });

  final PortfolioStats stats;
  final bool hidden;
  final VoidCallback onToggleHidden;

  @override
  Widget build(BuildContext context) {
    final pnlColor = stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_heroPrimary, AppColors.surface],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng giá trị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              InkWell(
                key: PortfolioTrackerPage.hideBalanceKey,
                onTap: onToggleHidden,
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    hidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 16,
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _mask(_formatUsd(stats.totalValue), hidden, long: true),
            style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                stats.totalPnl >= 0
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: 15,
                color: pnlColor,
              ),
              const SizedBox(width: 8),
              Text(
                _mask(
                  '${_formatUsd(stats.totalPnl.abs())} (${_formatSignedPercent(stats.totalPnlPct)})',
                  hidden,
                  long: true,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: pnlColor,
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

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            label: 'Vốn đầu tư',
            value: _mask(_formatCompact(stats.totalCost, prefix: r'$'), hidden),
            color: AppColors.text1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStatCard(
            label: 'Tốt nhất 24h',
            value:
                '${stats.best24hSymbol} ${_formatSignedPercent(stats.best24hChange)}',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStatCard(
            label: 'Kém nhất 24h',
            value:
                '${stats.worst24hSymbol} ${_formatSignedPercent(stats.worst24hChange)}',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ tài sản',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _AllocationDonutPainter(holdings: holdings),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${holdings.length}',
                          style: AppTextStyles.caption.copyWith(
                            color: _marketPrimary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'tài sản',
                          style: AppTextStyles.micro.copyWith(
                            color: _marketPrimary,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  children: [
                    for (final holding in holdings.take(5)) ...[
                      _AllocationLegendRow(holding: holding),
                      if (holding != holdings.take(5).last)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegendRow extends StatelessWidget {
  const _AllocationLegendRow({required this.holding});

  final PortfolioHolding holding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: holding.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            holding.symbol,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          '${holding.allocation.toStringAsFixed(1)}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TopHoldings extends StatelessWidget {
  const _TopHoldings({
    required this.holdings,
    required this.hidden,
    required this.onTap,
  });

  final List<PortfolioHolding> holdings;
  final bool hidden;
  final ValueChanged<PortfolioHolding> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final holding in holdings) ...[
          _HoldingRow(
            key: PortfolioTrackerPage.holdingKey(holding.id),
            holding: holding,
            hidden: hidden,
            onTap: () => onTap(holding),
          ),
          if (holding != holdings.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pnlColor = holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _TokenBadge(holding: holding, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${_mask(holding.quantity.toStringAsFixed(4), hidden)} - ${holding.allocation.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 54,
            height: 22,
            child: CustomPaint(
              painter: _SparklinePainter(
                values: holding.sparkline,
                color: holding.change24h >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 86,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _mask(_formatUsd(holding.value), hidden),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  _formatSignedPercent(holding.pnlPct),
                  style: AppTextStyles.micro.copyWith(
                    color: pnlColor,
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

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.stats});

  final PortfolioStats stats;

  @override
  Widget build(BuildContext context) {
    final balanced = stats.stableAllocation > 20;
    final color = balanced ? AppColors.buy : AppColors.warn;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đánh giá rủi ro',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Text(
                  balanced ? 'Cân bằng' : 'Rủi ro cao',
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stablecoin',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${stats.stableAllocation.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: [
                  Container(color: AppColors.surface2),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: stats.stableAllocation / 100,
                    child: Container(color: AppColors.buy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Danh mục có ${stats.stableAllocation.toStringAsFixed(1)}% stablecoin, giúp giảm biến động. Khuyến nghị duy trì ít nhất 10-20% stablecoin cho quản lý rủi ro.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onSelected});

  final MarketPortfolioSort active;
  final ValueChanged<MarketPortfolioSort> onSelected;

  @override
  Widget build(BuildContext context) {
    const chips = {
      MarketPortfolioSort.value: 'Giá trị',
      MarketPortfolioSort.pnl: 'Lãi/Lỗ',
      MarketPortfolioSort.change: 'Thay đổi 24h',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in chips.entries) ...[
            _ChipButton(
              key: PortfolioTrackerPage.sortKey(entry.key),
              label: entry.value,
              active: active == entry.key,
              onTap: () => onSelected(entry.key),
            ),
            if (entry.key != chips.keys.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _TimeFilterChips extends StatelessWidget {
  const _TimeFilterChips({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = ['24h', '7d', '30d', 'Tất cả'];
    return Row(
      children: [
        for (final filter in filters) ...[
          _ChipButton(
            label: filter,
            active: active == filter,
            onTap: () => onSelected(filter),
          ),
          if (filter != filters.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .15)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .35)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _HoldingDetailCard extends StatelessWidget {
  const _HoldingDetailCard({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _TokenBadge(holding: holding, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holding.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      holding.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _mask(_formatUsd(holding.value), hidden),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${holding.allocation.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HoldingMetric(
                label: 'Số lượng',
                value: _mask(holding.quantity.toStringAsFixed(4), hidden),
              ),
              _HoldingMetric(
                label: 'Giá TB mua',
                value: '\$${_formatPrice(holding.avgBuyPrice)}',
              ),
              _HoldingMetric(
                label: 'Giá hiện tại',
                value: '\$${_formatPrice(holding.currentPrice)}',
              ),
              _HoldingMetric(
                label: 'Lãi/Lỗ',
                value: _mask(_formatSignedPercent(holding.pnlPct), hidden),
                color: holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({
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
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.stats, required this.points});

  final PortfolioStats stats;
  final List<PortfolioPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá trị danh mục',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                _formatSignedPercent(stats.totalPnlPct),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(painter: _PerformancePainter(points: points)),
          ),
        ],
      ),
    );
  }
}

class _PnlBreakdown extends StatelessWidget {
  const _PnlBreakdown({required this.holdings, required this.hidden});

  final List<PortfolioHolding> holdings;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final sorted = [...holdings]..sort((a, b) => b.pnl.compareTo(a.pnl));
    final maxPnl = sorted.fold<double>(
      0,
      (value, holding) => math.max(value, holding.pnl.abs()),
    );
    return Column(
      children: [
        for (final holding in sorted) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                _TokenBadge(holding: holding, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            holding.symbol,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _mask(
                              '${holding.pnl >= 0 ? '+' : ''}${_formatUsd(holding.pnl)}',
                              hidden,
                            ),
                            style: AppTextStyles.caption.copyWith(
                              color: holding.pnl >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: SizedBox(
                          height: 4,
                          child: Stack(
                            children: [
                              Container(color: AppColors.surface2),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: maxPnl == 0
                                    ? 0
                                    : holding.pnl.abs() / maxPnl,
                                child: Container(
                                  color: holding.pnl >= 0
                                      ? AppColors.buy
                                      : AppColors.sell,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (holding != sorted.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(12),
            child: _SummaryStat(
              label: 'Tổng lãi/lỗ',
              value: _mask(
                '${stats.totalPnl >= 0 ? '+' : ''}${_formatUsd(stats.totalPnl)}',
                hidden,
              ),
              color: stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(12),
            child: _SummaryStat(
              label: 'ROI tổng',
              value: _formatSignedPercent(stats.totalPnlPct),
              color: stats.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TokenBadge extends StatelessWidget {
  const _TokenBadge({required this.holding, required this.size});

  final PortfolioHolding holding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: holding.color.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      child: Text(
        holding.symbol.substring(0, math.min(2, holding.symbol.length)),
        style: AppTextStyles.caption.copyWith(
          color: holding.color,
          fontWeight: AppTextStyles.bold,
          fontSize: size <= 28 ? 10 : 12,
        ),
      ),
    );
  }
}

class _AllocationDonutPainter extends CustomPainter {
  const _AllocationDonutPainter({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(
      center: center,
      radius: size.shortestSide / 2 - 8,
    );
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;

    for (final holding in holdings) {
      final sweep = (holding.allocation / 100) * math.pi * 2;
      paint.color = holding.color.withValues(alpha: .86);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationDonutPainter oldDelegate) {
    return oldDelegate.holdings != holdings;
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = maxValue - minValue;
    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = values.length == 1
          ? 0.0
          : index / (values.length - 1) * size.width;
      final normalized = range == 0 ? .5 : (values[index] - minValue) / range;
      final y = size.height - normalized * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

class _PerformancePainter extends CustomPainter {
  const _PerformancePainter({required this.points});

  final List<PortfolioPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final values = [for (final point in points) point.value];
    final minValue = values.reduce(math.min) * .995;
    final maxValue = values.reduce(math.max) * 1.005;
    final range = maxValue - minValue;
    const topPadding = 8.0;
    const bottomPadding = 24.0;
    final chartHeight = size.height - topPadding - bottomPadding;
    final linePath = Path();

    Offset pointAt(int index) {
      final x = index / (points.length - 1) * size.width;
      final normalized = range == 0 ? .5 : (values[index] - minValue) / range;
      final y = topPadding + (1 - normalized) * chartHeight;
      return Offset(x, y);
    }

    for (var index = 0; index < points.length; index += 1) {
      final point = pointAt(index);
      if (index == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
    }

    final areaPath = Path.from(linePath)
      ..lineTo(size.width, topPadding + chartHeight)
      ..lineTo(0, topPadding + chartHeight)
      ..close();
    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, Color(0x0010B981)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    final last = pointAt(points.length - 1);
    canvas
      ..drawCircle(last, 4, Paint()..color = AppColors.buy)
      ..drawCircle(last, 2, Paint()..color = AppColors.text1);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (final index in [0, points.length ~/ 2, points.length - 1]) {
      textPainter.text = TextSpan(
        text: points[index].date,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      final x = (index / (points.length - 1) * size.width).clamp(
        textPainter.width / 2,
        size.width - textPainter.width / 2,
      );
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformancePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

List<PortfolioHolding> _overviewHoldings(List<PortfolioHolding> holdings) {
  const order = ['btc', 'eth', 'usdt', 'sol', 'bnb', 'ada'];
  final sorted = [...holdings];
  sorted.sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));
  return sorted;
}

String _mask(String value, bool hidden, {bool long = false}) {
  if (!hidden) return value;
  return long ? '••••••' : '••••';
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value, 2)}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(2)}';
}

String _formatPrice(double value) {
  if (value >= 1000) return _formatNumber(value, 2);
  if (value >= 1) return _formatNumber(value, 2);
  return _formatNumber(value, 4);
}

String _formatNumber(double value, int fractionDigits) {
  final sign = value < 0 ? '-' : '';
  final fixed = value.abs().toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  if (fractionDigits == 0) return '$sign$buffer';
  return '$sign$buffer.${parts[1]}';
}
