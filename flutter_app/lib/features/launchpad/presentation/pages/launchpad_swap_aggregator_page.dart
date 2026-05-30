import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

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
    final ctaInset = _activeTab == _SwapTab.compare ? 118.0 : 0.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-314 LaunchpadSwapAggregatorPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                _Tabs(
                  activeTab: _activeTab,
                  onChanged: (tab) => setState(() => _activeTab = tab),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadSwapAggregatorPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
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
                          _BestRouteAlert(bestDex: bestDex, savings: savings),
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
              ],
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
                    child: Text('Swap voi ${bestDex.name}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _SwapTab activeTab;
  final ValueChanged<_SwapTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'compare', label: 'So sanh'),
          VitTabItem(key: 'history', label: 'Lich su'),
          VitTabItem(key: 'settings', label: 'Cai dat'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_SwapTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _SwapInputCard extends StatelessWidget {
  const _SwapInputCard({
    required this.fromToken,
    required this.toToken,
    required this.amountController,
    required this.output,
    required this.bestPrice,
    required this.onFlip,
    required this.onAmountChanged,
  });

  final String fromToken;
  final String toToken;
  final TextEditingController amountController;
  final double output;
  final double bestPrice;
  final VoidCallback onFlip;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadSwapAggregatorPage.inputKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Swap from',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TokenButton(token: fromToken, color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: TextField(
                  controller: amountController,
                  onChanged: onAmountChanged,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontSize: 18,
                    fontWeight: AppTextStyles.bold,
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: AppColors.text3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Center(
            child: IconButton.filled(
              key: LaunchpadSwapAggregatorPage.flipKey,
              onPressed: onFlip,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onAccent,
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Swap to',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TokenButton(token: toToken, color: AppColors.accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '~${output.toStringAsFixed(4)}',
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontSize: 18,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '@${bestPrice.toStringAsFixed(2)} $fromToken',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenButton extends StatelessWidget {
  const _TokenButton({required this.token, required this.color});

  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              token.substring(0, 2),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            token,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _BestRouteAlert extends StatelessWidget {
  const _BestRouteAlert({required this.bestDex, required this.savings});

  final LaunchpadSwapDexQuoteDraft bestDex;
  final num savings;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.bestRouteKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.buy, size: 19),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best rate: ${bestDex.name}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Saving ${savings.toStringAsFixed(2)}% vs worst route - Gas: \$${bestDex.gas.toStringAsFixed(0)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DexList extends StatelessWidget {
  const _DexList({
    required this.quotes,
    required this.amount,
    required this.expandedDexId,
    required this.onToggle,
  });

  final List<LaunchpadSwapDexQuoteDraft> quotes;
  final double amount;
  final String? expandedDexId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.dexListKey,
      child: VitPageSection(
        label: 'DEX so sanh',
        accentColor: AppColors.primary,
        children: [
          for (final quote in quotes)
            _DexQuoteCard(
              quote: quote,
              amount: amount,
              expanded: expandedDexId == quote.id,
              onToggle: () => onToggle(quote.id),
            ),
        ],
      ),
    );
  }
}

class _DexQuoteCard extends StatelessWidget {
  const _DexQuoteCard({
    required this.quote,
    required this.amount,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadSwapDexQuoteDraft quote;
  final double amount;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final output = amount == 0 ? 0.0 : amount / quote.price;
    final impactColor = quote.priceImpact < .2
        ? AppColors.buy
        : quote.priceImpact < .3
        ? AppColors.primary
        : AppColors.sell;
    return VitCard(
      key: LaunchpadSwapAggregatorPage.dexKey(quote.id),
      borderColor: quote.recommended ? AppColors.buy20 : AppColors.cardBorder,
      padding: EdgeInsets.zero,
      clip: true,
      child: InkWell(
        key: LaunchpadSwapAggregatorPage.dexToggleKey(quote.id),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              Row(
                children: [
                  _DexLogo(quote: quote),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              quote.name,
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            if (quote.recommended) const _BestPill(),
                          ],
                        ),
                        Text(
                          quote.estimatedTime,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        output.toStringAsFixed(4),
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '~\$${amount.toStringAsFixed(0)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  _Metric(
                    label: 'Price Impact',
                    value: '${quote.priceImpact.toStringAsFixed(2)}%',
                    color: impactColor,
                    align: TextAlign.start,
                  ),
                  _Metric(
                    label: 'Gas Fee',
                    value: '\$${quote.gas.toStringAsFixed(0)}',
                    color: AppColors.text1,
                    align: TextAlign.center,
                  ),
                  _Metric(
                    label: 'Liquidity',
                    value:
                        '\$${(quote.liquidity / 1000000).toStringAsFixed(1)}M',
                    color: AppColors.text1,
                    align: TextAlign.end,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: AppSpacing.x3),
                _RouteDetails(quote: quote),
              ],
              const SizedBox(height: AppSpacing.x1),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DexLogo extends StatelessWidget {
  const _DexLogo({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: quote.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        quote.symbol.substring(0, 2),
        style: AppTextStyles.micro.copyWith(
          color: quote.accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _BestPill extends StatelessWidget {
  const _BestPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          'BEST',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
    required this.align,
  });

  final String label;
  final String value;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: switch (align) {
          TextAlign.end => CrossAxisAlignment.end,
          TextAlign.center => CrossAxisAlignment.center,
          _ => CrossAxisAlignment.start,
        },
        children: [
          Text(
            label,
            textAlign: align,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            textAlign: align,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetails extends StatelessWidget {
  const _RouteDetails({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < quote.route.length; i++) ...[
                _RouteToken(token: quote.route[i]),
                if (i < quote.route.length - 1)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 14,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: quote.security == LaunchpadSwapSecurity.high
                    ? AppColors.buy
                    : AppColors.primary,
                size: 13,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'Security: ${quote.security == LaunchpadSwapSecurity.high ? 'High' : 'Medium'}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteToken extends StatelessWidget {
  const _RouteToken({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          token,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SwapWarning extends StatelessWidget {
  const _SwapWarning({required this.slippage});

  final String slippage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.warningKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Gia chi mang tinh chat tham khao. Kiem tra lai truoc khi swap. Slippage: $slippage%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapPreview extends StatelessWidget {
  const _SwapPreview({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: AppColors.buy20,
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});

  final List<LaunchpadSwapHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.historyKey,
      child: VitPageSection(
        label: 'Giao dich gan day',
        accentColor: AppColors.buy,
        children: [
          for (final swap in history)
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${swap.from} -> ${swap.to}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _StatusPill(status: swap.status),
                          ],
                        ),
                      ),
                      Text(
                        '${swap.amount.toStringAsFixed(0)} ${swap.from}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          swap.dex,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Text(
                        '@${swap.rate.toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          swap.timestamp,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        swap.txHash,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LaunchpadSwapStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      LaunchpadSwapStatus.success => AppColors.buy,
      LaunchpadSwapStatus.pending => AppColors.primary,
      LaunchpadSwapStatus.failed => AppColors.sell,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.slippage,
    required this.autoRefresh,
    required this.onSlippageChanged,
    required this.onAutoRefreshChanged,
  });

  final String slippage;
  final bool autoRefresh;
  final ValueChanged<String> onSlippageChanged;
  final ValueChanged<bool> onAutoRefreshChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadSwapAggregatorPage.settingsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Slippage & Gas',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slippage Tolerance (%)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Row(
                      children: [
                        for (final value in ['0.1', '0.5', '1.0', '3.0']) ...[
                          Expanded(
                            child: _SlippageButton(
                              value: value,
                              active: slippage == value,
                              onTap: () => onSlippageChanged(value),
                            ),
                          ),
                          if (value != '3.0')
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto Refresh',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Cap nhat gia moi 10s',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: LaunchpadSwapAggregatorPage.autoRefreshKey,
                          value: autoRefresh,
                          activeThumbColor: AppColors.primary,
                          onChanged: onAutoRefreshChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'An toan',
            accentColor: AppColors.accent,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.x3),
                decoration: BoxDecoration(
                  color: AppColors.accent08,
                  border: Border.all(color: AppColors.accent20),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.accent,
                      size: 15,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Luon kiem tra dia chi hop dong va chi swap tren cac DEX uy tin. Khong chia se private key.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlippageButton extends StatelessWidget {
  const _SlippageButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadSwapAggregatorPage.slippageKey(value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.bg,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '$value%',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
