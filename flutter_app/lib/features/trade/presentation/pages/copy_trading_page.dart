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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_trading_hero.dart';
part '../widgets/copy_trading_list.dart';
part '../widgets/copy_trading_metrics_common.dart';

const _copyPrimary = AppColors.primary;
const _copyCardTone = AppColors.surface;
const _copyPanelTone = AppColors.surface2;

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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 126 : 28);
    final traders = _sortedTraders(snapshot.traders);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-063 CopyTradingPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Copy Trading',
              subtitle: 'Sao chép · Trade',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyTradingPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CopyHeroCard(snapshot: snapshot),
                    const SizedBox(height: 20),
                    _RiskWarningCard(
                      title: snapshot.riskWarningTitle,
                      message: snapshot.riskWarningText,
                    ),
                    const SizedBox(height: 20),
                    _SortChips(
                      options: snapshot.sortOptions,
                      selected: _sortBy,
                      onChanged: (value) => setState(() => _sortBy = value),
                    ),
                    const SizedBox(height: 20),
                    for (final trader in traders) ...[
                      _TraderCard(
                        trader: trader,
                        onOpen: () => context.go(
                          AppRoutePaths.tradeCopyProvider(trader.id),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
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
