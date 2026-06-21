import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_trading_hero.dart';
part '../widgets/copy_trading_list.dart';
part '../widgets/copy_trading_metrics_common.dart';

const _copyPrimary = AppColors.primary;
const _copySpace = AppSpacing.x2;
const _copyCardSpace = AppSpacing.x3;
const _copyVisualScrollClearance = 112.0;
const _copyNativeScrollClearance = 72.0;
const _copyWeeklyChartHeight = 36.0;
const _copyBadgeSize = 18.0;
const _copyButtonHeight = 44.0;
const _copyTextLineHeight = 1.24;

class CopyTradingPage extends ConsumerStatefulWidget {
  const CopyTradingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc063_copy_trading_scroll_content');
  static Key sortKey(String option) => Key('sc063_sort_$option');
  static Key traderKey(String id) => Key('sc063_trader_$id');
  static Key detailKey(String id) => Key('sc063_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyTradingPage> createState() => _CopyTradingPageState();
}

class _CopyTradingPageState extends ConsumerState<CopyTradingPage> {
  String _sortBy = 'Top ROI';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeCopyTradingProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _copyVisualScrollClearance
            : _copyNativeScrollClearance);
    final traders = _sortedTraders(snapshot.traders);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-063 CopyTradingPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Copy Trading',
            subtitle: 'Sao chép · Trade',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.trade,
              mode: BackNavigationMode.historyThenFallback,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyTradingPage.contentKey,
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollEndClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _CopyHeroCard(snapshot: snapshot),
                      _RiskWarningCard(
                        title: snapshot.riskWarningTitle,
                        message: snapshot.riskWarningText,
                      ),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review copy trading risk',
                        message:
                            'Compare provider drawdown, copier concentration, fees, and stop rules before copying any strategy.',
                        contractId: 'Providers available: ${traders.length}',
                        density: VitDensity.compact,
                      ),
                      _SortChips(
                        options: snapshot.sortOptions,
                        selected: _sortBy,
                        onChanged: (value) => setState(() => _sortBy = value),
                      ),
                      if (traders.isEmpty)
                        const VitEmptyState(
                          title: 'No copy providers',
                          message:
                              'Providers matching this sort will appear here when available.',
                          icon: Icons.groups_outlined,
                        )
                      else
                        for (final trader in traders) ...[
                          _TraderCard(
                            trader: trader,
                            onOpen: () => context.go(
                              AppRoutePaths.tradeCopyProvider(trader.id),
                            ),
                          ),
                        ],
                      _Disclaimer(text: snapshot.disclaimer),
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

  List<TradeCopyTrader> _sortedTraders(List<TradeCopyTrader> traders) {
    final sorted = [...traders];
    if (_sortBy == 'Ổn định nhất') {
      sorted.sort((a, b) => b.sharpeRatio.compareTo(a.sharpeRatio));
    } else if (_sortBy == 'Nhiều copier') {
      sorted.sort((a, b) => b.copiers.compareTo(a.copiers));
    } else if (_sortBy == 'AUM cao') {
      sorted.sort((a, b) => b.aum.compareTo(a.aum));
    } else {
      sorted.sort((a, b) => b.totalPnlPct.compareTo(a.totalPnlPct));
    }
    return sorted;
  }
}
