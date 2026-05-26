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
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;
const _predictionPurple = Color(0xFF8B5CF6);

class PredictionEventDetailPage extends ConsumerStatefulWidget {
  const PredictionEventDetailPage({
    super.key,
    required this.eventId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc030_prediction_event_detail_content');
  static const favoriteKey = Key('sc030_favorite');
  static const shareKey = Key('sc030_share');
  static const orderBookToggleKey = Key('sc030_order_book_toggle');
  static const commentsTabKey = Key('sc030_tab_comments');
  static const holdersTabKey = Key('sc030_tab_holders');
  static const activityTabKey = Key('sc030_tab_activity');
  static const rulesTabKey = Key('sc030_tab_rules');
  static const riskLinkKey = Key('sc030_risk_link');
  static const arenaCreateKey = Key('sc030_arena_create');
  static const dailyRewardsKey = Key('sc030_daily_rewards');
  static const globalActivityKey = Key('sc030_global_activity');

  static Key relatedKey(String id) => Key('sc030_related_$id');

  final String eventId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionEventDetailPage> createState() =>
      _PredictionEventDetailPageState();
}

enum _DetailTab { rules, comments, holders, activity }

class _PredictionEventDetailPageState
    extends ConsumerState<PredictionEventDetailPage> {
  _DetailTab _activeTab = _DetailTab.rules;
  bool _isFavorite = false;
  bool _showOrderBook = false;
  bool _isBuy = true;
  bool _isMarket = true;
  String _selectedOutcome = 'Yes';
  String _amount = '';

  @override
  void didUpdateWidget(covariant PredictionEventDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventId != widget.eventId) {
      _activeTab = _DetailTab.rules;
      _showOrderBook = false;
      _selectedOutcome = 'Yes';
      _amount = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getEventDetail(widget.eventId);
    final event = snapshot.event;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    if (!event.outcomes.any((outcome) => outcome.label == _selectedOutcome)) {
      _selectedOutcome = event.outcomes.first.label;
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-030 PredictionEventDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Event Detail',
              subtitle: 'Chi tiết · Prediction',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HeaderIconButton(
                    key: PredictionEventDetailPage.favoriteKey,
                    icon: _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isFavorite ? AppColors.sell : AppColors.text2,
                    onTap: () => setState(() {
                      _isFavorite = !_isFavorite;
                    }),
                  ),
                  const SizedBox(width: 6),
                  _HeaderIconButton(
                    key: PredictionEventDetailPage.shareKey,
                    icon: Icons.ios_share_rounded,
                    color: AppColors.text2,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionEventDetailPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 15,
                    children: [
                      _EventHeader(
                        event: event,
                        selectedOutcome: _selectedOutcome,
                        onOutcomeSelected: (value) => setState(() {
                          _selectedOutcome = value;
                        }),
                      ),
                      _StatsGrid(event: event),
                      if (snapshot.position != null)
                        _PositionBanner(position: snapshot.position!),
                      _ChartSection(snapshot: snapshot),
                      _OrderBookSection(
                        snapshot: snapshot,
                        expanded: _showOrderBook,
                        onToggle: () => setState(() {
                          _showOrderBook = !_showOrderBook;
                        }),
                      ),
                      if (event.status == PredictionEventStatus.active) ...[
                        _TradeSection(
                          event: event,
                          selectedOutcome: _selectedOutcome,
                          isBuy: _isBuy,
                          isMarket: _isMarket,
                          amount: _amount,
                          onSideChanged: (value) => setState(() {
                            _isBuy = value;
                          }),
                          onOrderTypeChanged: (value) => setState(() {
                            _isMarket = value;
                          }),
                          onAmountChanged: (value) => setState(() {
                            _amount = value;
                          }),
                          onOutcomeChanged: (value) => setState(() {
                            _selectedOutcome = value;
                          }),
                        ),
                        _RiskLink(onTap: () {}),
                      ],
                      _DetailTabs(
                        activeTab: _activeTab,
                        onChanged: (value) => setState(() {
                          _activeTab = value;
                        }),
                      ),
                      _TabCard(snapshot: snapshot, activeTab: _activeTab),
                      _RelatedMarketsSection(snapshot: snapshot),
                      _ArenaBridgeSection(
                        snapshot: snapshot,
                        onCreate: () => context.go(AppRoutePaths.arenaStudio),
                      ),
                      _QuickLinks(
                        onRewards: () =>
                            context.go(AppRoutePaths.marketsPredictionsRewards),
                        onActivity: () => context.go(
                          AppRoutePaths.marketsPredictionsActivity,
                        ),
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 6,
          children: [
            _TinyBadge(
              label: event.category,
              color: _predictionPrimary,
              background: _predictionPrimary.withValues(alpha: .13),
            ),
            for (final tag in event.tags)
              _TinyBadge(
                label: tag,
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
            if (event.status == PredictionEventStatus.resolved)
              _TinyBadge(
                label: 'RESOLVED',
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 20,
            height: 1.30,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _MetaItem(
              icon: Icons.schedule_rounded,
              label: _timeRemaining(event.endDate),
            ),
            _MetaItem(
              icon: Icons.group_outlined,
              label: _formatInt(event.participants),
            ),
            _MetaItem(
              icon: Icons.bar_chart_rounded,
              label: _formatVolume(event.totalVolume),
            ),
            _ChangeLabel(value: event.change24h),
          ],
        ),
        const SizedBox(height: 15),
        if (event.outcomes.length == 2)
          Row(
            children: [
              for (var index = 0; index < outcomes.length; index += 1) ...[
                Expanded(
                  child: _OutcomeCard(
                    outcome: outcomes[index],
                    selected: selectedOutcome == outcomes[index].label,
                    onTap: () => onOutcomeSelected(outcomes[index].label),
                  ),
                ),
                if (index == 0) const SizedBox(width: 12),
              ],
            ],
          )
        else
          _MultiOutcomeList(
            event: event,
            selectedOutcome: selectedOutcome,
            onOutcomeSelected: onOutcomeSelected,
          ),
        if (event.outcomes.length == 2) ...[
          const SizedBox(height: 12),
          _ProbabilityBar(outcomes: outcomes),
        ],
      ],
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({
    required this.outcome,
    required this.selected,
    required this.onTap,
  });

  final PredictionOutcomeDraft outcome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isYes = outcome.label == 'Yes';
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: outcome.color.withValues(alpha: isYes ? .08 : .07),
          border: Border.all(
            color: outcome.color.withValues(alpha: selected ? .42 : .18),
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: outcome.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  outcome.label,
                  style: AppTextStyles.body.copyWith(
                    color: outcome.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${outcome.chance}%',
              style: AppTextStyles.heroNumber.copyWith(
                color: outcome.color,
                fontSize: 28,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isYes ? 'Best Bid' : 'Best Ask',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  _formatPrice(outcome.chance / 100),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _MultiOutcomeList extends StatelessWidget {
  const _MultiOutcomeList({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final outcome in event.outcomes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onOutcomeSelected(outcome.label),
              borderRadius: AppRadii.mdRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selectedOutcome == outcome.label
                      ? outcome.color.withValues(alpha: .12)
                      : AppColors.surface,
                  border: Border.all(
                    color: selectedOutcome == outcome.label
                        ? outcome.color.withValues(alpha: .34)
                        : AppColors.cardBorder,
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: outcome.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        outcome.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${outcome.chance}%',
                      style: AppTextStyles.body.copyWith(
                        color: outcome.color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityBar extends StatelessWidget {
  const _ProbabilityBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Expanded(
              flex: yes.chance,
              child: ColoredBox(color: yes.color),
            ),
            Expanded(
              flex: no.chance,
              child: ColoredBox(color: no.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        icon: Icons.bar_chart_rounded,
        label: 'Volume 24h',
        value: _formatVolume(event.volume24h),
        color: _predictionPrimary,
      ),
      _StatItem(
        icon: Icons.group_outlined,
        label: 'Participants',
        value: _formatInt(event.participants),
        color: _predictionPurple,
      ),
      _StatItem(
        icon: Icons.stacked_line_chart_rounded,
        label: 'Total Volume',
        value: _formatVolume(event.totalVolume),
        color: AppColors.buy,
      ),
      _StatItem(
        icon: Icons.schedule_rounded,
        label: 'Ends in',
        value: _timeRemaining(event.endDate),
        color: AppColors.warn,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final stat in stats)
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: stat.color.withValues(alpha: .12),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        stat.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _PositionBanner extends StatelessWidget {
  const _PositionBanner({required this.position});

  final PredictionDetailPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 13),
              const SizedBox(width: 6),
              Text(
                'Your Position',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _TinyBadge(
                label: position.outcome,
                color: position.outcome == 'Yes'
                    ? AppColors.buy
                    : AppColors.sell,
                background: position.outcome == 'Yes'
                    ? AppColors.buy10
                    : AppColors.sell10,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${position.shares.toStringAsFixed(0)} shares @ '
                  '${_formatPrice(position.avgPrice)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${position.pnl >= 0 ? '+' : ''}'
                    '${_formatMoney(position.pnl)}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    '${position.pnlPct >= 0 ? '+' : ''}'
                    '${position.pnlPct.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Price / Probability',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ChartPeriodTabs(),
              const SizedBox(height: 10),
              SizedBox(
                height: 178,
                child: CustomPaint(
                  painter: _ProbabilityChartPainter(
                    values: snapshot.probabilityHistory,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Volume (24h)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 42,
                child: _VolumeBars(values: snapshot.volumeHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartPeriodTabs extends StatelessWidget {
  const _ChartPeriodTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = ['1H', '1D', '7D', '30D', 'All'];
    return Row(
      children: [
        for (var index = 0; index < tabs.length; index += 1) ...[
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tabs[index] == '30D'
                    ? _predictionPrimary.withValues(alpha: .14)
                    : Colors.transparent,
                border: Border.all(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary.withValues(alpha: .32)
                      : Colors.transparent,
                ),
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                tabs[index],
                style: AppTextStyles.micro.copyWith(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary
                      : AppColors.text3,
                  fontWeight: tabs[index] == '30D'
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
          ),
          if (index != tabs.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _VolumeBars extends StatelessWidget {
  const _VolumeBars({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max).toDouble();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in values)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(.10, value / maxValue),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: _predictionPrimary.withValues(alpha: .30),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityChartPainter extends CustomPainter {
  const _ProbabilityChartPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length < 2) return;

    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = size.width * index / (values.length - 1);
      final y = size.height - (values[index] / 100) * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x4D10B981), Color(0x0510B981)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ProbabilityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _OrderBookSection extends StatelessWidget {
  const _OrderBookSection({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final PredictionEventDetailSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final chance = snapshot.event.outcomes.first.chance / 100;
    final bestBid = snapshot.orderBook.bids.first.price;
    final bestAsk = snapshot.orderBook.asks.first.price;
    return Column(
      children: [
        InkWell(
          key: PredictionEventDetailPage.orderBookToggleKey,
          onTap: onToggle,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.layers_rounded,
                  color: _predictionPrimary,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  'Order Book',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Spread ${_formatPrice(bestAsk - bestBid)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: 8),
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
        if (expanded) ...[
          const SizedBox(height: 8),
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _OrderBookHeader(),
                const SizedBox(height: 6),
                for (final ask in snapshot.orderBook.asks.reversed)
                  _OrderBookRow(entry: ask, isBid: false),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    '${_formatPrice(chance)} · mid price',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (final bid in snapshot.orderBook.bids)
                  _OrderBookRow(entry: bid, isBid: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _OrderBookLabel('PRICE')),
        SizedBox(width: 72, child: _OrderBookLabel('SHARES', alignEnd: true)),
        SizedBox(width: 72, child: _OrderBookLabel('TOTAL', alignEnd: true)),
      ],
    );
  }
}

class _OrderBookLabel extends StatelessWidget {
  const _OrderBookLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({required this.entry, required this.isBid});

  final PredictionOrderBookEntryDraft entry;
  final bool isBid;

  @override
  Widget build(BuildContext context) {
    final color = isBid ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(entry.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt(entry.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt((entry.price * entry.shares).round()),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeSection extends StatelessWidget {
  const _TradeSection({
    required this.event,
    required this.selectedOutcome,
    required this.isBuy,
    required this.isMarket,
    required this.amount,
    required this.onSideChanged,
    required this.onOrderTypeChanged,
    required this.onAmountChanged,
    required this.onOutcomeChanged,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final bool isBuy;
  final bool isMarket;
  final String amount;
  final ValueChanged<bool> onSideChanged;
  final ValueChanged<bool> onOrderTypeChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    final outcome = event.outcomes.firstWhere(
      (item) => item.label == selectedOutcome,
      orElse: () => event.outcomes.first,
    );
    final price = outcome.chance / 100;
    return VitPageSection(
      label: 'Trade',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SegmentedToggle(
                leftLabel: 'Buy',
                rightLabel: 'Sell',
                leftActive: isBuy,
                leftColor: AppColors.buy,
                rightColor: AppColors.sell,
                onLeft: () => onSideChanged(true),
                onRight: () => onSideChanged(false),
              ),
              if (event.outcomes.length > 2) ...[
                const SizedBox(height: 13),
                Text(
                  'Outcome',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in event.outcomes)
                        Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: _SmallToggleChip(
                            label: option.label,
                            color: option.color,
                            active: option.label == selectedOutcome,
                            onTap: () => onOutcomeChanged(option.label),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 13),
              Text(
                'Order Type',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 7),
              _SegmentedToggle(
                leftLabel: 'Market',
                rightLabel: 'Limit',
                leftActive: isMarket,
                leftColor: _predictionPrimary,
                rightColor: _predictionPrimary,
                onLeft: () => onOrderTypeChanged(true),
                onRight: () => onOrderTypeChanged(false),
              ),
              const SizedBox(height: 4),
              Text(
                isMarket
                    ? 'Execute at current best available price'
                    : 'Set your desired entry price',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: 13),
              Text(
                'Amount',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                height: AppSpacing.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: onAmountChanged,
                        style: AppTextStyles.body.copyWith(
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ),
                    _TinyBadge(
                      label: 'USDT',
                      color: AppColors.text2,
                      background: AppColors.surface3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final preset in const ['10', '25', '50', '100']) ...[
                    Expanded(
                      child: _AmountChip(
                        amount: preset,
                        active: amount == preset,
                        onTap: () => onAmountChanged(preset),
                      ),
                    ),
                    if (preset != '100') const SizedBox(width: 6),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Đây không phải lời khuyên đầu tư. Xác suất không phải sự chắc chắn.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 10),
              VitCtaButton(
                variant: isBuy
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.danger,
                onPressed: amount.isEmpty ? null : () {},
                child: Text(
                  '${isBuy ? 'Buy' : 'Sell'} $selectedOutcome @ '
                  '${_formatPrice(price)}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftActive,
    required this.leftColor,
    required this.rightColor,
    required this.onLeft,
    required this.onRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool leftActive;
  final Color leftColor;
  final Color rightColor;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: leftLabel,
              active: leftActive,
              color: leftColor,
              onTap: onLeft,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _SegmentButton(
              label: rightLabel,
              active: !leftActive,
              color: rightColor,
              onTap: onRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
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
          color: active ? color.withValues(alpha: .12) : Colors.transparent,
          border: Border.all(
            color: active ? color.withValues(alpha: .28) : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _SmallToggleChip extends StatelessWidget {
  const _SmallToggleChip({
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
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .32) : Colors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.amount,
    required this.active,
    required this.onTap,
  });

  final String amount;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .32)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          '\$$amount',
          style: AppTextStyles.micro.copyWith(
            color: active ? _predictionPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PredictionEventDetailPage.riskLinkKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.warn, size: 13),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Hiểu rủi ro trước khi giao dịch',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.activeTab, required this.onChanged});

  final _DetailTab activeTab;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_DetailTab.rules, 'Rules', PredictionEventDetailPage.rulesTabKey),
      (
        _DetailTab.comments,
        'Comments',
        PredictionEventDetailPage.commentsTabKey,
      ),
      (
        _DetailTab.holders,
        'Top Holders',
        PredictionEventDetailPage.holdersTabKey,
      ),
      (
        _DetailTab.activity,
        'Activity',
        PredictionEventDetailPage.activityTabKey,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: InkWell(
                  key: tab.$3,
                  onTap: () => onChanged(tab.$1),
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeTab == tab.$1
                          ? AppColors.surface
                          : Colors.transparent,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      tab.$2,
                      style: AppTextStyles.caption.copyWith(
                        color: activeTab == tab.$1
                            ? AppColors.text1
                            : AppColors.text3,
                        fontSize: 12,
                        fontWeight: activeTab == tab.$1
                            ? AppTextStyles.bold
                            : AppTextStyles.normal,
                      ),
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

class _TabCard extends StatelessWidget {
  const _TabCard({required this.snapshot, required this.activeTab});

  final PredictionEventDetailSnapshot snapshot;
  final _DetailTab activeTab;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(15),
      child: switch (activeTab) {
        _DetailTab.rules => _RulesContent(snapshot: snapshot),
        _DetailTab.comments => const _CommentsContent(),
        _DetailTab.holders => _HoldersContent(snapshot: snapshot),
        _DetailTab.activity => _ActivityContent(snapshot: snapshot),
      },
    );
  }
}

class _RulesContent extends StatelessWidget {
  const _RulesContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBlock(
          icon: Icons.menu_book_rounded,
          title: 'Description',
          text:
              'This market will resolve to "Yes" if bitcoin reaches \$150K before July 2026 before the end date. Otherwise, it resolves to "No".',
        ),
        const SizedBox(height: 13),
        _InfoBox(
          icon: Icons.verified_user_outlined,
          title: 'Resolution Source',
          text: 'CoinGecko & CoinMarketCap (average)',
          color: _predictionPrimary,
        ),
        const SizedBox(height: 10),
        _InfoBox(
          icon: Icons.calendar_month_outlined,
          title: 'End Date',
          text: '${_formatDate(snapshot.event.endDate)} at 23:59 UTC',
          color: AppColors.warn,
        ),
        const SizedBox(height: 13),
        Text(
          'Market Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < snapshot.rules.length; index += 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    '${index + 1}.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.rules[index],
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text2, size: 13),
            const SizedBox(width: 7),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
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

class _CommentsContent extends StatelessWidget {
  const _CommentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.warn08,
            border: Border.all(color: AppColors.warningBorder),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Beware of external links. Do not share personal or financial information.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        _CommentRow(
          name: 'MacroAlpha',
          side: 'Yes',
          text: 'Strong ETF flow and liquidity backdrop support this market.',
          likes: 18,
        ),
        _CommentRow(
          name: 'RiskDesk',
          side: 'No',
          text: 'Watch macro rates and exchange liquidity before sizing up.',
          likes: 9,
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Add a comment...',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Post',
                style: AppTextStyles.caption.copyWith(
                  color: _predictionPrimary,
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

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.name,
    required this.side,
    required this.text,
    required this.likes,
  });

  final String name;
  final String side;
  final String text;
  final int likes;

  @override
  Widget build(BuildContext context) {
    final color = side == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surface2,
            child: Text(
              name[0],
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _TinyBadge(
                      label: side,
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                    Text(
                      '4m ago',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppColors.text3,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Báo cáo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldersContent extends StatelessWidget {
  const _HoldersContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 28, child: _OrderBookLabel('#')),
            const Expanded(child: _OrderBookLabel('TRADER')),
            const SizedBox(
              width: 54,
              child: _OrderBookLabel('SIDE', alignEnd: true),
            ),
            const SizedBox(
              width: 70,
              child: _OrderBookLabel('SHARES', alignEnd: true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < snapshot.topHolders.length; index += 1)
          _HolderRow(rank: index + 1, holder: snapshot.topHolders[index]),
      ],
    );
  }
}

class _HolderRow extends StatelessWidget {
  const _HolderRow({required this.rank, required this.holder});

  final int rank;
  final PredictionHolderDraft holder;

  @override
  Widget build(BuildContext context) {
    final color = holder.outcome == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Icon(
              rank == 1 ? Icons.workspace_premium_rounded : Icons.circle,
              color: rank == 1 ? AppColors.warn : AppColors.text3,
              size: rank == 1 ? 15 : 6,
            ),
          ),
          Expanded(
            child: Text(
              holder.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          SizedBox(
            width: 54,
            child: Align(
              alignment: Alignment.centerRight,
              child: _TinyBadge(
                label: holder.outcome,
                color: color,
                background: color.withValues(alpha: .12),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              _formatInt(holder.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityContent extends StatelessWidget {
  const _ActivityContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.activity)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: const Icon(
                    Icons.flash_on_rounded,
                    color: _predictionPrimary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.actor} ${item.action}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        item.amount,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.time,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RelatedMarketsSection extends StatelessWidget {
  const _RelatedMarketsSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.relatedEvents.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Related Markets',
      accentColor: _predictionPurple,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (
                var index = 0;
                index < snapshot.relatedEvents.length;
                index += 1
              )
                Padding(
                  padding: EdgeInsets.only(
                    right: index == snapshot.relatedEvents.length - 1 ? 0 : 12,
                  ),
                  child: _RelatedMarketCard(
                    event: snapshot.relatedEvents[index],
                    onTap: () => context.go(
                      AppRoutePaths.marketsPredictionEvent(
                        snapshot.relatedEvents[index].id,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RelatedMarketCard extends StatelessWidget {
  const _RelatedMarketCard({required this.event, required this.onTap});

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = event.outcomes.first;
    return SizedBox(
      key: PredictionEventDetailPage.relatedKey(event.id),
      width: 220,
      child: VitCard(
        onTap: onTap,
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TinyBadge(
              label: event.category,
              color: _predictionPrimary,
              background: _predictionPrimary.withValues(alpha: .13),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                height: 1.35,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: top.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${top.chance}%',
                  style: AppTextStyles.body.copyWith(
                    color: top.color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  top.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const Spacer(),
                Text(
                  _formatVolume(event.volume24h),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaBridgeSection extends StatelessWidget {
  const _ArenaBridgeSection({required this.snapshot, required this.onCreate});

  final PredictionEventDetailSnapshot snapshot;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Arena trên cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      children: const [
                        _ArenaBadge('Arena Points only'),
                        _ArenaBadge('Không liên quan Wallet'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final room in snapshot.arenaRooms)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.gamepad_outlined,
                      color: AppColors.warn,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${room.slots} · ${room.points} Arena Points',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _TinyBadge(
                      label: room.badge,
                      color: AppColors.warn,
                      background: AppColors.warn10,
                    ),
                  ],
                ),
              ),
            ),
          InkWell(
            key: PredictionEventDetailPage.arenaCreateKey,
            onTap: onCreate,
            borderRadius: AppRadii.mdRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.warn08,
                border: Border.all(color: AppColors.warningBorder),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.warn,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tạo Arena từ event này',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warn,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Event chỉ là bối cảnh, không liên kết ví hay P/L.',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _ArenaBadge('Arena Points only'),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.warn,
                    size: 16,
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

class _ArenaBadge extends StatelessWidget {
  const _ArenaBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.warn,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onRewards, required this.onActivity});

  final VoidCallback onRewards;
  final VoidCallback onActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.dailyRewardsKey,
            icon: Icons.card_giftcard_rounded,
            color: AppColors.warn,
            title: 'Daily Rewards',
            subtitle: 'Earn by providing liquidity',
            onTap: onRewards,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.globalActivityKey,
            icon: Icons.timeline_rounded,
            color: _predictionPurple,
            title: 'Global Activity',
            subtitle: 'Live trading feed',
            onTap: onActivity,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
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
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 11),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value >= 0 ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
          color: color,
          size: 12,
        ),
        Text(
          _formatPercent(value),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) {
  final absValue = value.abs();
  return '\$${absValue.toStringAsFixed(2)}';
}

String _formatPrice(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return buffer.toString();
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _formatDate(DateTime value) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Ended';
  final days = diff.inDays;
  if (days > 30) return '${days ~/ 30} tháng';
  if (days > 0) return '$days ngày';
  return '${diff.inHours}h';
}
