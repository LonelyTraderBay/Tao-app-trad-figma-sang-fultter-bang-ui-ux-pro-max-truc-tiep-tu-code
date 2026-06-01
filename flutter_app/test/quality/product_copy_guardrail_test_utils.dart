import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String readSource(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: path);
  return file.readAsStringSync();
}

Iterable<File> listDartFiles(String directoryPath) {
  return Directory(
    directoryPath,
  ).listSync().whereType<File>().where((file) => file.path.endsWith('.dart'));
}

String asciiFold(String value) {
  return value
      .replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
      .replaceAll(RegExp('[đ]'), 'd')
      .replaceAll(RegExp('[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A')
      .replaceAll(RegExp('[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E')
      .replaceAll(RegExp('[ÌÍỊỈĨ]'), 'I')
      .replaceAll(RegExp('[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O')
      .replaceAll(RegExp('[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U')
      .replaceAll(RegExp('[ỲÝỴỶỸ]'), 'Y')
      .replaceAll(RegExp('[Đ]'), 'D');
}

class HighRiskCopyTarget {
  const HighRiskCopyTarget({
    required this.path,
    this.paths = const <String>[],
    required this.roles,
  });

  final String path;
  final List<String> paths;
  final Map<String, List<RegExp>> roles;

  Iterable<String> get sourcePaths => paths.isEmpty ? [path] : paths;
}
