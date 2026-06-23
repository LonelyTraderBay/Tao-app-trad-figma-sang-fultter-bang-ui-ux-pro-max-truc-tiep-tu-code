part of '../pages/address_book_page.dart';

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitHeaderActionButton(
      key: AddressBookPage.addKey,
      type: VitHeaderActionType.add,
      tooltip: 'Thêm địa chỉ',
      onPressed: onTap,
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: AddressBookPage.searchKey,
      controller: controller,
      placeholder: 'Tìm địa chỉ hoặc tên...',
      onChanged: (_) => onChanged(),
    );
  }
}

class _NetworkFilterBar extends StatelessWidget {
  const _NetworkFilterBar({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<String> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _bookFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == active;
          return VitChoicePill(
            key: AddressBookPage.filterKey(filter),
            label: filter,
            selected: selected,
            onTap: () => onChanged(filter),
            height: _bookFilterHeight,
            padding: _bookFilterPadding,
            accentColor: _bookPrimary,
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: _bookInlineGap),
        itemCount: filters.length,
      ),
    );
  }
}

class _AddressStats extends StatelessWidget {
  const _AddressStats({required this.addresses});

  final List<WalletSavedAddress> addresses;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (addresses.length.toString(), 'Tổng địa chỉ', _bookPrimary),
      (
        addresses.where((address) => address.isFavorite).length.toString(),
        'Yêu thích',
        _bookAmber,
      ),
      (
        addresses.where((address) => address.isWhitelisted).length.toString(),
        'Whitelist',
        _bookGreen,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              height: _bookStatsHeight,
              borderColor: AppColors.overlayStroke,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: _bookTinyGap),
                  Text(
                    stats[i].$2,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1) const SizedBox(width: _bookInlineGap),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, this.icon, this.iconColor});

  final String label;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: AppSpacing.iconSm),
          const SizedBox(width: _bookTinyGap),
        ],
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}
