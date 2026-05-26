import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

enum _P2POrderUiStep { payment, confirm }

class P2POrderPage extends ConsumerStatefulWidget {
  const P2POrderPage({super.key, required this.orderId, this.shellRenderMode});

  static const contentKey = Key('sc216_p2p_order_content');
  static const markPaidKey = Key('sc216_p2p_order_mark_paid');
  static const cancelKey = Key('sc216_p2p_order_cancel');
  static const proofKey = Key('sc216_p2p_order_proof');
  static const chatKey = Key('sc216_p2p_order_chat');
  static const copyAllKey = Key('sc216_p2p_order_copy_all');
  static const escrowKey = Key('sc216_p2p_order_escrow');
  static const qrToggleKey = Key('sc216_p2p_order_qr_toggle');

  static Key copyKey(String id) => Key('sc216_p2p_order_copy_$id');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderPage> createState() => _P2POrderPageState();
}

class _P2POrderPageState extends ConsumerState<P2POrderPage> {
  _P2POrderUiStep _step = _P2POrderUiStep.payment;
  String? _copiedField;
  bool _showQr = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getOrder(widget.orderId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final order = snapshot.order;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-216 P2POrderPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết đơn hàng',
              subtitle: 'Đơn hàng - P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            _StatusBanner(
              label: _step == _P2POrderUiStep.payment
                  ? order.statusLabel
                  : 'Đã thanh toán - Chờ xác nhận',
              countdown: _step == _P2POrderUiStep.payment
                  ? order.countdownLabel
                  : '29:59',
              color: _step == _P2POrderUiStep.payment
                  ? AppColors.warn
                  : AppColors.primary,
            ),
            _OrderStepper(step: _step),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2POrderPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: AppSpacing.contentPad,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SafetyBanner(
                        title: snapshot.safetyTitle,
                        bullets: snapshot.safetyBullets,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowBanner(
                        order: order,
                        onTap: () =>
                            context.go(AppRoutePaths.p2pEscrow(order.id)),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderInfoCard(order: order),
                      if (_step == _P2POrderUiStep.payment) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _PaymentInfoCard(
                          order: order,
                          fields: snapshot.paymentFields,
                          showQr: _showQr,
                          copiedField: _copiedField,
                          warningTitle: snapshot.transferWarningTitle,
                          warning: snapshot.transferWarning,
                          onToggleQr: () {
                            HapticFeedback.selectionClick();
                            setState(() => _showQr = !_showQr);
                          },
                          onCopyAll: () => _markCopied('all'),
                          onCopy: _markCopied,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _ProofCard(
                        step: _step,
                        onUpload: () =>
                            context.go(AppRoutePaths.p2pOrderProof(order.id)),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _TimelineCard(timeline: snapshot.timeline),
                      const SizedBox(height: AppSpacing.x4),
                      _PaymentWarning(message: snapshot.paymentWarning),
                      const SizedBox(height: AppSpacing.x4),
                      _PrimaryActions(
                        step: _step,
                        onChat: () =>
                            context.go(AppRoutePaths.p2pChat(order.id)),
                        onPaid: _markPaid,
                      ),
                      if (_step == _P2POrderUiStep.payment) ...[
                        const SizedBox(height: AppSpacing.x3),
                        _TextActionButton(
                          key: P2POrderPage.cancelKey,
                          onPressed: () => context.go(
                            AppRoutePaths.p2pOrderCancel(order.id),
                          ),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: 'Hủy đơn hàng',
                          color: AppColors.sell,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _QuickActions(actions: snapshot.quickActions),
                      const SizedBox(height: AppSpacing.x5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markCopied(String field) {
    HapticFeedback.selectionClick();
    setState(() => _copiedField = field);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _copiedField != field) return;
      setState(() => _copiedField = null);
    });
  }

  void _markPaid() {
    HapticFeedback.mediumImpact();
    setState(() => _step = _P2POrderUiStep.confirm);
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.label,
    required this.countdown,
    required this.color,
  });

  final String label;
  final String countdown;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border(bottom: BorderSide(color: color.withValues(alpha: .15))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            countdown,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.step});

  final _P2POrderUiStep step;

  @override
  Widget build(BuildContext context) {
    final activeIndex = step == _P2POrderUiStep.payment ? 1 : 2;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < 3; index++) ...[
            Expanded(
              child: _StepperNode(
                index: index,
                label: const ['Đặt lệnh', 'Thanh toán', 'Nhận tiền'][index],
                activeIndex: activeIndex,
              ),
            ),
            if (index < 2)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x3 + 2),
                  child: Container(
                    height: 2,
                    color: index < activeIndex - 1
                        ? AppModuleAccents.p2p
                        : AppColors.borderSolid,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepperNode extends StatelessWidget {
  const _StepperNode({
    required this.index,
    required this.label,
    required this.activeIndex,
  });

  final int index;
  final String label;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < activeIndex;
    return Column(
      children: [
        Container(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          decoration: BoxDecoration(
            color: isCompleted ? AppModuleAccents.p2p : AppColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppModuleAccents.p2p : AppColors.borderSolid,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: AppSpacing.iconSm,
                  )
                : Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: isCompleted ? AppModuleAccents.p2p : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner({required this.title, required this.bullets});

  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: const BoxDecoration(
              color: AppColors.sell10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final item in bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Text(
                      item,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        height: 1.35,
                      ),
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

class _EscrowBanner extends StatelessWidget {
  const _EscrowBanner({required this.order, required this.onTap});

  final P2POrderDetailDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        key: P2POrderPage.escrowKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.buy20),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escrow: ${_formatCrypto(order.escrowAmount)} ${order.asset} đã khóa',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tài sản được bảo vệ cho đến khi xác nhận thanh toán',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Chi tiết',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
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
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đơn hàng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(
                icon: Icons.copy_rounded,
                label: order.orderNumber,
                color: AppColors.text2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _InfoLine(
            label: 'Giao dịch',
            value:
                '${order.typeLabel} ${_formatCrypto(order.amount)} ${order.asset}',
            emphasis: true,
          ),
          _InfoLine(
            label: 'Giá',
            value: '${_formatVnd(order.priceVnd)} VND/${order.asset}',
          ),
          _InfoLine(
            label: 'Cần thanh toán',
            value: '${_formatVnd(order.totalVnd)} ${order.currency}',
            emphasis: true,
          ),
          _InfoLine(label: 'Thanh toán qua', value: order.paymentMethod),
          _InfoLine(label: 'Người bán', value: order.merchant),
          _InfoLine(label: 'Phí', value: order.feeLabel, isLast: true),
        ],
      ),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({
    required this.order,
    required this.fields,
    required this.showQr,
    required this.copiedField,
    required this.warningTitle,
    required this.warning,
    required this.onToggleQr,
    required this.onCopyAll,
    required this.onCopy,
  });

  final P2POrderDetailDraft order;
  final List<P2POrderPaymentFieldDraft> fields;
  final bool showQr;
  final String? copiedField;
  final String warningTitle;
  final String warning;
  final VoidCallback onToggleQr;
  final VoidCallback onCopyAll;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Thông tin chuyển khoản',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _CopyButton(
                key: P2POrderPage.copyAllKey,
                label: copiedField == 'all' ? 'Đã copy!' : 'Copy tất cả',
                copied: copiedField == 'all',
                onPressed: onCopyAll,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          InkWell(
            key: P2POrderPage.qrToggleKey,
            onTap: onToggleQr,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Mã QR chuyển khoản',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    showQr ? 'Thu gọn' : 'Hiển thị',
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showQr) ...[
            const SizedBox(height: AppSpacing.x3),
            _QrPanel(order: order),
            const SizedBox(height: AppSpacing.x4),
          ],
          for (final field in fields)
            _PaymentFieldLine(
              field: field,
              copied: copiedField == field.id,
              onCopy: () => onCopy(field.id),
            ),
          const SizedBox(height: AppSpacing.x3),
          _InlineWarning(title: warningTitle, message: warning),
        ],
      ),
    );
  }
}

class _QrPanel extends StatelessWidget {
  const _QrPanel({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadii.mdRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x2),
                child: CustomPaint(
                  painter: _QrPatternPainter(
                    data:
                        '${order.bankName}|${order.accountNumber}|${order.accountName}|${order.totalVnd}|${order.transferContent}',
                  ),
                  size: const Size(140, 140),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Quét mã bằng app ngân hàng',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '${order.bankName} - ${order.accountName}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x3),
            _SmallPill(
              icon: Icons.open_in_new_rounded,
              label: 'Mở app ngân hàng',
              color: AppModuleAccents.p2p,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentFieldLine extends StatelessWidget {
  const _PaymentFieldLine({
    required this.field,
    required this.copied,
    required this.onCopy,
  });

  final P2POrderPaymentFieldDraft field;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  field.value,
                  style:
                      (field.emphasis
                              ? AppTextStyles.caption
                              : AppTextStyles.micro)
                          .copyWith(
                            color: AppColors.text1,
                            fontWeight: field.emphasis
                                ? AppTextStyles.bold
                                : AppTextStyles.medium,
                            fontFeatures: field.monospace
                                ? AppTextStyles.tabularFigures
                                : null,
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _CopyButton(
            key: P2POrderPage.copyKey(field.id),
            label: copied ? 'Đã copy' : 'Copy',
            copied: copied,
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}

class _ProofCard extends StatelessWidget {
  const _ProofCard({required this.step, required this.onUpload});

  final _P2POrderUiStep step;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.upload_file_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Bằng chứng thanh toán',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (step == _P2POrderUiStep.payment)
                _SmallButton(
                  key: P2POrderPage.proofKey,
                  icon: Icons.upload_outlined,
                  label: 'Tải lên',
                  color: AppModuleAccents.p2p,
                  onPressed: onUpload,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            step == _P2POrderUiStep.payment
                ? 'Tải ảnh chụp giao dịch ngân hàng trước khi xác nhận thanh toán'
                : 'Đang chờ merchant xác nhận',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<P2POrderTimelineStepDraft> timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiến trình giao dịch',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < timeline.length; index++)
            _TimelineItem(
              item: timeline[index],
              isLast: index == timeline.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final P2POrderTimelineStepDraft item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _stepColor(item.status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: AppSpacing.x6,
              height: AppSpacing.x6,
              decoration: BoxDecoration(
                color: _stepBackground(item.status),
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
              child: Icon(_timelineIcon(item.iconKey), color: color, size: 15),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: AppSpacing.x6,
                color: color.withValues(alpha: .35),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: item.status == P2POrderStepStatus.pending
                              ? AppColors.text3
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    item.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentWarning extends StatelessWidget {
  const _PaymentWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.sell,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({
    required this.step,
    required this.onChat,
    required this.onPaid,
  });

  final _P2POrderUiStep step;
  final VoidCallback onChat;
  final VoidCallback onPaid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderPage.chatKey,
            onPressed: onChat,
            variant: VitCtaButtonVariant.ghost,
            leading: const Icon(Icons.chat_bubble_outline_rounded),
            child: const Text('Nhắn tin'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2POrderPage.markPaidKey,
            onPressed: step == _P2POrderUiStep.payment ? onPaid : null,
            variant: VitCtaButtonVariant.success,
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: Text(
              step == _P2POrderUiStep.payment
                  ? 'Đã thanh toán'
                  : 'Chờ xác nhận',
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.actions});

  final List<P2POrderQuickActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HÀNH ĐỘNG NHANH',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                Expanded(child: _QuickActionButton(action: actions[index])),
                if (index < actions.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.action});

  final P2POrderQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _quickActionColor(action.id);
    return Material(
      color: color.withValues(alpha: .08),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: () => context.go(action.route),
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.buttonCompact,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: .18)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_quickActionIcon(action.iconKey), color: color, size: 12),
              const SizedBox(width: AppSpacing.x1),
              Flexible(
                child: Text(
                  action.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    this.emphasis = false,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool emphasis;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: emphasis
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
                fontFeatures: emphasis ? AppTextStyles.tabularFigures : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.buttonCompact,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextActionButton extends StatelessWidget {
  const _TextActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: color, size: AppSpacing.iconSm),
                child: icon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.label,
    required this.copied,
    required this.onPressed,
  });

  final String label;
  final bool copied;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _SmallButton(
      icon: copied ? Icons.check_rounded : Icons.copy_rounded,
      label: label,
      color: copied ? AppColors.buy : AppModuleAccents.p2p,
      onPressed: onPressed,
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    message,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  const _QrPatternPainter({required this.data});

  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = Colors.white;
    final foreground = Paint()..color = AppColors.surface;
    final cell = size.width / 21;
    canvas.drawRect(Offset.zero & size, background);

    void drawFinder(int row, int col) {
      final origin = Offset(col * cell, row * cell);
      canvas.drawRect(origin & Size(cell * 7, cell * 7), foreground);
      canvas.drawRect(
        origin + Offset(cell, cell) & Size(cell * 5, cell * 5),
        background,
      );
      canvas.drawRect(
        origin + Offset(cell * 2, cell * 2) & Size(cell * 3, cell * 3),
        foreground,
      );
    }

    drawFinder(0, 0);
    drawFinder(0, 14);
    drawFinder(14, 0);

    final seed = data.codeUnits.fold<int>(0, (sum, code) => sum + code);
    for (var row = 0; row < 21; row++) {
      for (var col = 0; col < 21; col++) {
        final inFinder =
            (row < 7 && col < 7) ||
            (row < 7 && col >= 14) ||
            (row >= 14 && col < 7);
        if (inFinder) continue;
        final hash = (seed * (row * 21 + col + 1) * 31) % 100;
        if (hash < 42) {
          canvas.drawRect(
            Offset(col * cell, row * cell) & Size(cell, cell),
            foreground,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPatternPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

IconData _timelineIcon(String iconKey) {
  return switch (iconKey) {
    'created' => Icons.receipt_long_outlined,
    'payment' => Icons.schedule_rounded,
    'confirm' => Icons.shield_outlined,
    'release' => Icons.lock_outline_rounded,
    _ => Icons.circle_outlined,
  };
}

Color _stepColor(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy,
    P2POrderStepStatus.active => AppModuleAccents.p2p,
    P2POrderStepStatus.pending => AppColors.text3,
  };
}

Color _stepBackground(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy10,
    P2POrderStepStatus.active => AppColors.warn10,
    P2POrderStepStatus.pending => AppColors.surface2,
  };
}

IconData _quickActionIcon(String iconKey) {
  return switch (iconKey) {
    'merchant' => Icons.groups_outlined,
    'block' => Icons.person_off_outlined,
    'guide' => Icons.menu_book_outlined,
    'support' => Icons.help_outline_rounded,
    _ => Icons.chevron_right_rounded,
  };
}

Color _quickActionColor(String id) {
  return switch (id) {
    'block' => AppColors.sell,
    'guide' => AppColors.accent,
    'support' => AppColors.buy,
    _ => AppColors.text2,
  };
}

String _formatCrypto(double value) => value.toStringAsFixed(4);

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
