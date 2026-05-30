import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PWalletTransferPage extends ConsumerStatefulWidget {
  const P2PWalletTransferPage({
    super.key,
    this.initialAsset,
    this.initialType,
    this.shellRenderMode,
  });

  static const directionKey = Key('sc261_p2p_wallet_transfer_direction');
  static const switchKey = Key('sc261_p2p_wallet_transfer_switch');
  static const assetSelectorKey = Key('sc261_p2p_wallet_transfer_assets');
  static const amountFieldKey = Key('sc261_p2p_wallet_transfer_amount');
  static const maxKey = Key('sc261_p2p_wallet_transfer_max');
  static const submitKey = Key('sc261_p2p_wallet_transfer_submit');
  static const confirmKey = Key('sc261_p2p_wallet_transfer_confirm');
  static const feeKey = Key('sc261_p2p_wallet_transfer_fee');
  static const escrowNoteKey = Key('sc261_p2p_wallet_transfer_escrow_note');
  static const confirmPanelKey = Key('sc261_p2p_wallet_transfer_confirm_panel');

  static Key assetKey(String symbol) =>
      Key('sc261_p2p_wallet_transfer_asset_$symbol');

  static Key percentKey(int value) =>
      Key('sc261_p2p_wallet_transfer_percent_$value');

  final String? initialAsset;
  final String? initialType;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletTransferPage> createState() =>
      _P2PWalletTransferPageState();
}

class _P2PWalletTransferPageState extends ConsumerState<P2PWalletTransferPage> {
  late final TextEditingController _amountController;
  late String _asset;
  late String _type;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _asset = (widget.initialAsset ?? 'USDT').toUpperCase();
    _type = widget.initialType == 'withdraw' ? 'withdraw' : 'deposit';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      p2pWalletTransferProvider((asset: _asset, type: _type)),
    );
    if (!snapshot.assets.any((item) => item.symbol == _asset)) {
      _asset = snapshot.defaultAsset;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final source = snapshot.sourceBalance(_type, _asset);
    final destination = snapshot.destinationBalance(_type, _asset);
    final canTransfer = _amount > 0 && _amount <= source.available;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-261 P2PWalletTransferPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: _showConfirm ? 'Xác nhận chuyển tiền' : 'Chuyển tiền',
              subtitle: 'Ví · P2P',
              showBack: true,
              onBack: () {
                if (_showConfirm) {
                  setState(() => _showConfirm = false);
                  return;
                }
                context.go(snapshot.parentRoute);
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: _showConfirm
                      ? _ConfirmTransferView(
                          snapshot: snapshot,
                          source: source,
                          destination: destination,
                          amount: _amount,
                          asset: _asset,
                          onEdit: () => setState(() => _showConfirm = false),
                          onConfirm: () {
                            HapticFeedback.mediumImpact();
                            context.go(snapshot.parentRoute);
                          },
                        )
                      : _TransferForm(
                          snapshot: snapshot,
                          source: source,
                          destination: destination,
                          type: _type,
                          asset: _asset,
                          amountController: _amountController,
                          amount: _amount,
                          canTransfer: canTransfer,
                          onSwitch: _switchDirection,
                          onAssetChanged: _setAsset,
                          onMax: () => _setAmount(source.available),
                          onPercent: (percent) =>
                              _setAmount(source.available * percent / 100),
                          onAmountChanged: () => setState(() {}),
                          onSubmit: canTransfer
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  setState(() => _showConfirm = true);
                                }
                              : null,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchDirection() {
    HapticFeedback.selectionClick();
    setState(() {
      _type = _type == 'deposit' ? 'withdraw' : 'deposit';
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAsset(String symbol) {
    HapticFeedback.selectionClick();
    setState(() {
      _asset = symbol;
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAmount(double value) {
    HapticFeedback.selectionClick();
    _amountController.text = _formatTransferAmount(value, _asset);
    setState(() {});
  }
}

class _TransferForm extends StatelessWidget {
  const _TransferForm({
    required this.snapshot,
    required this.source,
    required this.destination,
    required this.type,
    required this.asset,
    required this.amountController,
    required this.amount,
    required this.canTransfer,
    required this.onSwitch,
    required this.onAssetChanged,
    required this.onMax,
    required this.onPercent,
    required this.onAmountChanged,
    required this.onSubmit,
  });

  final P2PWalletTransferSnapshot snapshot;
  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final String type;
  final String asset;
  final TextEditingController amountController;
  final double amount;
  final bool canTransfer;
  final VoidCallback onSwitch;
  final ValueChanged<String> onAssetChanged;
  final VoidCallback onMax;
  final ValueChanged<int> onPercent;
  final VoidCallback onAmountChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DirectionCard(
          source: source,
          destination: destination,
          onSwitch: onSwitch,
        ),
        const SizedBox(height: AppSpacing.x5),
        _AssetSelection(
          assets: snapshot.assets,
          selectedAsset: asset,
          onChanged: onAssetChanged,
        ),
        const SizedBox(height: AppSpacing.x5),
        _AmountInput(
          controller: amountController,
          asset: asset,
          insufficient: amount > source.available,
          onChanged: onAmountChanged,
          onMax: onMax,
        ),
        const SizedBox(height: AppSpacing.x4),
        _QuickPercentRow(onPercent: onPercent),
        const SizedBox(height: AppSpacing.x5),
        const _FeeNotice(),
        const SizedBox(height: AppSpacing.x3),
        _EscrowNotice(text: snapshot.escrowNote),
        const SizedBox(height: AppSpacing.x5),
        _SubmitButton(
          enabled: canTransfer,
          label: amount > 0
              ? 'Chuyển ${_formatTransferAmount(amount, asset)} $asset'
              : 'Chuyển $asset',
          onTap: onSubmit,
        ),
      ],
    );
  }
}

class _DirectionCard extends StatelessWidget {
  const _DirectionCard({
    required this.source,
    required this.destination,
    required this.onSwitch,
  });

  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PWalletTransferPage.directionKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _WalletSide(label: 'Từ', balance: source),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            child: Material(
              key: P2PWalletTransferPage.switchKey,
              color: AppModuleAccents.p2p.withValues(alpha: .16),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onSwitch,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: AppModuleAccents.p2p,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _WalletSide(label: 'Đến', balance: destination),
          ),
        ],
      ),
    );
  }
}

class _WalletSide extends StatelessWidget {
  const _WalletSide({required this.label, required this.balance});

  final String label;
  final P2PWalletTransferBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    final color = balance.walletKey == 'p2p'
        ? AppColors.warn
        : AppModuleAccents.p2p;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Icon(_walletIcon(balance.walletKey), color: color, size: 17),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                balance.walletLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${balance.balanceLabel}: ${_formatAvailable(balance.available, balance.asset)} ${balance.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AssetSelection extends StatelessWidget {
  const _AssetSelection({
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<P2PWalletTransferAssetDraft> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletTransferPage.assetSelectorKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn tài sản',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            for (var index = 0; index < assets.length; index++) ...[
              Expanded(
                child: _AssetTile(
                  asset: assets[index],
                  selected: selectedAsset == assets[index].symbol,
                  onTap: () => onChanged(assets[index].symbol),
                ),
              ),
              if (index != assets.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final P2PWalletTransferAssetDraft asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(asset.symbol);
    return Material(
      key: P2PWalletTransferPage.assetKey(asset.symbol),
      color: selected
          ? color.withValues(alpha: .11)
          : AppColors.surface.withValues(alpha: .50),
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.lgRadius,
            border: Border.all(color: selected ? color : AppColors.cardBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AssetMark(symbol: asset.symbol, color: color),
              const SizedBox(height: AppSpacing.x2),
              Text(
                asset.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: selected ? color : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (symbol) {
      'BTC' => Icons.currency_bitcoin_rounded,
      'VND' => Icons.money_rounded,
      _ => Icons.attach_money_rounded,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.asset,
    required this.insufficient,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final String asset;
  final bool insufficient;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Số tiền',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Material(
              key: P2PWalletTransferPage.maxKey,
              color: AppModuleAccents.p2p.withValues(alpha: .15),
              borderRadius: AppRadii.mdRadius,
              child: InkWell(
                onTap: onMax,
                borderRadius: AppRadii.mdRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x1,
                  ),
                  child: Text(
                    'MAX',
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.lgRadius,
            border: Border.all(
              color: insufficient ? AppColors.sell : AppColors.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: P2PWalletTransferPage.amountFieldKey,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: (_) => onChanged(),
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text3,
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              Text(
                asset,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        if (insufficient) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Số dư không đủ',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickPercentRow extends StatelessWidget {
  const _QuickPercentRow({required this.onPercent});

  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    const values = [25, 50, 75, 100];
    return Row(
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Expanded(
            child: Material(
              key: P2PWalletTransferPage.percentKey(values[index]),
              color: AppColors.surface2,
              borderRadius: AppRadii.xlRadius,
              child: InkWell(
                onTap: () => onPercent(values[index]),
                borderRadius: AppRadii.xlRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
                  child: Text(
                    '${values[index]}%',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (index != values.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FeeNotice extends StatelessWidget {
  const _FeeNotice();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PWalletTransferPage.feeKey,
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.buy.withValues(alpha: .30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.bolt_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Miễn phí & Tức thì',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Chuyển tiền nội bộ hoàn toàn miễn phí và được xử lý ngay lập tức.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EscrowNotice extends StatelessWidget {
  const _EscrowNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PWalletTransferPage.escrowNoteKey,
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletTransferPage.submitKey,
      color: enabled ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadii.lgRadius,
        child: SizedBox(
          height: AppSpacing.inputHeight,
          child: Center(
            child: Text(
              label.trim(),
              style: AppTextStyles.baseMedium.copyWith(
                color: enabled ? AppColors.onAccent : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmTransferView extends StatelessWidget {
  const _ConfirmTransferView({
    required this.snapshot,
    required this.source,
    required this.destination,
    required this.amount,
    required this.asset,
    required this.onEdit,
    required this.onConfirm,
  });

  final P2PWalletTransferSnapshot snapshot;
  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final double amount;
  final String asset;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletTransferPage.confirmPanelKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppModuleAccents.p2p.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: AppModuleAccents.p2p,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text('Kiểm tra thông tin', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Đảm bảo thông tin chính xác trước khi xác nhận',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ConfirmRow(
                label: 'Số tiền',
                value: '${_formatAvailable(amount, asset)} $asset',
                large: true,
              ),
              const Divider(color: AppColors.divider, height: 1),
              _ConfirmRow(label: 'Từ', value: source.walletLabel),
              _ConfirmRow(label: 'Đến', value: destination.walletLabel),
              _ConfirmRow(
                label: 'Phí giao dịch',
                value: snapshot.feeLabel,
                valueColor: AppColors.buy,
              ),
              _ConfirmRow(
                label: 'Thời gian',
                value: snapshot.processingLabel,
                valueColor: AppModuleAccents.p2p,
              ),
              const _ConfirmRow(
                label: 'Loại giao dịch',
                value: 'Internal Transfer',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _EscrowNotice(text: snapshot.confirmationNote),
        const SizedBox(height: AppSpacing.x5),
        Row(
          children: [
            Expanded(
              child: _ConfirmButton(
                label: 'Quay lại',
                background: AppColors.surface2,
                color: AppColors.text1,
                onTap: onEdit,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _ConfirmButton(
                buttonKey: P2PWalletTransferPage.confirmKey,
                label: 'Xác nhận',
                background: AppModuleAccents.p2p,
                color: AppColors.onAccent,
                onTap: onConfirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.large = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: (large ? AppTextStyles.sectionTitle : AppTextStyles.caption)
                .copyWith(
                  color: valueColor ?? AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    this.buttonKey,
    required this.label,
    required this.background,
    required this.color,
    required this.onTap,
  });

  final Key? buttonKey;
  final String label;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: buttonKey,
      color: background,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: SizedBox(
          height: AppSpacing.inputHeight,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconData _walletIcon(String walletKey) {
  return switch (walletKey) {
    'p2p' => Icons.account_balance_wallet_outlined,
    _ => Icons.wallet_outlined,
  };
}

Color _assetColor(String symbol) {
  return switch (symbol) {
    'BTC' => AppColors.warn,
    'VND' => AppColors.text1,
    _ => AppModuleAccents.p2p,
  };
}

String _formatTransferAmount(double value, String asset) {
  final decimals = switch (asset) {
    'BTC' => 8,
    'VND' => 0,
    _ => 2,
  };
  return value.toStringAsFixed(decimals);
}

String _formatAvailable(double value, String asset) {
  return _withCommas(_formatTransferAmount(value, asset));
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
