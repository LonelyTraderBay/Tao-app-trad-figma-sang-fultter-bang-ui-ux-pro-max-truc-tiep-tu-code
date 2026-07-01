import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
import 'package:vit_trade_flutter/features/trade/presentation/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_terminal_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert_pair_info_sheet.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert_pair_route.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert_page_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'convert_page_part_01.dart';
part 'convert_page_part_02.dart';
part '../widgets/convert_page_header_widgets.dart';
part '../widgets/convert_page_amount_widgets.dart';

const _tradePrimary = AppColors.primary;

bool _convertSnapshotIsOffline(TradeConvertSnapshot snapshot) {
  return snapshot.lastUpdatedLabel.toLowerCase().contains('offline');
}

bool _convertSnapshotHasError(TradeConvertSnapshot snapshot) {
  return snapshot.lastUpdatedLabel.toLowerCase().contains('error');
}

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
    final scrollEndClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );
    final isOffline = _convertSnapshotIsOffline(snapshot);
    final hasError = _convertSnapshotHasError(snapshot);
    final pairId = _resolvedSpotPairId(snapshot);
    final alertBadgeCount = _activeAlertCountForPair(pairId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-056 ConvertPage',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: VitAutoHideHeaderScaffold(
          header: _ConvertHeader(
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.trade,
              mode: BackNavigationMode.historyThenFallback,
            ),
            onSettings: _openSettings,
          ),
          child: VitInsetScrollView(
            key: ConvertPage.contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                _ModeTabs(
                  mode: _mode,
                  onChanged: (value) => setState(() => _mode = value),
                ),
                const SizedBox(height: AppSpacing.x3),
                VitTradeProductTabs(
                  activeId: 'convert',
                  tabs: [
                    VitTradeProductTab(
                      id: 'spot',
                      label: 'Spot',
                      tabKey: TradePage.quickNavKey('spot'),
                      onTap: () => context.go(AppRoutePaths.trade),
                    ),
                    VitTradeProductTab(
                      id: 'futures',
                      label: 'Futures',
                      tabKey: TradePage.quickNavKey('futures'),
                      onTap: () => context.go(AppRoutePaths.tradeFutures('btcusdt')),
                    ),
                    VitTradeProductTab(
                      id: 'margin',
                      label: 'Margin',
                      tabKey: TradePage.quickNavKey('margin'),
                      onTap: () => context.go(AppRoutePaths.tradeMargin),
                    ),
                    VitTradeProductTab(
                      id: 'convert',
                      label: 'Convert',
                      tabKey: TradePage.quickNavKey('convert'),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                if (isOffline)
                  const VitOfflineBanner(
                    message: 'Mất kết nối. Đang hiển thị tỷ giá đã lưu.',
                    detail: 'Thử làm mới sau khi có mạng.',
                  ),
                if (!isOffline && hasError)
                  const VitBanner(
                    variant: VitBannerVariant.error,
                    icon: Icons.error_outline_rounded,
                    message: 'Không thể làm mới tỷ giá.',
                    detail: 'Đang hiển thị báo giá gần nhất.',
                  ),
                _ConvertHeroCard(
                  fromAsset: fromAsset,
                  toAsset: toAsset,
                  amountController: _amountController,
                  quoteAmount: quote.toAmount,
                  quoteLabel: quote.quoteLabel,
                  countdown: '${quote.validSeconds}s',
                  favoritePairs: snapshot.favoritePairs,
                  activeFrom: fromAsset.symbol,
                  activeTo: toAsset.symbol,
                  onFromChanged: () => setState(() => _receipt = null),
                  onFromAssetTap: () =>
                      _showAssetPicker('from', snapshot.assets),
                  onToAssetTap: () => _showAssetPicker('to', snapshot.assets),
                  onPercent: (pct) => _setPercentAmount(fromAsset, pct),
                  onSwap: _swapAssets,
                  onFavoriteSelected: _selectFavoritePair,
                ),
                _ConvertRiskReviewPanel(
                  quote: quote,
                  fromSymbol: fromAsset.symbol,
                  toSymbol: toAsset.symbol,
                  slippage: _slippage,
                ),
                _SubmitButton(
                  enabled: quote.canSubmit && !isOffline,
                  receipt: _receipt,
                  onPressed: () => _submit(request),
                ),
                _ConvertToolGrid(
                  alertBadgeCount: alertBadgeCount,
                  onChart: () => _openChart(pairId),
                  onDepth: () => _openDepth(pairId),
                  onInfo: () => _openInfoSheet(
                    snapshot: snapshot,
                    quote: quote,
                    pairId: pairId,
                  ),
                  onAlert: _openAlerts,
                ),
                _SlippageRow(
                  options: snapshot.slippageOptions,
                  active: _slippage,
                  onChanged: (value) => setState(() {
                    _slippage = value;
                    _receipt = null;
                  }),
                ),
                VitTradeSection(
                  title: 'Giao dịch gần đây',
                  actionLabel: 'Xem tất cả',
                  onAction: () {},
                  child: _HistoryList(records: snapshot.history),
                ),
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
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.modalScrim,
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

  String? _resolvedSpotPairId(TradeConvertSnapshot snapshot) {
    return resolveConvertSpotPairId(
      fromSymbol: _fromSymbol,
      toSymbol: _toSymbol,
      knownPairs: snapshot.trade.pairs,
    );
  }

  int _activeAlertCountForPair(String? pairId) {
    if (pairId == null) return 0;
    final alerts = ref
        .read(marketControllerProvider)
        .getPriceAlerts()
        .priceAlerts;
    return alerts
        .where((alert) => alert.isActive && alert.pairId == pairId)
        .length;
  }

  void _showUnsupportedPairSnackBar() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Chưa có biểu đồ spot cho cặp này')),
    );
  }

  void _openChart(String? pairId) {
    if (pairId == null) {
      _showUnsupportedPairSnackBar();
      return;
    }
    context.push(AppRoutePaths.tradeAdvancedChart(pairId));
  }

  void _openDepth(String? pairId) {
    if (pairId == null) {
      _showUnsupportedPairSnackBar();
      return;
    }
    final returnTo = Uri.encodeComponent(AppRoutePaths.tradeConvert);
    context.push('${AppRoutePaths.pairDepth(pairId)}?returnTo=$returnTo');
  }

  Future<void> _openInfoSheet({
    required TradeConvertSnapshot snapshot,
    required TradeConvertQuote quote,
    required String? pairId,
  }) async {
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.modalScrim,
      builder: (_) => ConvertPairInfoSheet(
        fromSymbol: _fromSymbol,
        toSymbol: _toSymbol,
        modeLabel: _convertModeLabel(_mode),
        quoteLabel: quote.quoteLabel,
        countdownLabel: '${quote.validSeconds}s',
        minUsd: snapshot.minUsd,
        maxUsd: snapshot.maxUsd,
        slippageLabel: '${_slippage.toStringAsFixed(1)}%',
        pairId: pairId,
        onViewTokenInfo: pairId == null
            ? null
            : () {
                Navigator.of(context).pop();
                context.push(AppRoutePaths.pairInfo(pairId));
              },
      ),
    );
  }

  void _openAlerts() {
    context.push(AppRoutePaths.marketsAlerts);
  }

  void _openSettings() {
    context.push(AppRoutePaths.tradeSettings);
  }

  String _convertModeLabel(_ConvertMode mode) => switch (mode) {
    _ConvertMode.market => 'Market',
    _ConvertMode.limit => 'Limit',
    _ConvertMode.schedule => 'Tự động',
  };

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
