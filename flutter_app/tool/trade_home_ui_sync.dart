import 'dart:io';

/// Bulk-applies Home-aligned scroll inset helpers across trade presentation pages.
void main() {
  final appRoot = Directory.current;
  final pagesDir = Directory('${appRoot.path}/lib/features/trade/presentation');
  if (!pagesDir.existsSync()) {
    stderr.writeln('Run from flutter_app/');
    exitCode = 1;
    return;
  }

  const layoutImport =
      "import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';";

  final patterns = <RegExp, String>{
    RegExp(
      r'final chromeInset = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final scrollClearance =\s*\n'
      r'\s*chromeInset \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? AppSpacing\.x6 \+ AppSpacing\.x6\s*\n'
      r'\s*: AppSpacing\.x5 \+ AppSpacing\.x5\);',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '      context,\n'
        '      shellRenderMode: mode,\n'
        '    );',

    RegExp(
      r'final bottomChrome = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final bottomInset =\s*\n'
      r'\s*bottomChrome \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame \? 34 : 20\);',
      multiLine: true,
    ): 'final bottomInset = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollEndClearance =\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? _framedScrollClearance\s*\n'
      r'\s*: _nativeScrollClearance\);',
      multiLine: true,
    ): 'final scrollEndClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollEndClearance =\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? _\w+(?:Visual|Framed)ScrollClearance\s*\n'
      r'\s*: _\w+NativeScrollClearance\) \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;',
      multiLine: true,
    ): 'final scrollEndClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollEndClearance =\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? _\w+(?:Visual|Framed)ScrollClearance\s*\n'
      r'\s*: _\w+NativeScrollClearance\);',
      multiLine: true,
    ): 'final scrollEndClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollEndClearance =\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? _\w+VisualScrollClearance\s*\n'
      r'\s*: _\w+NativeScrollClearance\);',
      multiLine: true,
    ): 'final scrollEndClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollClearance =\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome \+ AppSpacing\.x7\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome \+ AppSpacing\.x6\);',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollEndClearance =\s*\n'
      r'\s*safeArea \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? _\w+VisualScrollClearance\s*\n'
      r'\s*: _\w+NativeScrollClearance\);',
      multiLine: true,
    ): 'final scrollEndClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollClearance =\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome \+ AppSpacing\.x7\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome \+ AppSpacing\.x5\) \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollClearance =\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome \+ AppSpacing\.x7\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome \+ AppSpacing\.x6\) \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final chromeInset = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final scrollClearance =\s*\n'
      r'\s*chromeInset \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? AppSpacing\.x6 \+ AppSpacing\.x5\s*\n'
      r'\s*: AppSpacing\.x5 \+ AppSpacing\.x3\);',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final chromeInset = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final bottomInset =\s*\n'
      r'\s*chromeInset \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? AppSpacing\.x6 \+ AppSpacing\.x4\s*\n'
      r'\s*: AppSpacing\.x5 \+ AppSpacing\.x2\) \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;',
      multiLine: true,
    ): 'final bottomInset = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final bottomInset =\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome \+ AppSpacing\.x7\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome \+ AppSpacing\.x5\) \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;',
      multiLine: true,
    ): 'final bottomInset = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final scrollClearance =\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*chromeInset \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? AppSpacing\.x6 \+ AppSpacing\.x6\s*\n'
      r'\s*: AppSpacing\.x5 \+ AppSpacing\.x5\);',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final chromeInset = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final scrollClearance = chromeInset \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom;\s*\n'
      r'\s*final bottomInset =\s*\n'
      r'\s*scrollClearance \+\s*\n'
      r'\s*\(mode\.usesVisualQaFrame\s*\n'
      r'\s*\? AppSpacing\.x6 \+ AppSpacing\.x4\s*\n'
      r'\s*: AppSpacing\.x5 \+ AppSpacing\.x2\);',
      multiLine: true,
    ): 'final bottomInset = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',

    RegExp(
      r'final chromeInset = mode\.usesVisualQaFrame\s*\n'
      r'\s*\? DeviceMetrics\.bottomChrome\s*\n'
      r'\s*: DeviceMetrics\.nativeBottomChrome;\s*\n'
      r'\s*final scrollClearance =\s*\n'
      r'\s*chromeInset \+\s*\n'
      r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
      r'\s*AppSpacing\.x3;',
      multiLine: true,
    ): 'final scrollClearance = tradeScrollBottomInset(\n'
        '        context,\n'
        '        shellRenderMode: mode,\n'
        '      );',
  };

  final scrollClearanceConst = RegExp(
    r"const (?:double )?_\w+(?:Visual|Native|Framed)ScrollClearance = [^;]+;\s*\n",
  );

  var updated = 0;
  final librariesNeedingImport = <String>{};

  for (final entity in pagesDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    if (entity.path.contains('trade_module_layout.dart')) {
      continue;
    }
    var content = entity.readAsStringSync();
    final original = content;
    final isPart = content.startsWith('part of');

    for (final entry in patterns.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }

    content = content.replaceAllMapped(
      RegExp(r'bottomInset:\s*bottomChrome \+ AppSpacing\.x3'),
      (_) =>
          'bottomInset: tradeScrollBottomInset(context, shellRenderMode: mode)',
    );

    content = content.replaceAllMapped(
      RegExp(
        r'final scrollEndClearance =\s*\n'
        r'\s*MediaQuery\.paddingOf\(context\)\.bottom \+\s*\n'
        r'\s*\(mode\.usesVisualQaFrame\s*\n'
        r'\s*\? DeviceMetrics\.bottomChrome \+ AppSpacing\.x5\s*\n'
        r'\s*: DeviceMetrics\.nativeBottomChrome \+ AppSpacing\.x3\);',
        multiLine: true,
      ),
      (_) =>
          'final scrollEndClearance = tradeScrollBottomInset(\n'
          '        context,\n'
          '        shellRenderMode: mode,\n'
          '      );',
    );

    content = content.replaceAll(
      'EdgeInsets.zero',
      'AppSpacing.zeroInsets',
    );

    if (content.contains('tradeScrollBottomInset(') ||
        content.contains('copyTradingScrollBottomInset(')) {
      if (isPart) {
        final match = RegExp(r"part of '([^']+)';").firstMatch(content);
        if (match != null) {
          final partName = match.group(1)!;
          final candidates = [
            '${pagesDir.path}/pages/$partName',
            '${pagesDir.path}/$partName',
          ];
          for (final candidate in candidates) {
            if (File(candidate).existsSync()) {
              librariesNeedingImport.add(candidate);
              break;
            }
          }
        }
      } else if (!content.contains(layoutImport)) {
        content = _insertImport(content, layoutImport);
      }
    }

    content = content.replaceAll(scrollClearanceConst, '');

    if (content != original) {
      entity.writeAsStringSync(content);
      updated++;
      stdout.writeln('Updated ${entity.path}');
    }
  }

  for (final libraryPath in librariesNeedingImport) {
    final file = File(libraryPath);
    if (!file.existsSync()) {
      continue;
    }
    var content = file.readAsStringSync();
    if (!content.contains(layoutImport)) {
      file.writeAsStringSync(_insertImport(content, layoutImport));
      stdout.writeln('Added import to $libraryPath');
    }
  }

  stdout.writeln('Done. Updated $updated files.');
}

String _insertImport(String content, String layoutImport) {
  final lastImport = content.lastIndexOf("import 'package:");
  if (lastImport == -1) {
    return content;
  }
  final lineEnd = content.indexOf('\n', lastImport);
  return '${content.substring(0, lineEnd + 1)}$layoutImport\n${content.substring(lineEnd + 1)}';
}
