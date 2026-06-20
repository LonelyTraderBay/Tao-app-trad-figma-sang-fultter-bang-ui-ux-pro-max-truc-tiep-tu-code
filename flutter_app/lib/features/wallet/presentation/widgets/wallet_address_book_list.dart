part of '../pages/address_book_page.dart';

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.copied,
    required this.onCopy,
    required this.onFavorite,
    required this.onDelete,
  });

  final WalletSavedAddress address;
  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _bookCardMinHeight),
      child: VitCard(
        padding: _bookCardPadding,
        borderColor: AppColors.overlayStroke,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShieldBadge(whitelisted: address.isWhitelisted),
                const SizedBox(width: _bookInlineGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          if (address.isWhitelisted) ...[
                            const SizedBox(width: _bookTinyGap),
                            const _WhitelistBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: _bookTinyGap),
                      Row(
                        children: [
                          _MiniTag(address.network),
                          const SizedBox(width: _bookInlineGap),
                          _MiniTag(address.asset),
                        ],
                      ),
                      const SizedBox(height: _bookTinyGap),
                      Text(
                        address.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (address.lastUsed != null) ...[
                        const SizedBox(height: _bookTinyGap),
                        Text(
                          'DÃ¹ng gáº§n nháº¥t: ${address.lastUsed}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: _bookGap),
            Row(
              children: [
                Expanded(
                  child: _CopyButton(
                    copied: copied,
                    onTap: onCopy,
                    addressId: address.id,
                  ),
                ),
                const SizedBox(width: _bookTinyGap),
                _RoundActionButton(
                  key: AddressBookPage.favoriteKey(address.id),
                  icon: address.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: address.isFavorite ? _bookAmber : AppColors.text3,
                  filled: address.isFavorite,
                  onTap: onFavorite,
                ),
                const SizedBox(width: _bookTinyGap),
                _RoundActionButton(
                  key: AddressBookPage.editKey(address.id),
                  icon: Icons.edit_rounded,
                  color: AppColors.text2,
                  onTap: () {},
                ),
                const SizedBox(width: _bookTinyGap),
                _RoundActionButton(
                  key: AddressBookPage.deleteKey(address.id),
                  icon: Icons.delete_outline_rounded,
                  color: _bookRed,
                  danger: true,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShieldBadge extends StatelessWidget {
  const _ShieldBadge({required this.whitelisted});

  final bool whitelisted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: _bookIconBox,
      height: _bookIconBox,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      alignment: Alignment.center,
      child: Icon(
        Icons.shield_outlined,
        color: whitelisted ? _bookGreen : AppColors.text3,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

class _WhitelistBadge extends StatelessWidget {
  const _WhitelistBadge();

  @override
  Widget build(BuildContext context) {
    return const VitStatusPill(
      label: 'Whitelist',
      icon: Icons.check_rounded,
      status: VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.copied,
    required this.onTap,
    required this.addressId,
  });

  final bool copied;
  final VoidCallback onTap;
  final String addressId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AddressBookPage.copyKey(addressId),
      height: _bookCopyHeight,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      alignment: Alignment.center,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            copied ? Icons.check_circle_outline_rounded : Icons.copy_rounded,
            color: _bookPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: _bookTinyGap),
          Text(
            copied ? 'ÄÃ£ copy' : 'Sao chÃ©p',
            style: AppTextStyles.caption.copyWith(
              color: _bookPrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
    this.danger = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool filled;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: _bookActionSize,
      height: _bookActionSize,
      variant: VitCardVariant.inner,
      borderColor: danger
          ? AppColors.sell15
          : filled
          ? AppColors.caution.withValues(alpha: .20)
          : AppColors.borderSolid,
      alignment: Alignment.center,
      onTap: onTap,
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.walletAddressEmptyPadding,
      child: Column(
        children: [
          const VitCard(
            width: AppSpacing.walletAddressEmptyIconSize,
            height: AppSpacing.walletAddressEmptyIconSize,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            alignment: Alignment.center,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: AppSpacing.walletAddressEmptyIconGlyph,
            ),
          ),
          const SizedBox(height: _bookInlineGap),
          Text(
            'KhÃ´ng tÃ¬m tháº¥y Ä‘á»‹a chá»‰',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _bookGap),
          _AddAddressButton(onTap: onAdd),
        ],
      ),
    );
  }
}
