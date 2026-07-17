/// Marker lỗi "mất kết nối" cho các đường ghi tài chính async (ADR-001).
///
/// Repository (mock hoặc thật) ném [OfflineFailure] khi request không tới
/// được backend; controller catch riêng nhánh này để chuyển máy trạng thái
/// high-risk sang `offline` (phân biệt với `error` — lỗi nghiệp vụ/khác).
/// Nằm ở `core/data` cạnh `repository_guard.dart` vì dùng chung cho nhiều
/// feature (trade, predictions, ...) và không phụ thuộc UI.
final class OfflineFailure implements Exception {
  const OfflineFailure([
    this.message = 'Mất kết nối. Kiểm tra mạng và thử lại.',
  ]);

  final String message;

  @override
  String toString() => 'OfflineFailure: $message';
}
