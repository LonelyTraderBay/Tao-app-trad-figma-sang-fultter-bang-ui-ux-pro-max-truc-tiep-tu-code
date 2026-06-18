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
    return VitCard(
      height: AppSpacing.walletAddressCardHeight,
      padding: AppSpacing.walletAddressCardPadding,
      borderColor: AppColors.overlayStroke,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShieldBadge(whitelisted: address.isWhitelisted),
              const SizedBox(width: AppSpacing.walletAddressPrimaryGap),
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
                          const SizedBox(width: AppSpacing.rowGap),
                          const _WhitelistBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.walletAddressMetaGap),
                    Row(
                      children: [
                        _MiniTag(address.network),
                        const SizedBox(width: AppSpacing.rowGapRegular),
                        _MiniTag(address.asset),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.walletAddressMetaGap),
                    Text(
                      address.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (address.lastUsed != null) ...[
                      const SizedBox(
                        height: AppSpacing.walletAddressCompactGap,
                      ),
                      Text(
                        'Dùng gần nhất: ${address.lastUsed}',
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
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _CopyButton(
                  copied: copied,
                  onTap: onCopy,
                  addressId: address.id,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAddressActionGap),
              _RoundActionButton(
                key: AddressBookPage.favoriteKey(address.id),
                icon: address.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: address.isFavorite ? _bookAmber : AppColors.text3,
                filled: address.isFavorite,
                onTap: onFavorite,
              ),
              const SizedBox(width: AppSpacing.walletAddressActionGap),
              _RoundActionButton(
                key: AddressBookPage.editKey(address.id),
                icon: Icons.edit_rounded,
                color: AppColors.text2,
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.walletAddressActionGap),
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
    );
  }
}

class _ShieldBadge extends StatelessWidget {
  const _ShieldBadge({required this.whitelisted});

  final bool whitelisted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.walletAddressIconSize,
      height: AppSpacing.walletAddressIconSize,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      alignment: Alignment.center,
      child: Icon(
        Icons.shield_outlined,
        color: whitelisted ? _bookGreen : AppColors.text3,
        size: AppSpacing.walletAddressShieldIcon,
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
      height: AppSpacing.walletAddressCopyHeight,
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
            const SizedBox(width: AppSpacing.walletAddressSectionGap),
            Text(
              copied ? 'Đã copy' : 'Sao chép',
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
      width: AppSpacing.walletAddressActionSize,
      height: AppSpacing.walletAddressActionSize,
      variant: VitCardVariant.inner,
      borderColor: danger
          ? AppColors.sell15
          : filled
          ? AppColors.caution.withValues(alpha: .20)
          : AppColors.borderSolid,
      alignment: Alignment.center,
      onTap: onTap,
      child: Icon(icon, color: color, size: AppSpacing.walletAddressActionIcon),
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
          const SizedBox(height: AppSpacing.rowGapRegular),
          Text(
            'Không tìm thấy địa chỉ',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.walletAddressFilterGap),
          _AddAddressButton(onTap: onAdd),
        ],
      ),
    );
  }
}
