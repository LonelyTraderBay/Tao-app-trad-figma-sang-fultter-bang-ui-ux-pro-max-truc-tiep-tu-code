import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert_page_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'convert_page_part_01.dart';
part 'convert_page_part_02.dart';
part '../widgets/convert_page_header_widgets.dart';
part '../widgets/convert_page_amount_widgets.dart';

const _tradePrimary = AppColors.primary;
const _convertSpace = AppSpacing.x2;
const _convertVisualScrollClearance = 112.0;
const _convertNativeScrollClearance = 72.0;
const _convertModeHeight = 44.0;
const _convertChipHeight = 34.0;
const _convertControlHeight = 40.0;
const _convertSwapSize = 40.0;
const _convertFromCardHeight = 168.0;
const _convertToCardHeight = 100.0;
const _convertPairHeight = 44.0;
const _convertSlippageHeight = 104.0;
const _convertButtonHeight = 44.0;
const _convertSparklineHeight = 20.0;

enum _ConvertMode { market, limit, schedule }

class ConvertPage extends ConsumerStatefulWidget {
  const ConvertPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc056_convert_scroll_content');
  static const backKey = Key('sc056_back');
  static const swapKey = Key('sc056_swap');
  static const fromAssetKey = Key('sc056_from_asset');
  static const toAssetKey = Key('sc056_to_asset');
  static const amountFieldKey = Key('sc056_amount_field');
  static const submitKey = Key('sc056_submit');

  static Key modeKey(String id) => Key('sc056_mode_$id');
  static Key favoriteKey(String label) => Key('sc056_favorite_$label');
  static Key pctKey(int pct) => Key('sc056_pct_$pct');
  static Key slippageKey(String pct) => Key('sc056_slippage_$pct');
  static Key toolKey(String id) => Key('sc056_tool_$id');
  static Key assetOptionKey(String side, String symbol) =>
      Key('sc056_asset_${side}_$symbol');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends ConsumerState<ConvertPage> {
  final _amountController = TextEditingController();
  _ConvertMode _mode = _ConvertMode.market;
  late String _fromSymbol;
  late String _toSymbol;
  double _slippage = .5;
  TradeConvertReceipt? _receipt;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(tradeReadModelControllerProvider).getConvert();
    _fromSymbol = snapshot.fromAsset.symbol;
    _toSymbol = snapshot.toAsset.symbol;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeReadModelControllerProvider).getConvert();
    final fromAsset = _asset(snapshot, _fromSymbol);
    final toAsset = _asset(snapshot, _toSymbol);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final request = TradeConvertRequest(
      fromSymbol: fromAsset.symbol,
      toSymbol: toAsset.symbol,
      amount: amount,
      slippagePct: _slippage,
      mode: _mode.name,
    );
    final quote = ref
        .watch(tradeReadModelControllerProvider)
        .previewConvert(request);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _convertVisualScrollClearance
            : _convertNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-056 ConvertPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: _ConvertHeader(
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.trade,
              mode: BackNavigationMode.historyThenFallback,
            ),
          ),
          child: SingleChildScrollView(
            key: ConvertPage.contentKey,
            padding: EdgeInsetsDirectional.only(bottom: scrollEndClearance),
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                _ModeTabs(
                  mode: _mode,
                  onChanged: (value) => setState(() => _mode = value),
                ),
                _FavoriteHeader(),
                _FavoritePairs(
                  pairs: snapshot.favoritePairs,
                  activeFrom: fromAsset.symbol,
                  activeTo: toAsset.symbol,
                  onSelected: _selectFavoritePair,
                ),
                _RateBar(
                  label: quote.quoteLabel,
                  countdown: '${quote.validSeconds}s',
                ),
                _AmountCard(
                  label: 'Từ',
                  asset: fromAsset,
                  amountController: _amountController,
                  input: true,
                  onChanged: () => setState(() => _receipt = null),
                  onAssetTap: () => _showAssetPicker('from', snapshot.assets),
                  onPercent: (pct) => _setPercentAmount(fromAsset, pct),
                ),
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: Center(child: _SwapButton(onTap: _swapAssets)),
                ),
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: _AmountCard(
                    label: 'Sang',
                    asset: toAsset,
                    quoteAmount: quote.toAmount,
                    onAssetTap: () => _showAssetPicker('to', snapshot.assets),
                  ),
                ),
                const _ToolRow(),
                _PairMiniCard(
                  fromSymbol: fromAsset.symbol,
                  toSymbol: toAsset.symbol,
                ),
                _SlippageCard(
                  options: snapshot.slippageOptions,
                  active: _slippage,
                  onChanged: (value) => setState(() {
                    _slippage = value;
                    _receipt = null;
                  }),
                ),
                _ConvertRiskReviewPanel(
                  quote: quote,
                  fromSymbol: fromAsset.symbol,
                  toSymbol: toAsset.symbol,
                  slippage: _slippage,
                ),
                _SubmitButton(
                  enabled: quote.canSubmit,
                  receipt: _receipt,
                  onPressed: () => _submit(request),
                ),
                _HistoryHeader(),
                _HistoryList(records: snapshot.history),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TradeConvertAsset _asset(TradeConvertSnapshot snapshot, String symbol) {
    return snapshot.assets.firstWhere(
      (asset) => asset.symbol == symbol,
      orElse: () => snapshot.assets.first,
    );
  }

  void _selectFavoritePair(TradeConvertFavoritePair pair) {
    setState(() {
      _fromSymbol = pair.fromSymbol;
      _toSymbol = pair.toSymbol;
      _receipt = null;
    });
  }

  void _swapAssets() {
    setState(() {
      final currentFrom = _fromSymbol;
      _fromSymbol = _toSymbol;
      _toSymbol = currentFrom;
      _receipt = null;
    });
  }

  void _setPercentAmount(TradeConvertAsset asset, int pct) {
    final amount = asset.balance * pct / 100;
    setState(() {
      _amountController.text = formatConvertInputAmount(amount);
      _receipt = null;
    });
  }

  Future<void> _showAssetPicker(
    String side,
    List<TradeConvertAsset> assets,
  ) async {
    final selected = await showVitBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .72),
      builder: (_) => ConvertAssetSheet(
        side: side,
        assets: assets,
        selectedSymbol: side == 'from' ? _fromSymbol : _toSymbol,
        excludedSymbol: side == 'from' ? _toSymbol : _fromSymbol,
        optionKeyBuilder: ConvertPage.assetOptionKey,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (side == 'from') {
        _fromSymbol = selected;
      } else {
        _toSymbol = selected;
      }
      _receipt = null;
    });
  }

  void _submit(TradeConvertRequest request) {
    if (request.amount <= 0) return;
    setState(() {
      _receipt = ref
          .read(tradeReadModelControllerProvider)
          .submitConvert(request);
    });
    if (Scaffold.maybeOf(context) != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã tạo ${_receipt!.convertId}')));
    }
  }
}
