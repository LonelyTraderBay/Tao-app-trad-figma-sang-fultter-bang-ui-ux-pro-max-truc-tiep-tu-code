import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _tradePrimary = AppColors.primary;
const _tradePrimaryDark = AppColors.primaryDark;
const _panelBackground = AppColors.surface;
const _chipBackground = AppColors.surface2;
const _rateBackground = AppColors.surface;
const _disabledPrimary = AppColors.surface3;

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
    final snapshot = ref.read(tradeRepositoryProvider).getConvert();
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
    final snapshot = ref.watch(tradeRepositoryProvider).getConvert();
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
    final quote = ref.watch(tradeRepositoryProvider).previewConvert(request);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-056 ConvertPage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: ConvertPage.contentKey,
          padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ConvertHeader(onBack: () => context.go(AppRoutePaths.trade)),
              const SizedBox(height: 20),
              _ModeTabs(
                mode: _mode,
                onChanged: (value) => setState(() => _mode = value),
              ),
              const SizedBox(height: 18),
              _FavoriteHeader(),
              const SizedBox(height: 9),
              _FavoritePairs(
                pairs: snapshot.favoritePairs,
                activeFrom: fromAsset.symbol,
                activeTo: toAsset.symbol,
                onSelected: _selectFavoritePair,
              ),
              const SizedBox(height: 22),
              _RateBar(
                label: quote.quoteLabel,
                countdown: '${quote.validSeconds}s',
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              const _ToolRow(),
              const SizedBox(height: 16),
              _PairMiniCard(
                fromSymbol: fromAsset.symbol,
                toSymbol: toAsset.symbol,
              ),
              const SizedBox(height: 16),
              _SlippageCard(
                options: snapshot.slippageOptions,
                active: _slippage,
                onChanged: (value) => setState(() {
                  _slippage = value;
                  _receipt = null;
                }),
              ),
              const SizedBox(height: 18),
              _SubmitButton(
                enabled: quote.canSubmit,
                receipt: _receipt,
                onPressed: () => _submit(request),
              ),
              const SizedBox(height: 18),
              _HistoryHeader(),
              const SizedBox(height: 9),
              _HistoryList(records: snapshot.history),
            ],
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
      _amountController.text = _formatInputAmount(amount);
      _receipt = null;
    });
  }

  Future<void> _showAssetPicker(
    String side,
    List<TradeConvertAsset> assets,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .72),
      builder: (_) => _AssetSheet(
        side: side,
        assets: assets,
        selectedSymbol: side == 'from' ? _fromSymbol : _toSymbol,
        excludedSymbol: side == 'from' ? _toSymbol : _fromSymbol,
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
      _receipt = ref.read(tradeRepositoryProvider).submitConvert(request);
    });
    if (Scaffold.maybeOf(context) != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã tạo ${_receipt!.convertId}')));
    }
  }
}

class _ConvertHeader extends StatelessWidget {
  const _ConvertHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          InkWell(
            key: ConvertPage.backKey,
            onTap: onBack,
            borderRadius: AppRadii.cardRadius,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 27,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Convert / Swap',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _chipBackground,
              border: Border.all(color: Colors.white.withValues(alpha: .06)),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.text1,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});

  final _ConvertMode mode;
  final ValueChanged<_ConvertMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _chipBackground,
        border: Border.all(color: _tradePrimary.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _ModeTab(
            key: ConvertPage.modeKey('market'),
            label: 'Market',
            icon: Icons.bolt_rounded,
            active: mode == _ConvertMode.market,
            onTap: () => onChanged(_ConvertMode.market),
          ),
          _ModeTab(
            key: ConvertPage.modeKey('limit'),
            label: 'Limit',
            icon: Icons.gps_fixed_rounded,
            active: mode == _ConvertMode.limit,
            onTap: () => onChanged(_ConvertMode.limit),
          ),
          _ModeTab(
            key: ConvertPage.modeKey('schedule'),
            label: 'Tự động',
            icon: Icons.calendar_today_rounded,
            active: mode == _ConvertMode.schedule,
            onTap: () => onChanged(_ConvertMode.schedule),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: active
                ? AppColors.bg.withValues(alpha: .52)
                : Colors.transparent,
            borderRadius: AppRadii.inputRadius,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? AppColors.text1 : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.text1 : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteHeader extends StatelessWidget {
  const _FavoriteHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Cặp thường dùng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const Spacer(),
        const Icon(Icons.star_rounded, color: AppColors.primary, size: 15),
        const SizedBox(width: 4),
        Text(
          'Đã lưu',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _FavoritePairs extends StatelessWidget {
  const _FavoritePairs({
    required this.pairs,
    required this.activeFrom,
    required this.activeTo,
    required this.onSelected,
  });

  final List<TradeConvertFavoritePair> pairs;
  final String activeFrom;
  final String activeTo;
  final ValueChanged<TradeConvertFavoritePair> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pairs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          final active =
              pair.fromSymbol == activeFrom && pair.toSymbol == activeTo;
          return InkWell(
            key: ConvertPage.favoriteKey(pair.label),
            onTap: () => onSelected(pair),
            borderRadius: AppRadii.cardRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? Colors.transparent : _chipBackground,
                border: Border.all(
                  color: active
                      ? _tradePrimary
                      : _tradePrimary.withValues(alpha: .20),
                ),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                pair.label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? _tradePrimary : AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RateBar extends StatelessWidget {
  const _RateBar({required this.label, required this.countdown});

  final String label;
  final String countdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _rateBackground,
        border: Border.all(color: _tradePrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_rounded, color: _tradePrimary, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.swap_vert_rounded, color: AppColors.text3, size: 16),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            countdown,
            style: AppTextStyles.micro.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.refresh_rounded, color: _tradePrimary, size: 15),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.asset,
    required this.onAssetTap,
    this.amountController,
    this.quoteAmount,
    this.input = false,
    this.onChanged,
    this.onPercent,
  });

  final String label;
  final TradeConvertAsset asset;
  final VoidCallback onAssetTap;
  final TextEditingController? amountController;
  final double? quoteAmount;
  final bool input;
  final VoidCallback? onChanged;
  final ValueChanged<int>? onPercent;

  @override
  Widget build(BuildContext context) {
    final height = input ? 176.0 : 108.0;
    final balanceLabel =
        'Số dư: ${_formatBalance(asset.balance, asset.symbol)} ${asset.symbol}';
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const Spacer(),
              Text(
                balanceLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _AssetButton(
                key: input ? ConvertPage.fromAssetKey : ConvertPage.toAssetKey,
                asset: asset,
                onTap: onAssetTap,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: input
                    ? TextField(
                        key: ConvertPage.amountFieldKey,
                        controller: amountController,
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,8}'),
                          ),
                        ],
                        onChanged: (_) => onChanged?.call(),
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                          fontSize: 22,
                          fontFamily: 'monospace',
                          fontWeight: AppTextStyles.bold,
                        ),
                        cursorColor: _tradePrimary,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text3,
                            fontSize: 22,
                            fontFamily: 'monospace',
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      )
                    : Text(
                        _formatQuoteAmount(quoteAmount ?? 0, asset.symbol),
                        textAlign: TextAlign.right,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text3,
                          fontSize: 22,
                          fontFamily: 'monospace',
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
            ],
          ),
          if (input) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                for (final pct in const [25, 50, 75, 100]) ...[
                  _PercentChip(
                    key: ConvertPage.pctKey(pct),
                    label: '$pct%',
                    onTap: () => onPercent?.call(pct),
                  ),
                  if (pct != 100) const SizedBox(width: 8),
                ],
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Min: \$10',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: 16),
                Text(
                  'Max: \$500,000',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetButton extends StatelessWidget {
  const _AssetButton({super.key, required this.asset, required this.onTap});

  final TradeConvertAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .22)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Text(
                asset.symbol.substring(0, math.min(3, asset.symbol.length)),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 8,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              asset.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _PercentChip extends StatelessWidget {
  const _PercentChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        width: 50,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .16)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.swapKey,
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: _tradePrimary.withValues(alpha: .45)),
          borderRadius: AppRadii.cardRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.swap_vert_rounded,
          color: _tradePrimary,
          size: 25,
        ),
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: const [
          Expanded(
            child: _ToolChip(
              id: 'chart',
              label: 'Chart',
              icon: Icons.bar_chart_rounded,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'depth',
              label: 'Depth',
              icon: Icons.layers_outlined,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'info',
              label: 'Info',
              icon: Icons.info_outline_rounded,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'alert',
              label: 'Alert',
              icon: Icons.notifications_none_rounded,
              badge: true,
            ),
          ),
          SizedBox(width: 7),
          _SettingsChip(),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.id,
    required this.label,
    required this.icon,
    this.badge = false,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.toolKey(id),
      onTap: () {},
      borderRadius: AppRadii.lgRadius,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _disabledPrimary,
              border: Border.all(color: _tradePrimary.withValues(alpha: .14)),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 13, color: AppColors.text3),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (badge)
            Positioned(
              top: -3,
              right: 5,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.sell,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '1',
                  style: AppTextStyles.micro.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsChip extends StatelessWidget {
  const _SettingsChip();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.toolKey('settings'),
      onTap: () {},
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _disabledPrimary,
          border: Border.all(color: _tradePrimary.withValues(alpha: .14)),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: AppColors.text3,
          size: 15,
        ),
      ),
    );
  }
}

class _PairMiniCard extends StatelessWidget {
  const _PairMiniCard({required this.fromSymbol, required this.toSymbol});

  final String fromSymbol;
  final String toSymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Text(
            '$fromSymbol/$toSymbol · 24h',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.show_chart_rounded, color: AppColors.buy, size: 15),
          const Spacer(),
          SizedBox(
            width: 72,
            height: 31,
            child: CustomPaint(painter: _SparklinePainter()),
          ),
          const SizedBox(width: 8),
          Text(
            '+0.62%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00DCA5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < 28; i++) {
      final x = size.width * i / 27;
      final wave = math.sin(i * 1.45) * .33 + math.sin(i * 3.2) * .18;
      final y = size.height * (.50 - wave);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlippageCard extends StatelessWidget {
  const _SlippageCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<double> options;
  final double active;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 7),
              Text(
                'Slippage tolerance',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                'Tùy chỉnh',
                style: AppTextStyles.micro.copyWith(
                  color: _tradePrimary,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final option in options) ...[
                _SlippageChip(
                  key: ConvertPage.slippageKey(option.toString()),
                  label: '${option.toStringAsFixed(option % 1 == 0 ? 0 : 1)}%',
                  active: option == active,
                  onTap: () => onChanged(option),
                ),
                const SizedBox(width: 9),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SlippageChip extends StatelessWidget {
  const _SlippageChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradePrimary : _chipBackground,
          gradient: active
              ? const LinearGradient(colors: [_tradePrimary, _tradePrimaryDark])
              : null,
          border: Border.all(
            color: active
                ? _tradePrimary
                : _tradePrimary.withValues(alpha: .16),
          ),
          borderRadius: AppRadii.cardRadius,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _tradePrimary.withValues(alpha: .35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.receipt,
    required this.onPressed,
  });

  final bool enabled;
  final TradeConvertReceipt? receipt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = receipt == null
        ? (enabled ? 'Chuyển đổi ngay' : 'Nhập số lượng')
        : 'Đã gửi ${receipt!.convertId}';
    return InkWell(
      key: ConvertPage.submitKey,
      onTap: enabled ? onPressed : null,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _tradePrimary : AppColors.surface3,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: enabled
                ? Colors.white
                : AppColors.text3.withValues(alpha: .32),
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Giao dịch gần đây',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.download_rounded, color: AppColors.text3, size: 13),
        const SizedBox(width: 4),
        Text(
          'Xuất',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: 12),
        Text(
          'Xem tất cả',
          style: AppTextStyles.micro.copyWith(
            color: _tradePrimary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.chevron_right_rounded, color: _tradePrimary, size: 16),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.records});

  final List<TradeConvertHistoryRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < records.length; i++)
            _HistoryRow(
              record: records[i],
              showDivider: i != records.length - 1,
            ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.record, required this.showDivider});

  final TradeConvertHistoryRecord record;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.swap_vert_rounded,
              color: AppColors.buy,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatHistoryAmount(record.fromAmount, record.fromSymbol)} ${record.fromSymbol} → ${_formatHistoryAmount(record.toAmount, record.toSymbol)} ${record.toSymbol}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${record.timeLabel}  ·  Phí: \$${record.feeUsd.toStringAsFixed(record.feeUsd < 1 ? 4 : 2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              record.status,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _AssetSheet extends StatelessWidget {
  const _AssetSheet({
    required this.side,
    required this.assets,
    required this.selectedSymbol,
    required this.excludedSymbol,
  });

  final String side;
  final List<TradeConvertAsset> assets;
  final String selectedSymbol;
  final String excludedSymbol;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 620),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSolid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Chọn tài sản',
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  final disabled = asset.symbol == excludedSymbol;
                  final selected = asset.symbol == selectedSymbol;
                  return ListTile(
                    key: ConvertPage.assetOptionKey(side, asset.symbol),
                    enabled: !disabled,
                    onTap: disabled
                        ? null
                        : () => Navigator.of(context).pop(asset.symbol),
                    leading: CircleAvatar(
                      backgroundColor: Color(
                        asset.colorHex,
                      ).withValues(alpha: .18),
                      child: Text(
                        asset.symbol.substring(
                          0,
                          math.min(3, asset.symbol.length),
                        ),
                        style: AppTextStyles.micro.copyWith(
                          color: Color(asset.colorHex),
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    title: Text(asset.symbol, style: AppTextStyles.baseMedium),
                    subtitle: Text(asset.name, style: AppTextStyles.caption),
                    trailing: selected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: _tradePrimary,
                          )
                        : Text(
                            _formatBalance(asset.balance, asset.symbol),
                            style: AppTextStyles.caption.copyWith(
                              color: disabled
                                  ? AppColors.text3.withValues(alpha: .55)
                                  : AppColors.text2,
                              fontFamily: 'monospace',
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatInputAmount(double value) {
  if (value >= 1000) return value.toStringAsFixed(2);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _formatBalance(double value, String symbol) {
  final decimals = value < 1 || symbol == 'BTC' ? 6 : 2;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String _formatQuoteAmount(double value, String symbol) {
  if (value <= 0) return '0.00';
  final decimals = symbol == 'BTC'
      ? 6
      : value >= 100
      ? 2
      : 4;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String _formatHistoryAmount(double value, String symbol) {
  final decimals = symbol == 'BTC' ? 6 : 4;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String _groupNumber(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final left = whole.length - i;
    buffer.write(whole[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
