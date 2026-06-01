part of '../pages/launchpad_address_book_page.dart';

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.expanded,
    required this.copied,
    required this.onCopy,
    required this.onFavorite,
    required this.onDefault,
    required this.onExpand,
  });

  final LaunchpadWalletAddressDraft address;
  final bool expanded;
  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;
  final VoidCallback onDefault;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadAddressBookPage.cardKey(address.id),
      borderColor: address.isDefault
          ? address.accent.withValues(alpha: .42)
          : null,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          InkWell(
            key: LaunchpadAddressBookPage.expandKey(address.id),
            onTap: onExpand,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChainIcon(address: address),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                address.label,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.base.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (address.isDefault) ...[
                              const SizedBox(width: AppSpacing.x2),
                              _Badge(
                                label: 'MAC DINH',
                                color: AppModuleAccents.launchpad,
                              ),
                            ],
                            if (address.verified) ...[
                              const SizedBox(width: AppSpacing.x1),
                              const Icon(
                                Icons.verified_user_outlined,
                                color: AppColors.buy,
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          address.maskedAddress,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Wrap(
                          spacing: AppSpacing.x1,
                          runSpacing: AppSpacing.x1,
                          children: [
                            _Badge(label: address.chain, color: address.accent),
                            for (final tag in address.tags.take(2))
                              _Badge(label: tag, color: AppColors.text3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        key: LaunchpadAddressBookPage.favoriteKey(address.id),
                        onPressed: onFavorite,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          address.isFavorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: address.isFavorite
                              ? AppColors.warn
                              : AppColors.text3,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        key: LaunchpadAddressBookPage.copyKey(address.id),
                        onPressed: onCopy,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          copied ? Icons.check_rounded : Icons.copy_rounded,
                          color: copied ? AppColors.buy : AppColors.text3,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _ExpandedAddress(address: address, onDefault: onDefault),
        ],
      ),
    );
  }
}

class _ExpandedAddress extends StatelessWidget {
  const _ExpandedAddress({required this.address, required this.onDefault});

  final LaunchpadWalletAddressDraft address;
  final VoidCallback onDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.x3),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              address.address,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _DetailRow(label: 'Chain', value: address.chain),
          if (address.lastUsed != null)
            _DetailRow(label: 'Lan dung gan nhat', value: address.lastUsed!),
          _DetailRow(
            label: 'So lan su dung',
            value: '${address.usageCount} lan',
          ),
          _DetailRow(label: 'Ngay them', value: address.createdAt),
          _DetailRow(
            label: 'Trang thai',
            value: address.verified ? 'Da xac minh' : 'Chua xac minh',
          ),
          if (address.notes != null) ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              address.notes!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.35,
              ),
            ),
          ],
          if (!address.isDefault) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              key: LaunchpadAddressBookPage.defaultKey(address.id),
              onPressed: onDefault,
              variant: VitCtaButtonVariant.secondary,
              height: 42,
              leading: const Icon(
                Icons.verified_user_outlined,
                color: AppColors.text1,
                size: 16,
              ),
              child: const Text('Dat lam mac dinh'),
            ),
          ],
        ],
      ),
    );
  }
}
