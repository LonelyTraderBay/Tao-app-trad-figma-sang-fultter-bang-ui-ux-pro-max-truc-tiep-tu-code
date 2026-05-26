import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

enum _LiquidTab { stake, swap, holdings }

class StakingLiquidStakingPage extends ConsumerStatefulWidget {
  const StakingLiquidStakingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc364_info_banner');
  static const tabsKey = Key('sc364_tabs');
  static const detailSheetKey = Key('sc364_detail_sheet');
  static const swapCardKey = Key('sc364_swap_card');
  static const swapAmountKey = Key('sc364_swap_amount');
  static const swapSummaryKey = Key('sc364_swap_summary');
  static const holdingsKey = Key('sc364_holdings');
  static const emptyKey = Key('sc364_empty_holdings');
  static const benefitsKey = Key('sc364_benefits');

  static Key tabKey(String id) => Key('sc364_tab_$id');

  static Key tokenKey(String id) => Key('sc364_token_$id');

  static Key detailButtonKey(String id) => Key('sc364_detail_$id');

  static Key stakeButtonKey(String id) => Key('sc364_stake_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingLiquidStakingPage> createState() =>
      _StakingLiquidStakingPageState();
}

class _StakingLiquidStakingPageState
    extends ConsumerState<StakingLiquidStakingPage> {
  final _swapAmountController = TextEditingController();
  _LiquidTab _tab = _LiquidTab.stake;
  String _swapFrom = 'stETH';
  String _swapTo = 'ETH';

  @override
  void dispose() {
    _swapAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingLiquidStakingRepositoryProvider)
        .getLiquidStaking();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-364 StakingLiquidStakingPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _LiquidTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _LiquidTab.stake)
                      _StakeTab(
                        snapshot: snapshot,
                        onDetail: _showTokenDetail,
                        onStake: (token) {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã chọn stake ${token.symbol}'),
                            ),
                          );
                        },
                      ),
                    if (_tab == _LiquidTab.swap)
                      _SwapTab(
                        snapshot: snapshot,
                        swapFrom: _swapFrom,
                        swapTo: _swapTo,
                        amountController: _swapAmountController,
                        onFromChanged: (value) =>
                            setState(() => _swapFrom = value),
                        onToChanged: (value) => setState(() => _swapTo = value),
                        onAmountChanged: (_) => setState(() {}),
                        onReverse: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            final oldFrom = _swapFrom;
                            _swapFrom = _swapTo;
                            _swapTo = oldFrom;
                          });
                        },
                      ),
                    if (_tab == _LiquidTab.holdings)
                      _HoldingsTab(
                        snapshot: snapshot,
                        onStakeNow: () {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = _LiquidTab.stake);
                        },
                      ),
                    _BenefitsGrid(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTokenDetail(StakingLiquidTokenDraft token) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SheetFrame(child: _TokenDetailSheet(token: token));
      },
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingLiquidStakingPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.water_drop_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidTabs extends StatelessWidget {
  const _LiquidTabs({required this.active, required this.onChanged});

  final _LiquidTab active;
  final ValueChanged<_LiquidTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingLiquidStakingPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _LiquidTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                selected: active == tab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _LiquidTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: StakingLiquidStakingPage.tabKey(tab.name),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x4),
          child: Column(
            children: [
              Text(
                _tabLabel(tab),
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: selected ? AppSpacing.buttonHero : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StakeTab extends StatelessWidget {
  const _StakeTab({
    required this.snapshot,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final ValueChanged<StakingLiquidTokenDraft> onDetail;
  final ValueChanged<StakingLiquidTokenDraft> onStake;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Chọn Liquid Token',
          accentColor: AppColors.primary,
          children: [
            for (final token in snapshot.tokens)
              _LiquidTokenCard(
                token: token,
                onDetail: () => onDetail(token),
                onStake: () => onStake(token),
              ),
          ],
        ),
        _RiskNote(snapshot: snapshot),
      ],
    );
  }
}

class _LiquidTokenCard extends StatelessWidget {
  const _LiquidTokenCard({
    required this.token,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidTokenDraft token;
  final VoidCallback onDetail;
  final VoidCallback onStake;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingLiquidStakingPage.tokenKey(token.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.ctaHeight,
                height: AppSpacing.ctaHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  borderRadius: AppRadii.xlRadius,
                  border: Border.all(color: AppColors.primary30),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            token.symbol,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        _ProtocolPill(label: token.protocol),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '1 ${token.symbol} = ${token.exchangeRate.toStringAsFixed(3)} ${token.underlyingAsset}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${token.apy.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TokenMetric(
                  label: 'TVL',
                  value: _formatBillions(token.tvl),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TokenMetric(
                  label: 'Supply',
                  value: _formatMillions(token.totalSupply),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.detailButtonKey(token.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  onPressed: onDetail,
                  child: const Text('Chi tiết'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.stakeButtonKey(token.id),
                  height: AppSpacing.buttonCompact,
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onPressed: onStake,
                  child: const Text('Stake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProtocolPill extends StatelessWidget {
  const _ProtocolPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.primarySoft,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TokenMetric extends StatelessWidget {
  const _TokenMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _RiskNote extends StatelessWidget {
  const _RiskNote({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Lưu ý: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: snapshot.riskNote,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapTab extends StatelessWidget {
  const _SwapTab({
    required this.snapshot,
    required this.swapFrom,
    required this.swapTo,
    required this.amountController,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onAmountChanged,
    required this.onReverse,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final String swapFrom;
  final String swapTo;
  final TextEditingController amountController;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onReverse;

  @override
  Widget build(BuildContext context) {
    final fromToken = snapshot.tokenBySymbol(swapFrom);
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final receive = amount * (fromToken?.exchangeRate ?? 1);
    final minReceive = receive * (1 - snapshot.slippageTolerance / 100);
    final canSwap = amount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingLiquidStakingPage.swapCardKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SwapRow(
                label: 'Từ',
                selected: swapFrom,
                options: snapshot.swapFromOptions,
                amountController: amountController,
                amountKey: StakingLiquidStakingPage.swapAmountKey,
                onSelected: onFromChanged,
                onAmountChanged: onAmountChanged,
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.secondary,
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                  ),
                  onPressed: onReverse,
                  child: const Icon(Icons.swap_vert_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _ReceiveRow(
                label: 'Sang',
                selected: swapTo,
                options: snapshot.swapToOptions,
                receive: receive,
                onSelected: onToChanged,
              ),
              if (canSwap) ...[
                const SizedBox(height: AppSpacing.x4),
                _SwapSummary(
                  key: StakingLiquidStakingPage.swapSummaryKey,
                  swapFrom: swapFrom,
                  swapTo: swapTo,
                  rate: fromToken?.exchangeRate ?? 1,
                  slippage: snapshot.slippageTolerance,
                  minReceive: minReceive,
                  gasFee: snapshot.estimatedGasFee,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          onPressed: canSwap ? () {} : null,
          child: Text('Swap $swapFrom → $swapTo'),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Gợi ý: ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                TextSpan(
                  text: snapshot.swapNote,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SwapRow extends StatelessWidget {
  const _SwapRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.amountController,
    required this.amountKey,
    required this.onSelected,
    required this.onAmountChanged,
  });

  final String label;
  final String selected;
  final List<String> options;
  final TextEditingController amountController;
  final Key amountKey;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _AmountInput(
              fieldKey: amountKey,
              controller: amountController,
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiveRow extends StatelessWidget {
  const _ReceiveRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.receive,
    required this.onSelected,
  });

  final String label;
  final String selected;
  final List<String> options;
  final double receive;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.md,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x4,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    receive > 0 ? receive.toStringAsFixed(6) : '0.0',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(selected) ? selected : options.first,
          dropdownColor: AppColors.surface2,
          iconEnabledColor: AppColors.text2,
          style: AppTextStyles.body,
          isExpanded: true,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: (value) {
            if (value != null) onSelected(value);
          },
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.fieldKey,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: TextField(
        key: fieldKey,
        controller: controller,
        textAlign: TextAlign.right,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        cursorColor: AppColors.primary,
        onChanged: onChanged,
        style: AppTextStyles.baseMedium.copyWith(
          fontFeatures: AppTextStyles.tabularFigures,
        ),
        decoration: InputDecoration(
          hintText: '0.0',
          hintStyle: AppTextStyles.baseMedium.copyWith(color: AppColors.text3),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _SwapSummary extends StatelessWidget {
  const _SwapSummary({
    super.key,
    required this.swapFrom,
    required this.swapTo,
    required this.rate,
    required this.slippage,
    required this.minReceive,
    required this.gasFee,
  });

  final String swapFrom;
  final String swapTo;
  final double rate;
  final double slippage;
  final double minReceive;
  final double gasFee;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          _SheetRow(
            label: 'Exchange Rate',
            value: '1 $swapFrom = $rate $swapTo',
          ),
          _SheetRow(
            label: 'Slippage Tolerance',
            value: '${slippage.toStringAsFixed(1)}%',
          ),
          _SheetRow(
            label: 'Minimum Received',
            value: '${minReceive.toStringAsFixed(6)} $swapTo',
            valueColor: AppColors.warn,
          ),
          _SheetRow(label: 'Gas Fee', value: '~${_formatUsd(gasFee)}'),
        ],
      ),
    );
  }
}

class _HoldingsTab extends StatelessWidget {
  const _HoldingsTab({required this.snapshot, required this.onStakeNow});

  final StakingLiquidStakingSnapshot snapshot;
  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.holdingsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng giá trị Liquid Staking',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          _formatUsd(snapshot.holdingsValue),
                          style: AppTextStyles.heroNumber.copyWith(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: AppSpacing.buttonHero,
                    height: AppSpacing.buttonHero,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      borderRadius: AppRadii.xlRadius,
                      border: Border.all(color: AppColors.primary30, width: 2),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: AppColors.primarySoft,
                      size: AppSpacing.iconLg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Row(
                children: const [
                  Expanded(child: _HoldingMetric(label: 'stETH Balance')),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(child: _HoldingMetric(label: 'rETH Balance')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _EmptyHoldings(onStakeNow: onStakeNow),
      ],
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text('0.0000', style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _EmptyHoldings extends StatelessWidget {
  const _EmptyHoldings({required this.onStakeNow});

  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.emptyKey,
      children: [
        const Icon(
          Icons.water_drop_outlined,
          color: AppColors.text3,
          size: AppSpacing.x7,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Bạn chưa có liquid token nào',
          style: AppTextStyles.body.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          fullWidth: false,
          onPressed: onStakeNow,
          child: const Text('Stake ngay'),
        ),
      ],
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingLiquidStakingPage.benefitsKey,
      label: 'Lợi ích Liquid Staking',
      accentColor: AppColors.primary,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppSpacing.ctaHeight,
                    height: AppSpacing.ctaHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      borderRadius: AppRadii.lgRadius,
                      border: Border.all(color: AppColors.primary30),
                    ),
                    child: Icon(
                      _benefitIcon(benefit.icon),
                      color: AppColors.primarySoft,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    benefit.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    benefit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _TokenDetailSheet extends StatelessWidget {
  const _TokenDetailSheet({required this.token});

  final StakingLiquidTokenDraft token;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingLiquidStakingPage.detailSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(token.name, style: AppTextStyles.sectionTitle),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                _SheetRow(
                  label: 'Exchange Rate',
                  value:
                      '1 ${token.symbol} = ${token.exchangeRate} ${token.underlyingAsset}',
                ),
                _SheetRow(
                  label: 'APY',
                  value: '${token.apy}%',
                  valueColor: AppColors.buy,
                ),
                _SheetRow(
                  label: 'Total Supply',
                  value: '${_formatAmount(token.totalSupply)} ${token.symbol}',
                ),
                _SheetRow(label: 'TVL', value: _formatUsd(token.tvl)),
                _SheetRow(label: 'Protocol', value: token.protocol),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          _BulletSection(
            title: 'Lợi ích',
            items: token.benefits,
            success: true,
          ),
          const SizedBox(height: AppSpacing.x5),
          _BulletSection(title: 'Rủi ro', items: token.risks, success: false),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.success,
  });

  final String title;
  final List<String> items;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.buy : AppColors.sell;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.x3),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.x1,
                  height: AppSpacing.x1,
                  margin: const EdgeInsets.only(top: AppSpacing.x3),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _tabLabel(_LiquidTab tab) {
  return switch (tab) {
    _LiquidTab.stake => 'Stake',
    _LiquidTab.swap => 'Swap',
    _LiquidTab.holdings => 'Holdings',
  };
}

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'zap' => Icons.bolt_rounded,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'swap' => Icons.swap_horiz_rounded,
    _ => Icons.water_drop_outlined,
  };
}

String _formatUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(1)}M';
  }
  return '\$${value.toStringAsFixed(value == 0 ? 0 : 2)}';
}

String _formatBillions(double value) {
  return '\$${(value / 1000000000).toStringAsFixed(1)}B';
}

String _formatMillions(double value) {
  return '${(value / 1000000).toStringAsFixed(1)}M';
}

String _formatAmount(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}

extension on StakingLiquidStakingSnapshot {
  StakingLiquidTokenDraft? tokenBySymbol(String symbol) {
    for (final token in tokens) {
      if (token.symbol == symbol) return token;
    }
    return null;
  }
}
