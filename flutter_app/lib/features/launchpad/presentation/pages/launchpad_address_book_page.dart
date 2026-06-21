import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
part '../widgets/launchpad_address_book_controls.dart';
part '../widgets/launchpad_address_book_cards.dart';
part '../widgets/launchpad_address_book_sheet_common.dart';

class LaunchpadAddressBookPage extends ConsumerStatefulWidget {
  const LaunchpadAddressBookPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc309_launchpad_address_book_content');
  static const searchKey = Key('sc309_launchpad_address_book_search');
  static const addKey = Key('sc309_launchpad_address_book_add');
  static const statsKey = Key('sc309_launchpad_address_book_stats');
  static const favoritesKey = Key('sc309_launchpad_address_book_favorites');
  static const allKey = Key('sc309_launchpad_address_book_all');
  static const emptyKey = Key('sc309_launchpad_address_book_empty');
  static const addSheetKey = Key('sc309_launchpad_address_book_add_sheet');
  static const addSheetCloseKey = Key(
    'sc309_launchpad_address_book_add_sheet_close',
  );
  static const infoKey = Key('sc309_launchpad_address_book_info');

  static Key filterKey(String chain) =>
      Key('sc309_launchpad_address_book_filter_$chain');
  static Key cardKey(String id) => Key('sc309_launchpad_address_book_card_$id');
  static Key copyKey(String id) => Key('sc309_launchpad_address_book_copy_$id');
  static Key favoriteKey(String id) =>
      Key('sc309_launchpad_address_book_favorite_$id');
  static Key expandKey(String id) =>
      Key('sc309_launchpad_address_book_expand_$id');
  static Key defaultKey(String id) =>
      Key('sc309_launchpad_address_book_default_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadAddressBookPage> createState() =>
      _LaunchpadAddressBookPageState();
}

class _LaunchpadAddressBookPageState
    extends ConsumerState<LaunchpadAddressBookPage> {
  final _searchController = TextEditingController();
  late List<LaunchpadWalletAddressDraft> _addresses;
  var _chainFilter = 'all';
  var _searchQuery = '';
  var _showAddSheet = false;
  String? _expandedId;
  String? _copiedId;

  @override
  void initState() {
    super.initState();
    _addresses = ref
        .read(launchpadControllerProvider)
        .getAddressBook()
        .addresses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getAddressBook();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;
    final filtered = _filteredAddresses();
    final favorites = filtered.where((address) => address.isFavorite).toList();
    final others = filtered.where((address) => !address.isFavorite).toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-309 LaunchpadAddressBookPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: scrollTailReserve,
              semanticLabel: 'SC-309 LaunchpadAddressBookPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
                actions: [
                  VitHeaderActionItem(
                    key: LaunchpadAddressBookPage.addKey,
                    type: VitHeaderActionType.add,
                    onPressed: () => setState(() => _showAddSheet = true),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                key: LaunchpadAddressBookPage.contentKey,
                physics: const ClampingScrollPhysics(),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.tight,
                  children: [
                    _SearchField(
                      controller: _searchController,
                      query: _searchQuery,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      onClear: () => setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      }),
                    ),
                    _ChainFilters(
                      filters: snapshot.chainFilters,
                      activeFilter: _chainFilter,
                      onChanged: (value) =>
                          setState(() => _chainFilter = value),
                    ),
                    _AddressStats(addresses: _addresses),
                    if (filtered.isEmpty)
                      const VitEmptyState(
                        key: LaunchpadAddressBookPage.emptyKey,
                        title: 'Khong tim thay dia chi',
                        message:
                            'Thu doi tu khoa tim kiem hoac chon tat ca chain de tiep tuc.',
                        icon: Icons.search_off_rounded,
                      ),
                    if (favorites.isNotEmpty)
                      VitPageSection(
                        key: LaunchpadAddressBookPage.favoritesKey,
                        label: 'Yeu thich',
                        accentColor: AppColors.warn,
                        children: [
                          for (final address in favorites) ...[
                            _AddressCard(
                              address: address,
                              expanded: _expandedId == address.id,
                              copied: _copiedId == address.id,
                              onCopy: () => _copyAddress(address),
                              onFavorite: () => _toggleFavorite(address.id),
                              onDefault: () => _setDefault(address.id),
                              onExpand: () => setState(() {
                                _expandedId = _expandedId == address.id
                                    ? null
                                    : address.id;
                              }),
                            ),
                            if (address != favorites.last)
                              const SizedBox(height: AppSpacing.x3),
                          ],
                        ],
                      ),
                    if (others.isNotEmpty)
                      VitPageSection(
                        key: LaunchpadAddressBookPage.allKey,
                        label: 'Tat ca dia chi',
                        accentColor: AppModuleAccents.launchpad,
                        children: [
                          for (final address in others) ...[
                            _AddressCard(
                              address: address,
                              expanded: _expandedId == address.id,
                              copied: _copiedId == address.id,
                              onCopy: () => _copyAddress(address),
                              onFavorite: () => _toggleFavorite(address.id),
                              onDefault: () => _setDefault(address.id),
                              onExpand: () => setState(() {
                                _expandedId = _expandedId == address.id
                                    ? null
                                    : address.id;
                              }),
                            ),
                            if (address != others.last)
                              const SizedBox(height: AppSpacing.x3),
                          ],
                        ],
                      ),
                    const _InfoBanner(),
                  ],
                ),
              ),
            ),
            if (_showAddSheet)
              Positioned.fill(
                child: _AddAddressSheet(
                  onClose: () => setState(() => _showAddSheet = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<LaunchpadWalletAddressDraft> _filteredAddresses() {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _addresses.where((address) {
      final matchesChain =
          _chainFilter == 'all' || address.chain == _chainFilter;
      final matchesQuery =
          query.isEmpty ||
          address.label.toLowerCase().contains(query) ||
          address.address.toLowerCase().contains(query) ||
          address.chain.toLowerCase().contains(query) ||
          address.tags.any((tag) => tag.toLowerCase().contains(query));
      return matchesChain && matchesQuery;
    }).toList();
    filtered.sort((a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
      return b.usageCount.compareTo(a.usageCount);
    });
    return filtered;
  }

  Future<void> _copyAddress(LaunchpadWalletAddressDraft address) async {
    setState(() => _copiedId = address.id);
    try {
      await Clipboard.setData(ClipboardData(text: address.address));
    } catch (_) {
      // Embedded test shells may not expose clipboard support.
    }
  }

  void _toggleFavorite(String id) {
    setState(() {
      _addresses = [
        for (final address in _addresses)
          address.id == id
              ? address.copyWith(isFavorite: !address.isFavorite)
              : address,
      ];
    });
  }

  void _setDefault(String id) {
    setState(() {
      _addresses = [
        for (final address in _addresses)
          address.copyWith(isDefault: address.id == id),
      ];
    });
  }
}
