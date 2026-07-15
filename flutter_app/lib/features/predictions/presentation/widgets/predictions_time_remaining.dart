/// Shared "time remaining" countdown formatter for prediction event cards
/// and detail pages.
///
/// Every predictions hub/detail page previously repeated its own private
/// `_timeRemaining(DateTime)` helper with the same hardcoded
/// `DateTime.utc(2026, 2, 27, 12)` "now" anchor. This module-scoped helper
/// captures that shared anchor/diff logic; callers may override
/// [endedLabel]/[activePrefix] to preserve their existing copy (e.g. the
/// event detail page's English "Ended" label vs. the hub pages' Vietnamese
/// "Đóng ..." prefix).
String predictionsTimeRemaining(
  DateTime endDate, {
  String endedLabel = 'Đã đóng',
  String activePrefix = 'Đóng ',
}) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return endedLabel;
  final days = diff.inDays;
  if (days > 30) return '$activePrefix${days ~/ 30} tháng';
  if (days > 0) return '$activePrefix$days ngày';
  return '$activePrefix${diff.inHours}h';
}
