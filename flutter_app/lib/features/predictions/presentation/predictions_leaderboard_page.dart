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
import '../data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsLeaderboardPage extends ConsumerStatefulWidget {
  const PredictionsLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc033_predictions_leaderboard_content');
  static const todayFilterKey = Key('sc033_filter_today');
  static const weeklyFilterKey = Key('sc033_filter_weekly');
  static const monthlyFilterKey = Key('sc033_filter_monthly');
  static const allTimeFilterKey = Key('sc033_filter_all_time');
  static const pnlMetricKey = Key('sc033_metric_pnl');
  static const volumeMetricKey = Key('sc033_metric_volume');
  static const infoKey = Key('sc033_pnl_info');

  static Key traderKey(String user) => Key('sc033_trader_$user');
  static Key biggestWinKey(String user) => Key('sc033_biggest_win_$user');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsLeaderboardPage> createState() =>
      _PredictionsLeaderboardPageState();
}

class _PredictionsLeaderboardPageState
    extends ConsumerState<PredictionsLeaderboardPage> {
  PredictionLeaderboardTimeFilter _timeFilter =
      PredictionLeaderboardTimeFilter.weekly;
  PredictionLeaderboardMetric _metric = PredictionLeaderboardMetric.pnl;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getLeaderboard(timeFilter: _timeFilter, metric: _metric);
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
      semanticLabel: 'SC-033 PredictionsLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Leaderboard',
              subtitle: 'Bảng xếp hạng · Prediction',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsLeaderboardPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _TimeFilters(
                        active: _timeFilter,
                        onSelected: (value) => setState(() {
                          _timeFilter = value;
                        }),
                      ),
                      _MetricTabs(
                        active: _metric,
                        onSelected: (value) => setState(() {
                          _metric = value;
                        }),
                        onInfoTap: () => _showPnlInfo(context),
                      ),
                      _Podium(traders: snapshot.traders.take(3).toList()),
                      _Rankings(snapshot: snapshot),
                      _BiggestWins(snapshot: snapshot),
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

  void _showPnlInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Text(
          'P/L (Profit/Loss) shows how much a trader has gained or lost. '
          'A positive P/L means profit, negative means loss.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _TimeFilters extends StatelessWidget {
  const _TimeFilters({required this.active, required this.onSelected});

  final PredictionLeaderboardTimeFilter active;
  final ValueChanged<PredictionLeaderboardTimeFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = [
      (PredictionLeaderboardTimeFilter.today, 'Today'),
      (PredictionLeaderboardTimeFilter.weekly, 'Weekly'),
      (PredictionLeaderboardTimeFilter.monthly, 'Monthly'),
      (PredictionLeaderboardTimeFilter.allTime, 'All Time'),
    ];

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final item in filters)
            Expanded(
              child: _TimeFilterButton(
                key: _timeFilterKey(item.$1),
                label: item.$2,
                active: active == item.$1,
                onTap: () => onSelected(item.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeFilterButton extends StatelessWidget {
  const _TimeFilterButton({
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.text1 : AppColors.text3,
            fontSize: 12,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _MetricTabs extends StatelessWidget {
  const _MetricTabs({
    required this.active,
    required this.onSelected,
    required this.onInfoTap,
  });

  final PredictionLeaderboardMetric active;
  final ValueChanged<PredictionLeaderboardMetric> onSelected;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetricTab(
          key: PredictionsLeaderboardPage.pnlMetricKey,
          label: 'Profit/Loss',
          icon: Icons.trending_up_rounded,
          active: active == PredictionLeaderboardMetric.pnl,
          onTap: () => onSelected(PredictionLeaderboardMetric.pnl),
          trailing: InkWell(
            key: PredictionsLeaderboardPage.infoKey,
            onTap: onInfoTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppColors.text3,
                size: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _MetricTab(
          key: PredictionsLeaderboardPage.volumeMetricKey,
          label: 'Volume',
          icon: Icons.bar_chart_rounded,
          active: active == PredictionLeaderboardMetric.volume,
          onTap: () => onSelected(PredictionLeaderboardMetric.volume),
        ),
      ],
    );
  }
}

class _MetricTab extends StatelessWidget {
  const _MetricTab({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .38)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? _predictionPrimary : AppColors.text3,
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? _predictionPrimary : AppColors.text3,
                fontSize: 12,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.traders});

  final List<PredictionLeaderboardTraderDraft> traders;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      if (traders.length > 1) traders[1],
      if (traders.isNotEmpty) traders[0],
      if (traders.length > 2) traders[2],
    ];
    const heights = [90.0, 110.0, 75.0];
    const colors = [Color(0xFFC0C0C0), Color(0xFFFFD700), Color(0xFFCD7F32)];
    const labels = ['2nd', '1st', '3rd'];

    return VitCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: SizedBox(
        height: 198,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < ordered.length; index += 1)
              Expanded(
                child: _PodiumColumn(
                  trader: ordered[index],
                  height: heights[index],
                  color: colors[index],
                  label: labels[index],
                  winner: index == 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.trader,
    required this.height,
    required this.color,
    required this.label,
    required this.winner,
  });

  final PredictionLeaderboardTraderDraft trader;
  final double height;
  final Color color;
  final String label;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(trader.avatar, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          trader.user,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatSignedCompact(trader.pnl),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: .18),
                color.withValues(alpha: .04),
              ],
            ),
            border: Border.all(color: color.withValues(alpha: .28)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (winner) ...[
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFFFD700),
                  size: 14,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Rankings extends StatelessWidget {
  const _Rankings({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Rankings',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _RankingHeader(metric: snapshot.metric),
              for (var index = 0; index < snapshot.traders.length; index += 1)
                _RankingRow(
                  key: PredictionsLeaderboardPage.traderKey(
                    snapshot.traders[index].user,
                  ),
                  trader: snapshot.traders[index],
                  metric: snapshot.metric,
                  last: index == snapshot.traders.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingHeader extends StatelessWidget {
  const _RankingHeader({required this.metric});

  final PredictionLeaderboardMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 32, child: _HeaderLabel('#')),
          const Expanded(child: _HeaderLabel('TRADER')),
          SizedBox(
            width: 84,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderLabel(
                metric == PredictionLeaderboardMetric.pnl ? 'P/L' : 'VOLUME',
              ),
            ),
          ),
          const SizedBox(
            width: 58,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderLabel('WIN %'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    super.key,
    required this.trader,
    required this.metric,
    required this.last,
  });

  final PredictionLeaderboardTraderDraft trader;
  final PredictionLeaderboardMetric metric;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(width: 32, child: _RankBadge(rank: trader.rank)),
          Expanded(
            child: Row(
              children: [
                Text(trader.avatar, style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trader.user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${trader.trades} trades',
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
          ),
          SizedBox(
            width: 84,
            child: Text(
              metric == PredictionLeaderboardMetric.pnl
                  ? _formatSignedCompact(trader.pnl)
                  : _formatCurrencyCompact(trader.volume),
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: metric == PredictionLeaderboardMetric.pnl
                    ? AppColors.buy
                    : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 58,
            child: Text(
              '${trader.winRate}%',
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: _winRateColor(trader.winRate),
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return Text(
        '$rank',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      );
    }
    final color = rank == 1
        ? const Color(0xFFFFD700)
        : rank == 2
        ? const Color(0xFFC0C0C0)
        : const Color(0xFFCD7F32);
    return Container(
      width: 21,
      height: 21,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _BiggestWins extends StatelessWidget {
  const _BiggestWins({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.biggestWins.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Biggest Wins',
      accentColor: AppColors.buy,
      children: [
        Text(
          'Top single-trade profits this period',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        for (final trader in snapshot.biggestWins)
          _BiggestWinCard(snapshot: snapshot, trader: trader),
      ],
    );
  }
}

class _BiggestWinCard extends StatelessWidget {
  const _BiggestWinCard({required this.snapshot, required this.trader});

  final PredictionLeaderboardSnapshot snapshot;
  final PredictionLeaderboardTraderDraft trader;

  @override
  Widget build(BuildContext context) {
    final event = snapshot.eventForWin(trader);
    return VitCard(
      key: PredictionsLeaderboardPage.biggestWinKey(trader.user),
      variant: VitCardVariant.inner,
      onTap: event == null
          ? null
          : () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.buy10,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.buy,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(trader.avatar, style: const TextStyle(fontSize: 15)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        trader.user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        trader.biggestWinMarket ?? 'Prediction market',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: event == null
                              ? AppColors.text3
                              : _predictionPrimary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (event != null) ...[
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: _predictionPrimary,
                        size: 10,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatSignedCompact(trader.biggestWin ?? 0),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

Key _timeFilterKey(PredictionLeaderboardTimeFilter filter) {
  return switch (filter) {
    PredictionLeaderboardTimeFilter.today =>
      PredictionsLeaderboardPage.todayFilterKey,
    PredictionLeaderboardTimeFilter.weekly =>
      PredictionsLeaderboardPage.weeklyFilterKey,
    PredictionLeaderboardTimeFilter.monthly =>
      PredictionsLeaderboardPage.monthlyFilterKey,
    PredictionLeaderboardTimeFilter.allTime =>
      PredictionsLeaderboardPage.allTimeFilterKey,
  };
}

Color _winRateColor(int winRate) {
  if (winRate >= 70) return AppColors.buy;
  if (winRate >= 50) return AppColors.warn;
  return AppColors.sell;
}

String _formatSignedCompact(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatCurrencyCompact(value.abs())}';
}

String _formatCurrencyCompact(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}
