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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2POrderCancelPage extends ConsumerStatefulWidget {
  const P2POrderCancelPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc214_p2p_order_cancel_content');
  static const confirmKey = Key('sc214_p2p_order_cancel_confirm');
  static const backKey = Key('sc214_p2p_order_cancel_back');

  static Key reasonKey(String reason) => Key('sc214_p2p_cancel_$reason');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderCancelPage> createState() => _P2POrderCancelPageState();
}

class _P2POrderCancelPageState extends ConsumerState<P2POrderCancelPage> {
  String _cancelReason = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pOrderCancelProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-214 P2POrderCancelPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Hủy đơn hàng',
              subtitle: 'Đơn hàng - P2P',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2POrderCancelPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: AppSpacing.x6,
                    children: [
                      const _CancelHero(),
                      _OrderSummary(order: snapshot.order),
                      _ReasonSelector(
                        reasons: snapshot.reasons,
                        selectedReason: _cancelReason,
                        onSelected: _setReason,
                      ),
                      _CancelWarning(
                        title: snapshot.warningTitle,
                        message: snapshot.warningMessage,
                      ),
                      _ActionRow(
                        enabled: _cancelReason.isNotEmpty,
                        loading: _isSubmitting,
                        onBack: () => _close(context),
                        onConfirm: () =>
                            _confirmCancel(context, snapshot.order),
                      ),
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

  void _setReason(String reason) {
    HapticFeedback.selectionClick();
    setState(() => _cancelReason = reason);
  }

  Future<void> _confirmCancel(
    BuildContext context,
    P2POrderCancelDraft order,
  ) async {
    if (_cancelReason.isEmpty || _isSubmitting) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pOrder(order.id));
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.p2pOrder(widget.orderId));
  }
}

class _CancelHero extends StatelessWidget {
  const _CancelHero();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        children: [
          Container(
            width: AppSpacing.x7 + AppSpacing.x3,
            height: AppSpacing.x7 + AppSpacing.x3,
            decoration: BoxDecoration(
              color: AppColors.sell10,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconLg,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Hủy đơn hàng?',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              'Vui lòng chọn lý do hủy. Hủy đơn quá nhiều có thể ảnh hưởng đến uy tín.',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final P2POrderCancelDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _SummaryRowDraft(label: 'Mã đơn', value: order.orderNumber),
      _SummaryRowDraft(
        label: 'Giao dịch',
        value:
            '${order.typeLabel} ${_formatAmount(order.amount)} ${order.asset}',
      ),
      _SummaryRowDraft(
        label: 'Tổng tiền',
        value: '${_formatVnd(order.totalVnd)} ${order.currency}',
      ),
      _SummaryRowDraft(label: 'Merchant', value: order.merchant),
    ];
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THÔNG TIN ĐƠN HÀNG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var index = 0; index < rows.length; index++)
            _SummaryRow(row: rows[index], showDivider: index < rows.length - 1),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.row, required this.showDivider});

  final _SummaryRowDraft row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                row.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Flexible(
              child: Text(
                row.value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRowDraft {
  const _SummaryRowDraft({required this.label, required this.value});

  final String label;
  final String value;
}

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({
    required this.reasons,
    required this.selectedReason,
    required this.onSelected,
  });

  final List<String> reasons;
  final String selectedReason;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lý do hủy',
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final reason in reasons)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: _ReasonButton(
              reason: reason,
              selected: selectedReason == reason,
              onPressed: () => onSelected(reason),
            ),
          ),
      ],
    );
  }
}

class _ReasonButton extends StatelessWidget {
  const _ReasonButton({
    required this.reason,
    required this.selected,
    required this.onPressed,
  });

  final String reason;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.sell10 : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: P2POrderCancelPage.reasonKey(reason),
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.sell20 : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.x5,
                height: AppSpacing.x5,
                decoration: BoxDecoration(
                  color: selected ? AppColors.sell : AppColors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.sell : AppColors.borderSolid,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.onAccent,
                        size: AppSpacing.iconSm,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  reason,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.sell : AppColors.text2,
                    fontWeight: selected
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
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

class _CancelWarning extends StatelessWidget {
  const _CancelWarning({required this.title, required this.message});

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
                    style: AppTextStyles.micro.copyWith(color: AppColors.warn),
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

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.enabled,
    required this.loading,
    required this.onBack,
    required this.onConfirm,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderCancelPage.backKey,
            onPressed: onBack,
            variant: VitCtaButtonVariant.secondary,
            child: const Text('Quay lại'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2POrderCancelPage.confirmKey,
            onPressed: enabled ? onConfirm : null,
            loading: loading,
            variant: VitCtaButtonVariant.danger,
            child: const Text('Xác nhận hủy'),
          ),
        ),
      ],
    );
  }
}

String _formatAmount(double value) {
  return value.toStringAsFixed(4);
}

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
