part of '../pages/p2p_my_orders_page.dart';

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _StatMeta {
  const _StatMeta(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

final class _StatusMeta {
  const _StatusMeta(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

_StatusMeta _statusMeta(String status) {
  return switch (status) {
    'pending_payment' => const _StatusMeta(
      'Chờ thanh toán',
      AppModuleAccents.p2p,
      Icons.schedule_rounded,
    ),
    'paid' => const _StatusMeta(
      'Đã thanh toán',
      AppColors.primary,
      Icons.schedule_rounded,
    ),
    'released' => const _StatusMeta(
      'Hoàn tất',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    'cancelled' => const _StatusMeta(
      'Đã hủy',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    'disputed' => const _StatusMeta(
      'Tranh chấp',
      AppColors.sell,
      Icons.report_problem_outlined,
    ),
    _ => const _StatusMeta('Hết hạn', AppColors.text3, Icons.schedule_rounded),
  };
}

String _formatCrypto(double value) => value.toStringAsFixed(4);

String _formatVnd(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatCompactVnd(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)}M';
  }
  return _formatVnd(value);
}

String _formatDateTime(String value) {
  if (value.length < 16) return value;
  return '${value.substring(5, 10)} ${value.substring(11, 16)}';
}
