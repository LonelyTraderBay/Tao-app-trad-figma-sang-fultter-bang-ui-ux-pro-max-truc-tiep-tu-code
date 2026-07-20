// Origin: 3b2197fe (2026-07-18) - feat(gd3-a): quyet toan 2 task + const lints + 3 guardrail + tach spacing tokens — dong Cum A GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// DEBT-87 (A-Plus GĐ3): đóng băng kích thước 5 họ god-family mock lớn nhất.
/// Đây là data tĩnh sẽ bị thay nguyên khối khi có backend (DEC-backend) —
/// chấp nhận tồn tại, nhưng KHÔNG được phình thêm: tăng vượt dung sai +10%
/// là tín hiệu logic hiển thị đang chảy nhầm vào tầng mock (xem quy ước
/// trong docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md và doc comment
/// đầu mock_earn_repository.dart). Baseline đo 2026-07-18; family teo đi
/// (dedup, chuyển sang backend) thì HẠ baseline xuống theo — ratchet.
void main() {
  test('god-family mock fixtures không phình vượt baseline +10%', () {
    // family -> (số file baseline, tổng dòng baseline)
    const baselines = <String, (int files, int lines)>{
      'lib/features/earn/data/fixtures': (26, 11202),
      'lib/features/p2p/data/fixtures': (26, 6668),
      'lib/features/arena/data/fixtures': (10, 5006),
      'lib/features/launchpad/data/fixtures': (9, 3764),
      'lib/features/trade_compliance/data/fixtures': (8, 2569),
    };
    const tolerance = 1.10;

    final violations = <String>[];
    for (final entry in baselines.entries) {
      final dir = Directory(entry.key);
      expect(dir.existsSync(), isTrue, reason: 'Thiếu thư mục ${entry.key}');
      final dartFiles =
          dir
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList()
            ..sort(
              (a, b) => a.path
                  .replaceAll(r'\', '/')
                  .compareTo(b.path.replaceAll(r'\', '/')),
            );
      final fileCount = dartFiles.length;
      final lineCount = dartFiles.fold<int>(
        0,
        (sum, f) => sum + f.readAsLinesSync().length,
      );

      final (baseFiles, baseLines) = entry.value;
      if (fileCount > (baseFiles * tolerance).ceil()) {
        violations.add(
          '${entry.key}: $fileCount file > baseline $baseFiles (+10%)',
        );
      }
      if (lineCount > (baseLines * tolerance).ceil()) {
        violations.add(
          '${entry.key}: $lineCount dòng > baseline $baseLines (+10%)',
        );
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'God-family mock phình vượt dung sai — kiểm tra xem logic hiển thị '
          'có đang chảy nhầm vào tầng mock không (DEBT-87); nếu là data mock '
          'chính đáng cho màn hình mới, cân nhắc kỹ rồi mới nâng baseline '
          'kèm lý do trong PR: $violations',
    );
  });
}
