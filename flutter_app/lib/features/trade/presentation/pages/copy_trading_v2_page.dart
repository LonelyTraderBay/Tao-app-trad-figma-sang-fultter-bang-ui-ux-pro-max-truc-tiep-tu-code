import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/copy_trading_v2_variant_hero.dart';
part '../widgets/copy_trading_v2_list.dart';
part '../widgets/copy_trading_v2_common.dart';

const _copyPrimary = AppColors.primary;
const _copyPurple = AppColors.accent;
const _copySpace = AppSpacing.x2;
const _copyCardSpace = AppSpacing.tradePageContentGap;
const _copyVariantMinHeight = 44.0;
const _copyVariantButtonHeight = 40.0;
const _copyGlassHeroMinHeight = 188.0;
const _copyBoldHeroMinHeight = 176.0;
const _copyHeroIconBox = 40.0;
const _copyHeroIconGlyph = 22.0;
const _copyGlassStatHeight = 104.0;
const _copyGlassStatIconBox = 30.0;
const _copyGlassStatIconGlyph = 16.0;
const _copyBoldStatHeight = 62.0;

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
    final traders = _sortedTraders(copyTrading.traders).take(3).toList();

    return VitTradeHubScaffold(
      title: 'Copy Trading v2',
      subtitle: 'With Variant Switcher',
      semanticLabel: 'SC-064 CopyTradingPageV2',
      contentKey: CopyTradingV2Page.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Hero variant',
          child: _VariantSwitcher(
            variants: snapshot.heroVariants,
            selected: _heroVariant,
            onChanged: (value) => setState(() => _heroVariant = value),
          ),
        ),
        VitTradeSection(
          title: 'Tổng quan',
          child: _HeroCard(snapshot: copyTrading, variant: _heroVariant),
        ),
        _RiskWarningCard(
          title: copyTrading.riskWarningTitle,
          message: copyTrading.riskWarningText,
        ),
        VitTradeSection(
          title: 'Nhà cung cấp',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SortChips(
                options: copyTrading.sortOptions,
                selected: _sortBy,
                onChanged: (value) => setState(() => _sortBy = value),
              ),
              _TraderList(
                traders: traders,
                onOpen: (trader) => context.go(
                  AppRoutePaths.tradeCopyProvider(
                    trader.id,
                    backPath: AppRoutePaths.tradeCopyTradingV2,
                  ),
                ),
              ),
            ],
          ),
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
