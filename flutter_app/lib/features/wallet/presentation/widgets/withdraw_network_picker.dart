import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';

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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn mạng lưới',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
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
      child: GestureDetector(
        key: withdrawNetworkKey(network.id),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: selected
                ? withdrawPrimary.withValues(alpha: .10)
                : AppColors.transparent,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network.name,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phí: ${formatWithdrawCompact(network.fee)} · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: withdrawPrimary,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
