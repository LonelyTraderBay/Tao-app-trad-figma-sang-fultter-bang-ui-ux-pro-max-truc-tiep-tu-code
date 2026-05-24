import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

class PredictionOrderReceiptPage extends ConsumerWidget {
  const PredictionOrderReceiptPage({
    super.key,
    required this.receiptId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc035_prediction_receipt_content');
  static const missingReceiptKey = Key('sc035_prediction_receipt_missing');
  static const shareKey = Key('sc035_share_receipt');
  static const viewEventKey = Key('sc035_view_event');
  static const viewPortfolioKey = Key('sc035_view_portfolio');

  final String receiptId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getOrderReceipt(receiptId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-035 PredictionOrderReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết lệnh',
              subtitle: 'Biên lai · Prediction',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.marketsPredictionsPortfolio),
            ),
            Expanded(
              child: snapshot.found
                  ? _ReceiptContent(
                      snapshot: snapshot,
                      bottomInset: bottomInset,
                    )
                  : _MissingReceipt(bottomInset: bottomInset),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingReceipt extends StatelessWidget {
  const _MissingReceipt({required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.missingReceiptKey,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: const VitEmptyState(
          title: 'Không tìm thấy',
          message: 'Lệnh không tồn tại hoặc đã bị xoá',
          icon: Icons.warning_amber_rounded,
        ),
      ),
    );
  }
}

class _ReceiptContent extends StatelessWidget {
  const _ReceiptContent({required this.snapshot, required this.bottomInset});

  final PredictionOrderReceiptSnapshot snapshot;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final receipt = snapshot.receipt!;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.contentKey,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: VitPageContent(
          padding: VitContentPadding.relaxed,
          customGap: 15,
          children: [
            _ReceiptHero(receipt: receipt),
            _OrderSummary(receipt: receipt),
            _TimelineCard(receipt: receipt),
            _TimestampCard(receipt: receipt),
            _ShareReceiptButton(receipt: receipt),
            const _DisclosureCard(),
            _ReceiptActions(receipt: receipt),
          ],
        ),
      ),
    );
  }
}

class _ReceiptHero extends StatelessWidget {
  const _ReceiptHero({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final status = _statusConfig(receipt.status);

    return VitCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _SoftPill(
                label: isBuy ? '↑ Buy' : '↓ Sell',
                color: isBuy ? AppColors.buy : AppColors.sell,
                background: isBuy ? AppColors.buy10 : AppColors.sell10,
              ),
              _SoftPill(
                label: status.label,
                color: status.color,
                background: status.background,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            receipt.outcome,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            receipt.eventTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final fillPct = receipt.shares <= 0
        ? 0
        : ((receipt.filledShares / receipt.shares) * 100).round();

    return VitPageSection(
      label: 'Tổng quan lệnh',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Loại lệnh',
                value: receipt.orderType == 'market' ? 'Market' : 'Limit',
              ),
              _SummaryRow(label: 'Outcome', value: receipt.outcome),
              _SummaryRow(
                label: 'Shares',
                value:
                    '${_formatShares(receipt.filledShares)}/${_formatShares(receipt.shares)}',
                mono: true,
              ),
              _SummaryRow(
                label: 'Giá đặt',
                value: _formatPrice(receipt.price),
                mono: true,
              ),
              if (receipt.avgPrice > 0)
                _SummaryRow(
                  label: 'Giá khớp TB',
                  value: _formatPrice(receipt.avgPrice),
                  mono: true,
                ),
              _SummaryRow(
                label: 'Tổng giá trị',
                value: _formatMoney(receipt.total),
                mono: true,
              ),
              _SummaryRow(
                label: 'Phí (2%)',
                value: _formatMoney(receipt.fee),
                mono: true,
              ),
              if (receipt.status != 'canceled' && receipt.status != 'rejected')
                _FillProgress(percent: fillPct),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final timeline = receipt.timeline.isEmpty
        ? [
            PredictionReceiptTimelineDraft(
              label: 'Lệnh đã gửi',
              date: receipt.createdAt,
              done: true,
            ),
          ]
        : receipt.timeline;

    return VitPageSection(
      label: 'Tiến trình',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (var i = 0; i < timeline.length; i++)
                _TimelineStep(
                  step: timeline[i],
                  isLast: i == timeline.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimestampCard extends StatelessWidget {
  const _TimestampCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SummaryRow(label: 'Tạo lúc', value: receipt.createdAt),
          _SummaryRow(label: 'Cập nhật', value: receipt.updatedAt),
          _SummaryRow(
            label: 'Mã lệnh',
            value: receipt.id.toUpperCase(),
            valueColor: AppColors.accent,
            mono: true,
            trailingIcon: Icons.copy_rounded,
          ),
        ],
      ),
    );
  }
}

class _ShareReceiptButton extends StatelessWidget {
  const _ShareReceiptButton({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Chia sẻ chi tiết lệnh ${receipt.id}',
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primary12,
            border: Border.all(color: AppColors.primary15, width: 1.5),
            borderRadius: AppRadii.inputRadius,
          ),
          child: InkWell(
            key: PredictionOrderReceiptPage.shareKey,
            onTap: () {},
            borderRadius: AppRadii.inputRadius,
            child: SizedBox(
              height: AppSpacing.inputHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.ios_share_rounded,
                    color: _predictionPrimary,
                    size: 17,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Chia sẻ chi tiết lệnh',
                    style: AppTextStyles.body.copyWith(
                      color: _predictionPrimary,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Probability không phải certainty. Giá thị trường dự đoán phản ánh ước lượng cộng đồng và có thể thay đổi bất cứ lúc nào. Đây không phải lời khuyên đầu tư.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptActions extends StatelessWidget {
  const _ReceiptActions({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewEventKey,
          onPressed: () =>
              context.go(AppRoutePaths.marketsPredictionEvent(receipt.eventId)),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xem sự kiện'),
        ),
        const SizedBox(height: 12),
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewPortfolioKey,
          onPressed: () => context.go(AppRoutePaths.profilePredictions),
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Xem danh mục'),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.mono = false,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool mono;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: valueColor,
                      fontWeight: AppTextStyles.medium,
                      fontFeatures: mono ? AppTextStyles.tabularFigures : null,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 5),
                  Icon(trailingIcon, color: valueColor, size: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FillProgress extends StatelessWidget {
  const _FillProgress({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Tiến trình khớp',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const Spacer(),
                  Text(
                    '$percent%',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 8,
                  color: percent == 100 ? AppColors.buy : AppColors.warn,
                  backgroundColor: AppColors.surface2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.step, required this.isLast});

  final PredictionReceiptTimelineDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.done ? AppColors.buy : AppColors.text3;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: step.done ? AppColors.buy15 : AppColors.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.done ? AppColors.buy : AppColors.borderSolid,
                  ),
                ),
                child: Icon(
                  step.done ? Icons.check_rounded : Icons.schedule_rounded,
                  size: 12,
                  color: color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    color: AppColors.borderSolid,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: AppTextStyles.caption.copyWith(
                      color: step.done ? AppColors.text1 : AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  if (step.date.isNotEmpty)
                    Text(
                      step.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
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

class _SoftPill extends StatelessWidget {
  const _SoftPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 13,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

_ReceiptStatus _statusConfig(String status) {
  switch (status) {
    case 'submitted':
      return const _ReceiptStatus(
        label: 'Đã gửi',
        color: AppColors.text2,
        background: Color(0x1F94A3B8),
      );
    case 'accepted':
      return const _ReceiptStatus(
        label: 'Đã tiếp nhận',
        color: _predictionPrimary,
        background: AppColors.primary12,
      );
    case 'partially_filled':
      return const _ReceiptStatus(
        label: 'Khớp một phần',
        color: AppColors.warn,
        background: AppColors.warn15,
      );
    case 'filled':
      return const _ReceiptStatus(
        label: 'Đã khớp',
        color: AppColors.buy,
        background: AppColors.buy15,
      );
    case 'canceled':
      return const _ReceiptStatus(
        label: 'Đã hủy',
        color: AppColors.text3,
        background: AppColors.surface2,
      );
    case 'rejected':
      return const _ReceiptStatus(
        label: 'Từ chối',
        color: AppColors.sell,
        background: AppColors.sell15,
      );
    default:
      return const _ReceiptStatus(
        label: 'Đang xử lý',
        color: AppColors.text2,
        background: AppColors.surface2,
      );
  }
}

class _ReceiptStatus {
  const _ReceiptStatus({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String _formatShares(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
