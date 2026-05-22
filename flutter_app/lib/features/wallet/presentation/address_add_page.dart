import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _addressBg = Color(0xFF080C14);
const _addressSurface = Color(0xFF151A23);
const _addressSurface2 = Color(0xFF1D2436);
const _addressBlue = Color(0xFF3B82F6);
const _addressGreen = Color(0xFF10B981);
const _addressAmber = Color(0xFFF59E0B);
const _addressRed = Color(0xFFEF4444);

class AddressAddPage extends ConsumerStatefulWidget {
  const AddressAddPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc143_address_add_content');
  static const labelFieldKey = Key('sc143_address_label_field');
  static const addressFieldKey = Key('sc143_address_address_field');
  static const memoFieldKey = Key('sc143_address_memo_field');
  static const whitelistKey = Key('sc143_address_whitelist');
  static const agreementKey = Key('sc143_address_agreement');
  static const saveKey = Key('sc143_address_save');
  static Key networkKey(String id) => Key('sc143_address_network_$id');
  static Key assetKey(String asset) => Key('sc143_address_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends ConsumerState<AddressAddPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _addressController;
  late final TextEditingController _memoController;
  String _networkId = 'erc20';
  String _asset = 'ETH';
  bool _whitelist = false;
  bool _agreed = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _addressController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _canSave {
    return _labelController.text.trim().isNotEmpty &&
        _addressController.text.trim().length > 8 &&
        _agreed;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getAddressAdd();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    if (_saved) {
      return _AddressSavedState(
        label: _labelController.text.trim(),
        whitelist: _whitelist,
        onBack: () => context.go(AppRoutePaths.walletAddressBook),
      );
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-143 AddressAddPage',
      child: Material(
        color: _addressBg,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final footerTop = _footerTop(context, constraints, mode);
            return Stack(
              children: [
                Column(
                  children: [
                    VitHeader(
                      title: 'Thêm địa chỉ mới',
                      subtitle: 'Sổ địa chỉ · Wallet',
                      showBack: true,
                      onBack: () => context.go(AppRoutePaths.walletAddressBook),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: AddressAddPage.contentKey,
                        padding: EdgeInsets.fromLTRB(
                          20,
                          14,
                          20,
                          _scrollBottomInset(context, mode),
                        ),
                        child: _AddressAddForm(
                          snapshot: snapshot,
                          selectedNetworkId: _networkId,
                          selectedAsset: _asset,
                          labelController: _labelController,
                          addressController: _addressController,
                          memoController: _memoController,
                          whitelist: _whitelist,
                          agreed: _agreed,
                          onNetworkChanged: (id) =>
                              setState(() => _networkId = id),
                          onAssetChanged: (asset) =>
                              setState(() => _asset = asset),
                          onWhitelistChanged: () =>
                              setState(() => _whitelist = !_whitelist),
                          onAgreementChanged: () =>
                              setState(() => _agreed = !_agreed),
                          onInputChanged: () => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: footerTop,
                  left: 0,
                  right: 0,
                  child: _AddressSaveFooter(
                    enabled: _canSave,
                    onTap: () => _showConfirmPreview(snapshot),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _footerTop(
    BuildContext context,
    BoxConstraints constraints,
    ShellRenderMode mode,
  ) {
    const footerHeight = 72.0;
    if (mode.usesVisualQaFrame) {
      return DeviceMetrics.height -
          DeviceMetrics.safeTop -
          DeviceMetrics.bottomChrome -
          footerHeight;
    }

    final navReserve =
        DeviceMetrics.nativeBottomChrome + MediaQuery.paddingOf(context).bottom;
    return constraints.maxHeight - navReserve - footerHeight;
  }

  double _scrollBottomInset(BuildContext context, ShellRenderMode mode) {
    final navReserve = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome +
              MediaQuery.paddingOf(context).bottom;
    return navReserve + 112;
  }

  WalletAddressNetwork _selectedNetwork(WalletAddressAddSnapshot snapshot) {
    for (final network in snapshot.networks) {
      if (network.id == _networkId) return network;
    }
    return snapshot.networks.first;
  }

  void _showConfirmPreview(WalletAddressAddSnapshot snapshot) {
    if (!_canSave) return;

    final network = _selectedNetwork(snapshot);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _addressSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Xác nhận lưu địa chỉ',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.auditTrailNote,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                _PreviewPanel(
                  rows: [
                    ('Tên', _labelController.text.trim()),
                    ('Mạng', network.label),
                    ('Tài sản', _asset),
                    ('Địa chỉ', _maskAddress(_addressController.text.trim())),
                    if (_memoController.text.trim().isNotEmpty)
                      ('Memo', _memoController.text.trim()),
                    ('Whitelist', _whitelist ? 'Có' : 'Không'),
                  ],
                ),
                const SizedBox(height: 16),
                _PrimaryActionButton(
                  enabled: true,
                  label: 'Xác nhận lưu',
                  onTap: () {
                    final router = GoRouter.of(this.context);
                    Navigator.of(context).pop();
                    setState(() => _saved = true);
                    Future<void>.delayed(const Duration(milliseconds: 900), () {
                      if (mounted) router.go(AppRoutePaths.walletAddressBook);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddressAddForm extends StatelessWidget {
  const _AddressAddForm({
    required this.snapshot,
    required this.selectedNetworkId,
    required this.selectedAsset,
    required this.labelController,
    required this.addressController,
    required this.memoController,
    required this.whitelist,
    required this.agreed,
    required this.onNetworkChanged,
    required this.onAssetChanged,
    required this.onWhitelistChanged,
    required this.onAgreementChanged,
    required this.onInputChanged,
  });

  final WalletAddressAddSnapshot snapshot;
  final String selectedNetworkId;
  final String selectedAsset;
  final TextEditingController labelController;
  final TextEditingController addressController;
  final TextEditingController memoController;
  final bool whitelist;
  final bool agreed;
  final ValueChanged<String> onNetworkChanged;
  final ValueChanged<String> onAssetChanged;
  final VoidCallback onWhitelistChanged;
  final VoidCallback onAgreementChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final selectedNetwork = snapshot.networks.firstWhere(
      (network) => network.id == selectedNetworkId,
      orElse: () => snapshot.networks.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldSection(
          label: 'Tên địa chỉ',
          required: true,
          child: _TextInput(
            fieldKey: AddressAddPage.labelFieldKey,
            controller: labelController,
            hintText: 'VD: Ví lạnh cá nhân, Sàn Binance...',
            maxLength: 30,
            onChanged: onInputChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Đặt tên dễ nhớ cho ví',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                '${labelController.text.length}/30',
                style: AppTextStyles.micro.copyWith(
                  color: labelController.text.length > 25
                      ? _addressAmber
                      : AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _FieldLabel(label: 'Mạng lưới', required: true),
        const SizedBox(height: 9),
        _NetworkGrid(
          networks: snapshot.networks,
          selectedId: selectedNetworkId,
          onChanged: onNetworkChanged,
        ),
        const SizedBox(height: 26),
        const _FieldLabel(label: 'Tài sản'),
        const SizedBox(height: 12),
        _AssetSelector(
          assets: snapshot.assets,
          selectedAsset: selectedAsset,
          onChanged: onAssetChanged,
        ),
        const SizedBox(height: 34),
        _FieldSection(
          label: 'Địa chỉ ví',
          required: true,
          child: _AddressInput(
            controller: addressController,
            onChanged: onInputChanged,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            selectedNetwork.addressHint,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 28),
        _FieldSection(
          label: 'Memo / Tag',
          optionalText: '(tùy chọn)',
          child: _TextInput(
            fieldKey: AddressAddPage.memoFieldKey,
            controller: memoController,
            hintText: 'Nhập memo nếu cần...',
            height: 48,
            onChanged: onInputChanged,
          ),
        ),
        const SizedBox(height: 32),
        _WhitelistCard(enabled: whitelist, onTap: onWhitelistChanged),
        const SizedBox(height: 24),
        const _WarningCard(),
        const SizedBox(height: 24),
        _AgreementRow(agreed: agreed, onTap: onAgreementChanged),
        if (labelController.text.trim().isNotEmpty &&
            addressController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 18),
          _PreviewPanel(
            rows: [
              ('Tên', labelController.text.trim()),
              ('Mạng', selectedNetwork.label),
              ('Tài sản', selectedAsset),
              ('Địa chỉ', _maskAddress(addressController.text.trim())),
              if (memoController.text.trim().isNotEmpty)
                ('Memo', memoController.text.trim()),
              ('Whitelist', whitelist ? 'Có' : 'Không'),
            ],
          ),
        ],
      ],
    );
  }
}

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.label,
    required this.child,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(
          label: label,
          required: required,
          optionalText: optionalText,
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          height: 1.1,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _addressRed),
            ),
          if (optionalText != null)
            TextSpan(
              text: ' $optionalText',
              style: const TextStyle(
                color: AppColors.text3,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    this.fieldKey,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLength,
    this.height = 52,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final int? maxLength;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _addressSurface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasValue ? _addressBlue : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        key: fieldKey,
        controller: controller,
        maxLength: maxLength,
        onChanged: (_) => onChanged(),
        style: AppTextStyles.body.copyWith(
          color: AppColors.text1,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          counterText: '',
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class _AddressInput extends StatelessWidget {
  const _AddressInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().length > 8;
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 16, right: 9),
      decoration: BoxDecoration(
        color: _addressSurface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasValue ? _addressBlue : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: AddressAddPage.addressFieldKey,
              controller: controller,
              onChanged: (_) => onChanged(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập hoặc dán địa chỉ...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          _IconCircleButton(
            icon: Icons.content_paste_rounded,
            onTap: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              final text = data?.text;
              if (text == null || text.isEmpty) return;
              controller.text = text;
              onChanged();
            },
          ),
          const SizedBox(width: 7),
          _IconCircleButton(icon: Icons.qr_code_scanner_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0x14FFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.text2, size: 16),
      ),
    );
  }
}

class _NetworkGrid extends StatelessWidget {
  const _NetworkGrid({
    required this.networks,
    required this.selectedId,
    required this.onChanged,
  });

  final List<WalletAddressNetwork> networks;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (final network in networks)
          GestureDetector(
            key: AddressAddPage.networkKey(network.id),
            onTap: () => onChanged(network.id),
            behavior: HitTestBehavior.opaque,
            child: _NetworkChip(
              network: network,
              selected: network.id == selectedId,
            ),
          ),
      ],
    );
  }
}

class _NetworkChip extends StatelessWidget {
  const _NetworkChip({required this.network, required this.selected});

  final WalletAddressNetwork network;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126.5,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0x243B82F6) : _addressSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? const Color(0x803B82F6) : AppColors.borderSolid,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(network.colorHex),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              network.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _addressBlue : AppColors.text2,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<String> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 17,
      runSpacing: 12,
      children: [
        for (final asset in assets)
          GestureDetector(
            key: AddressAddPage.assetKey(asset),
            onTap: () => onChanged(asset),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: asset == 'MATIC' ? 64 : 53,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: asset == selectedAsset
                    ? const Color(0x243B82F6)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: asset == selectedAsset
                      ? const Color(0x803B82F6)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                asset,
                style: AppTextStyles.caption.copyWith(
                  color: asset == selectedAsset
                      ? _addressBlue
                      : AppColors.text2,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WhitelistCard extends StatelessWidget {
  const _WhitelistCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: AddressAddPage.whitelistKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 73,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: _addressSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled ? AppColors.buy10 : _addressSurface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: enabled
                      ? const Color(0x4D10B981)
                      : AppColors.borderSolid,
                ),
              ),
              child: Icon(
                Icons.shield_outlined,
                color: enabled ? _addressGreen : AppColors.text3,
                size: 18,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thêm vào Whitelist',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chỉ rút tiền đến địa chỉ whitelist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
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
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: enabled ? _addressGreen : _addressSurface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? _addressGreen : AppColors.borderSolid,
          width: 1.5,
        ),
      ),
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0x0FF59E0B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x26F59E0B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _addressAmber,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý quan trọng',
                  style: AppTextStyles.caption.copyWith(
                    color: _addressAmber,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kiểm tra kỹ địa chỉ và mạng lưới trước khi lưu. Rút tiền sai địa chỉ hoặc sai mạng sẽ mất vĩnh viễn và không thể khôi phục.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.agreed, required this.onTap});

  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: AddressAddPage.agreementKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: agreed ? _addressGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: agreed ? _addressGreen : const Color(0xFF44507A),
                width: 2,
              ),
            ),
            child: agreed
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tôi xác nhận địa chỉ ví và mạng lưới chính xác. Tôi hiểu rằng gửi tiền sai địa chỉ sẽ không thể hoàn lại.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _addressSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem trước',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: Text(
                    row.$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: row.$1 == 'Địa chỉ' ? 'Roboto Mono' : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _AddressSaveFooter extends StatelessWidget {
  const _AddressSaveFooter({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: const BoxDecoration(
        color: Color(0xF2141A26),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: _PrimaryActionButton(
        key: AddressAddPage.saveKey,
        enabled: enabled,
        label: 'Lưu địa chỉ',
        onTap: onTap,
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    super.key,
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _addressBlue : const Color(0xFF182030),
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: _addressBlue.withValues(alpha: .22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? Colors.white : const Color(0xFF303949),
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _AddressSavedState extends StatelessWidget {
  const _AddressSavedState({
    required this.label,
    required this.whitelist,
    required this.onBack,
  });

  final String label;
  final bool whitelist;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-143 AddressAddPage Success',
      child: Material(
        color: _addressBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Thêm địa chỉ',
              subtitle: 'Sổ địa chỉ · Wallet',
              showBack: true,
              onBack: onBack,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.buy20, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _addressGreen,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Đã lưu thành công!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Địa chỉ "$label" đã được thêm vào sổ địa chỉ.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.buy15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: _addressGreen,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            whitelist
                                ? 'Đã thêm vào whitelist'
                                : 'Chưa whitelist - có thể bật sau',
                            style: AppTextStyles.micro.copyWith(
                              color: _addressGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _maskAddress(String address) {
  if (address.length <= 24) return address;
  return '${address.substring(0, 16)}...${address.substring(address.length - 8)}';
}
