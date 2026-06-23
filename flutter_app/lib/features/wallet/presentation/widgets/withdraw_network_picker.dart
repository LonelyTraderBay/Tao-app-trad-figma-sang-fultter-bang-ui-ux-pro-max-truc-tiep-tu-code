import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class WithdrawNetworkPicker extends StatelessWidget {
  const WithdrawNetworkPicker({
    required this.networks,
    required this.selectedNetworkId,
    required this.onSelected,
    super.key,
  });

  final List<WalletWithdrawNetwork> networks;
  final String selectedNetworkId;
  final ValueChanged<WalletWithdrawNetwork> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.transferSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Chọn mạng lưới', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.rowGap),
            for (final network in networks)
              WithdrawNetworkOption(
                network: network,
                selected: network.id == selectedNetworkId,
                onTap: () => onSelected(network),
              ),
          ],
        ),
      ),
    );
  }
}

class WithdrawNetworkOption extends StatelessWidget {
  const WithdrawNetworkOption({
    required this.network,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final WalletWithdrawNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${network.name} withdraw network',
      child: VitCard(
        key: withdrawNetworkKey(network.id),
        onTap: onTap,
        variant: VitCardVariant.ghost,
        borderColor: AppColors.transparent,
        child: VitCard(
          margin: AppSpacing.walletWithdrawNetworkOptionMargin,
          variant: VitCardVariant.inner,
          padding: AppSpacing.walletWithdrawNetworkOptionPadding,
          borderColor: selected ? withdrawPrimary : AppColors.border,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network.name,
                      style: AppTextStyles.control.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Phí: ${formatWithdrawCompact(network.fee)} · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: withdrawPrimary,
                  size: AppSpacing.iconMd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
