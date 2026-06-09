import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_order_preview_card.dart';

part 'prediction_event_detail_page_part_01.dart';
part 'prediction_event_detail_page_part_02.dart';
part 'prediction_event_detail_page_part_03.dart';
part 'prediction_event_detail_page_part_04.dart';
part 'prediction_event_detail_page_part_05.dart';
part '../widgets/prediction_event_detail_header.dart';
part '../widgets/prediction_event_detail_stats_position.dart';
part '../widgets/prediction_event_detail_chart.dart';
part '../widgets/prediction_event_detail_order_book.dart';
part '../widgets/prediction_event_detail_trade_panel.dart';
part '../widgets/prediction_event_detail_trade_controls.dart';
part '../widgets/prediction_event_detail_detail_tabs.dart';
part '../widgets/prediction_event_detail_comments.dart';
part '../widgets/prediction_event_detail_activity_holders.dart';
part '../widgets/prediction_event_detail_related_arena.dart';

const _predictionPrimary = AppColors.primary;
const _predictionPurple = AppColors.accent;

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
    final controller = ref.watch(
      predictionEventDetailControllerProvider(widget.eventId),
    );
    final snapshot = controller.state.snapshot;
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
    final orderPreview = controller.previewOrder(
      outcome: _selectedOutcome,
      isBuy: _isBuy,
      isMarket: _isMarket,
      amountText: _amount,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-030 PredictionEventDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Event Detail',
            subtitle: 'Chi tiết · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
            actions: [
              VitHeaderActionItem(
                key: PredictionEventDetailPage.favoriteKey,
                type: _isFavorite
                    ? VitHeaderActionType.favoriteOn
                    : VitHeaderActionType.favoriteOff,
                onPressed: () => setState(() {
                  _isFavorite = !_isFavorite;
                }),
              ),
              const VitHeaderActionItem(
                key: PredictionEventDetailPage.shareKey,
                type: VitHeaderActionType.share,
                onPressed: _noop,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        if (snapshot.highRiskContractId != null)
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Order risk states active',
                            message:
                                'Rules, amount setup, probability preview, confirmation, submitted receipt and recovery are tracked in one prediction contract.',
                            contractId: snapshot.highRiskContractId,
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
                            preview: orderPreview,
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
                          onRewards: () => context.go(
                            AppRoutePaths.marketsPredictionsRewards,
                          ),
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
      ),
    );
  }
}

void _noop() {}
