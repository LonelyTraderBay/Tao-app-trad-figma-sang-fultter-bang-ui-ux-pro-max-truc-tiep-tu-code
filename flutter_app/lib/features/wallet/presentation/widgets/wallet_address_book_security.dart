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
        height: _bookSecurityHeight,
        padding: _bookSecurityPadding,
        borderColor: AppColors.overlayStroke,
        child: Row(
          children: [
            VitCard(
              width: _bookIconBox,
              height: _bookIconBox,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.lg,
              borderColor: enabled ? AppColors.buy20 : AppColors.borderSolid,
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline_rounded,
                color: enabled ? _bookGreen : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ),
            const SizedBox(width: _bookInlineGap),
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
                  const SizedBox(height: _bookTinyGap),
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
    return VitTogglePill(enabled: enabled, activeColor: _bookGreen);
  }
}

class _SecurityTip extends StatelessWidget {
  const _SecurityTip();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _bookSecurityPadding,
      borderColor: AppColors.primary15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: _bookPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: _bookInlineGap),
          Expanded(
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
