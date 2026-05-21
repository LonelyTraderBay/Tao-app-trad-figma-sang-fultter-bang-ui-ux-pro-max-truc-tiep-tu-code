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
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _profileBlue = Color(0xFF3B82F6);
const _profileGreen = Color(0xFF10B981);
const _profileAmber = Color(0xFFF59E0B);
const _profileRed = Color(0xFFEF4444);
const _profileCard = Color(0xFF10141B);

class TraderProfilePage extends ConsumerStatefulWidget {
  const TraderProfilePage({
    super.key,
    required this.traderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc087_trader_profile_content');
  static const copyButtonKey = Key('sc087_trader_profile_copy');
  static Key tabKey(String id) => Key('sc087_trader_profile_tab_$id');

  final String traderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TraderProfilePage> createState() => _TraderProfilePageState();
}

class _TraderProfilePageState extends ConsumerState<TraderProfilePage> {
  String _tab = 'overview';
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getTraderProfile(traderId: widget.traderId);
    final trader = snapshot.trader;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-087 TraderProfilePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Trader Profile',
              subtitle: 'Hồ sơ · Trade',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: TraderProfilePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHero(
                      trader: trader,
                      isFollowing: _isFollowing,
                      onToggleFollow: () =>
                          setState(() => _isFollowing = !_isFollowing),
                    ),
                    const SizedBox(height: 16),
                    _SegmentTabs(
                      activeId: _tab,
                      tabs: const [
                        _TraderTab(id: 'overview', label: 'Tổng quan'),
                        _TraderTab(id: 'trades', label: 'Giao dịch'),
                        _TraderTab(id: 'stats', label: 'Thống kê'),
                      ],
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    const SizedBox(height: 16),
                    if (_tab == 'overview')
                      _OverviewTab(snapshot: snapshot)
                    else if (_tab == 'trades')
                      _TradesTab(trades: snapshot.recentTrades)
                    else
                      _StatsTab(trader: trader),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.trader,
    required this.isFollowing,
    required this.onToggleFollow,
  });

  final TradeCopyTrader trader;
  final bool isFollowing;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final risk = _riskPresentation(trader.riskLevel);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A2550)],
        ),
        border: Border.all(color: _profileBlue.withValues(alpha: .25)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _profileBlue.withValues(alpha: .13),
                  border: Border.all(
                    color: _profileBlue.withValues(alpha: .28),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  trader.avatar,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: _profileBlue,
                    fontSize: 22,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trader.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: AppTextStyles.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (isFollowing)
                          const Icon(
                            Icons.star_rounded,
                            color: _profileAmber,
                            size: 17,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in trader.tags) _TagChip(label: tag),
                        _TagChip(
                          label: 'Rủi ro: ${risk.label}',
                          color: risk.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroMetric(
                label: 'Tổng ROI',
                value: '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'Win Rate',
                value: '${trader.winRate.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'Sharpe',
                value: trader.sharpeRatio.toStringAsFixed(2),
                color: _profileAmber,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'MDD',
                value: '${trader.maxDrawdown.toStringAsFixed(1)}%',
                color: _profileRed,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Copiers: ${trader.copiers} / ${trader.maxCopiers}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${trader.maxCopiers - trader.copiers} slots trống',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: (trader.copiers / trader.maxCopiers).clamp(0, 1),
              backgroundColor: Colors.white.withValues(alpha: .10),
              valueColor: const AlwaysStoppedAnimation(_profileBlue),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            key: TraderProfilePage.copyButtonKey,
            onTap: onToggleFollow,
            borderRadius: AppRadii.cardRadius,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isFollowing
                    ? _profileRed.withValues(alpha: .15)
                    : _profileBlue,
                border: isFollowing
                    ? Border.all(color: _profileRed.withValues(alpha: .3))
                    : null,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing
                        ? Icons.warning_amber_rounded
                        : Icons.content_copy_rounded,
                    color: isFollowing ? _profileRed : Colors.white,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFollowing ? 'Hủy theo dõi' : 'Copy Trader này',
                    style: AppTextStyles.body.copyWith(
                      color: isFollowing ? _profileRed : Colors.white,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.text2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withValues(alpha: .08),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: chipColor,
          fontSize: 10,
          fontWeight: AppTextStyles.medium,
          height: 1,
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
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
        height: 54,
        padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .05),
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
                color: AppColors.text3,
                fontSize: 9,
                height: 1,
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

class _TraderTab {
  const _TraderTab({required this.id, required this.label});

  final String id;
  final String label;
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({
    required this.activeId,
    required this.tabs,
    required this.onChanged,
  });

  final String activeId;
  final List<_TraderTab> tabs;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: TraderProfilePage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                borderRadius: AppRadii.mdRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: activeId == tab.id
                        ? _profileBlue
                        : Colors.transparent,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    tab.label,
                    style: AppTextStyles.caption.copyWith(
                      color: activeId == tab.id
                          ? Colors.white
                          : AppColors.text3,
                      fontSize: 12,
                      fontWeight: activeId == tab.id
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeTraderProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChartCard(
          title: 'PnL tích lũy (30 ngày)',
          trailing: _signedUsd(snapshot.trader.totalPnl),
          child: SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _AreaChartPainter(points: snapshot.pnlHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'PnL hằng ngày',
          child: SizedBox(
            height: 100,
            child: CustomPaint(
              painter: _DailyBarsPainter(
                points: snapshot.pnlHistory.takeLast(14),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _DetailsCard(trader: snapshot.trader),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.caption.copyWith(
                    color: _profileGreen,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final details = [
      _DetailItem(
        Icons.bar_chart_rounded,
        'Tổng lệnh',
        _formatInt(trader.totalTrades),
      ),
      _DetailItem(
        Icons.schedule_rounded,
        'TG nắm giữ TB',
        trader.avgHoldingTime,
      ),
      _DetailItem(
        Icons.people_alt_rounded,
        'Copiers hiện tại',
        _formatInt(trader.copiers),
      ),
      _DetailItem(Icons.shield_outlined, 'AUM', _compactUsd(trader.aum)),
      _DetailItem(
        Icons.track_changes_rounded,
        'Max Drawdown',
        '${trader.maxDrawdown.toStringAsFixed(1)}%',
      ),
      _DetailItem(
        Icons.bolt_rounded,
        'Sharpe Ratio',
        trader.sharpeRatio.toStringAsFixed(2),
      ),
    ];

    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chi tiết',
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  for (final item in details)
                    SizedBox(
                      width: itemWidth,
                      child: _DetailRow(item: item),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  const _DetailItem(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.icon, color: AppColors.text3, size: 15),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.value,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TradesTab extends StatelessWidget {
  const _TradesTab({required this.trades});

  final List<TradeTraderRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final trade in trades) ...[
          _TradeCard(trade: trade),
          if (trade != trades.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeTraderRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final isProfit = trade.pnl >= 0;
    final sideColor = trade.side == 'long' ? _profileGreen : _profileRed;
    return _Panel(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                trade.pair,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              _MiniBadge(label: trade.side.toUpperCase(), color: sideColor),
              if (trade.status == 'open') ...[
                const SizedBox(width: 6),
                const _MiniBadge(label: 'OPEN', color: _profileBlue),
              ],
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _signedUsd(trade.pnl),
                    style: AppTextStyles.caption.copyWith(
                      color: isProfit ? _profileGreen : _profileRed,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trade.pnlPct >= 0 ? '+' : ''}${trade.pnlPct.toStringAsFixed(2)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: isProfit ? _profileGreen : _profileRed,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 5,
                  children: [
                    _TradePrice(
                      label: 'Entry:',
                      value: _formatPrice(trade.entry),
                    ),
                    if (trade.exit != null)
                      _TradePrice(
                        label: 'Exit:',
                        value: _formatPrice(trade.exit!),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                trade.time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _TradePrice extends StatelessWidget {
  const _TradePrice({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 10,
          height: 1,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: '\$$value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  const _StatsTab({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final wins = (trader.totalTrades * trader.winRate / 100).round();
    final losses = trader.totalTrades - wins;
    final rows = [
      _StatRow('Tổng PnL', _signedUsd(trader.totalPnl), _profileGreen),
      _StatRow(
        'ROI tổng',
        '+${trader.totalPnlPct.toStringAsFixed(1)}%',
        _profileGreen,
      ),
      _StatRow(
        'Sharpe Ratio',
        trader.sharpeRatio.toStringAsFixed(2),
        _profileAmber,
      ),
      _StatRow(
        'Max Drawdown',
        '${trader.maxDrawdown.toStringAsFixed(1)}%',
        _profileRed,
      ),
      _StatRow('Avg Holding Time', trader.avgHoldingTime, Colors.white),
      _StatRow('Tổng lệnh', _formatInt(trader.totalTrades), Colors.white),
      _StatRow('AUM', _compactUsd(trader.aum), _profileBlue),
      _StatRow(
        'Copiers',
        '${trader.copiers} / ${trader.maxCopiers}',
        _profileBlue,
      ),
    ];

    return Column(
      children: [
        _Panel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tỷ lệ thắng/thua',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 12,
                        child: Row(
                          children: [
                            Expanded(
                              flex: trader.winRate.round(),
                              child: const ColoredBox(color: _profileGreen),
                            ),
                            Expanded(
                              flex: 100 - trader.winRate.round(),
                              child: const ColoredBox(color: _profileRed),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 54,
                    child: Text(
                      '${trader.winRate.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  _LegendDot(color: _profileGreen, label: 'Thắng: $wins'),
                  const Spacer(),
                  _LegendDot(color: _profileRed, label: 'Thua: $losses'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Panel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thống kê chi tiết',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 9),
              for (final row in rows) _StatsLine(row: row),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow {
  const _StatRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

class _StatsLine extends StatelessWidget {
  const _StatsLine({required this.row});

  final _StatRow row;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1,
              ),
            ),
          ),
          Text(
            row.value,
            style: AppTextStyles.caption.copyWith(
              color: row.color,
              fontSize: 13,
              fontWeight: AppTextStyles.medium,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _profileCard,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _RiskPresentation {
  const _RiskPresentation(this.color, this.label);

  final Color color;
  final String label;
}

_RiskPresentation _riskPresentation(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => const _RiskPresentation(_profileGreen, 'Thấp'),
    TradeCopyRiskLevel.medium => const _RiskPresentation(
      _profileAmber,
      'Trung bình',
    ),
    TradeCopyRiskLevel.high => const _RiskPresentation(_profileRed, 'Cao'),
  };
}

class _AreaChartPainter extends CustomPainter {
  const _AreaChartPainter({required this.points});

  final List<TradeTraderPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    const padding = 4.0;
    final values = points.map((point) => point.cumPnl).toList(growable: false);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(1, maxValue - minValue);
    final linePath = Path();
    final areaPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = padding + (size.width - padding * 2) * i / (values.length - 1);
      final y =
          padding +
          (size.height - padding * 2) * (1 - (values[i] - minValue) / span);
      if (i == 0) {
        linePath.moveTo(x, y);
        areaPath.moveTo(x, size.height - padding);
        areaPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
    }
    areaPath
      ..lineTo(size.width - padding, size.height - padding)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _profileGreen.withValues(alpha: .30),
          _profileGreen.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    final linePaint = Paint()
      ..color = _profileGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DailyBarsPainter extends CustomPainter {
  const _DailyBarsPainter({required this.points});

  final List<TradeTraderPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxAbs = points
        .map((point) => point.pnl.abs())
        .fold<double>(0, math.max)
        .clamp(1, double.infinity);
    final zeroY = size.height * .58;
    final gap = 5.0;
    final barWidth = (size.width - gap * (points.length - 1)) / points.length;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final height = (point.pnl.abs() / maxAbs) * (size.height * .46);
      final left = i * (barWidth + gap);
      final top = point.pnl >= 0 ? zeroY - height : zeroY;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height.clamp(3, size.height)),
        const Radius.circular(3),
      );
      final paint = Paint()
        ..color = point.pnl >= 0 ? _profileGreen : _profileRed;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DailyBarsPainter oldDelegate) =>
      oldDelegate.points != points;
}

extension _TakeLast<T> on Iterable<T> {
  List<T> takeLast(int count) {
    final list = toList(growable: false);
    if (list.length <= count) return list;
    return list.sublist(list.length - count);
  }
}

String _signedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _compactUsd(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(value >= 10000000 ? 1 : 2)}M';
  }
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

String _formatPrice(double value) {
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

String _formatInt(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}
