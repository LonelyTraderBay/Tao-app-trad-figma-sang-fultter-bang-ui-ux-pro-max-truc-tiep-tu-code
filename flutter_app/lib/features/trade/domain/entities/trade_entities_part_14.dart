part of 'trade_entities.dart';

final class TradeOrderReceipt {
  const TradeOrderReceipt({
    required this.orderId,
    required this.preview,
    required this.status,
  });

  final String orderId;
  final TradeOrderPreview preview;
  final String status;
}

final class TradeOrderActionResult {
  const TradeOrderActionResult({
    required this.orderId,
    required this.action,
    required this.status,
  });

  final String orderId;
  final String action;
  final String status;
}
