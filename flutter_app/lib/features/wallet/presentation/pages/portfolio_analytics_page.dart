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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/portfolio_analytics_summary_switcher.dart';
part '../widgets/portfolio_analytics_overview_chart.dart';
part '../widgets/portfolio_analytics_metrics_assets.dart';
part '../widgets/portfolio_analytics_common.dart';

const _analyticsBackground = AppColors.bg;
const _analyticsPanel = AppColors.surface;
const _analyticsPanel2 = AppColors.surface2;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsRed = AppColors.sell;

class PortfolioAnalyticsPage extends ConsumerStatefulWidget {
  const PortfolioAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc142_portfolio_analytics_content');
  static Key periodKey(String period) => Key('sc142_period_$period');
  static Key viewKey(String id) => Key('sc142_view_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioAnalyticsPage> createState() =>
      _PortfolioAnalyticsPageState();
}

class _PortfolioAnalyticsPageState
    extends ConsumerState<PortfolioAnalyticsPage> {
  String _activeView = 'overview';
  late String _activePeriod;

  @override
  void initState() {
    super.initState();
    _activePeriod = '1M';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletPortfolioAnalyticsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-142 PortfolioAnalyticsPage',
      child: Material(
        color: _analyticsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích Danh mục',
            subtitle: 'Phân tích · Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PortfolioAnalyticsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ValueSummary(snapshot: snapshot),
                      const SizedBox(height: 18),
                      _ViewSwitcher(
                        active: _activeView,
                        onChanged: (view) => setState(() => _activeView = view),
                      ),
                      const SizedBox(height: 19),
                      if (_activeView == 'overview')
                        _OverviewContent(
                          snapshot: snapshot,
                          activePeriod: _activePeriod,
                          onPeriodChanged: (period) =>
                              setState(() => _activePeriod = period),
                        )
                      else
                        _PlaceholderAnalyticsView(view: _activeView),
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
