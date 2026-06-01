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
      child: Container(
        height: 74,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: _bookPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.overlayStroke),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled ? AppColors.buy10 : _bookPanel2,
                borderRadius: AppRadii.lgRadius,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: enabled ? _bookGreen : AppColors.text3,
                size: 19,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chế độ Whitelist',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    enabled
                        ? 'Chỉ rút tới địa chỉ whitelist'
                        : 'Cho phép rút tới mọi địa chỉ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10.5,
                      height: 1,
                    ),
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
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: enabled ? _bookGreen : _bookPanel2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: enabled ? _bookGreen : AppColors.borderSolid,
          width: 1.4,
        ),
      ),
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.primary15),
      ),
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
                  fontSize: 12,
                  height: 1.45,
                ),
                children: const [
                  TextSpan(
                    text: 'Bảo mật: ',
                    style: TextStyle(
                      color: _bookPrimary,
                      fontWeight: FontWeight.w800,
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
