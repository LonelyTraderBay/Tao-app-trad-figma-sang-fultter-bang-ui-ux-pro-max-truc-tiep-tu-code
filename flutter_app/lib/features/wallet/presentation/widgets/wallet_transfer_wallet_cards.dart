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
        height: _transferWalletCardHeight,
        child: Padding(
          padding: _transferTilePadding,
          child: Row(
            children: [
              SizedBox(
                width: _transferWalletLabelWidth,
                child: Text(
                  label,
                  style: AppTextStyles.badge.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: _transferTinyGap),
              _WalletIcon(wallet: wallet, color: color),
              const SizedBox(width: _transferInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(wallet.name, style: AppTextStyles.baseMedium),
                    const SizedBox(height: _transferTinyGap),
                    Text(
                      'Số dư: ${formatTransferUsd(wallet.balanceUsd)}',
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
                color: AppColors.text3,
                size: _transferActionIcon,
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
      width: _transferIconBox,
      height: _transferIconBox,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      background: ColoredBox(color: color.withValues(alpha: .13)),
      alignment: Alignment.center,
      clip: true,
      child: Icon(icon, color: color, size: _transferActionIcon),
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
          width: _transferSwapButtonSize,
          height: _transferSwapButtonSize,
          child: Material(
            color: _transferPrimary,
            elevation: 2,
            shadowColor: _transferPrimary.withValues(alpha: .38),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.swap_vert_rounded,
              color: AppColors.onAccent,
              size: _transferActionIcon,
            ),
          ),
        ),
      ),
    );
  }
}
