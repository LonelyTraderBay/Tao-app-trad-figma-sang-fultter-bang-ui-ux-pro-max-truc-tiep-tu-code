import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

const _transferPanel = AppColors.surface;
const _transferPanel2 = AppColors.surface2;
const _transferPrimary = AppColors.primary;
const _transferGreen = AppColors.buy;

class TransferConfirmSheet extends StatelessWidget {
  const TransferConfirmSheet({
    super.key,
    required this.fromWallet,
    required this.toWallet,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.onConfirm,
  });

  final WalletTransferWallet fromWallet;
  final WalletTransferWallet toWallet;
  final WalletTransferAsset asset;
  final double amount;
  final double usdValue;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
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
                    value:
                        '${formatTransferAssetAmount(amount)} ${asset.symbol}',
                    highlight: true,
                  ),
                  _ConfirmRow(
                    label: 'Giá trị',
                    value: formatTransferUsd(usdValue),
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
                    buttonKey: const Key('sc146_transfer_confirm'),
                    label: 'Xác nhận',
                    background: _transferPrimary,
                    color: AppColors.onAccent,
                    onTap: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransferWalletCard extends StatelessWidget {
  const TransferWalletCard({
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
          border: Border.all(color: AppColors.overlayStroke),
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
                        'Số dư: ${formatTransferUsd(wallet.balanceUsd)}',
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

class TransferSwapButton extends StatelessWidget {
  const TransferSwapButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        key: const Key('sc146_transfer_swap'),
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
            color: AppColors.onAccent,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class TransferAssetCard extends StatelessWidget {
  const TransferAssetCard({
    super.key,
    required this.asset,
    required this.onTap,
  });

  final WalletTransferAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc146_transfer_asset'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 99,
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        decoration: BoxDecoration(
          color: _transferPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.overlayStroke),
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
                        'Khả dụng: ${formatTransferAssetAmount(asset.available)} ${asset.symbol}',
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

class TransferAmountCard extends StatelessWidget {
  const TransferAmountCard({
    super.key,
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
        border: Border.all(color: AppColors.overlayStroke),
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
                key: const Key('sc146_transfer_max'),
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
                  key: const Key('sc146_transfer_amount'),
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

class TransferInfoNotice extends StatelessWidget {
  const TransferInfoNotice({super.key});

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

class TransferButton extends StatelessWidget {
  const TransferButton({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc146_transfer_submit'),
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _transferPrimary : AppColors.surfacePressed,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          'Xác nhận chuyển',
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled
                ? AppColors.onAccent
                : AppColors.controlBorderDisabled,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class RecentTransfersList extends StatelessWidget {
  const RecentTransfersList({super.key, required this.transfers});

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
            ? const Border(
                bottom: BorderSide(color: AppColors.dividerBlueSubtle),
              )
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
            '${formatTransferAssetAmount(transfer.amount)} ${transfer.asset}',
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

class TransferWalletPickerRow extends StatelessWidget {
  const TransferWalletPickerRow({
    super.key,
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
              formatTransferUsd(wallet.balanceUsd),
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

class TransferAssetPickerRow extends StatelessWidget {
  const TransferAssetPickerRow({
    super.key,
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
              formatTransferAssetAmount(asset.available),
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

class TransferSuccessBanner extends StatelessWidget {
  const TransferSuccessBanner({super.key});

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

String formatTransferUsd(double value) {
  return '\$${_withCommas(value.toStringAsFixed(2))}';
}

String formatTransferAssetAmount(double value) {
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
