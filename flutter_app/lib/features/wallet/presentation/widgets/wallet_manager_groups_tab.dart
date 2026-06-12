import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
        const SizedBox(height: AppSpacing.walletManagerGroupsSectionGap),
        for (var i = 0; i < snapshot.groups.length; i++) ...[
          _GroupCard(
            group: snapshot.groups[i],
            wallets: snapshot.wallets
                .where((wallet) => wallet.groupId == snapshot.groups[i].id)
                .toList(),
          ),
          if (i != snapshot.groups.length - 1)
            const SizedBox(height: AppSpacing.walletManagerGroupCardGap),
        ],
        const SizedBox(height: AppSpacing.walletManagerGroupCreateTopGap),
        Container(
          height: AppSpacing.walletManagerGroupCreateHeight,
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
                size: AppSpacing.walletManagerGroupCreateIcon,
              ),
              const SizedBox(width: AppSpacing.walletManagerGroupCreateIconGap),
              Text(
                'Create Group',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
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
      padding: AppSpacing.walletManagerGroupCardPadding,
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
                width: AppSpacing.walletManagerGroupSwatch,
                height: AppSpacing.walletManagerGroupSwatch,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadii.swatchRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.walletManagerGroupSwatchGap),
              Expanded(
                child: Text(
                  group.name,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: AppColors.text3,
                size: AppSpacing.walletManagerGroupMoreIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupMetaGap),
          Text(
            '${wallets.length} wallets',
            style: AppTextStyles.badge.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupMetaGap),
          Text(
            'Total Value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupValueGap),
          Text(
            formatWalletManagerUsd(group.totalValueUsd, decimals: 0),
            style: AppTextStyles.sectionTitle.copyWith(color: color, height: 1),
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupMetaGap),
          for (final wallet in wallets) ...[
            _GroupWalletRow(wallet: wallet),
            if (wallet != wallets.last)
              const SizedBox(height: AppSpacing.walletManagerGroupWalletGap),
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
      height: AppSpacing.walletManagerGroupWalletRowHeight,
      padding: AppSpacing.walletManagerGroupWalletRowPadding,
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
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.walletManagerGroupWalletTextGap,
                ),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
