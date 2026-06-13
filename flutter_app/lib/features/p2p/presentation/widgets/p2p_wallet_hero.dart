part of '../pages/p2p_wallet_page.dart';

class _WalletHero extends StatelessWidget {
  const _WalletHero({
    required this.snapshot,
    required this.balanceVisible,
    required this.onPrivacyToggle,
    required this.onTransferFromMain,
    required this.onTransferToMain,
  });

  final P2PWalletSnapshot snapshot;
  final bool balanceVisible;
  final VoidCallback onPrivacyToggle;
  final VoidCallback onTransferFromMain;
  final VoidCallback onTransferToMain;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PWalletPage.heroKey,
      padding: const EdgeInsets.all(AppSpacing.x5),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppModuleAccents.p2p),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tài sản P2P',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .82),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      balanceVisible
                          ? '\$${_formatComma(snapshot.totalUsdValue, 2)}'
                          : snapshot.privacyMask,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.onAccent,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Material(
                key: P2PWalletPage.privacyKey,
                color: AppColors.onAccent.withValues(alpha: .18),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onPrivacyToggle,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: AppSpacing.inputHeight,
                    height: AppSpacing.inputHeight,
                    child: Icon(
                      balanceVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: AppColors.onAccent,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroActionButton(
                  key: P2PWalletPage.transferFromMainKey,
                  label: 'Chuyển từ Main',
                  icon: Icons.south_west_rounded,
                  onTap: onTransferFromMain,
                  filled: false,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroActionButton(
                  key: P2PWalletPage.transferToMainKey,
                  label: 'Chuyển về Main',
                  icon: Icons.north_east_rounded,
                  onTap: onTransferToMain,
                  filled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled
          ? AppColors.onAccent
          : AppColors.onAccent.withValues(alpha: .18),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: filled ? AppModuleAccents.p2p : AppColors.onAccent,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: filled ? AppModuleAccents.p2p : AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletInfoBanner extends StatelessWidget {
  const _WalletInfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      key: P2PWalletPage.infoKey,
      icon: Icons.info_outline_rounded,
      message: text,
      borderColor: AppModuleAccents.p2p.withValues(alpha: .28),
      padding: const EdgeInsets.all(AppSpacing.x3),
      iconSize: 16,
      messageStyle: AppTextStyles.captionSm.copyWith(color: AppColors.text2),
    );
  }
}
