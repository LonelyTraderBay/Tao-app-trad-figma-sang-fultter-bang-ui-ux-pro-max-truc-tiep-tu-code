part of '../pages/risk_management_demo_page.dart';

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: AppRadii.inputRadius,
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .28),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 17),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 14,
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
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _OcoSheet extends StatelessWidget {
  const _OcoSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            Text(
              'OCO Order Form',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const _SheetRow(label: 'Cặp', value: 'BTC/USDT'),
            const _SheetRow(label: 'Side', value: 'Buy'),
            const _SheetRow(label: 'Limit', value: '\$69,000'),
            const _SheetRow(label: 'Take Profit', value: '\$72,000'),
            const _SheetRow(label: 'Stop Loss', value: '\$66,000'),
            const SizedBox(height: 16),
            _GradientButton(
              key: RiskManagementDemoPage.ocoSubmitKey,
              label: 'Đặt lệnh OCO',
              icon: Icons.check_rounded,
              colors: const [AppColors.buy, AppColors.buyDark],
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorSheet extends StatelessWidget {
  const _CalculatorSheet({required this.result});

  final TradePositionSizeResult result;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            Text(
              'Position Sizing Calculator',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 16),
            _GradientButton(
              key: RiskManagementDemoPage.calculatorApplyKey,
              label: 'Áp dụng khối lượng',
              icon: Icons.check_rounded,
              colors: const [AppColors.accent, AppColors.accentDark],
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.borderSolid,
          borderRadius: AppRadii.xsRadius,
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 7),
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
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buy10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy.withValues(alpha: .38)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicIslandBg.withValues(alpha: .22),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            InkWell(
              onTap: onClose,
              borderRadius: AppRadii.xsRadius,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text2,
                  size: 16,
                ),
              ),
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
