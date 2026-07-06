import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part '../widgets/launchpad_swap_aggregator_input.dart';
part '../widgets/launchpad_swap_aggregator_quotes.dart';
part '../widgets/launchpad_swap_aggregator_history_settings.dart';

enum _SwapTab { compare, history, settings }

class LaunchpadSwapAggregatorPage extends ConsumerStatefulWidget {
  const LaunchpadSwapAggregatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc314_launchpad_swap_content');
  static const tabsKey = Key('sc314_launchpad_swap_tabs');
  static const inputKey = Key('sc314_launchpad_swap_input');
  static const flipKey = Key('sc314_launchpad_swap_flip');
  static const bestRouteKey = Key('sc314_launchpad_swap_best_route');
  static const dexListKey = Key('sc314_launchpad_swap_dex_list');
  static const warningKey = Key('sc314_launchpad_swap_warning');
  static const ctaKey = Key('sc314_launchpad_swap_cta');
  static const historyKey = Key('sc314_launchpad_swap_history');
  static const settingsKey = Key('sc314_launchpad_swap_settings');
  static const autoRefreshKey = Key('sc314_launchpad_swap_auto_refresh');

  static Key dexKey(String id) => Key('sc314_launchpad_swap_dex_$id');
  static Key dexToggleKey(String id) =>
      Key('sc314_launchpad_swap_dex_toggle_$id');
  static Key slippageKey(String value) =>
      Key('sc314_launchpad_swap_slippage_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadSwapAggregatorPage> createState() =>
      _LaunchpadSwapAggregatorPageState();
}

class _LaunchpadSwapAggregatorPageState
    extends ConsumerState<LaunchpadSwapAggregatorPage> {
  late final TextEditingController _amountController;
  late String _fromToken;
  late String _toToken;
  late String _slippage;
  late bool _autoRefresh;
  var _activeTab = _SwapTab.compare;
  String? _expandedDexId;
  String? _swapPreview;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(launchpadControllerProvider).getSwapAggregator();
    _fromToken = snapshot.fromToken;
    _toToken = snapshot.toToken;
    _slippage = snapshot.slippageTolerance.toStringAsFixed(1);
    _autoRefresh = snapshot.autoRefresh;
    _amountController = TextEditingController(text: snapshot.amount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getSwapAggregator();
    final bestDex = snapshot.dexQuotes.firstWhere(
      (quote) => quote.recommended,
      orElse: () => snapshot.dexQuotes.first,
    );
    final amount = double.tryParse(_amountController.text) ?? 0;
    final output = amount == 0 ? 0.0 : amount / bestDex.price;
    final worst = snapshot.dexQuotes.last;
    final savings = ((bestDex.price - worst.price) / worst.price * 100).clamp(
      0,
      100,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final ctaInset = _activeTab == _SwapTab.compare
        ? AppSpacing.launchpadSwapStickyCtaClearance
        : 0.0;
    final scrollTailReserve = navInset + safeBottom + AppSpacing.x3 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-314 LaunchpadSwapAggregatorPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: scrollTailReserve,
              semanticLabel:
                  'SC-314 LaunchpadSwapAggregatorPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                subtitle: 'So sánh swap · Xác nhận route trước khi đổi',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: VitInsetScrollView(
                key: LaunchpadSwapAggregatorPage.contentKey,
                physics: const ClampingScrollPhysics(),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.tight,
                  children: [
                    _Tabs(
                      activeTab: _activeTab,
                      onChanged: (tab) => setState(() => _activeTab = tab),
                    ),
                    if (_activeTab == _SwapTab.compare) ...[
                      _SwapInputCard(
                        fromToken: _fromToken,
                        toToken: _toToken,
                        amountController: _amountController,
                        output: output,
                        bestPrice: bestDex.price,
                        onFlip: () {
                          setState(() {
                            final previous = _fromToken;
                            _fromToken = _toToken;
                            _toToken = previous;
                          });
                        },
                        onAmountChanged: (_) => setState(() {}),
                      ),
                      _BestRouteCard(bestDex: bestDex, savings: savings),
                      _DexList(
                        quotes: snapshot.dexQuotes,
                        amount: amount,
                        expandedDexId: _expandedDexId,
                        onToggle: (id) => setState(() {
                          _expandedDexId = _expandedDexId == id ? null : id;
                        }),
                      ),
                      _SwapWarning(slippage: _slippage),
                      if (_swapPreview != null)
                        _SwapPreview(message: _swapPreview!),
                    ] else if (_activeTab == _SwapTab.history) ...[
                      _HistorySection(history: snapshot.history),
                    ] else ...[
                      _SettingsSection(
                        slippage: _slippage,
                        autoRefresh: _autoRefresh,
                        onSlippageChanged: (value) =>
                            setState(() => _slippage = value),
                        onAutoRefreshChanged: (value) =>
                            setState(() => _autoRefresh = value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_activeTab == _SwapTab.compare)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadSwapAggregatorPage.ctaKey,
                    onPressed: () => setState(() {
                      _swapPreview =
                          'Swap ${_amountController.text} $_fromToken qua ${bestDex.name}';
                    }),
                    leading: const Icon(Icons.repeat_rounded),
                    child: Text('Swap v\u1EDBi ${bestDex.name}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
