import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_data_analytics_widgets.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

import '../widgets/trade_body_review_widgets.dart';

const _liveBackground = AppColors.bg;

class LiveMarketDataAnalyticsPage extends ConsumerStatefulWidget {
  const LiveMarketDataAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc091_live_market_analytics_content');
  static Key tabKey(String id) => Key('sc091_live_market_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LiveMarketDataAnalyticsPage> createState() =>
      _LiveMarketDataAnalyticsPageState();
}

class _LiveMarketDataAnalyticsPageState
    extends ConsumerState<LiveMarketDataAnalyticsPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getLiveMarketDataAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = tradeScrollBottomInset(context, shellRenderMode: mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-091 LiveMarketDataAnalyticsPage',
      child: Material(
        color: _liveBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Live Market Analytics',
            subtitle: 'Real-Time Data',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: LiveMarketDataAnalyticsPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top:
                        AppSpacing.x4 +
                        AppSpacing.x1 -
                        AppSpacing.hairlineStroke,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: AppSpacing.x4 + AppSpacing.x1,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review real-time market risk',
                        message:
                            'Live feeds can move or disconnect during volatility. Confirm liquidity, limits, and execution risk before trading.',
                      ),
                      LiveMarketPairCard(snapshot: snapshot),
                      LiveMarketUnderlineTabs(
                        activeId: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                        keyBuilder: LiveMarketDataAnalyticsPage.tabKey,
                      ),
                      LiveMarketTabContent(activeTab: _tab, snapshot: snapshot),
                      const TradeBodyReviewSection(
                        title: 'Live data review',
                        message: 'Live market analytics body reviewed',
                        detail:
                            'Feed, liquidity, latency, tab, empty, and reconnect states remain visible before trading.',
                        primary:
                            'Pair and feed health stay above tabbed analytics.',
                        secondary:
                            'Latency and liquidity metrics remain informational before execution.',
                        tertiary:
                            'Disconnected or delayed data remains separated from order placement.',
                      ),
                    ],
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
