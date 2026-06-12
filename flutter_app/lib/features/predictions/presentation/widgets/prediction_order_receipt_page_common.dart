part of '../pages/prediction_order_receipt_page.dart';

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
      padding: AppSpacing.predictionReceiptSummaryRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
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
                  const SizedBox(
                    width: AppSpacing.predictionReceiptSummaryTrailingGap,
                  ),
                  Icon(
                    trailingIcon,
                    color: valueColor,
                    size: AppSpacing.predictionReceiptSummaryTrailingIcon,
                  ),
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
      padding: const EdgeInsets.only(
        top: AppSpacing.predictionReceiptFillDividerGap,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.predictionReceiptFillDividerGap,
          ),
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
              const SizedBox(height: AppSpacing.predictionReceiptFillBarGap),
              ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: AppSpacing.predictionReceiptFillBarHeight,
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
                width: AppSpacing.predictionReceiptTimelineDot,
                height: AppSpacing.predictionReceiptTimelineDot,
                decoration: BoxDecoration(
                  color: step.done ? AppColors.buy15 : AppColors.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.done ? AppColors.buy : AppColors.borderSolid,
                  ),
                ),
                child: Icon(
                  step.done ? Icons.check_rounded : Icons.schedule_rounded,
                  size: AppSpacing.predictionReceiptTimelineIcon,
                  color: color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: AppSpacing.predictionReceiptTimelineLineWidth,
                    margin: AppSpacing.predictionReceiptTimelineLineMargin,
                    color: AppColors.borderSolid,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.predictionReceiptTimelineGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast
                    ? 0
                    : AppSpacing.predictionReceiptTimelineItemBottomGap,
              ),
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
      height: AppSpacing.predictionReceiptSoftPillHeight,
      padding: AppSpacing.predictionReceiptSoftPillPadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

_ReceiptStatus _statusConfig(String status) {
  switch (status) {
    case 'submitted':
      return _ReceiptStatus(
        label: 'Đã gửi',
        color: AppColors.text2,
        background: AppColors.medalSilverBlue.withValues(alpha: .12),
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
