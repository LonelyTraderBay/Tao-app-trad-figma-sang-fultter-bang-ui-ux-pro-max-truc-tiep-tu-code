part of 'wallet_transfer_sections.dart';

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
      child: SizedBox(
        height: AppSpacing.transferCardHeight,
        child: Padding(
          padding: AppSpacing.transferCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.badge.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.transferTileGap),
              Row(
                children: [
                  _WalletIcon(wallet: wallet, color: color),
                  const SizedBox(
                    width: AppSpacing.searchBarHorizontalTrailingPadding,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(wallet.name, style: AppTextStyles.baseMedium),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Số dư: ${formatTransferUsd(wallet.balanceUsd)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.transferActionIcon,
                  ),
                ],
              ),
            ],
          ),
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
    return VitCard(
      width: AppSpacing.transferIcon,
      height: AppSpacing.transferIcon,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      background: ColoredBox(color: color.withValues(alpha: .13)),
      alignment: Alignment.center,
      clip: true,
      child: Icon(icon, color: color, size: AppSpacing.transferActionIcon),
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
        child: SizedBox(
          width: AppSpacing.transferSwapButton,
          height: AppSpacing.transferSwapButton,
          child: Material(
            color: _transferPrimary,
            elevation: AppSpacing.transferSwapButtonShadowOffset,
            shadowColor: _transferPrimary.withValues(alpha: .38),
            shape: const CircleBorder(),
            child: Icon(
              Icons.swap_vert_rounded,
              color: AppColors.onAccent,
              size: AppSpacing.transferActionIcon + AppSpacing.x1,
            ),
          ),
        ),
      ),
    );
  }
}
