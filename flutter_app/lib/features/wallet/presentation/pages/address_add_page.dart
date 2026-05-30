import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

const _addressBackground = AppColors.bg;
const _addressPanel = AppColors.surface;

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

  bool _canSave(AddressAddController controller) {
    return controller.canPreview(
      label: _labelController.text,
      address: _addressController.text,
      agreed: _agreed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addressAddControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    if (_saved) {
      return AddressSavedState(
        label: _labelController.text.trim(),
        whitelist: _whitelist,
        onBack: () => context.go(AppRoutePaths.walletAddressBook),
      );
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-143 AddressAddPage',
      child: Material(
        color: _addressBackground,
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
                        child: AddressAddForm(
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
                  child: AddressSaveFooter(
                    enabled: _canSave(controller),
                    onTap: () => _showConfirmPreview(controller),
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

  void _showConfirmPreview(AddressAddController controller) {
    if (!_canSave(controller)) return;

    final preview = controller.preview(
      label: _labelController.text,
      address: _addressController.text,
      memo: _memoController.text,
      selectedNetworkId: _networkId,
      selectedAsset: _asset,
      whitelist: _whitelist,
    );
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _addressPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => AddressConfirmPreviewSheet(
        preview: preview,
        onConfirm: () {
          final router = GoRouter.of(this.context);
          Navigator.of(context).pop();
          setState(() => _saved = true);
          Future<void>.delayed(const Duration(milliseconds: 900), () {
            if (mounted) router.go(AppRoutePaths.walletAddressBook);
          });
        },
      ),
    );
  }
}
