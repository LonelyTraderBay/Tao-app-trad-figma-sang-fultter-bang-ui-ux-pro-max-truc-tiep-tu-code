part of '../pages/address_book_page.dart';

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: AddressBookPage.addKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary15,
          borderRadius: AppRadii.lgRadius,
          border: Border.all(color: AppColors.primary20),
        ),
        child: const Icon(Icons.add_rounded, color: _bookPrimary, size: 24),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _bookPanel2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.borderSolid, width: 1.35),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              key: AddressBookPage.searchKey,
              controller: controller,
              onChanged: (_) => onChanged(),
              style: AppTextStyles.body.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tìm địa chỉ hoặc tên...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
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
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == active;
          return GestureDetector(
            key: AddressBookPage.filterKey(filter),
            onTap: () => onChanged(filter),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary15 : AppColors.transparent,
                borderRadius: AppRadii.inputRadius,
                border: Border.all(
                  color: selected ? AppColors.primary60 : AppColors.transparent,
                ),
              ),
              child: Text(
                filter,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? _bookPrimary : AppColors.text2,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 16),
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
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: _bookPanel,
                borderRadius: AppRadii.mdRadius,
                border: Border.all(color: AppColors.overlayStroke),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontSize: 20,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    stats[i].$2,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1) const SizedBox(width: 8),
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
          Icon(icon, color: iconColor, size: 15),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 13,
            height: 1,
          ),
        ),
      ],
    );
  }
}
