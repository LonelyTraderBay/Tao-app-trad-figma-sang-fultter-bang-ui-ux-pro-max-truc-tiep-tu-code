import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';

class WalletGroupsTab extends StatelessWidget {
  const WalletGroupsTab({super.key, required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletManagerSectionLabel(label: 'Wallet Groups'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.groups.length; i++) ...[
          _GroupCard(
            group: snapshot.groups[i],
            wallets: snapshot.wallets
                .where((wallet) => wallet.groupId == snapshot.groups[i].id)
                .toList(),
          ),
          if (i != snapshot.groups.length - 1) const SizedBox(height: 12),
        ],
        const SizedBox(height: 14),
        Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: walletManagerPanel2,
            borderRadius: AppRadii.mdRadius,
            border: Border.all(color: walletManagerBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_outlined,
                color: AppColors.text2,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Create Group',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.wallets});

  final WalletManagerGroup group;
  final List<WalletManagerItem> wallets;

  @override
  Widget build(BuildContext context) {
    final color = Color(group.colorHex);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: walletManagerPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletManagerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            '${wallets.length} wallets',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            'Total Value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatWalletManagerUsd(group.totalValueUsd, decimals: 0),
            style: AppTextStyles.heroNumber.copyWith(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          for (final wallet in wallets) ...[
            _GroupWalletRow(wallet: wallet),
            if (wallet != wallets.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _GroupWalletRow extends StatelessWidget {
  const _GroupWalletRow({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: walletManagerBackground,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
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
          Text(
            formatWalletManagerUsd(wallet.balanceUsd, decimals: 0),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
