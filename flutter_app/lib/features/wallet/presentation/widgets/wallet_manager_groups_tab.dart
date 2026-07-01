import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class WalletGroupsTab extends StatelessWidget {
  const WalletGroupsTab({super.key, required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletManagerSectionLabel(
          label: 'Wallet Groups',
          icon: Icons.folder_outlined,
        ),
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
        VitCard(
          height: AppSpacing.walletManagerGroupCreateHeight,
          alignment: Alignment.center,
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.standard,
          borderColor: walletManagerBorder,
          background: const ColoredBox(color: walletManagerPanel2),
          clip: true,
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
                  height: AppSpacing.tradeBotLineHeightTight,
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
    return VitCard(
      padding: AppSpacing.walletManagerGroupCardPadding,
      variant: VitCardVariant.ghost,
      borderColor: walletManagerBorder,
      background: const ColoredBox(color: walletManagerPanel),
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.walletManagerGroupSwatch,
                height: AppSpacing.walletManagerGroupSwatch,
                child: ClipRRect(
                  borderRadius: AppRadii.swatchRadius,
                  child: ColoredBox(color: color),
                ),
              ),
              const SizedBox(width: AppSpacing.walletManagerGroupSwatchGap),
              Expanded(
                child: Text(
                  group.name,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
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
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupMetaGap),
          Text(
            'Total Value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerGroupValueGap),
          Text(
            formatWalletManagerUsd(group.totalValueUsd, decimals: 0),
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
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
    return VitCard(
      height: AppSpacing.walletManagerGroupWalletRowHeight,
      padding: AppSpacing.walletManagerGroupWalletRowPadding,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: const ColoredBox(color: walletManagerBackground),
      clip: true,
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
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.walletManagerGroupWalletTextGap,
                ),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
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
