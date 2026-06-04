import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_data_analytics_widgets.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LiveMarketPairCard(snapshot: snapshot),
                      const SizedBox(height: 16),
                      LiveMarketUnderlineTabs(
                        activeId: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                        keyBuilder: LiveMarketDataAnalyticsPage.tabKey,
                      ),
                      const SizedBox(height: 16),
                      LiveMarketTabContent(activeTab: _tab, snapshot: snapshot),
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
