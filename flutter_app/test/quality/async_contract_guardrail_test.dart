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

/// CHỈ GIẢM — đích 0 ở Cụm F6 (đo thực tế 2026-07-18, sau Cụm F2 GD4).
/// Method sync còn lại theo file (31 file domain/repositories/ tổng cộng;
/// auth/home/news/trade/wallet/notifications đã về 0 — 2 đầu đã ở GĐ2,
/// wallet+notifications vừa xong ở Cụm F2 GD4):
/// admin=4, arena=27, cross_module/analytics=1, cross_module/smart_alerts=1,
/// cross_module/tax_report=1, cross_module/unified_portfolio=1, dca=12,
/// dev_tools=4, discovery=2, earn=68, enterprise_states=1, launchpad=24,
/// markets=21, onboarding=1, p2p=71, predictions=17, profile=11,
/// referral=5, rewards=1, support=3, trade_bots/analytics=13,
/// trade_bots/trading_bots=14, trade_compliance=28, trade_copy=29,
/// trade_terminal/spot=24, trade_terminal/futures_margin=6.
/// Fan-out: mỗi cụm xong thì trừ đúng số method đã async-hoá khỏi baseline
/// này (không hạ thấp hơn actual đo được — xem reason message bên dưới).
const _baseline = 390;

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
