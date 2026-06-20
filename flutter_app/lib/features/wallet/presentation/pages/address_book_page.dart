import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/wallet_address_book_controls.dart';
part '../widgets/wallet_address_book_security.dart';
part '../widgets/wallet_address_book_list.dart';

const _bookBackground = AppColors.bg;
const _bookPanel = AppColors.surface;
const _bookPrimary = AppColors.primary;
const _bookGreen = AppColors.buy;
const _bookAmber = AppColors.caution;
const _bookRed = AppColors.sell;
const _bookNativeBottomClearance = 88.0;
const _bookVisualBottomClearance = 112.0;
const _bookScrollTopPad = 0.0;
const _bookGap = 8.0;
const _bookTinyGap = 4.0;
const _bookInlineGap = 8.0;
const _bookFilterHeight = 34.0;
const _bookStatsHeight = 52.0;
const _bookCardMinHeight = 124.0;
const _bookIconBox = 34.0;
const _bookCopyHeight = 38.0;
const _bookActionSize = 38.0;
const _bookSecurityHeight = 62.0;
const _bookCardPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
const _bookFilterPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
const _bookSecurityPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

double _bookScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _bookVisualBottomClearance
          : _bookNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
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

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-144 AddressBookPage',
      child: Material(
        color: _bookBackground,
        child: VitAutoHideHeaderScaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: AddressBookPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _bookScrollTopPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _SearchBox(
                        controller: _searchController,
                        onChanged: () => setState(() {}),
                      ),
                      _WhitelistModeCard(
                        enabled: _whitelistOnly,
                        onTap: () =>
                            setState(() => _whitelistOnly = !_whitelistOnly),
                      ),
                      _NetworkFilterBar(
                        filters: snapshot.networkFilters,
                        active: _networkFilter,
                        onChanged: (filter) =>
                            setState(() => _networkFilter = filter),
                      ),
                      _AddressStats(addresses: _addresses),
                      if (favorites.isNotEmpty) ...[
                        const _SectionTitle(
                          icon: Icons.star_rounded,
                          iconColor: _bookAmber,
                          label: 'Yêu thích',
                        ),
                        for (final address in favorites) ...[
                          _AddressCard(
                            address: address,
                            copied: _copiedId == address.id,
                            onCopy: () => _copyAddress(address),
                            onFavorite: () => _toggleFavorite(address.id),
                            onDelete: () => _confirmDelete(address),
                          ),
                        ],
                      ],
                      if (others.isNotEmpty) ...[
                        const _SectionTitle(label: 'Tất cả địa chỉ'),
                        for (final address in others) ...[
                          _AddressCard(
                            address: address,
                            copied: _copiedId == address.id,
                            onCopy: () => _copyAddress(address),
                            onFavorite: () => _toggleFavorite(address.id),
                            onDelete: () => _confirmDelete(address),
                          ),
                        ],
                      ],
                      if (filtered.isEmpty)
                        _EmptyAddressState(
                          onAdd: () =>
                              context.go(AppRoutePaths.walletAddressBookAdd),
                        ),
                      const _SecurityTip(),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Address book state review',
                        message:
                            'Search, network filter, whitelist-only mode, favorites, copy state, delete confirmation, empty state, and add-address route remain visible before wallet address changes.',
                        contractId: 'SC-144',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              child: Text(
                'Xóa',
                style: AppTextStyles.caption.copyWith(color: _bookRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
