// Origin: 3baadda1 (2026-07-18) - feat(gd4-f2): pilot async contract — wallet 19 + notifications 1 method Future<T> + PLAYBOOK + ratchet 390
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// GD4 (A-Plus roadmap): ADR-001 hứa mọi domain repository read-method là
/// `Future<T>` — xem docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md
/// và docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md. Cụm
/// F2 (pilot) đã async-hoá wallet (19 method) + notifications (1 method);
/// 4 cụm fan-out còn lại (~29 file khác) sẽ trừ dần baseline này.
///
/// Regex khớp một dòng khai báo method trong `abstract interface class`:
/// thụt lề + (KHÔNG bắt đầu bằng `Future<`/`Stream<`) + bất kỳ ký tự nào
/// (kiểu trả về) + khoảng trắng + tên method lowerCamelCase + `(`. Getter
/// (không có `(`) và field (`final ...;`, không có `(`) tự động bị loại vì
/// thiếu `(` ngay sau tên. Dòng tiếp theo của tham số nhiều dòng (vd
/// `String asset,`) không khớp vì không có `(` ở cuối.
final _syncMethodPattern = RegExp(r'^\s+(?!Future<|Stream<)\S.*\s[a-z]\w*\(');

/// CHỈ GIẢM — đích 0 ở Cụm F6 (đo thực tế 2026-07-18, sau Cụm F3 GD4
/// trade_copy — 29 method). Baseline đo lại = actual thật tại thời điểm
/// đóng Cụm F3 (282), vì các cụm fan-out khác (F4/F5/trade_bots/...) có
/// thể đang chạy song song trong cùng working tree (không worktree) và đã
/// tự hạ phần của họ trước hoặc sau — số này phản ánh tổng thật đo được,
/// không phải suy ra bằng phép trừ thủ công 29 khỏi baseline cũ.
/// Fan-out: mỗi cụm xong thì trừ đúng số method đã async-hoá khỏi baseline
/// này (không hạ thấp hơn actual đo được — xem reason message bên dưới).
const _baseline = 0;

List<String> _syncRepositoryMethods() {
  final findings = <String>[];
  final root = Directory('lib/features');
  if (!root.existsSync()) return findings;

  for (final file in root.listSync(recursive: true).whereType<File>()) {
    final path = file.path.replaceAll('\\', '/');
    if (!path.endsWith('.dart')) continue;
    if (!path.contains('/domain/repositories/')) continue;

    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      if (_syncMethodPattern.hasMatch(lines[index])) {
        findings.add('$path:${index + 1}');
      }
    }
  }
  return findings;
}

void main() {
  test('domain repository sync methods only decrease toward the GD4 Future<T> '
      'migration', () {
    final syncMethods = _syncRepositoryMethods();

    expect(
      syncMethods.length,
      lessThanOrEqualTo(_baseline),
      reason:
          'Số method SYNC còn lại trong '
          'lib/features/*/domain/repositories/*.dart tăng lên trên '
          'baseline GD4 ($_baseline). GD4 CHỈ GIẢM dần theo cụm (đích 0 ở '
          'Cụm F6) — nếu bạn vừa thêm method mới, khai báo Future<T> ngay '
          'từ đầu. Nếu bạn vừa async-hoá một cụm, HẠ _baseline xuống số '
          'thật (actual = ${syncMethods.length}).',
    );
  });
}
