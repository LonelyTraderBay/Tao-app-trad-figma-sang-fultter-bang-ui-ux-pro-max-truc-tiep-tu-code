import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';

class WalletActivityTab extends StatelessWidget {
  const WalletActivityTab({super.key, required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletManagerSectionLabel(label: 'Recent Activity'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.wallets.length; i++) ...[
          _ActivityRow(wallet: snapshot.wallets[i]),
          if (i != snapshot.wallets.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.typeColorHex);
    final parts = wallet.lastActiveLabel.split(' ');
    final time = parts.isNotEmpty ? parts.first : wallet.lastActiveLabel;
    final date = parts.length > 1 ? parts.skip(1).join(' ') : '';
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: walletManagerPanel,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: walletManagerBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                time,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
