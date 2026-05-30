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

const _detailBackground = AppColors.bg;
const _detailPanel = AppColors.surface;
const _detailPanel2 = AppColors.surface2;
const _detailPrimary = AppColors.primary;
const _detailGreen = AppColors.buy;
const _detailRed = AppColors.sell;
const _detailAmber = AppColors.caution;

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc141_transaction_detail_content');
  static const explorerKey = Key('sc141_transaction_detail_explorer');
  static const supportKey = Key('sc141_transaction_detail_support');
  static const copyTxIdKey = Key('sc141_transaction_detail_copy_txid');

  final String transactionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletTransactionDetailProvider(transactionId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-141 TransactionDetailPage',
      child: Material(
        color: _detailBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết giao dịch',
              subtitle: 'Lịch sử · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.walletHistory),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: snapshot.transaction == null
                    ? _MissingTransaction(
                        onBack: () => context.go(AppRoutePaths.walletHistory),
                      )
                    : _TransactionDetailContent(
                        tx: snapshot.transaction!,
                        onCopy: (value) => _copyValue(context, value),
                        onSupport: () => context.go('/support'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyValue(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép'),
        duration: Duration(milliseconds: 900),
      ),
    );
  }
}

class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent({
    required this.tx,
    required this.onCopy,
    required this.onSupport,
  });

  final WalletTransaction tx;
  final ValueChanged<String> onCopy;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final type = _DetailTypeMeta.from(tx);
    final status = _DetailStatusMeta.from(tx.status);
    final details = _detailsFor(tx, type.isDebit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryCard(tx: tx, type: type, status: status),
        const SizedBox(height: 16),
        _ProgressCard(tx: tx),
        const SizedBox(height: 16),
        _DetailsCard(rows: details, onCopy: onCopy),
        const SizedBox(height: 18),
        if (tx.txHash != null) ...[
          const _ExplorerButton(),
          const SizedBox(height: 12),
        ],
        _SupportButton(onTap: onSupport),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.tx,
    required this.type,
    required this.status,
  });

  final WalletTransaction tx;
  final _DetailTypeMeta type;
  final _DetailStatusMeta status;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: Icon(type.icon, color: AppColors.text1, size: 29),
          ),
          const SizedBox(height: 16),
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1,
            ),
          ),
          const SizedBox(height: 21),
          Text(
            '${type.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heroNumber.copyWith(
              color: type.color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 21),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: status.color.withValues(alpha: .28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, color: status.color, size: 15),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: AppTextStyles.caption.copyWith(
                    color: status.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStep('Tạo yêu cầu', tx.createdAt, done: true),
      _ProgressStep(
        'Đang xử lý',
        tx.status == WalletTransactionStatus.failed ? null : tx.createdAt,
        done: tx.status != WalletTransactionStatus.failed,
      ),
      _ProgressStep(
        tx.status == WalletTransactionStatus.completed
            ? 'Hoàn tất'
            : tx.status == WalletTransactionStatus.failed
            ? 'Thất bại'
            : 'Đang chờ...',
        tx.status == WalletTransactionStatus.completed ? tx.createdAt : null,
        done: tx.status == WalletTransactionStatus.completed,
        failed: tx.status == WalletTransactionStatus.failed,
      ),
    ];

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến trình',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 23),
          for (var i = 0; i < steps.length; i++)
            _ProgressRow(step: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.step, required this.isLast});

  final _ProgressStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.failed
        ? _detailRed
        : step.done
        ? _detailGreen
        : AppColors.borderSolid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: step.done ? _detailGreen : AppColors.borderSolid,
              ),
          ],
        ),
        const SizedBox(width: 13),
        Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: AppTextStyles.caption.copyWith(
                  color: step.done || step.failed
                      ? AppColors.text1
                      : AppColors.text3,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (step.time != null) ...[
                const SizedBox(height: 9),
                Text(
                  step.time!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.rows, required this.onCopy});

  final List<_DetailRowData> rows;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'Thông tin chi tiết',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          for (final row in rows)
            _DetailInfoRow(row: row, onCopy: () => onCopy(row.value)),
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({required this.row, required this.onCopy});

  final _DetailRowData row;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              row.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ),
          if (row.copyable) ...[
            const SizedBox(width: 10),
            GestureDetector(
              key: TransactionDetailPage.copyTxIdKey,
              onTap: onCopy,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: AppColors.hoverBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.text2,
                  size: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExplorerButton extends StatelessWidget {
  const _ExplorerButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: TransactionDetailPage.explorerKey,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _detailPanel2,
        border: Border.all(color: _detailPrimary.withValues(alpha: .28)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            color: _detailPrimary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Xem trên Explorer',
            style: AppTextStyles.caption.copyWith(
              color: _detailPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransactionDetailPage.supportKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _detailAmber.withValues(alpha: .08),
          border: Border.all(color: _detailAmber.withValues(alpha: .24)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: _detailAmber,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Liên hệ hỗ trợ',
              style: AppTextStyles.caption.copyWith(
                color: _detailAmber,
                fontSize: 14,
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

class _MissingTransaction extends StatelessWidget {
  const _MissingTransaction({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 56),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _detailPanel2,
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(Icons.error_outline_rounded, color: _detailRed),
        ),
        const SizedBox(height: 16),
        Text(
          'Không tìm thấy giao dịch',
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onBack,
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _detailPrimary,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              'Quay lại lịch sử',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _detailPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

final class _DetailTypeMeta {
  const _DetailTypeMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;

  factory _DetailTypeMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _DetailTypeMeta(
        label: 'Nạp tiền',
        color: _detailGreen,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
      ),
      WalletTransactionType.withdraw => const _DetailTypeMeta(
        label: 'Rút tiền',
        color: _detailRed,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
      ),
      WalletTransactionType.tradeBuy => const _DetailTypeMeta(
        label: 'Mua giao dịch',
        color: _detailGreen,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
      ),
      WalletTransactionType.tradeSell => const _DetailTypeMeta(
        label: 'Bán giao dịch',
        color: _detailRed,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
      ),
      WalletTransactionType.p2pBuy => const _DetailTypeMeta(
        label: 'P2P Mua',
        color: _detailGreen,
        icon: Icons.handshake_rounded,
        isDebit: false,
      ),
      WalletTransactionType.p2pSell => const _DetailTypeMeta(
        label: 'P2P Bán',
        color: _detailRed,
        icon: Icons.handshake_rounded,
        isDebit: true,
      ),
    };
  }
}

final class _DetailStatusMeta {
  const _DetailStatusMeta({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  factory _DetailStatusMeta.from(WalletTransactionStatus status) {
    return switch (status) {
      WalletTransactionStatus.completed => const _DetailStatusMeta(
        label: 'Hoàn thành',
        color: _detailGreen,
        icon: Icons.check_circle_outline_rounded,
      ),
      WalletTransactionStatus.pending => const _DetailStatusMeta(
        label: 'Đang xử lý',
        color: _detailAmber,
        icon: Icons.access_time_rounded,
      ),
      WalletTransactionStatus.failed => const _DetailStatusMeta(
        label: 'Thất bại',
        color: _detailRed,
        icon: Icons.cancel_outlined,
      ),
    };
  }
}

final class _ProgressStep {
  const _ProgressStep(
    this.label,
    this.time, {
    required this.done,
    this.failed = false,
  });

  final String label;
  final String? time;
  final bool done;
  final bool failed;
}

final class _DetailRowData {
  const _DetailRowData({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;
}

List<_DetailRowData> _detailsFor(WalletTransaction tx, bool isDebit) {
  final rows = <_DetailRowData>[];
  if (tx.txHash != null) {
    rows.add(
      _DetailRowData(
        label: 'Mã giao dịch (TxID)',
        value: tx.txHash!,
        copyable: true,
      ),
    );
  }
  if (tx.network != null) {
    rows.add(_DetailRowData(label: 'Mạng', value: tx.network!));
  }
  if (tx.address != null) {
    rows.add(
      _DetailRowData(
        label: isDebit ? 'Địa chỉ nhận' : 'Địa chỉ gửi',
        value: tx.address!,
        copyable: true,
      ),
    );
  }
  if (tx.fee != null && tx.fee! > 0) {
    rows.add(
      _DetailRowData(label: 'Phí giao dịch', value: _formatFee(tx.fee!)),
    );
  }
  rows.add(_DetailRowData(label: 'Thời gian', value: tx.createdAt));
  return rows;
}

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return _formatNumber(tx.amount, fractionDigits: 2);
}

String _formatFee(double value) => '\$${value.toStringAsFixed(2)}';

String _formatNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts[1]}';
}
