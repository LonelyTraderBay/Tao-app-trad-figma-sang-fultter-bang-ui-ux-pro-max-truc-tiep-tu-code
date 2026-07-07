import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/wallet_address_book_controls.dart';
part '../widgets/wallet_address_book_security.dart';
part '../widgets/wallet_address_book_list.dart';

double _bookScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? AppSpacing.walletBottomInsetVisualChrome
          : AppSpacing.walletBottomInsetNativeChrome) +
      MediaQuery.paddingOf(context).bottom;
}

String _maskAddress(String address) {
  if (address.length <= 12) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

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
    _addresses = ref.read(walletAddressBookProvider).addresses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletAddressBookProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _bookScrollBottomInset(context, mode);
    final filtered = _filteredAddresses();
    final favorites = filtered.where((address) => address.isFavorite).toList();
    final others = filtered.where((address) => !address.isFavorite).toList();

    return VitAutoHidePageScaffold(
      semanticLabel: 'SC-144 AddressBookPage',
      header: VitHeader(
        title: 'Sổ địa chỉ',
        subtitle: 'Quản lý · Wallet',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.wallet),
        actions: [
          VitHeaderActionItem(
            key: AddressBookPage.addKey,
            type: VitHeaderActionType.add,
            tooltip: 'Thêm địa chỉ',
            onPressed: () => context.go(AppRoutePaths.walletAddressBookAdd),
          ),
        ],
      ),
      body: VitInsetScrollView(
        key: AddressBookPage.contentKey,
        bottomInset: bottomInset,
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          gap: VitContentGap.tight,
          children: [
            _WhitelistModeCard(
              enabled: _whitelistOnly,
              onTap: () => setState(() => _whitelistOnly = !_whitelistOnly),
            ),
            _AddressStats(addresses: _addresses),
            _SearchBox(
              controller: _searchController,
              onChanged: () => setState(() {}),
            ),
            _NetworkFilterBar(
              filters: snapshot.networkFilters,
              active: _networkFilter,
              onChanged: (filter) => setState(() => _networkFilter = filter),
            ),
            if (favorites.isNotEmpty)
              VitPageSection(
                label: 'Yêu thích',
                headerIcon: Icons.star_rounded,
                headerIconColor: AppColors.caution,
                accentColor: AppColors.caution,
                headerVariant: VitSectionHeaderVariant.plain,
                headerDensity: VitDensity.compact,
                innerGap: AppSpacing.pageRhythmStandardInnerGap,
                children: [
                  for (final address in favorites)
                    _AddressCard(
                      address: address,
                      copied: _copiedId == address.id,
                      onCopy: () => _copyAddress(address),
                      onFavorite: () => _toggleFavorite(address.id),
                      onEdit: () => _showActionNotice(
                        'Chỉnh sửa địa chỉ sẽ mở trong bước kế tiếp',
                      ),
                      onDelete: () => _confirmDelete(address),
                    ),
                ],
              ),
            if (others.isNotEmpty)
              VitPageSection(
                label: 'Tất cả địa chỉ',
                headerIcon: Icons.list_alt_rounded,
                headerVariant: VitSectionHeaderVariant.plain,
                headerDensity: VitDensity.compact,
                innerGap: AppSpacing.pageRhythmStandardInnerGap,
                children: [
                  for (final address in others)
                    _AddressCard(
                      address: address,
                      copied: _copiedId == address.id,
                      onCopy: () => _copyAddress(address),
                      onFavorite: () => _toggleFavorite(address.id),
                      onEdit: () => _showActionNotice(
                        'Chỉnh sửa địa chỉ sẽ mở trong bước kế tiếp',
                      ),
                      onDelete: () => _confirmDelete(address),
                    ),
                ],
              ),
            if (filtered.isEmpty)
              _EmptyAddressState(
                onAdd: () => context.go(AppRoutePaths.walletAddressBookAdd),
              ),
            VitPageSection(
              label: 'B\u1EA3o m\u1EADt \u0111\u1ECBa ch\u1EC9',
              headerIcon: Icons.shield_outlined,
              headerIconColor: AppColors.primary,
              innerGap: AppSpacing.pageRhythmStandardInnerGap,
              children: const [_SecurityTip()],
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

  void _showActionNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _confirmDelete(WalletSavedAddress address) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Xóa địa chỉ'),
          content: Text(
            'Bạn có chắc muốn xóa địa chỉ "${address.label}" (${_maskAddress(address.address)})?',
          ),
          actions: [
            VitCtaButton(
              onPressed: () => Navigator.of(context).pop(),
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              child: const Text('Hủy'),
            ),
            VitCtaButton(
              onPressed: () {
                setState(() {
                  _addresses = [
                    for (final item in _addresses)
                      if (item.id != address.id) item,
                  ];
                });
                Navigator.of(context).pop();
              },
              variant: VitCtaButtonVariant.destructive,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              child: Text(
                'Xóa',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
