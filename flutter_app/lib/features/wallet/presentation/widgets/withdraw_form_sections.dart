import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';

part 'withdraw_amount_actions.dart';

class WithdrawBalanceCard extends StatelessWidget {
  const WithdrawBalanceCard({
    required this.asset,
    required this.value,
    super.key,
  });

  final String asset;
  final double value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      height: AppSpacing.inputHeight,
      density: VitDensity.tool,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Số dư khả dụng',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            '${formatWithdrawBalance(value)} $asset',
            style: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawNetworkSelector extends StatelessWidget {
  const WithdrawNetworkSelector({
    required this.asset,
    required this.network,
    required this.onTap,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WithdrawSectionLabel('Mạng lưới'),
        const SizedBox(height: AppSpacing.x2),
        Semantics(
          button: true,
          label:
              'Withdraw network selector ${network.name}, fee ${formatWithdrawNetworkFee(network.fee)} $asset, minimum ${formatWithdrawCompact(network.minWithdraw)}',
          child: VitCard(
            key: withdrawNetworkSelectorKey,
            onTap: onTap,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            height: AppSpacing.inputHeight,
            density: VitDensity.tool,
            borderColor: withdrawPrimary.withValues(alpha: .34),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        style: AppTextStyles.control.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'Phí: ${formatWithdrawNetworkFee(network.fee)} $asset · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.transferActionIcon,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2 + AppSpacing.x1),
        Row(
          children: [
            const SizedBox(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              child: ClipOval(child: ColoredBox(color: withdrawGreen)),
            ),
            const SizedBox(width: AppSpacing.x3 - AppSpacing.x1),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  Phí: ${formatWithdrawNetworkFee(network.fee)} $asset',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WithdrawAddressInput extends StatelessWidget {
  const WithdrawAddressInput({
    required this.asset,
    required this.network,
    required this.controller,
    required this.onScan,
    required this.onChanged,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final TextEditingController controller;
  final VoidCallback onScan;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: WithdrawSectionLabel('Địa chỉ ví nhận')),
            Semantics(
              button: true,
              label: 'Scan withdrawal address QR code',
              child: VitCtaButton(
                onPressed: onScan,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: AppSpacing.walletWithdrawScanButtonPadding,
                leading: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: withdrawPrimary,
                  size: AppSpacing.iconSm,
                ),
                child: Text(
                  'Quét QR',
                  style: AppTextStyles.control.copyWith(
                    color: withdrawPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.formFieldLabelGap),
        VitInput(
          fieldKey: withdrawAddressFieldKey,
          controller: controller,
          hintText: 'Nhập địa chỉ $asset (${network.name.split(' ').first})',
          semanticLabel: 'Withdrawal destination address',
          textStyle: AppTextStyles.control,
          onChanged: onChanged,
          suffix: Padding(
            padding: AppSpacing.walletWithdrawInputSuffixPadding,
            child: Text(
              asset,
              style: AppTextStyles.control.copyWith(color: AppColors.text3),
            ),
          ),
        ),
      ],
    );
  }
}
