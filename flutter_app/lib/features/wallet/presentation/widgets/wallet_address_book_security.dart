part of '../pages/address_book_page.dart';

class _WhitelistModeCard extends StatelessWidget {
  const _WhitelistModeCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: enabled,
      label: 'Toggle address whitelist mode',
      child: VitCard(
        key: AddressBookPage.whitelistModeKey,
        onTap: onTap,
        density: VitDensity.compact,
        borderColor: AppColors.overlayStroke,
        child: Row(
          children: [
            Container(
              width: AppSpacing.buttonCompact,
              height: AppSpacing.buttonCompact,
              decoration: BoxDecoration(
                color: enabled
                    ? AppColors.buy.withValues(alpha: .12)
                    : AppColors.surface2,
                borderRadius: AppRadii.smRadius,
                border: Border.all(
                  color: enabled ? AppColors.buy20 : AppColors.borderSolid,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline_rounded,
                color: enabled ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ),
            const SizedBox(width: AppSpacing.walletAddressActionGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chế độ Whitelist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletAddressCompactGap),
                  Text(
                    enabled
                        ? 'Chỉ rút tới địa chỉ whitelist'
                        : 'Cho phép rút tới mọi địa chỉ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            VitTogglePill(enabled: enabled, activeColor: AppColors.buy),
          ],
        ),
      ),
    );
  }
}

class _SecurityTip extends StatelessWidget {
  const _SecurityTip();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.primary15,
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.45,
          ),
          children: [
            TextSpan(
              text: 'Bảo mật: ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const TextSpan(
              text:
                  'Địa chỉ whitelist được bảo vệ bởi 2FA. Chỉ có thể rút tới địa chỉ đã được xác minh.',
            ),
          ],
        ),
      ),
    );
  }
}
