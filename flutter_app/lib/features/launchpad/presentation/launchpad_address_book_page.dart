import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

class LaunchpadAddressBookPage extends ConsumerStatefulWidget {
  const LaunchpadAddressBookPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc309_launchpad_address_book_content');
  static const searchKey = Key('sc309_launchpad_address_book_search');
  static const addKey = Key('sc309_launchpad_address_book_add');
  static const statsKey = Key('sc309_launchpad_address_book_stats');
  static const favoritesKey = Key('sc309_launchpad_address_book_favorites');
  static const allKey = Key('sc309_launchpad_address_book_all');
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
        .read(launchpadRepositoryProvider)
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
    final snapshot = ref.watch(launchpadRepositoryProvider).getAddressBook();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
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
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                  trailing: _AddButton(
                    onTap: () => setState(() => _showAddSheet = true),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadAddressBookPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
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
              ],
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

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: LaunchpadAddressBookPage.addKey,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      icon: const Icon(Icons.add_rounded, color: AppColors.text1, size: 22),
    );
  }
}

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

class _AddAddressSheet extends StatelessWidget {
  const _AddAddressSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadAddressBookPage.addSheetKey,
      color: Colors.black.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(AppSpacing.x5),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.cardLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.xlRadius,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                'Them dia chi moi',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Address mutation se can KYC submission-step va preview confirm truoc khi ghi len backend.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: LaunchpadAddressBookPage.addSheetCloseKey,
                onPressed: onClose,
                leading: const Icon(Icons.close_rounded, color: Colors.white),
                child: const Text('Dong'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadAddressBookPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'So dia chi duoc luu tren thiet bi. Luon kiem tra lai dia chi truoc khi thuc hien giao dich.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.xlRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .32) : Colors.transparent,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.xlRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainIcon extends StatelessWidget {
  const _ChainIcon({required this.address});

  final LaunchpadWalletAddressDraft address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: address.accent.withValues(alpha: .16),
        border: Border.all(color: address.accent.withValues(alpha: .28)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(_chainIcon(address.iconKey), color: address.accent, size: 20),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

Color _chainColor(String chain) {
  return switch (chain) {
    'BSC' => AppColors.warn,
    'Polygon' => AppColors.accent,
    'Arbitrum' => AppColors.primary,
    _ => AppModuleAccents.launchpad,
  };
}

IconData _chainIcon(String iconKey) {
  return switch (iconKey) {
    'bsc' => Icons.hexagon_outlined,
    'polygon' => Icons.hive_outlined,
    'arbitrum' => Icons.change_circle_outlined,
    _ => Icons.account_balance_wallet_outlined,
  };
}
