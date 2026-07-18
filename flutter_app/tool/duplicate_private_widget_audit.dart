// DEBT-86 (A-Plus GĐ3): audit tên private class trùng lặp trong lib/.
//
// Cách dùng:
//   dart run tool/duplicate_private_widget_audit.dart          # ghi artifact
//   dart run tool/duplicate_private_widget_audit.dart --check  # CI so byte
//
// Đếm mỗi TÊN private class (`class _X ...`) xuất hiện ở >= [_duplicateMin]
// FILE khác nhau — ứng viên dedup về lớp shared (Vit*). Ratchet đóng băng:
// [duplicateNameBaseline] CHỈ ĐƯỢC GIẢM (dedup dần từng họ widget theo đợt
// nhỏ); tên mới trùng >= ngưỡng làm tổng vượt baseline -> CI đỏ.
//
// Whitelist có chủ đích (không phải nợ dedup):
// - `_...State` — State của StatefulWidget, trùng tên là bản chất Flutter;
// - `_...Painter` — CustomPainter cục bộ theo màn, dedup render logic là
//   việc riêng (PERF-HN5 đã bọc RepaintBoundary);
// - part-of cùng library: cùng tên trong các part của MỘT library chỉ là
//   1 lớp — đã khử bằng cách đếm theo library cha (file part quy về file
//   chứa `part of`)? KHÔNG — đơn giản hóa: hai part cùng library không thể
//   khai cùng tên class (Dart cấm), nên mọi lần xuất hiện ở file khác nhau
//   trong cùng library thực chất là các part KHÁC library. Đếm theo file
//   là đúng.
//
// Tuân 10 bài học cross-OS: path repo-relative forward-slash, sort TOÀN
// PHẦN (khóa duy nhất), --check in first-diff, input đều trong git.
import 'dart:io';

const _duplicateMin = 3;

/// Ratchet — CHỈ ĐƯỢC GIẢM. Đo thực 2026-07-18: 195 tên (manifest ước 203
/// vì đếm cả _State/_Painter trước khi whitelist).
const duplicateNameBaseline = 195;

const _csvPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Duplicate-Private-Widget-Audit.csv';

String _normalize(String path) =>
    path.replaceAll(r'\', '/').replaceFirst(RegExp('^\\./'), '');

void main(List<String> args) {
  final checkOnly = args.contains('--check');

  final classPattern = RegExp(
    r'^(?:final |abstract |sealed |base )*class\s+(_[A-Z]\w*)[\s<{]',
  );
  final occurrences = <String, Set<String>>{};

  final files =
      Directory('lib').listSync(recursive: true).whereType<File>().toList()
        ..sort((a, b) => _normalize(a.path).compareTo(_normalize(b.path)));
  for (final file in files) {
    final path = _normalize(file.path);
    if (!path.endsWith('.dart')) continue;
    for (final line in file.readAsLinesSync()) {
      final match = classPattern.firstMatch(line.trim());
      if (match == null) continue;
      final name = match.group(1)!;
      if (name.endsWith('State') || name.endsWith('Painter')) continue;
      occurrences.putIfAbsent(name, () => <String>{}).add(path);
    }
  }

  final duplicated =
      occurrences.entries.where((e) => e.value.length >= _duplicateMin).toList()
        ..sort((a, b) => a.key.compareTo(b.key));

  final buffer = StringBuffer('name,file_count,files\n');
  for (final entry in duplicated) {
    final fileList = (entry.value.toList()..sort()).join('; ');
    buffer.writeln('"${entry.key}",${entry.value.length},"$fileList"');
  }
  final content = buffer.toString();

  final csvFile = File(_csvPath);
  if (checkOnly) {
    if (!csvFile.existsSync()) {
      stderr.writeln(
        'Duplicate private widget artifact missing. Run '
        '`dart run tool/duplicate_private_widget_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    final existing = csvFile.readAsStringSync().replaceAll('\r\n', '\n');
    if (existing != content) {
      stderr.writeln(
        'Duplicate private widget artifact is stale. Run '
        '`dart run tool/duplicate_private_widget_audit.dart` from flutter_app/.',
      );
      final a = existing.split('\n');
      final b = content.split('\n');
      for (var i = 0; i < a.length || i < b.length; i++) {
        final left = i < a.length ? a[i] : '<EOF>';
        final right = i < b.length ? b[i] : '<EOF>';
        if (left != right) {
          stderr.writeln('First diff at line ${i + 1}:');
          stderr.writeln('  artifact: $left');
          stderr.writeln('  computed: $right');
          break;
        }
      }
      exit(1);
    }
  } else {
    csvFile.writeAsStringSync(content);
  }

  stdout.writeln(
    'duplicate_private_widget: ${duplicated.length} ten trung >= '
    '$_duplicateMin file (baseline $duplicateNameBaseline).',
  );
  if (duplicated.length > duplicateNameBaseline) {
    stderr.writeln(
      'FAIL: ${duplicated.length} ten trung vuot baseline '
      '$duplicateNameBaseline — private class moi dang nhan ban thay vi dung '
      'lop shared (lib/shared/widgets). Dedup hoac dung Vit* thay the; '
      'baseline CHI DUOC GIAM (DEBT-86).',
    );
    exit(1);
  }
  if (checkOnly) {
    stdout.writeln('Duplicate private widget artifact is current.');
  }
}
