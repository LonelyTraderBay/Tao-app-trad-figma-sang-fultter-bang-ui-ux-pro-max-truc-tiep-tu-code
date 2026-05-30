import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

const _marketPrimary = AppColors.primary;

class DerivativesOverviewPage extends ConsumerStatefulWidget {
  const DerivativesOverviewPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc018_derivatives_scroll_content');
  static const overviewTabKey = Key('sc018_tab_overview');
  static const perpetualTabKey = Key('sc018_tab_perpetual');
  static const liquidationTabKey = Key('sc018_tab_liquidation');

  static Key sortKey(MarketDerivativesSort sort) =>
      Key('sc018_sort_${sort.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DerivativesOverviewPage> createState() =>
      _DerivativesOverviewPageState();
}

class _DerivativesOverviewPageState
    extends ConsumerState<DerivativesOverviewPage> {
  String _tab = 'overview';
  MarketDerivativesSort _sortBy = MarketDerivativesSort.openInterest;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getMarketDerivatives(sortBy: _sortBy);
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
      semanticLabel: 'SC-018 DerivativesOverviewPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phái sinh',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _DerivativesTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: DerivativesOverviewPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 10,
                    children: [
                      if (_tab == 'overview') ...[
                        _OpenInterestHero(stats: snapshot.globalStats),
                        _OverviewStatGrid(stats: snapshot.globalStats),
                        _SectionHeader(
                          label: 'Thanh lý theo thời gian (24h)',
                          accentColor: AppColors.sell,
                        ),
                        _LiquidationTimeline(
                          history: snapshot.liquidationHistory,
                          pairs: snapshot.pairs,
                        ),
                        _SectionHeader(
                          label: 'Top Open Interest',
                          accentColor: _marketPrimary,
                        ),
                        _TopOpenInterestList(
                          pairs: snapshot.pairs.take(5).toList(),
                        ),
                      ] else if (_tab == 'perpetual') ...[
                        _SortChips(
                          active: _sortBy,
                          onSelected: (value) => setState(() {
                            _sortBy = value;
                          }),
                        ),
                        for (final pair in snapshot.pairs)
                          _PerpetualPairCard(pair: pair),
                      ] else ...[
                        _LiquidationSummary(stats: snapshot.globalStats),
                        _SectionHeader(
                          label: 'Thanh lý theo cặp',
                          accentColor: AppColors.sell,
                        ),
                        for (final pair
                            in [...snapshot.pairs]..sort(
                              (a, b) => b.totalLiquidations24h.compareTo(
                                a.totalLiquidations24h,
                              ),
                            ))
                          _LiquidationPairCard(pair: pair),
                        const _RiskWarningCard(),
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

class _DerivativesTabs extends StatelessWidget {
  const _DerivativesTabs({required this.activeTab, required this.onChanged});

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
              key: DerivativesOverviewPage.overviewTabKey,
              label: 'Tổng quan',
              value: 'overview',
              active: activeTab == 'overview',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: DerivativesOverviewPage.perpetualTabKey,
              label: 'Perpetual',
              value: 'perpetual',
              active: activeTab == 'perpetual',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: DerivativesOverviewPage.liquidationTabKey,
              label: 'Thanh lý',
              value: 'liquidation',
              active: activeTab == 'liquidation',
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
                    fontWeight: AppTextStyles.medium,
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

class _OpenInterestHero extends StatelessWidget {
  const _OpenInterestHero({required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: .2)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng Open Interest',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCompact(stats.totalOpenInterest, prefix: r'$'),
                style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  _formatSignedPercent(stats.oiChange24h),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
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

class _OverviewStatGrid extends StatelessWidget {
  const _OverviewStatGrid({required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2,
      children: [
        _StatCard(
          icon: Icons.bar_chart_rounded,
          iconColor: _marketPrimary,
          label: 'KL giao dịch 24h',
          value: _formatCompact(stats.totalVolume24h, prefix: r'$'),
          change: _formatSignedPercent(stats.volumeChange24h),
        ),
        _StatCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.sell,
          label: 'Thanh lý 24h',
          value: _formatCompact(stats.totalLiquidations24h, prefix: r'$'),
          subtitle:
              'L: ${_formatCompact(stats.longLiquidations24h, prefix: r'$')} / S: ${_formatCompact(stats.shortLiquidations24h, prefix: r'$')}',
        ),
        _StatCard(
          icon: Icons.show_chart_rounded,
          iconColor: AppColors.accent,
          label: 'Funding TB',
          value: '${(stats.avgFundingRate * 100).toStringAsFixed(4)}%',
          valueColor: AppColors.buy,
          subtitle: '8h rate',
        ),
        _StatCard(
          icon: Icons.balance_rounded,
          iconColor: AppColors.warn,
          label: 'BTC Long/Short',
          value: stats.btcLongShortRatio.toStringAsFixed(2),
          valueColor: AppColors.buy,
          subtitle: 'Long thiên hướng',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.change,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final String? change;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.smRadius,
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: valueColor ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 17,
            ),
          ),
          if (change != null)
            Text(
              '↗ $change',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.medium,
              ),
            )
          else if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
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
            borderRadius: BorderRadius.circular(2),
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

class _LiquidationTimeline extends StatelessWidget {
  const _LiquidationTimeline({required this.history, required this.pairs});

  final List<LiquidationPoint> history;
  final List<DerivativePair> pairs;

  @override
  Widget build(BuildContext context) {
    final maxValue = history.fold<double>(
      0,
      (max, point) => math.max(max, math.max(point.long, point.short)),
    );
    final totalLong = pairs.fold<double>(
      0,
      (sum, pair) => sum + pair.longLiquidations24h,
    );
    final totalShort = pairs.fold<double>(
      0,
      (sum, pair) => sum + pair.shortLiquidations24h,
    );

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final point in history) ...[
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    point.time,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: (point.long / maxValue * 1000).round(),
                        child: const _BarSegment(
                          color: AppColors.buy,
                          leftRadius: true,
                        ),
                      ),
                      Flexible(
                        flex: (point.short / maxValue * 1000).round(),
                        child: const _BarSegment(
                          color: AppColors.sell,
                          rightRadius: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const Divider(height: 18, color: AppColors.borderSolid),
          Row(
            children: [
              _Legend(
                label: 'Long (${_formatCompact(totalLong, prefix: r'$')})',
                color: AppColors.buy,
              ),
              const SizedBox(width: 18),
              _Legend(
                label: 'Short (${_formatCompact(totalShort, prefix: r'$')})',
                color: AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarSegment extends StatelessWidget {
  const _BarSegment({
    required this.color,
    this.leftRadius = false,
    this.rightRadius = false,
  });

  final Color color;
  final bool leftRadius;
  final bool rightRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .78),
        borderRadius: BorderRadius.horizontal(
          left: leftRadius ? const Radius.circular(4) : Radius.zero,
          right: rightRadius ? const Radius.circular(4) : Radius.zero,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox(width: 10, height: 10),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TopOpenInterestList extends StatelessWidget {
  const _TopOpenInterestList({required this.pairs});

  final List<DerivativePair> pairs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pair in pairs) ...[
          _OIPairRow(pair: pair),
          const SizedBox(height: 2),
        ],
      ],
    );
  }
}

class _OIPairRow extends StatelessWidget {
  const _OIPairRow({required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    final up = pair.openInterestChange24h >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _PairLogo(pair: pair, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'OI: ${_formatCompact(pair.openInterest, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatSignedPercent(pair.openInterestChange24h),
                style: AppTextStyles.caption.copyWith(
                  color: up ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '24h',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onSelected});

  final MarketDerivativesSort active;
  final ValueChanged<MarketDerivativesSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final sort in MarketDerivativesSort.values) ...[
            _SortChip(
              key: DerivativesOverviewPage.sortKey(sort),
              sort: sort,
              active: active == sort,
              onTap: () => onSelected(sort),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.sort,
    required this.active,
    required this.onTap,
  });

  final MarketDerivativesSort sort;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .18)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .55)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          _sortLabel(sort),
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _PerpetualPairCard extends StatelessWidget {
  const _PerpetualPairCard({required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _PairLogo(pair: pair, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pair.symbol,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: 7),
                        _TinyPill('${pair.maxLeverage}x'),
                      ],
                    ),
                    Text(
                      'Perpetual',
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
                    '\$${_formatPrice(pair.price)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    _formatSignedPercent(pair.change24h),
                    style: AppTextStyles.micro.copyWith(
                      color: pair.change24h >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.medium,
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
                child: _Metric(
                  label: 'OI',
                  value: _formatCompact(pair.openInterest, prefix: r'$'),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Volume 24h',
                  value: _formatCompact(pair.volume24h, prefix: r'$'),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Funding',
                  value: '${(pair.fundingRate * 100).toStringAsFixed(4)}%',
                  color: pair.fundingRate >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SplitBar(
            leftPercent: pair.longRatio,
            leftLabel: 'Long ${pair.longRatio.toStringAsFixed(1)}%',
            rightLabel: 'Short ${pair.shortRatio.toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }
}

class _LiquidationSummary extends StatelessWidget {
  const _LiquidationSummary({required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    final longPercent =
        stats.longLiquidations24h / stats.totalLiquidations24h * 100;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.sell10],
        ),
        border: Border.all(color: AppColors.sell20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng thanh lý 24h',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCompact(stats.totalLiquidations24h, prefix: r'$'),
            style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 14),
          _SplitBar(
            leftPercent: longPercent,
            leftLabel:
                'Long ${_formatCompact(stats.longLiquidations24h, prefix: r'$')}',
            rightLabel:
                'Short ${_formatCompact(stats.shortLiquidations24h, prefix: r'$')}',
          ),
        ],
      ),
    );
  }
}

class _LiquidationPairCard extends StatelessWidget {
  const _LiquidationPairCard({required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    final longPercent =
        pair.longLiquidations24h / pair.totalLiquidations24h * 100;
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _PairLogo(pair: pair, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      pair.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatCompact(pair.totalLiquidations24h, prefix: r'$'),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                _SplitBar(
                  leftPercent: longPercent,
                  leftLabel:
                      'L: ${_formatCompact(pair.longLiquidations24h, prefix: r'$')}',
                  rightLabel:
                      'S: ${_formatCompact(pair.shortLiquidations24h, prefix: r'$')}',
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Giao dịch phái sinh có rủi ro cao. Đòn bẩy khuếch đại cả lãi lẫn lỗ.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
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

class _SplitBar extends StatelessWidget {
  const _SplitBar({
    required this.leftPercent,
    required this.leftLabel,
    required this.rightLabel,
    this.compact = false,
  });

  final double leftPercent;
  final String leftLabel;
  final String rightLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rightPercent = 100 - leftPercent;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: (leftPercent * 10).round(),
              child: Container(
                height: compact ? 4 : 6,
                decoration: const BoxDecoration(
                  color: AppColors.buy,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: (rightPercent * 10).round(),
              child: Container(
                height: compact ? 4 : 6,
                decoration: const BoxDecoration(
                  color: AppColors.sell,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                leftLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ),
            Text(
              rightLabel,
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

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
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PairLogo extends StatelessWidget {
  const _PairLogo({required this.pair, required this.size});

  final DerivativePair pair;
  final double size;

  @override
  Widget build(BuildContext context) {
    final base = pair.symbol.split('/').first;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        base.length <= 2 ? base : base.substring(0, 2),
        style: AppTextStyles.caption.copyWith(
          color: pair.color,
          fontWeight: AppTextStyles.bold,
          fontSize: size <= 30 ? 10 : 12,
        ),
      ),
    );
  }
}

String _sortLabel(MarketDerivativesSort sort) {
  return switch (sort) {
    MarketDerivativesSort.openInterest => 'OI',
    MarketDerivativesSort.volume => 'Volume',
    MarketDerivativesSort.funding => 'Funding',
    MarketDerivativesSort.change => 'Thay đổi',
  };
}

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_trimFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_trimFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_trimFixed(value / 1000, 2)}K';
  }
  return '$prefix${_trimFixed(value, 2)}';
}

String _formatPrice(double value) {
  if (value >= 1000) return _formatNumber(value, 2);
  if (value >= 1) return _formatNumber(value, 2);
  return _formatNumber(value, 4);
}

String _trimFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

String _formatNumber(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
