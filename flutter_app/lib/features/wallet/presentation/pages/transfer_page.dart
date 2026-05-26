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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

const _transferBackground = AppColors.bg;
const _transferPanel = AppColors.surface;
const _transferPanel2 = AppColors.surface2;
const _transferPrimary = AppColors.primary;
const _transferGreen = Color(0xFF10B981);

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc146_transfer_content');
  static const fromWalletKey = Key('sc146_transfer_from_wallet');
  static const toWalletKey = Key('sc146_transfer_to_wallet');
  static const swapKey = Key('sc146_transfer_swap');
  static const assetSelectorKey = Key('sc146_transfer_asset');
  static const amountFieldKey = Key('sc146_transfer_amount');
  static const maxKey = Key('sc146_transfer_max');
  static const submitKey = Key('sc146_transfer_submit');
  static const confirmKey = Key('sc146_transfer_confirm');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromWalletId = 'spot';
  String _toWalletId = 'funding';
  String _assetId = 'usdt';
  bool _showSuccess = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount {
    return double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getTransfer();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;
    final fromWallet = _wallet(snapshot, _fromWalletId);
    final toWallet = _wallet(snapshot, _toWalletId);
    final asset = _asset(snapshot, _assetId);
    final usdValue = _amount * asset.usdRate;
    final canTransfer = _amount > 0 && _amount <= asset.available;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-146 TransferPage',
      child: Material(
        color: _transferBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Chuyển nội bộ',
              subtitle: 'Chuyển tiền · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: TransferPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_showSuccess) ...[
                      const _SuccessBanner(),
                      const SizedBox(height: 14),
                    ],
                    _TransferWalletCard(
                      key: TransferPage.fromWalletKey,
                      label: 'Từ',
                      wallet: fromWallet,
                      color: _transferPrimary,
                      onTap: () => _showWalletPicker(
                        title: 'Chọn ví nguồn',
                        snapshot: snapshot,
                        excludedWalletId: _toWalletId,
                        selectedWalletId: _fromWalletId,
                        onSelected: (id) => setState(() => _fromWalletId = id),
                      ),
                    ),
                    const SizedBox(height: 9),
                    _SwapButton(onTap: _swapWallets),
                    const SizedBox(height: 9),
                    _TransferWalletCard(
                      key: TransferPage.toWalletKey,
                      label: 'Đến',
                      wallet: toWallet,
                      color: _transferGreen,
                      onTap: () => _showWalletPicker(
                        title: 'Chọn ví nhận',
                        snapshot: snapshot,
                        excludedWalletId: _fromWalletId,
                        selectedWalletId: _toWalletId,
                        onSelected: (id) => setState(() => _toWalletId = id),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _TransferAssetCard(
                      asset: asset,
                      onTap: () => _showAssetPicker(snapshot),
                    ),
                    const SizedBox(height: 18),
                    _AmountCard(
                      controller: _amountController,
                      asset: asset,
                      onChanged: () => setState(() {}),
                      onMax: () {
                        _amountController.text = _formatAssetAmount(
                          asset.available,
                        );
                        setState(() {});
                      },
                    ),
                    if (_amount > 0) ...[
                      const SizedBox(height: 6),
                      Text(
                        '≈ ${_formatUsd(usdValue)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const _InfoNotice(),
                    const SizedBox(height: 16),
                    _TransferButton(
                      enabled: canTransfer,
                      onTap: canTransfer
                          ? () => _showConfirmSheet(
                              fromWallet: fromWallet,
                              toWallet: toWallet,
                              asset: asset,
                              amount: _amount,
                              usdValue: usdValue,
                            )
                          : null,
                    ),
                    const SizedBox(height: 19),
                    _RecentTransfersList(transfers: snapshot.recentTransfers),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  WalletTransferWallet _wallet(
    WalletTransferSnapshot snapshot,
    String walletId,
  ) {
    return snapshot.wallets.firstWhere(
      (wallet) => wallet.id == walletId,
      orElse: () => snapshot.wallets.first,
    );
  }

  WalletTransferAsset _asset(WalletTransferSnapshot snapshot, String assetId) {
    return snapshot.assets.firstWhere(
      (asset) => asset.id == assetId,
      orElse: () => snapshot.assets.first,
    );
  }

  void _swapWallets() {
    setState(() {
      final from = _fromWalletId;
      _fromWalletId = _toWalletId;
      _toWalletId = from;
    });
  }

  void _showWalletPicker({
    required String title,
    required WalletTransferSnapshot snapshot,
    required String excludedWalletId,
    required String selectedWalletId,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final wallet in snapshot.wallets)
                  if (wallet.id != excludedWalletId)
                    _WalletPickerRow(
                      wallet: wallet,
                      selected: wallet.id == selectedWalletId,
                      onTap: () {
                        onSelected(wallet.id);
                        Navigator.of(context).pop();
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAssetPicker(WalletTransferSnapshot snapshot) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chọn tài sản',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final asset in snapshot.assets)
                  _AssetPickerRow(
                    asset: asset,
                    selected: asset.id == _assetId,
                    onTap: () {
                      setState(() {
                        _assetId = asset.id;
                        _amountController.clear();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmSheet({
    required WalletTransferWallet fromWallet,
    required WalletTransferWallet toWallet,
    required WalletTransferAsset asset,
    required double amount,
    required double usdValue,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24 + DeviceMetrics.nativeBottomChrome,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Xác nhận chuyển nội bộ',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transferPanel2,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Column(
                    children: [
                      _ConfirmRow(label: 'Từ', value: fromWallet.name),
                      _ConfirmRow(label: 'Đến', value: toWallet.name),
                      _ConfirmRow(label: 'Tài sản', value: asset.symbol),
                      _ConfirmRow(
                        label: 'Số lượng',
                        value: '${_formatAssetAmount(amount)} ${asset.symbol}',
                        highlight: true,
                      ),
                      _ConfirmRow(
                        label: 'Giá trị',
                        value: _formatUsd(usdValue),
                      ),
                      const _ConfirmRow(
                        label: 'Phí',
                        value: 'Miễn phí',
                        valueColor: _transferGreen,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const _ConfirmNote(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(
                        label: 'Huỷ',
                        background: _transferPanel2,
                        color: AppColors.text2,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SheetButton(
                        buttonKey: TransferPage.confirmKey,
                        label: 'Xác nhận',
                        background: _transferPrimary,
                        color: Colors.white,
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _showSuccess = true;
                            _amountController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TransferWalletCard extends StatelessWidget {
  const _TransferWalletCard({
    super.key,
    required this.label,
    required this.wallet,
    required this.color,
    required this.onTap,
  });

  final String label;
  final WalletTransferWallet wallet;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 99,
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        decoration: BoxDecoration(
          color: _transferPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                _WalletIcon(wallet: wallet, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        wallet.name,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Số dư: ${_formatUsd(wallet.balanceUsd)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletIcon extends StatelessWidget {
  const _WalletIcon({required this.wallet, required this.color});

  final WalletTransferWallet wallet;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (wallet.iconKey) {
      'funding' => Icons.account_balance_wallet_outlined,
      'futures' => Icons.account_balance_outlined,
      _ => Icons.bar_chart_rounded,
    };
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.lgRadius,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        key: TransferPage.swapKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _transferPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _transferPrimary.withValues(alpha: .38),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.swap_vert_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _TransferAssetCard extends StatelessWidget {
  const _TransferAssetCard({required this.asset, required this.onTap});

  final WalletTransferAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransferPage.assetSelectorKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 99,
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        decoration: BoxDecoration(
          color: _transferPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tài sản',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                _AssetLogo(asset: asset, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.symbol,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Khả dụng: ${_formatAssetAmount(asset.available)} ${asset.symbol}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.asset, required this.size});

  final WalletTransferAsset asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.substring(
          0,
          asset.symbol.length < 3 ? asset.symbol.length : 3,
        ),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: size >= 40 ? 10 : 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.asset,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final WalletTransferAsset asset;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: _transferPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số lượng',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ),
              GestureDetector(
                key: TransferPage.maxKey,
                onTap: onMax,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Tối đa',
                  style: AppTextStyles.micro.copyWith(
                    color: _transferPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: TransferPage.amountFieldKey,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: (_) => onChanged(),
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text2,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              Text(
                asset.symbol,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 59),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Chuyển nội bộ giữa các ví miễn phí, xử lý ngay lập tức. Không cần xác nhận blockchain.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransferButton extends StatelessWidget {
  const _TransferButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransferPage.submitKey,
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _transferPrimary : const Color(0xFF121928),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          'Xác nhận chuyển',
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? Colors.white : const Color(0xFF2C3545),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _RecentTransfersList extends StatelessWidget {
  const _RecentTransfersList({required this.transfers});

  final List<WalletRecentTransfer> transfers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lịch sử chuyển gần đây',
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < transfers.length; i++)
          _RecentTransferRow(
            transfer: transfers[i],
            showDivider: i != transfers.length - 1,
          ),
      ],
    );
  }
}

class _RecentTransferRow extends StatelessWidget {
  const _RecentTransferRow({required this.transfer, required this.showDivider});

  final WalletRecentTransfer transfer;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0x141E293B)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _transferPrimary.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.swap_vert_rounded,
              color: _transferPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transfer.fromWallet} → ${transfer.toWallet}',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  transfer.time,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_formatAssetAmount(transfer.amount)} ${transfer.asset}',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletPickerRow extends StatelessWidget {
  const _WalletPickerRow({
    required this.wallet,
    required this.selected,
    required this.onTap,
  });

  final WalletTransferWallet wallet;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.colorHex);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _WalletIcon(wallet: wallet, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                wallet.name,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              _formatUsd(wallet.balanceUsd),
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: _transferPrimary),
          ],
        ),
      ),
    );
  }
}

class _AssetPickerRow extends StatelessWidget {
  const _AssetPickerRow({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final WalletTransferAsset asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _AssetLogo(asset: asset, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    asset.name,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            Text(
              _formatAssetAmount(asset.available),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: _transferPrimary),
          ],
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _transferGreen.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _transferGreen.withValues(alpha: .30)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _transferGreen,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Chuyển thành công!',
            style: AppTextStyles.caption.copyWith(
              color: _transferGreen,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool highlight;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color:
                  valueColor ??
                  (highlight ? _transferPrimary : AppColors.text1),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmNote extends StatelessWidget {
  const _ConfirmNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _transferPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chuyển nội bộ xử lý ngay lập tức, không mất phí.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
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
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  return '\$${_withCommas(value.toStringAsFixed(2))}';
}

String _formatAssetAmount(double value) {
  final decimals = value >= 1000 ? 2 : 4;
  return _withCommas(value.toStringAsFixed(decimals));
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
