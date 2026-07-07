part of '../pages/risk_management_demo_page.dart';

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.variant,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VitCtaButtonVariant variant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: variant,
      height: _riskControlExtent,
      leading: Icon(icon),
      child: Text(label),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      width: size,
      height: size,
      alignment: Alignment.center,
      borderColor: color.withValues(alpha: .24),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _OcoSheet extends StatelessWidget {
  const _OcoSheet();

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'OCO Order Form',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetRow(label: 'Cặp', value: 'BTC/USDT'),
          const _SheetRow(label: 'Side', value: 'Buy'),
          const _SheetRow(label: 'Limit', value: '\$69,000'),
          const _SheetRow(label: 'Take Profit', value: '\$72,000'),
          const _SheetRow(label: 'Stop Loss', value: '\$66,000'),
          const SizedBox(height: _riskCardSpace),
          _GradientButton(
            key: RiskManagementDemoPage.ocoSubmitKey,
            label: 'Đặt lệnh OCO',
            icon: Icons.check_rounded,
            variant: VitCtaButtonVariant.success,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _CalculatorSheet extends StatelessWidget {
  const _CalculatorSheet({required this.result});

  final TradePositionSizeResult result;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Position Sizing Calculator',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetRow(
            label: 'Risk amount',
            value: '\$${_formatMoney(result.riskAmount)}',
          ),
          _SheetRow(
            label: 'Per-unit risk',
            value: '\$${_formatMoney(result.perUnitRisk)}',
          ),
          _SheetRow(
            label: 'Suggested amount',
            value: '${result.suggestedAmount.toStringAsFixed(6)} BTC',
          ),
          _SheetRow(
            label: 'Notional',
            value: '\$${_formatMoney(result.notional)}',
          ),
          const SizedBox(height: _riskCardSpace),
          _GradientButton(
            key: RiskManagementDemoPage.calculatorApplyKey,
            label: 'Áp dụng khối lượng',
            icon: Icons.check_rounded,
            variant: VitCtaButtonVariant.auth,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.tradeToolSheetRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: VitCard(
        variant: VitCardVariant.inner,
        padding: AppSpacing.tradeToolToastPadding,
        borderColor: AppColors.buy.withValues(alpha: .38),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: AppSpacing.tradeToolBodyIcon,
            ),
            const SizedBox(width: _riskSpace),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Dismiss risk action message',
              onPressed: onClose,
              size: VitIconButtonSize.sm,
              variant: VitIconButtonVariant.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _formatMoney(double value) {
  if (value >= 1000) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.first.length; i++) {
      final remaining = parts.first.length - i;
      buffer.write(parts.first[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }
  return value.toStringAsFixed(2);
}
