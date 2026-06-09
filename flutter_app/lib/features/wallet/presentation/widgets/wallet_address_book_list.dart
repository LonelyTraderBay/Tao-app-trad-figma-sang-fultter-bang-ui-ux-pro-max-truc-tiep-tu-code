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
      height: 162,
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.overlayStroke,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShieldBadge(whitelisted: address.isWhitelisted),
              const SizedBox(width: 13),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                        if (address.isWhitelisted) ...[
                          const SizedBox(width: 8),
                          const _WhitelistBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MiniTag(address.network),
                        const SizedBox(width: 12),
                        _MiniTag(address.asset),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      address.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    if (address.lastUsed != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Dùng gần nhất: ${address.lastUsed}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
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
              const SizedBox(width: 10),
              _RoundActionButton(
                key: AddressBookPage.favoriteKey(address.id),
                icon: address.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: address.isFavorite ? _bookAmber : AppColors.text3,
                filled: address.isFavorite,
                onTap: onFavorite,
              ),
              const SizedBox(width: 10),
              _RoundActionButton(
                key: AddressBookPage.editKey(address.id),
                icon: Icons.edit_rounded,
                color: AppColors.text2,
                onTap: () {},
              ),
              const SizedBox(width: 10),
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
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _bookPanel2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Icon(
        Icons.shield_outlined,
        color: whitelisted ? _bookGreen : AppColors.text3,
        size: 19,
      ),
    );
  }
}

class _WhitelistBadge extends StatelessWidget {
  const _WhitelistBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, color: _bookGreen, size: 11),
          const SizedBox(width: 2),
          Text(
            'Whitelist',
            style: AppTextStyles.micro.copyWith(
              color: _bookGreen,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
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
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1,
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
    return GestureDetector(
      key: AddressBookPage.copyKey(addressId),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary12,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.primary20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              copied ? Icons.check_circle_outline_rounded : Icons.copy_rounded,
              color: _bookPrimary,
              size: 14,
            ),
            const SizedBox(width: 7),
            Text(
              copied ? 'Đã copy' : 'Sao chép',
              style: AppTextStyles.caption.copyWith(
                color: _bookPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: danger
              ? AppColors.sell.withValues(alpha: .08)
              : filled
              ? AppColors.caution.withValues(alpha: .10)
              : _bookPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: danger
                ? AppColors.sell15
                : filled
                ? AppColors.caution.withValues(alpha: .20)
                : AppColors.borderSolid,
          ),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _bookPanel2,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy địa chỉ',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 16),
          _AddAddressButton(onTap: onAdd),
        ],
      ),
    );
  }
}
