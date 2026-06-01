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
