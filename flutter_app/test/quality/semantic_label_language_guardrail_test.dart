// Origin: 70c67af6 (2026-07-17) - refactor: nâng cấp nền tảng VitTrade Flutter theo lộ trình enterprise A+
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A11Y-4 (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// DEC-i18n (decided: Nhánh A — label tiếng Việt inline) requires user-facing
/// accessibility label text to be Vietnamese, matching the rest of each
/// screen's on-screen copy. Screen-reader users hearing one flow announce
/// some controls in Vietnamese and others in English is a real regression,
/// not a cosmetic one.
///
/// A11Y-4 batch 2 (2026-07-16) translated the 58 Latin-only `semanticLabel:`
/// literals the original narrower regex found. A11Y-4 batch 3 (2026-07-17)
/// widened detection to also catch:
/// (1) raw `Semantics(label: ...)`/`Semantics(..., value: ...)` calls (this
///     codebase's own `semanticLabel:` convenience param is a DIFFERENT,
///     narrower thing than Flutter's built-in `Semantics.label`), and
/// (2) `semanticLabel:`/`semanticsLabel:` (a second, plural convenience
///     param name found on a couple of shared widgets) values that START
///     with a `${...}`/`$identifier` interpolation rather than a plain
///     letter — checked against the STATIC text with interpolations
///     stripped out, so `${title}: $message` (all-interpolation, no real
///     prose) correctly does NOT count, while `${label} risk scenario`
///     correctly does.
/// Baseline is 0 — a real zero-violations check, not a ratchet.
///
/// Still-known gap, not a violation: text fed to accessibility only via a
/// `tooltip:` param (VitIconButton et al. mirror the tooltip into their
/// internal Semantics.label) isn't scanned here — that would require
/// tracing widget internals, not a source-text regex.
void main() {
  test(
    'user-facing accessibility label text does not gain new Latin-only strings',
    () {
      const baseline = 0;

      final violations = <String>[];
      for (final entity in Directory(
        'lib/features',
      ).listSync(recursive: true)) {
        if (entity is! File) continue;
        final path = entity.path.replaceAll('\\', '/');
        if (!path.endsWith('.dart')) continue;
        violations.addAll(_violationsIn(path, entity.readAsLinesSync()));
      }

      expect(
        violations.length,
        lessThanOrEqualTo(baseline),
        reason:
            'New Latin-only accessibility label text introduced — '
            'user-facing labels should be Vietnamese (DEC-i18n Nhánh A):\n'
            '${violations.join('\n')}',
      );
    },
  );
}

final _semanticsOpenPattern = RegExp(r'\bSemantics\(');
final _labelOrValueKeyPattern = RegExp(r'^\s*(label|value):');
final _stringLiteralPattern = RegExp(r"'([^']*)'");
final _namedLabelPattern = RegExp(r"semantic(?:s)?Label:\s*'([^']*)'");

List<String> _violationsIn(String path, List<String> lines) {
  final found = <String>[];
  final seen = <int>{};

  // Raw Semantics(label: ...) / Semantics(..., value: ...) — scan a window
  // after `Semantics(` for a line starting with `label:`/`value:`, then
  // pull every string literal from that line plus the next 2 (covers a
  // ternary split across lines).
  for (var i = 0; i < lines.length; i++) {
    if (!_semanticsOpenPattern.hasMatch(lines[i])) continue;
    for (var j = i; j < lines.length && j < i + 20; j++) {
      if (!_labelOrValueKeyPattern.hasMatch(lines[j])) continue;
      final window = lines.sublist(j, (j + 3).clamp(0, lines.length)).join(' ');
      for (final m in _stringLiteralPattern.allMatches(window)) {
        if (_isViolation(m.group(1)!) && seen.add(j)) {
          found.add('$path:${j + 1}: ${m.group(1)}');
        }
      }
      break;
    }
  }

  // semanticLabel:/semanticsLabel: literal (covers both the plain-letter
  // case and the interpolation-prefixed case in one pass).
  for (var i = 0; i < lines.length; i++) {
    final m = _namedLabelPattern.firstMatch(lines[i]);
    if (m == null) continue;
    final value = m.group(1)!;
    if (_isViolation(value) && seen.add(-(i + 1))) {
      found.add('$path:${i + 1}: $value');
    }
  }

  return found;
}

final _scIdPattern = RegExp(r'^SC-\d+ ');
final _asciiOnly = RegExp(r'^[\x00-\x7F]*$');
final _pageIdPattern = RegExp(
  r'^[A-Z][A-Za-z0-9]*Page(\s+(scroll surface|blank|not found|Success))?$',
);
final _wordPattern = RegExp(r'[A-Za-z]{3,}');

bool _isViolation(String rawValue) {
  if (rawValue.contains(r'\u')) {
    return false; // \uXXXX escapes are usually already-Vietnamese text.
  }
  if (_scIdPattern.hasMatch(rawValue.trim())) return false;
  final stripped = _stripInterpolation(rawValue).trim();
  if (stripped.isEmpty) return false;
  if (!_asciiOnly.hasMatch(stripped)) return false;
  if (!_wordPattern.hasMatch(stripped)) return false;
  if (_pageIdPattern.hasMatch(stripped)) return false;
  return true;
}

/// Removes `${...}` and `$identifier` interpolations, leaving only the
/// static text fragments (space-joined so word boundaries survive).
String _stripInterpolation(String value) {
  final buffer = StringBuffer();
  var i = 0;
  while (i < value.length) {
    if (value[i] == r'$') {
      if (i + 1 < value.length && value[i + 1] == '{') {
        final end = value.indexOf('}', i + 2);
        i = end == -1 ? value.length : end + 1;
      } else {
        var j = i + 1;
        while (j < value.length &&
            RegExp(r'[A-Za-z0-9_.]').hasMatch(value[j])) {
          j++;
        }
        i = j;
      }
      buffer.write(' ');
    } else {
      buffer.write(value[i]);
      i++;
    }
  }
  return buffer.toString();
}
