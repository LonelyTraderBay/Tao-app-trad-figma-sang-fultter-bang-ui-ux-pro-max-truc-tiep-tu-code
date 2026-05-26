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

const _withdrawBackground = AppColors.bg;
const _withdrawPanel = AppColors.surface;
const _withdrawPanel2 = AppColors.surface2;
const _withdrawPrimary = AppColors.primary;
const _withdrawGreen = Color(0xFF10B981);
const _withdrawAmber = Color(0xFFF59E0B);

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc139_withdraw_content');
  static const networkSelectorKey = Key('sc139_withdraw_network_selector');
  static const addressFieldKey = Key('sc139_withdraw_address_field');
  static const amountFieldKey = Key('sc139_withdraw_amount_field');
  static const allAmountKey = Key('sc139_withdraw_all_amount');
  static const nextKey = Key('sc139_withdraw_next');
  static Key networkKey(String id) => Key('sc139_withdraw_network_$id');
  static Key recentAddressKey(String label) =>
      Key('sc139_withdraw_recent_$label');

  final String asset;
  final bool assetScoped;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  late final TextEditingController _addressController;
  late final TextEditingController _amountController;
  String? _selectedNetworkId;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(walletRepositoryProvider)
        .getWithdraw(widget.asset, assetScoped: widget.assetScoped);
    final selected = _selectedNetwork(snapshot.networks);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.assetScoped
          ? 'SC-140 WithdrawPage Asset'
          : 'SC-139 WithdrawPage',
      child: Material(
        color: _withdrawBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Rút ${snapshot.asset}',
              subtitle: 'Rút tiền · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WithdrawPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BalanceCard(
                      asset: snapshot.asset,
                      value: snapshot.available,
                    ),
                    const SizedBox(height: 20),
                    _NetworkSelector(
                      asset: snapshot.asset,
                      network: selected,
                      onTap: () => _openNetworkPicker(snapshot.networks),
                    ),
                    const SizedBox(height: 18),
                    _AddressInput(
                      asset: snapshot.asset,
                      network: selected,
                      controller: _addressController,
                      onScan: () {},
                    ),
                    const SizedBox(height: 8),
                    _RecentAddresses(
                      addresses: snapshot.recentAddresses,
                      onSelect: (address) {
                        _addressController.text = address.address;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    _AmountInput(
                      asset: snapshot.asset,
                      available: snapshot.available,
                      controller: _amountController,
                      onAll: () {
                        _amountController.text = _formatBalance(
                          snapshot.available,
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    const _WithdrawWarning(),
                    const SizedBox(height: 16),
                    _NextButton(onTap: _showConfirmPreview),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  WalletWithdrawNetwork _selectedNetwork(List<WalletWithdrawNetwork> networks) {
    final selectedId = _selectedNetworkId;
    if (selectedId != null) {
      for (final network in networks) {
        if (network.id == selectedId) return network;
      }
    }
    return networks.first;
  }

  void _openNetworkPicker(List<WalletWithdrawNetwork> networks) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _withdrawPanel,
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
                  'Chọn mạng lưới',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final network in networks)
                  _NetworkOption(
                    network: network,
                    selected: network.id == _selectedNetwork(networks).id,
                    onTap: () {
                      setState(() => _selectedNetworkId = network.id);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmPreview() {
    final amount = _amountController.text.trim().isEmpty
        ? '0'
        : _amountController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? 'Chưa nhập'
        : _addressController.text.trim();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _withdrawPanel,
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
                  'Xác nhận rút tiền',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 14),
                _PreviewRow(
                  label: 'Số lượng',
                  value: '$amount ${widget.asset}',
                ),
                _PreviewRow(label: 'Địa chỉ đến', value: _maskAddress(address)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _withdrawAmber.withValues(alpha: .10),
                    border: Border.all(
                      color: _withdrawAmber.withValues(alpha: .24),
                    ),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    'High-risk action: preview + confirm + audit trail required.',
                    style: AppTextStyles.caption.copyWith(
                      color: _withdrawAmber,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.asset, required this.value});

  final String asset;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _withdrawPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Số dư khả dụng',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            '${_formatBalance(value)} $asset',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkSelector extends StatelessWidget {
  const _NetworkSelector({
    required this.asset,
    required this.network,
    required this.onTap,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Mạng lưới'),
        const SizedBox(height: 9),
        GestureDetector(
          key: WithdrawPage.networkSelectorKey,
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _withdrawPanel2,
              border: Border.all(
                color: _withdrawPrimary.withValues(alpha: .34),
              ),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phí: ${_formatNetworkFee(network.fee)} $asset · Tối thiểu: ${_formatCompact(network.minWithdraw)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: _withdrawGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              'Mạng hoạt động tốt  ·  Phí: ${_formatNetworkFee(network.fee)} $asset',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AddressInput extends StatelessWidget {
  const _AddressInput({
    required this.asset,
    required this.network,
    required this.controller,
    required this.onScan,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final TextEditingController controller;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionLabel('Địa chỉ ví nhận')),
            GestureDetector(
              onTap: onScan,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: _withdrawPrimary.withValues(alpha: .14),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: _withdrawPrimary,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Quét QR',
                      style: AppTextStyles.micro.copyWith(
                        color: _withdrawPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          height: 47,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: _withdrawPanel2,
            border: Border.all(color: _withdrawPrimary.withValues(alpha: .25)),
            borderRadius: AppRadii.inputRadius,
          ),
          alignment: Alignment.center,
          child: TextField(
            key: WithdrawPage.addressFieldKey,
            controller: controller,
            style: AppTextStyles.body.copyWith(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              hintText:
                  'Nhập địa chỉ $asset (${network.name.split(' ').first})',
              hintStyle: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentAddresses extends StatelessWidget {
  const _RecentAddresses({required this.addresses, required this.onSelect});

  final List<WalletRecentAddress> addresses;
  final ValueChanged<WalletRecentAddress> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.text3,
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              'Địa chỉ gần đây',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final address in addresses) ...[
          GestureDetector(
            key: WithdrawPage.recentAddressKey(address.label),
            onTap: () => onSelect(address),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 51,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: _withdrawPanel2,
                borderRadius: AppRadii.inputRadius,
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          address.label,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          address.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 9,
                            fontFamily: 'Roboto',
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    address.lastUsed,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
        ],
      ],
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.asset,
    required this.available,
    required this.controller,
    required this.onAll,
  });

  final String asset;
  final double available;
  final TextEditingController controller;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionLabel('Số lượng rút')),
            GestureDetector(
              key: WithdrawPage.allAmountKey,
              onTap: onAll,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Tất cả',
                style: AppTextStyles.micro.copyWith(
                  color: _withdrawPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _withdrawPanel2,
            border: Border.all(color: _withdrawPrimary.withValues(alpha: .25)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: WithdrawPage.amountFieldKey,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: AppTextStyles.body.copyWith(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: '0.00',
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.text2,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Text(
                asset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 13,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WithdrawWarning extends StatelessWidget {
  const _WithdrawWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _withdrawAmber.withValues(alpha: .10),
        border: Border.all(color: _withdrawAmber.withValues(alpha: .28)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: _withdrawAmber,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Rút tiền cần xác minh 2FA. Yêu cầu rút trên \$10,000 sẽ được xem xét trong 24h.',
              style: AppTextStyles.micro.copyWith(
                color: _withdrawAmber,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WithdrawPage.nextKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: AppRadii.inputRadius,
          boxShadow: [
            BoxShadow(
              color: _withdrawPrimary.withValues(alpha: .28),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          'Tiếp tục →',
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _NetworkOption extends StatelessWidget {
  const _NetworkOption({
    required this.network,
    required this.selected,
    required this.onTap,
  });

  final WalletWithdrawNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WithdrawPage.networkKey(network.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: selected
              ? _withdrawPrimary.withValues(alpha: .10)
              : Colors.transparent,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    network.name,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phí: ${_formatCompact(network.fee)} · Tối thiểu: ${_formatCompact(network.minWithdraw)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: _withdrawPrimary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(value, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontSize: 13,
        height: 1,
      ),
    );
  }
}

String _formatBalance(double value) {
  return _formatNumber(value, fractionDigits: 2);
}

String _formatNetworkFee(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}

String _formatCompact(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}

String _formatNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}

String _maskAddress(String address) {
  if (address.length < 18) return address;
  return '${address.substring(0, 10)}...${address.substring(address.length - 8)}';
}
