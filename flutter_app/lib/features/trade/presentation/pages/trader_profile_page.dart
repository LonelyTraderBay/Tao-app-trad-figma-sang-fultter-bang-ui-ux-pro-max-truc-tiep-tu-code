import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trader_profile_chart_painters.dart';

part '../widgets/trader_profile_hero.dart';
part '../widgets/trader_profile_overview.dart';
part '../widgets/trader_profile_trades.dart';
part '../widgets/trader_profile_stats_common.dart';

const _profilePrimary = AppColors.primary;
const _profileGreen = AppColors.buy;
const _profileAmber = AppColors.caution;
const _profileRed = AppColors.sell;

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
        .watch(tradeReadModelControllerProvider)
        .getTraderProfile(traderId: widget.traderId);
    final trader = snapshot.trader;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-087 TraderProfilePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trader Profile',
            subtitle: 'Hồ sơ · Trade',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: TraderProfilePage.contentKey,
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.contentPad,
                    AppSpacing.tradeBotCardGap,
                    AppSpacing.contentPad,
                    scrollClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.compact,
                    children: [
                      _ProfileHero(
                        trader: trader,
                        isFollowing: _isFollowing,
                        onToggleFollow: () =>
                            setState(() => _isFollowing = !_isFollowing),
                      ),
                      VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              density: VitDensity.compact,
                              title: 'Trader profile review',
                              message:
                                  'Performance, recent trades, statistics, risk history and copy action suitability are reviewed before following.',
                              contractId: 'trader-profile-${widget.traderId}',
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            const VitStatusPill(
                              label: 'Past performance varies',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      _SegmentTabs(
                        activeId: _tab,
                        tabs: const [
                          _TraderTab(id: 'overview', label: 'Tổng quan'),
                          _TraderTab(id: 'trades', label: 'Giao dịch'),
                          _TraderTab(id: 'stats', label: 'Thống kê'),
                        ],
                        onChanged: (id) => setState(() => _tab = id),
                      ),
                      VitPageSection(
                        density: VitDensity.compact,
                        children: [
                          if (_tab == 'overview')
                            _OverviewTab(snapshot: snapshot)
                          else if (_tab == 'trades')
                            _TradesTab(trades: snapshot.recentTrades)
                          else
                            _StatsTab(trader: trader),
                        ],
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
