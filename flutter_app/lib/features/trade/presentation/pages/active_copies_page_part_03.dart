part of 'active_copies_page.dart';

class _RiskAlert extends StatelessWidget {
  const _RiskAlert({required this.onViewDetails});

  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Cảnh báo rủi ro',
      message:
          'Một copy đang lỗ >5%. Xem xét dừng copy hoặc điều chỉnh stop-loss.',
      contractId: 'Active copy risk alert',
    );
  }
}

class _ActionStatusBanner extends StatelessWidget {
  const _ActionStatusBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'Copy action recorded',
      message: text,
      contractId: 'Active copy action',
    );
  }
}

class _StopCopyModal extends StatefulWidget {
  const _StopCopyModal({
    required this.copy,
    required this.confirmText,
    required this.onTextChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  final TradeActiveCopy copy;
  final String confirmText;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  State<_StopCopyModal> createState() => _StopCopyModalState();
}

class _StopCopyModalState extends State<_StopCopyModal> {
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController(text: widget.confirmText);
  }

  @override
  void didUpdateWidget(covariant _StopCopyModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.confirmText != oldWidget.confirmText &&
        widget.confirmText != _confirmController.text) {
      _confirmController.text = widget.confirmText;
    }
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = widget.confirmText.toLowerCase() == 'stop';

    return Positioned.fill(
      child: Material(
        color: AppColors.dynamicIslandBg.withValues(alpha: .54),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.sell10,
                        borderRadius: AppRadii.inputRadius,
                      ),
                      child: const Icon(
                        Icons.stop_rounded,
                        color: AppColors.sell,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dừng copy?',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontSize: 16,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            widget.copy.providerName,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.sell10,
                    border: Border.all(color: AppColors.sell20),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    'Cảnh báo: khi dừng copy, các vị thế đang mở có thể được đóng. Hành động này cần xác nhận rõ ràng.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nhập STOP để xác nhận',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                VitInput(
                  controller: _confirmController,
                  fieldKey: ActiveCopiesPage.stopConfirmInputKey,
                  hintText: 'STOP',
                  textInputAction: TextInputAction.done,
                  onChanged: widget.onTextChanged,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(label: 'Hủy', onTap: widget.onCancel),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SheetButton(
                        key: ActiveCopiesPage.stopConfirmButtonKey,
                        label: 'Dừng copy',
                        onTap: canConfirm ? widget.onConfirm : null,
                        danger: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: danger
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.inputHeight,
      child: Text(label),
    );
  }
}

final class _StatusStyle {
  const _StatusStyle({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

_StatusStyle _statusStyle(TradeActiveCopyStatus status) {
  return switch (status) {
    TradeActiveCopyStatus.active => const _StatusStyle(
      label: 'Đang chạy',
      color: AppColors.buy,
      background: _lightBuyBackground,
    ),
    TradeActiveCopyStatus.coolingOff => const _StatusStyle(
      label: 'Chờ kích hoạt',
      color: AppColors.caution,
      background: _lightWarnBackground,
    ),
    TradeActiveCopyStatus.paused => const _StatusStyle(
      label: 'Tạm dừng',
      color: AppColors.text3,
      background: AppColors.surfaceNeutralLight,
    ),
    TradeActiveCopyStatus.stopped => const _StatusStyle(
      label: 'Đã dừng',
      color: AppColors.sell,
      background: _lightSellBackground,
    ),
  };
}

String _copyModeLabel(TradeActiveCopy copy) {
  return switch (copy.copyMode) {
    TradeActiveCopyMode.mirror => 'Mirror',
    TradeActiveCopyMode.fixed => 'Fixed ${copy.copyRatio?.toStringAsFixed(0)}%',
    TradeActiveCopyMode.smart => 'Smart',
  };
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(0)}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatUsd(value.abs())}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}
