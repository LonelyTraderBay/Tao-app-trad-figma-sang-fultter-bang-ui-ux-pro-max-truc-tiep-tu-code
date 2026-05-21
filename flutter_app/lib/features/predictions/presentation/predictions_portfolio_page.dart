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

const _predictionBlue = Color(0xFF3B82F6);

class PredictionsPortfolioPage extends ConsumerStatefulWidget {
  const PredictionsPortfolioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc031_predictions_portfolio_content');
  static const visibilityToggleKey = Key('sc031_visibility_toggle');
  static const activeTabKey = Key('sc031_tab_active');
  static const closedTabKey = Key('sc031_tab_closed');
  static const historyTabKey = Key('sc031_tab_history');
  static const arenaBridgeKey = Key('sc031_arena_bridge');

  static Key positionKey(String id) => Key('sc031_position_$id');
  static Key openOrderKey(String id) => Key('sc031_open_order_$id');
  static Key cancelOrderKey(String id) => Key('sc031_cancel_order_$id');
  static Key receiptKey(String id) => Key('sc031_receipt_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsPortfolioPage> createState() =>
      _PredictionsPortfolioPageState();
}

enum _PortfolioTab { active, closed, history }

class _PredictionsPortfolioPageState
    extends ConsumerState<PredictionsPortfolioPage> {
  _PortfolioTab _activeTab = _PortfolioTab.active;
  bool _isHidden = false;
  final Set<String> _cancelledOrderIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(predictionsRepositoryProvider).getPortfolio();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);
    final openOrders = snapshot.openOrders
        .where((order) => !_cancelledOrderIds.contains(order.id))
        .toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-031 PredictionsPortfolioPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Prediction Portfolio',
              subtitle: 'Danh mục · Prediction',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsPortfolioPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _SummaryCard(
                        snapshot: snapshot,
                        openOrderCount: openOrders.length,
                        isHidden: _isHidden,
                        onToggleHidden: () => setState(() {
                          _isHidden = !_isHidden;
                        }),
                      ),
                      const _SharesNote(),
                      _PortfolioTabs(
                        activeTab: _activeTab,
                        activeCount: snapshot.activeCount,
                        closedCount: snapshot.closedCount,
                        historyCount: snapshot.historyCount,
                        onChanged: (tab) => setState(() {
                          _activeTab = tab;
                        }),
                      ),
                      if (_activeTab == _PortfolioTab.active)
                        _PositionsList(
                          snapshot: snapshot,
                          positions: snapshot.activePositions,
                        )
                      else if (_activeTab == _PortfolioTab.closed)
                        _PositionsList(
                          snapshot: snapshot,
                          positions: snapshot.closedPositions,
                          emptyTitle: 'No closed positions',
                          emptySubtitle: 'Closed positions will appear here',
                        )
                      else
                        _HistorySection(snapshot: snapshot),
                      if (_activeTab == _PortfolioTab.active &&
                          openOrders.isNotEmpty)
                        _OpenOrdersSection(
                          snapshot: snapshot,
                          orders: openOrders,
                          onCancel: (orderId) => setState(() {
                            _cancelledOrderIds.add(orderId);
                          }),
                        ),
                      _ArenaBridgeCard(
                        onTap: () => context.go(AppRoutePaths.arena),
                      ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.openOrderCount,
    required this.isHidden,
    required this.onToggleHidden,
  });

  final PredictionPortfolioSnapshot snapshot;
  final int openOrderCount;
  final bool isHidden;
  final VoidCallback onToggleHidden;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101B3A), Color(0xFF17183E)],
        ),
        border: Border.all(color: const Color(0xFF1C3265)),
        borderRadius: AppRadii.cardRadius,
        boxShadow: [
          BoxShadow(
            color: _predictionBlue.withValues(alpha: .12),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Portfolio Value',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                key: PredictionsPortfolioPage.visibilityToggleKey,
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: onToggleHidden,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.portfolioTextDim,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isHidden ? '••••••' : _formatMoney(snapshot.totalCurrentValue),
            style: AppTextStyles.heroNumber.copyWith(
              color: Colors.white,
              fontSize: 29,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!isHidden) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: pnlColor.withValues(alpha: .16),
                    border: Border.all(color: pnlColor.withValues(alpha: .22)),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        snapshot.totalPnl >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: pnlColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatSignedMoney(snapshot.totalPnl)} '
                        '(${snapshot.totalPnlPct.toStringAsFixed(1)}%)',
                        style: AppTextStyles.micro.copyWith(
                          color: pnlColor,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'all time',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Positions',
                  value: isHidden ? '••' : '${snapshot.activeCount}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStat(
                  label: 'P/L',
                  value: isHidden
                      ? '••'
                      : _formatSignedMoney(snapshot.totalPnl, decimals: 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStat(
                  label: 'Open Orders',
                  value: isHidden ? '••' : '$openOrderCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 13,
              height: 1.2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharesNote extends StatelessWidget {
  const _SharesNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: _predictionBlue.withValues(alpha: .07),
        border: Border.all(color: _predictionBlue.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionBlue,
            size: 15,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: const [
                  TextSpan(text: 'Shares'),
                  TextSpan(
                    text:
                        ' represent your stake in a market outcome. Each share pays ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: '\$1.00'),
                  TextSpan(
                    text: ' if correct, ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: '\$0.00'),
                  TextSpan(
                    text: ' if wrong. ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'P/L'),
                  TextSpan(
                    text: ' = current value minus amount invested.',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
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

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({
    required this.activeTab,
    required this.activeCount,
    required this.closedCount,
    required this.historyCount,
    required this.onChanged,
  });

  final _PortfolioTab activeTab;
  final int activeCount;
  final int closedCount;
  final int historyCount;
  final ValueChanged<_PortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (tab: _PortfolioTab.active, label: 'Active', count: activeCount),
      (tab: _PortfolioTab.closed, label: 'Closed', count: closedCount),
      (tab: _PortfolioTab.history, label: 'History', count: historyCount),
    ];

    return Container(
      height: 43,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          for (final item in tabs)
            Expanded(
              child: _PortfolioTabButton(
                key: switch (item.tab) {
                  _PortfolioTab.active => PredictionsPortfolioPage.activeTabKey,
                  _PortfolioTab.closed => PredictionsPortfolioPage.closedTabKey,
                  _PortfolioTab.history =>
                    PredictionsPortfolioPage.historyTabKey,
                },
                label: item.label,
                count: item.count,
                active: activeTab == item.tab,
                onTap: () => onChanged(item.tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _PortfolioTabButton extends StatelessWidget {
  const _PortfolioTabButton({
    super.key,
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.text1 : AppColors.text3,
                fontSize: 12,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
            const SizedBox(width: 5),
            _CountBadge(count: count, active: active),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.active});

  final int count;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: active
            ? _predictionBlue.withValues(alpha: .18)
            : AppColors.surface2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: active ? _predictionBlue : AppColors.text3,
          height: 1.1,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _PositionsList extends StatelessWidget {
  const _PositionsList({
    required this.snapshot,
    required this.positions,
    this.emptyTitle = 'No active positions',
    this.emptySubtitle = 'Start trading to build your portfolio',
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioPositionDraft> positions;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return VitEmptyState(
        icon: Icons.work_outline_rounded,
        title: emptyTitle,
        message: emptySubtitle,
      );
    }

    return Column(
      children: [
        for (var index = 0; index < positions.length; index += 1) ...[
          _PositionCard(
            key: PredictionsPortfolioPage.positionKey(positions[index].id),
            position: positions[index],
            event: snapshot.eventFor(positions[index].eventId),
          ),
          if (index != positions.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({super.key, required this.position, required this.event});

  final PredictionPortfolioPositionDraft position;
  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final isOpen = position.status == PredictionPortfolioPositionStatus.open;
    final isWon = position.status == PredictionPortfolioPositionStatus.won;
    final statusColor = isWon
        ? AppColors.buy
        : isOpen
        ? AppColors.warn
        : AppColors.sell;
    final statusLabel = isWon
        ? 'Won'
        : isOpen
        ? 'Open'
        : 'Lost';
    final outcomeColor = position.outcome == 'No'
        ? AppColors.sell
        : AppColors.buy;
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              isWon
                  ? Icons.check_circle_outline_rounded
                  : isOpen
                  ? Icons.schedule_rounded
                  : Icons.cancel_outlined,
              color: statusColor,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    height: 1.28,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(
                      label: position.outcome,
                      color: outcomeColor,
                      background: outcomeColor.withValues(alpha: .12),
                    ),
                    Text(
                      '${_formatShares(position.shares)} shares @ '
                      '\$${position.avgPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    _TinyBadge(
                      label: statusLabel,
                      color: statusColor,
                      background: statusColor.withValues(alpha: .12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _SmallMetric(
                      label: 'Avg:',
                      value: '\$${position.avgPrice.toStringAsFixed(2)}',
                    ),
                    const SizedBox(width: 18),
                    _SmallMetric(
                      label: 'Current:',
                      value: '\$${position.currentPrice.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _SmallMetric(
                      label: 'Value:',
                      value: _formatMoney(position.currentValue),
                      strong: true,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            position.pnl >= 0
                                ? Icons.arrow_outward_rounded
                                : Icons.south_east_rounded,
                            color: pnlColor,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${_formatSignedMoney(position.pnl)} '
                              '(${position.pnlPct.toStringAsFixed(1)}%)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.micro.copyWith(
                                color: pnlColor,
                                fontSize: 12,
                                height: 1.2,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: strong ? AppColors.text1 : AppColors.text2,
            fontSize: strong ? 12 : 10,
            height: 1.2,
            fontWeight: strong ? AppTextStyles.bold : AppTextStyles.normal,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _OpenOrdersSection extends StatelessWidget {
  const _OpenOrdersSection({
    required this.snapshot,
    required this.orders,
    required this.onCancel,
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioOrderDraft> orders;
  final ValueChanged<String> onCancel;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Open Orders',
      accentColor: AppColors.warn,
      children: [
        Row(
          children: [
            Text(
              'Pending limit orders awaiting fill',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${orders.length}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.help_outline_rounded,
              color: AppColors.text3,
              size: 13,
            ),
          ],
        ),
        for (var index = 0; index < orders.length; index += 1) ...[
          _OpenOrderCard(
            key: PredictionsPortfolioPage.openOrderKey(orders[index].id),
            order: orders[index],
            event: snapshot.eventFor(orders[index].eventId),
            onCancel: () => onCancel(orders[index].id),
          ),
        ],
      ],
    );
  }
}

class _OpenOrderCard extends StatelessWidget {
  const _OpenOrderCard({
    super.key,
    required this.order,
    required this.event,
    required this.onCancel,
  });

  final PredictionPortfolioOrderDraft order;
  final PredictionEventDraft event;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side == 'buy';
    final color = isBuy ? AppColors.buy : AppColors.sell;
    final fillPct = order.shares == 0 ? 0.0 : (order.filled / order.shares);

    return VitCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () =>
            context.go(AppRoutePaths.marketsPredictionReceipt(order.receiptId)),
        borderRadius: AppRadii.cardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(Icons.attach_money_rounded, color: color, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _TinyBadge(
                        label: '${order.side.toUpperCase()} ${order.outcome}',
                        color: color,
                        background: color.withValues(alpha: .12),
                      ),
                      Text(
                        '${_formatShares(order.shares)} @ '
                        '\$${order.price.toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 10,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      Text(
                        'Filled: ${(fillPct * 100).round()}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        value: fillPct,
                        backgroundColor: AppColors.surface3,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: 14,
                ),
                const SizedBox(height: 8),
                InkWell(
                  key: PredictionsPortfolioPage.cancelOrderKey(order.id),
                  onTap: onCancel,
                  borderRadius: AppRadii.mdRadius,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.sell10,
                      border: Border.all(color: AppColors.sell20),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.close_rounded,
                          color: AppColors.sell,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Cancel',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
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

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.snapshot});

  final PredictionPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final receipts = snapshot.historyReceipts;
    if (receipts.isEmpty) {
      return const VitEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Chưa có lịch sử lệnh',
        message: 'Các lệnh đã khớp hoặc đã hủy sẽ hiển thị ở đây',
      );
    }

    return VitPageSection(
      label: 'Lịch sử lệnh',
      accentColor: AppColors.accent,
      children: [
        for (var index = 0; index < receipts.length; index += 1) ...[
          _ReceiptCard(
            key: PredictionsPortfolioPage.receiptKey(receipts[index].id),
            receipt: receipts[index],
          ),
        ],
      ],
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({super.key, required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final isFilled = receipt.status == 'filled';
    final color = isFilled
        ? AppColors.buy
        : receipt.status == 'canceled'
        ? AppColors.text3
        : AppColors.sell;

    return VitCard(
      onTap: () =>
          context.go(AppRoutePaths.marketsPredictionReceipt(receipt.id)),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              isFilled
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: color,
              size: 17,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.eventTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _TinyBadge(
                      label: '${isBuy ? 'Buy' : 'Sell'} ${receipt.outcome}',
                      color: isBuy ? AppColors.buy : AppColors.sell,
                      background: (isBuy ? AppColors.buy : AppColors.sell)
                          .withValues(alpha: .12),
                    ),
                    _TinyBadge(
                      label: isFilled ? 'Filled' : 'Canceled',
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatShares(receipt.filledShares)}/'
                  '${_formatShares(receipt.shares)} shares · '
                  '${_formatMoney(receipt.total)} · ${receipt.createdAt}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _ArenaBridgeCard extends StatelessWidget {
  const _ArenaBridgeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsPortfolioPage.arenaBridgeKey,
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.warn,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khám phá Arena cùng chủ đề',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Social points-only · Không liên quan ví hay vị thế Prediction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Arena Points',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontSize: 8,
                fontWeight: AppTextStyles.bold,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          height: 1.1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatSignedMoney(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${value.abs().toStringAsFixed(decimals)}';
}

String _formatShares(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
