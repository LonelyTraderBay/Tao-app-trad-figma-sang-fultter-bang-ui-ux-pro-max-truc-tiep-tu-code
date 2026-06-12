part of '../pages/address_book_page.dart';

class _WhitelistModeCard extends StatelessWidget {
  const _WhitelistModeCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: AddressBookPage.whitelistModeKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: VitCard(
        height: AppSpacing.walletAddressSecurityCardHeight,
        padding: AppSpacing.walletAddressSecurityPadding,
        borderColor: AppColors.overlayStroke,
        child: Row(
          children: [
            Container(
              width: AppSpacing.walletAddressIconSize,
              height: AppSpacing.walletAddressIconSize,
              decoration: BoxDecoration(
                color: enabled ? AppColors.buy10 : _bookPanel2,
                borderRadius: AppRadii.lgRadius,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: enabled ? _bookGreen : AppColors.text3,
                size: AppSpacing.walletAddressShieldIcon,
              ),
            ),
            const SizedBox(width: AppSpacing.walletAddressPrimaryGap),
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
                  const SizedBox(height: AppSpacing.walletAddressSectionGap),
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
            _SwitchPill(enabled: enabled),
          ],
        ),
      ),
    );
  }
}

class _SwitchPill extends StatelessWidget {
  const _SwitchPill({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.walletAddressSwitchWidth,
      height: AppSpacing.walletAddressSwitchHeight,
      decoration: BoxDecoration(
        color: enabled ? _bookGreen : _bookPanel2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: enabled ? _bookGreen : AppColors.borderSolid,
          width: AppSpacing.walletAddressSwitchBorder,
        ),
      ),
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Container(
          width: AppSpacing.walletAddressSwitchKnob,
          height: AppSpacing.walletAddressSwitchKnob,
          margin: AppSpacing.walletAddressSwitchKnobMargin,
          decoration: BoxDecoration(
            color: enabled ? AppColors.onAccent : AppColors.textDisabledBlue,
            shape: BoxShape.circle,
          ),
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
      padding: AppSpacing.walletAddressSecurityPadding,
      borderColor: AppColors.primary15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _bookPrimary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
                children: const [
                  TextSpan(
                    text: 'Bảo mật: ',
                    style: TextStyle(
                      color: _bookPrimary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Địa chỉ whitelist được bảo vệ bởi 2FA. Chỉ có thể rút tới địa chỉ đã được xác minh.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
