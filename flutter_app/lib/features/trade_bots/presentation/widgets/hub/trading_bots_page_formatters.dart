part of '../../pages/hub/trading_bots_page.dart';

(String, Color, Color) _riskStyle(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => (
      'Thấp',
      AppColors.buy.withValues(alpha: .12),
      AppColors.buy,
    ),
    TradeBotRisk.medium => (
      'Trung bình',
      AppColors.warn.withValues(alpha: .12),
      AppColors.warn,
    ),
    TradeBotRisk.high => (
      'Cao',
      AppColors.sell.withValues(alpha: .10),
      AppColors.sell,
    ),
  };
}

VitStatusPillStatus _riskStatus(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => VitStatusPillStatus.success,
    TradeBotRisk.medium => VitStatusPillStatus.warning,
    TradeBotRisk.high => VitStatusPillStatus.error,
  };
}

String _formatWholeNumber(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${value.abs().toStringAsFixed(2)}';
}
