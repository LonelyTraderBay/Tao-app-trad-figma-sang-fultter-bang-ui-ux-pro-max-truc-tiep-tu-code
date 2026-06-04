part of '../pages/launchpad_address_book_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadAddressBookPage.searchKey,
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder),
        borderRadius: AppRadii.xlRadius,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          hintText: 'Tim dia chi, nhan, chain...',
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.searchPlaceholder,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: 18,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.text3,
                    size: 18,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ChainFilters extends StatelessWidget {
  const _ChainFilters({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              key: LaunchpadAddressBookPage.filterKey(filter),
              label: filter == 'all' ? 'Tat ca' : filter,
              active: activeFilter == filter,
              color: _chainColor(filter),
              onTap: () => onChanged(filter),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AddressStats extends StatelessWidget {
  const _AddressStats({required this.addresses});

  final List<LaunchpadWalletAddressDraft> addresses;

  @override
  Widget build(BuildContext context) {
    final favorites = addresses.where((address) => address.isFavorite).length;
    final verified = addresses.where((address) => address.verified).length;
    return Row(
      key: LaunchpadAddressBookPage.statsKey,
      children: [
        _StatPill(
          icon: Icons.account_balance_wallet_outlined,
          value: '${addresses.length}',
          label: 'dia chi',
          color: AppModuleAccents.launchpad,
        ),
        const SizedBox(width: AppSpacing.x3),
        _StatPill(
          icon: Icons.star_rounded,
          value: '$favorites',
          label: 'yeu thich',
          color: AppColors.warn,
        ),
        const SizedBox(width: AppSpacing.x3),
        _StatPill(
          icon: Icons.verified_user_outlined,
          value: '$verified',
          label: 'xac minh',
          color: AppColors.buy,
        ),
      ],
    );
  }
}
