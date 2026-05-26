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
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _tradePrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _footerBackground = AppColors.surface;

class OrderReceiptPage extends ConsumerStatefulWidget {
  const OrderReceiptPage({super.key, this.shellRenderMode});

  static const openOrdersKey = Key('sc051_open_orders');
  static const copyOrderIdKey = Key('sc051_copy_order_id');
  static const shareKey = Key('sc051_share');
  static const continueTradingKey = Key('sc051_continue_trading');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<OrderReceiptPage> createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends ConsumerState<OrderReceiptPage> {
  bool _sharePressed = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getOrderReceipt();
    final receipt = snapshot.receipt;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-051 OrderReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết lệnh',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SuccessHero(receipt: receipt),
                    _ReceiptCard(receipt: receipt),
                    const SizedBox(height: 28),
                    _WarningNotice(),
                  ],
                ),
              ),
            ),
            _ReceiptFooter(
              sharePressed: _sharePressed,
              onShare: () => setState(() => _sharePressed = true),
              onContinue: () => context.go(AppRoutePaths.tradePair('btcusdt')),
            ),
            SizedBox(height: bottomChrome),
          ],
        ),
      ),
    );
  }
}

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 34, 40, 38),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.buy.withValues(alpha: .08),
                  blurRadius: 0,
                  spreadRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: 34,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Đặt lệnh thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 18,
              height: 1.18,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lệnh $sideLabel ${receipt.symbol} đang được xử lý',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF98A2B3),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == TradeOrderSide.buy;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SideBadge(label: isBuy ? 'MUA' : 'BÁN', color: sideColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  receipt.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusBadge(
                key: OrderReceiptPage.openOrdersKey,
                status: receipt.status,
                onTap: () => context.go(AppRoutePaths.tradeOrdersHistory),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 13),
          _DetailRow(
            label: 'Order ID',
            value: receipt.orderId,
            trailing: _CopyOrderIdButton(orderId: receipt.orderId),
          ),
          _DetailRow(label: 'Loại lệnh', value: receipt.orderType),
          _DetailRow(label: 'Giá', value: '\$${_formatMoney(receipt.price)}'),
          _DetailRow(
            label: 'Khối lượng',
            value: '${_formatAmount(receipt.amount)} ${receipt.baseAsset}',
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 9),
          _DetailRow(
            label: 'Thành tiền',
            value: '\$${_formatMoney(receipt.total)}',
            highlight: true,
          ),
          _DetailRow(
            label: 'Phí giao dịch',
            value: '\$${receipt.fee.toStringAsFixed(4)} (${receipt.feeRate})',
          ),
          if (receipt.estimatedFill != null)
            _DetailRow(
              label: 'Thời gian ước tính',
              value: receipt.estimatedFill!,
            ),
          _DetailRow(label: 'Thời gian đặt', value: receipt.timestamp),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 13),
          Text(
            'Quản lý rủi ro',
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF98A2B3),
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              if (receipt.tpPrice != null)
                Expanded(
                  child: _RiskBox(
                    label: 'Take Profit',
                    value: _formatPrice(receipt.tpPrice!),
                    color: AppColors.buy,
                  ),
                ),
              if (receipt.tpPrice != null && receipt.slPrice != null)
                const SizedBox(width: 12),
              if (receipt.slPrice != null)
                Expanded(
                  child: _RiskBox(
                    label: 'Stop Loss',
                    value: _formatPrice(receipt.slPrice!),
                    color: AppColors.sell,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideBadge extends StatelessWidget {
  const _SideBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({super.key, required this.status, required this.onTap});

  final TradeReceiptStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      TradeReceiptStatus.submitted => 'Đã gửi',
      TradeReceiptStatus.pending => 'Đang xử lý',
      TradeReceiptStatus.partiallyFilled => 'Khớp 1 phần',
    };

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: _tradePrimary.withValues(alpha: .08),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule_rounded, color: _tradePrimary, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: _tradePrimary,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.trailing,
  });

  final String label;
  final String value;
  final bool highlight;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: highlight
                          ? AppColors.text1
                          : const Color(0xFFA9B1C6),
                      fontSize: highlight ? 14 : 11.5,
                      fontWeight: highlight
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      fontFamily: 'monospace',
                      height: 1.1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 4), trailing!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyOrderIdButton extends StatelessWidget {
  const _CopyOrderIdButton({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: IconButton(
        key: OrderReceiptPage.copyOrderIdKey,
        padding: EdgeInsets.zero,
        onPressed: () => Clipboard.setData(ClipboardData(text: orderId)),
        icon: const Icon(Icons.copy_rounded, size: 12, color: AppColors.text3),
      ),
    );
  }
}

class _RiskBox extends StatelessWidget {
  const _RiskBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 14,
              fontFamily: 'monospace',
              fontWeight: AppTextStyles.bold,
              height: 1.1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .06),
        border: Border.all(color: AppColors.warn.withValues(alpha: .22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Lệnh có thể bị khớp 1 phần hoặc hủy nếu giá thay đổi nhanh. '
              'Kiểm tra trạng thái tại Lệnh đang mở.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontSize: 11,
                height: 1.45,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptFooter extends StatelessWidget {
  const _ReceiptFooter({
    required this.sharePressed,
    required this.onShare,
    required this.onContinue,
  });

  final bool sharePressed;
  final VoidCallback onShare;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _footerBackground,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 16, 40, 8),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  key: OrderReceiptPage.shareKey,
                  onPressed: onShare,
                  icon: Icon(
                    Icons.share_rounded,
                    color: sharePressed
                        ? const Color(0xFFC8D2E8)
                        : const Color(0xFF98A2B3),
                    size: 16,
                  ),
                  label: Text(sharePressed ? 'Đã chia sẻ' : 'Chia sẻ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF98A2B3),
                    side: const BorderSide(color: AppColors.borderSolid),
                    backgroundColor: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                    textStyle: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: AppSpacing.inputHeight,
                child: ElevatedButton(
                  key: OrderReceiptPage.continueTradingKey,
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.buy,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                    textStyle: AppTextStyles.baseMedium.copyWith(
                      fontSize: 16,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  child: const Text('Tiếp tục giao dịch'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatPrice(double value) {
  final text = _formatMoney(value);
  return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
}

String _formatAmount(double value) => value.toStringAsFixed(6);
