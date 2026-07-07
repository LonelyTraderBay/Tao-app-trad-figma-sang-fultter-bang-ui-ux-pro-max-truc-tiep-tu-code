import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_history.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_orders.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_positions.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_summary.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_portfolio_bridge_card.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

class PredictionsPortfolioPage extends ConsumerStatefulWidget {
  const PredictionsPortfolioPage({
    super.key,
    this.shellRenderMode,
    this.backPath = AppRoutePaths.marketsPredictions,
    this.semanticLabel = 'SC-031 PredictionsPortfolioPage',
  });

  static const contentKey = predictionPortfolioContentKey;
  static const visibilityToggleKey = predictionPortfolioVisibilityToggleKey;
  static const activeTabKey = predictionPortfolioActiveTabKey;
  static const closedTabKey = predictionPortfolioClosedTabKey;
  static const historyTabKey = predictionPortfolioHistoryTabKey;
  static const arenaBridgeKey = predictionPortfolioArenaBridgeKey;

  static Key positionKey(String id) => predictionPortfolioPositionKey(id);
  static Key openOrderKey(String id) => predictionPortfolioOpenOrderKey(id);
  static Key cancelOrderKey(String id) => predictionPortfolioCancelOrderKey(id);
  static Key receiptKey(String id) => predictionPortfolioReceiptKey(id);

  final ShellRenderMode? shellRenderMode;
  final String backPath;
  final String semanticLabel;

  @override
  ConsumerState<PredictionsPortfolioPage> createState() =>
      _PredictionsPortfolioPageState();
}

class _PredictionsPortfolioPageState
    extends ConsumerState<PredictionsPortfolioPage> {
  PredictionPortfolioTab _activeTab = PredictionPortfolioTab.active;
  bool _isHidden = false;
  final Set<String> _cancelledOrderIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(predictionsPortfolioControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;
    final openOrders = controller.openOrdersExcluding(_cancelledOrderIds);
    final resolvedBackPath = resolveSafeBackPath(
      candidate: widget.backPath,
      fallbackPath: AppRoutePaths.marketsPredictions,
      allowedPrefixes: const [AppRoutePaths.markets, AppRoutePaths.profile],
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Prediction Portfolio',
            subtitle: 'Vị thế · Prediction',
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: resolvedBackPath),
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
                    key: PredictionsPortfolioPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionPortfolioScrollPadding(
                          scrollEndClearance,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: [
                        VitCard(
                          variant: VitCardVariant.hero,
                          radius: VitCardRadius.large,
                          clip: true,
                          padding: HomeSpacingTokens.homeCardPaddingDefault,
                          background: const VitHeroGlow(),
                          child: PredictionPortfolioSummaryCard(
                            snapshot: snapshot,
                            openOrderCount: openOrders.length,
                            isHidden: _isHidden,
                            onToggleHidden: () => setState(() {
                              _isHidden = !_isHidden;
                            }),
                          ),
                        ),
                        VitAnnouncementBanner(
                          message: predictionPortfolioSharesNoteMessage,
                          icon: Icons.info_outline_rounded,
                          accentColor: AppColors.primary,
                          variant: VitAnnouncementBannerVariant.compact,
                        ),
                        VitTabBar(
                          variant: VitTabBarVariant.segment,
                          activeKey: _activeTab.name,
                          onChanged: (key) => setState(() {
                            _activeTab = PredictionPortfolioTab.values.byName(
                              key,
                            );
                          }),
                          tabs: [
                            VitTabItem(
                              key: PredictionPortfolioTab.active.name,
                              label: 'Active',
                              widgetKey: predictionPortfolioActiveTabKey,
                            ),
                            VitTabItem(
                              key: PredictionPortfolioTab.closed.name,
                              label: 'Closed',
                              widgetKey: predictionPortfolioClosedTabKey,
                            ),
                            VitTabItem(
                              key: PredictionPortfolioTab.history.name,
                              label: 'History',
                              widgetKey: predictionPortfolioHistoryTabKey,
                            ),
                          ],
                        ),
                        if (_activeTab == PredictionPortfolioTab.active)
                          PredictionPortfolioPositionsList(
                            snapshot: snapshot,
                            positions: snapshot.activePositions,
                          )
                        else if (_activeTab == PredictionPortfolioTab.closed)
                          PredictionPortfolioPositionsList(
                            snapshot: snapshot,
                            positions: snapshot.closedPositions,
                            emptyTitle: 'No closed positions',
                            emptySubtitle: 'Closed positions will appear here',
                          )
                        else
                          PredictionPortfolioHistorySection(snapshot: snapshot),
                        if (_activeTab == PredictionPortfolioTab.active &&
                            openOrders.isNotEmpty)
                          PredictionPortfolioOpenOrdersSection(
                            snapshot: snapshot,
                            orders: openOrders,
                            onCancel: (orderId) => setState(() {
                              _cancelledOrderIds.add(orderId);
                            }),
                          ),
                        PredictionsPortfolioArenaBridgeCard(
                          key: PredictionsPortfolioPage.arenaBridgeKey,
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
      ),
    );
  }
}
