import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

const _depositBackground = AppColors.bg;
const _depositPanel = AppColors.surface;
const _depositPanel2 = AppColors.surface2;
const _depositPrimary = AppColors.primary;
const _depositGreen = AppColors.buy;
const _depositRed = AppColors.sell;

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc137_deposit_content');
  static const networkSelectorKey = Key('sc137_deposit_network_selector');
  static const copyAddressKey = Key('sc137_deposit_copy_address');
  static const refreshKey = Key('sc137_deposit_refresh');
  static Key networkKey(String id) => Key('sc137_deposit_network_$id');

  final String asset;
  final bool assetScoped;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  String? _selectedNetworkId;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      walletDepositControllerProvider((
        asset: widget.asset,
        assetScoped: widget.assetScoped,
      )),
    );
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
          ? 'SC-138 DepositPage Asset'
          : 'SC-137 DepositPage',
      child: Material(
        color: _depositBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Nạp ${snapshot.asset}',
              subtitle: 'Nạp tiền · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DepositPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NetworkSelector(
                      asset: snapshot.asset,
                      selected: selected,
                      onTap: () => _openNetworkPicker(snapshot.networks),
                    ),
                    const SizedBox(height: 24),
                    _WarningCard(asset: snapshot.asset, network: selected),
                    const SizedBox(height: 16),
                    _QrAddressCard(
                      asset: snapshot.asset,
                      network: selected,
                      copied: _copied,
                      onCopy: () => _copyAddress(selected.address),
                    ),
                    const SizedBox(height: 16),
                    _DepositInfoCard(asset: snapshot.asset, network: selected),
                    const SizedBox(height: 16),
                    _RefreshButton(onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  WalletDepositNetwork _selectedNetwork(List<WalletDepositNetwork> networks) {
    final selectedId = _selectedNetworkId;
    if (selectedId != null) {
      for (final network in networks) {
        if (network.id == selectedId) return network;
      }
    }
    return networks.first;
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  void _openNetworkPicker(List<WalletDepositNetwork> networks) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _depositPanel,
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
                    selected:
                        network.id == _selectedNetworkId ||
                        (_selectedNetworkId == null &&
                            network.id == networks.first.id),
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
}

class _NetworkSelector extends StatelessWidget {
  const _NetworkSelector({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final WalletDepositNetwork selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn mạng lưới',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          key: DepositPage.networkSelectorKey,
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _depositPanel2,
              border: Border.all(color: _depositPrimary, width: 1.5),
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
                        selected.name,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Phí: ${selected.fee} · Nạp tối thiểu: ${_formatDeposit(selected.minDeposit)} $asset',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
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
                color: _depositGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  ${selected.arrivalTime}  ·  ${selected.confirmations} xác nhận',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final warningItems = [
      'Chỉ gửi $asset qua mạng ${network.name}',
      'Gửi sai mạng sẽ mất tiền vĩnh viễn, không thể khôi phục',
      'Nạp tối thiểu: ${_formatDeposit(network.minDeposit)} $asset',
      'Cần ${network.confirmations} xác nhận blockchain',
    ];

    return Container(
      constraints: const BoxConstraints(minHeight: 129),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _depositRed.withValues(alpha: .08),
        border: Border.all(color: _depositRed.withValues(alpha: .38)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _depositRed, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quan trọng — Đọc trước khi nạp',
                  style: AppTextStyles.body.copyWith(
                    color: _depositRed,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                for (final item in warningItems) ...[
                  Text(
                    '• $item',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.sell,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrAddressCard extends StatelessWidget {
  const _QrAddressCard({
    required this.asset,
    required this.network,
    required this.copied,
    required this.onCopy,
  });

  final String asset;
  final WalletDepositNetwork network;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _depositPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _QrCode(address: network.address),
          const SizedBox(height: 17),
          Text(
            'Địa chỉ $asset (${network.name.split(' ').first})',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            network.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 19),
          GestureDetector(
            key: DepositPage.copyAddressKey,
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: copied
                    ? _depositGreen.withValues(alpha: .15)
                    : _depositPrimary.withValues(alpha: .18),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    copied ? Icons.check_circle_outline : Icons.copy_rounded,
                    color: copied ? _depositGreen : _depositPrimary,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      copied ? 'Đã sao chép địa chỉ!' : 'Sao chép địa chỉ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: copied ? _depositGreen : _depositPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
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

class _QrCode extends StatelessWidget {
  const _QrCode({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.onAccent,
        borderRadius: AppRadii.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicIslandBg.withValues(alpha: .32),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(painter: _QrPainter(address)),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter(this.address);

  final String address;

  @override
  void paint(Canvas canvas, Size size) {
    final seed = address.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final cell = size.width / 21;
    final fill = Paint()..color = AppColors.qrDark;
    final stroke = Paint()
      ..color = AppColors.qrDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(.5, cell * .08);

    for (var row = 0; row < 21; row++) {
      for (var col = 0; col < 21; col++) {
        final finder =
            (row < 7 && col < 7) ||
            (row < 7 && col > 13) ||
            (row > 13 && col < 7);
        final filled = finder || ((seed * (row + 1) * (col + 1)) % 7) < 3;
        if (!filled) continue;
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell, cell),
          fill,
        );
      }
    }

    void finder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 7, cell * 7), stroke);
      canvas.drawRect(
        Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
        stroke,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        fill,
      );
    }

    finder(0, 0);
    finder(cell * 14, 0);
    finder(0, cell * 14);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.address != address;
}

class _DepositInfoCard extends StatelessWidget {
  const _DepositInfoCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Thời gian xử lý', network.arrivalTime),
      ('Xác nhận cần thiết', '${network.confirmations} blocks'),
      ('Phí nạp', network.fee),
      ('Nạp tối thiểu', '${_formatDeposit(network.minDeposit)} $asset'),
      ('Nạp nhỏ hơn tối thiểu', 'Không được ghi nhận'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _depositPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin nạp tiền',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 19),
          for (var i = 0; i < rows.length; i++) ...[
            _InfoRow(label: rows[i].$1, value: rows[i].$2),
            if (i != rows.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 14,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DepositPage.refreshKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        decoration: BoxDecoration(
          color: _depositPanel2,
          border: Border.all(color: _depositPrimary.withValues(alpha: .26)),
          borderRadius: AppRadii.mdRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh_rounded, color: AppColors.text2, size: 15),
            const SizedBox(width: 8),
            Text(
              'Làm mới địa chỉ nạp',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
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

  final WalletDepositNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DepositPage.networkKey(network.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: selected
              ? _depositPrimary.withValues(alpha: .10)
              : AppColors.transparent,
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
                    'Phí: ${network.fee} · ${network.arrivalTime} · ${network.confirmations} xác nhận',
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
                color: _depositPrimary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

String _formatDeposit(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}
