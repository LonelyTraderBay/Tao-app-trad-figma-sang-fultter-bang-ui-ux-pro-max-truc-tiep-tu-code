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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_trading_v2_variant_hero.dart';
part '../widgets/copy_trading_v2_list.dart';
part '../widgets/copy_trading_v2_common.dart';

const _copyPrimary = AppColors.primary;
const _copyPurple = AppColors.accent;

class CopyTradingV2Page extends ConsumerStatefulWidget {
  const CopyTradingV2Page({super.key, this.shellRenderMode});

  static const contentKey = Key('sc064_copy_trading_v2_scroll_content');
  static Key variantKey(String id) => Key('sc064_variant_$id');
  static Key sortKey(String option) => Key('sc064_sort_$option');
  static Key traderKey(String id) => Key('sc064_trader_$id');
  static Key detailKey(String id) => Key('sc064_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyTradingV2Page> createState() => _CopyTradingV2PageState();
}

class _CopyTradingV2PageState extends ConsumerState<CopyTradingV2Page> {
  String _sortBy = 'Top ROI';
  String _heroVariant = 'clean';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeCopyTradingV2Provider);
    final copyTrading = snapshot.copyTrading;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 112 : 28);
    final traders = _sortedTraders(copyTrading.traders).take(3).toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-064 CopyTradingPageV2',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Copy Trading v2',
            subtitle: 'With Variant Switcher',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyTradingV2Page.contentKey,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.rowPy,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.cardGap,
                    children: [
                      _VariantSwitcher(
                        variants: snapshot.heroVariants,
                        selected: _heroVariant,
                        onChanged: (value) =>
                            setState(() => _heroVariant = value),
                      ),
                      _HeroCard(snapshot: copyTrading, variant: _heroVariant),
                      _RiskWarningCard(
                        title: copyTrading.riskWarningTitle,
                        message: copyTrading.riskWarningText,
                      ),
                      VitPageSection(
                        customGap: AppSpacing.cardGap,
                        children: [
                          _SortChips(
                            options: copyTrading.sortOptions,
                            selected: _sortBy,
                            onChanged: (value) =>
                                setState(() => _sortBy = value),
                          ),
                          for (final trader in traders)
                            _TraderCard(
                              trader: trader,
                              onOpen: () => context.go(
                                AppRoutePaths.tradeCopyProvider(
                                  trader.id,
                                  backPath: AppRoutePaths.tradeCopyTradingV2,
                                ),
                              ),
                            ),
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
