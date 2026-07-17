// CI-D3 (A-Plus GĐ2): sàn coverage ratchet chỉ-cho-tăng.
//
// Cách dùng:
//   dart run tool/coverage_floor.dart                       # đọc coverage/lcov.info
//   dart run tool/coverage_floor.dart a.info b.info ...     # hợp nhất nhiều shard
//
// DEC-coverage (A-Plus-DECISIONS.md): floor khởi điểm = min(40%, số đo thực − 2).
// Ratchet CHỈ-CHO-TĂNG: khi coverage thực vượt floor ≥ 5 điểm, tool in gợi ý
// nâng `coverageFloorPercent` — nâng trong PR thường, KHÔNG bao giờ hạ.
//
// Mẫu số: chỉ những file lib/ xuất hiện trong lcov (file chưa được test nào
// import sẽ không có mặt — đây là ratchet trên phần đo được, không phải
// coverage tuyệt đối; TEST-HR3/HR4 kéo thêm file vào mẫu số theo thời gian).
// Loại khỏi mẫu số theo DEC-coverage: file sinh máy (*.g.dart, *.freezed.dart)
// và fixture mock (
// *_fixtures.dart, mọi file dưới data/fixtures/) — data tĩnh, không phải hành vi.
//
// Hợp nhất shard: một dòng tính là "phủ" nếu BẤT KỲ shard nào chạm vào nó
// (max theo từng dòng), vì mỗi shard chỉ chạy một phần test suite.
import 'dart:io';

/// Sàn coverage hiện hành (%). CHỈ ĐƯỢC TĂNG — xem DEC-coverage.
/// Khởi điểm 2026-07-17: đo thực local 94.5% (121079/128110 dòng, 3155 test)
/// → min(40, 94.5−2) = 40.0. Số trên CI Linux sẽ thấp hơn chút (golden test
/// skip ngoài Windows) — ratchet lên ~(số CI − 2) sau khi PR đầu tiên có
/// số đo thật từ CI (kế hoạch: đóng gate GĐ2).
const double coverageFloorPercent = 40.0;

/// Vượt floor bao nhiêu điểm thì gợi ý ratchet lên.
const double _ratchetSuggestionSlack = 5.0;

bool _isExcluded(String path) {
  if (!path.startsWith('lib/')) return true;
  if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) return true;
  if (path.endsWith('_fixtures.dart')) return true;
  if (path.contains('/data/fixtures/')) return true;
  return false;
}

void main(List<String> args) {
  final inputs = args.isEmpty ? ['coverage/lcov.info'] : args;

  // file (repo-relative, forward-slash) -> line -> hits tổng hợp mọi shard.
  final lineHits = <String, Map<int, int>>{};

  for (final input in inputs) {
    final file = File(input);
    if (!file.existsSync()) {
      stderr.writeln('coverage_floor: khong tim thay file lcov "$input".');
      stderr.writeln('Chay truoc: flutter test --coverage');
      exit(2);
    }

    String? currentFile;
    for (final rawLine in file.readAsLinesSync()) {
      final line = rawLine.trim();
      if (line.startsWith('SF:')) {
        // Chuẩn hóa cross-OS: backslash Windows -> forward slash, bỏ prefix
        // tuyệt đối nếu có (phòng lcov sinh trên máy dev).
        var path = line.substring(3).replaceAll(r'\', '/');
        final libIndex = path.indexOf('lib/');
        if (libIndex > 0) path = path.substring(libIndex);
        currentFile = _isExcluded(path) ? null : path;
      } else if (line.startsWith('DA:') && currentFile != null) {
        final parts = line.substring(3).split(',');
        if (parts.length < 2) continue;
        final lineNo = int.tryParse(parts[0]);
        final hits = int.tryParse(parts[1]);
        if (lineNo == null || hits == null) continue;
        final perFile = lineHits.putIfAbsent(currentFile, () => {});
        perFile[lineNo] = (perFile[lineNo] ?? 0) + hits;
      } else if (line == 'end_of_record') {
        currentFile = null;
      }
    }
  }

  if (lineHits.isEmpty) {
    stderr.writeln(
      'coverage_floor: lcov khong chua file lib/ nao sau loai tru.',
    );
    exit(2);
  }

  var totalLines = 0;
  var coveredLines = 0;
  // Gom theo tang thu muc dau (lib/app, lib/core, lib/features/<feature>)
  // de bao cao co the hanh dong duoc.
  final byBucket = <String, ({int total, int covered})>{};

  for (final entry in lineHits.entries) {
    final segments = entry.key.split('/');
    final bucket = segments.length >= 3 && segments[1] == 'features'
        ? '${segments[0]}/${segments[1]}/${segments[2]}'
        : segments.take(2).join('/');
    var bucketTotal = byBucket[bucket]?.total ?? 0;
    var bucketCovered = byBucket[bucket]?.covered ?? 0;
    for (final hits in entry.value.values) {
      totalLines++;
      bucketTotal++;
      if (hits > 0) {
        coveredLines++;
        bucketCovered++;
      }
    }
    byBucket[bucket] = (total: bucketTotal, covered: bucketCovered);
  }

  final percent = coveredLines * 100 / totalLines;
  final formatted = percent.toStringAsFixed(1);

  stdout.writeln(
    'Coverage (line): $formatted% '
    '($coveredLines/$totalLines dong, ${lineHits.length} file lib/ sau loai tru)',
  );
  stdout.writeln('Floor hien hanh: $coverageFloorPercent%');

  final worst = byBucket.entries.toList()
    ..sort((a, b) {
      final pa = a.value.covered / a.value.total;
      final pb = b.value.covered / b.value.total;
      final byPercent = pa.compareTo(pb);
      if (byPercent != 0) return byPercent;
      return a.key.compareTo(b.key);
    });
  stdout.writeln('5 khu vuc thap nhat:');
  for (final entry in worst.take(5)) {
    final p = (entry.value.covered * 100 / entry.value.total).toStringAsFixed(
      1,
    );
    stdout.writeln(
      '  $p%  ${entry.key} (${entry.value.covered}/${entry.value.total})',
    );
  }

  if (percent < coverageFloorPercent) {
    stderr.writeln(
      'FAIL: coverage $formatted% tut duoi floor $coverageFloorPercent%. '
      'Bo sung test cho code moi (TEST-HR3/HR4) thay vi ha floor — '
      'floor la ratchet chi-cho-tang theo DEC-coverage.',
    );
    exit(1);
  }

  if (percent - coverageFloorPercent >= _ratchetSuggestionSlack) {
    final suggested = (percent - 2).floorToDouble();
    stdout.writeln(
      'GOI Y RATCHET: coverage thuc $formatted% vuot floor '
      '$coverageFloorPercent% >= $_ratchetSuggestionSlack diem — can nhac nang '
      'coverageFloorPercent len $suggested trong PR toi.',
    );
  }
  stdout.writeln('OK: coverage $formatted% >= floor $coverageFloorPercent%.');
}
