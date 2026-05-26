import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

const _bookBackground = AppColors.bg;
const _bookPanel = AppColors.surface;
const _bookPanel2 = AppColors.surface2;
const _bookPrimary = AppColors.primary;
const _bookGreen = Color(0xFF10B981);
const _bookAmber = Color(0xFFF59E0B);
const _bookRed = Color(0xFFEF4444);

class AddressBookPage extends ConsumerStatefulWidget {
  const AddressBookPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc144_address_book_content');
  static const searchKey = Key('sc144_address_book_search');
  static const addKey = Key('sc144_address_book_add');
  static const whitelistModeKey = Key('sc144_address_book_whitelist_mode');
  static Key filterKey(String filter) =>
      Key('sc144_address_book_filter_$filter');
  static Key copyKey(String id) => Key('sc144_address_book_copy_$id');
  static Key favoriteKey(String id) => Key('sc144_address_book_favorite_$id');
  static Key editKey(String id) => Key('sc144_address_book_edit_$id');
  static Key deleteKey(String id) => Key('sc144_address_book_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends ConsumerState<AddressBookPage> {
  late List<WalletSavedAddress> _addresses;
  final TextEditingController _searchController = TextEditingController();
  String _networkFilter = 'Tất cả';
  String? _copiedId;
  bool _whitelistOnly = false;

  @override
  void initState() {
    super.initState();
    _addresses = ref.read(walletRepositoryProvider).getAddressBook().addresses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getAddressBook();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 32
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;
    final filtered = _filteredAddresses();
    final favorites = filtered.where((address) => address.isFavorite).toList();
    final others = filtered.where((address) => !address.isFavorite).toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-144 AddressBookPage',
      child: Material(
        color: _bookBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Sổ địa chỉ',
              subtitle: 'Quản lý · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
              trailing: _AddAddressButton(
                onTap: () => context.go(AppRoutePaths.walletAddressBookAdd),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: AddressBookPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SearchBox(
                      controller: _searchController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 17),
                    _WhitelistModeCard(
                      enabled: _whitelistOnly,
                      onTap: () =>
                          setState(() => _whitelistOnly = !_whitelistOnly),
                    ),
                    const SizedBox(height: 16),
                    _NetworkFilterBar(
                      filters: snapshot.networkFilters,
                      active: _networkFilter,
                      onChanged: (filter) =>
                          setState(() => _networkFilter = filter),
                    ),
                    const SizedBox(height: 17),
                    _AddressStats(addresses: _addresses),
                    const SizedBox(height: 14),
                    if (favorites.isNotEmpty) ...[
                      const _SectionTitle(
                        icon: Icons.star_rounded,
                        iconColor: _bookAmber,
                        label: 'Yêu thích',
                      ),
                      const SizedBox(height: 9),
                      for (final address in favorites) ...[
                        _AddressCard(
                          address: address,
                          copied: _copiedId == address.id,
                          onCopy: () => _copyAddress(address),
                          onFavorite: () => _toggleFavorite(address.id),
                          onDelete: () => _confirmDelete(address),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                    if (others.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      const _SectionTitle(label: 'Tất cả địa chỉ'),
                      const SizedBox(height: 9),
                      for (final address in others) ...[
                        _AddressCard(
                          address: address,
                          copied: _copiedId == address.id,
                          onCopy: () => _copyAddress(address),
                          onFavorite: () => _toggleFavorite(address.id),
                          onDelete: () => _confirmDelete(address),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                    if (filtered.isEmpty)
                      _EmptyAddressState(
                        onAdd: () =>
                            context.go(AppRoutePaths.walletAddressBookAdd),
                      ),
                    const SizedBox(height: 4),
                    const _SecurityTip(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<WalletSavedAddress> _filteredAddresses() {
    final query = _searchController.text.trim().toLowerCase();
    return _addresses.where((address) {
      final matchesNetwork =
          _networkFilter == 'Tất cả' || address.network == _networkFilter;
      final matchesSearch =
          query.isEmpty ||
          address.label.toLowerCase().contains(query) ||
          address.address.toLowerCase().contains(query);
      final matchesWhitelist = !_whitelistOnly || address.isWhitelisted;
      return matchesNetwork && matchesSearch && matchesWhitelist;
    }).toList();
  }

  Future<void> _copyAddress(WalletSavedAddress address) async {
    await Clipboard.setData(ClipboardData(text: address.address));
    if (!mounted) return;
    setState(() => _copiedId = address.id);
  }

  void _toggleFavorite(String addressId) {
    setState(() {
      _addresses = [
        for (final address in _addresses)
          address.id == addressId
              ? address.copyWith(isFavorite: !address.isFavorite)
              : address,
      ];
    });
  }

  void _confirmDelete(WalletSavedAddress address) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _bookPanel,
          title: const Text('Xóa địa chỉ'),
          content: Text('Bạn có chắc muốn xóa địa chỉ "${address.label}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _addresses = [
                    for (final item in _addresses)
                      if (item.id != address.id) item,
                  ];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: _bookRed)),
            ),
          ],
        );
      },
    );
  }
}

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
          border: Border.all(color: const Color(0x14FFFFFF)),
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
            color: enabled ? Colors.white : const Color(0xFF65718A),
            shape: BoxShape.circle,
          ),
        ),
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
                color: selected ? AppColors.primary15 : Colors.transparent,
                borderRadius: AppRadii.inputRadius,
                border: Border.all(
                  color: selected ? AppColors.primary60 : Colors.transparent,
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
                border: Border.all(color: const Color(0x14FFFFFF)),
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
    return Container(
      height: 162,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bookPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
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
              ? const Color(0x14EF4444)
              : filled
              ? const Color(0x1AF59E0B)
              : _bookPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: danger
                ? const Color(0x26EF4444)
                : filled
                ? const Color(0x33F59E0B)
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
