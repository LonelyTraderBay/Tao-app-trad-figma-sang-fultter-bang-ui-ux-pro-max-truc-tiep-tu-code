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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/copy_trading_hero.dart';
part '../widgets/copy_trading_list.dart';
part '../widgets/copy_trading_metrics_common.dart';

const _copyPrimary = AppColors.primary;
const _copySpace = AppSpacing.x2;
const _copyCardSpace = AppSpacing.tradePageContentGap;
const _copyWeeklyChartHeight = AppSpacing.copyTradingWeeklyChartHeight;
const _copyBadgeSize = AppSpacing.ctaLoadingIcon;
const _copyButtonHeight = AppSpacing.homeHeroActionHeight;
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
    final traders = _sortedTraders(snapshot.traders);

    return VitTradeHubScaffold(
      title: 'Copy Trading',
      subtitle: 'Sao chép · Trade',
      semanticLabel: 'SC-063 CopyTradingPage',
      contentKey: CopyTradingPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        VitTradeSection(
          title: 'Tổng quan',
          child: _CopyHeroCard(snapshot: snapshot),
        ),
        _RiskWarningCard(
          title: snapshot.riskWarningTitle,
          message: snapshot.riskWarningText,
        ),
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Review copy trading risk',
            message:
                'Compare provider drawdown, copier concentration, fees, and stop rules before copying any strategy.',
            contractId: 'Providers available: ${traders.length}',
            density: VitDensity.compact,
          ),
        ),
        VitTradeSection(
          title: 'Nhà cung cấp',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                _TraderList(
                  traders: traders,
                  onOpen: (trader) =>
                      context.go(AppRoutePaths.tradeCopyProvider(trader.id)),
                ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Lưu ý',
          child: _Disclaimer(text: snapshot.disclaimer),
        ),
      ],
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
