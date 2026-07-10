import 'dart:io';

/// Removes orphan section SizedBox from VitPageContent children and unwraps
/// single-child Column stacks that duplicate parent section gaps.
void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final appRoot = _findAppRoot();
  final libRoot = Directory('${appRoot.path}/lib/features');
  var filesChanged = 0;
  var orphansRemoved = 0;
  var columnsUnwrapped = 0;

  for (final entity in libRoot.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.contains('${Platform.pathSeparator}dev${Platform.pathSeparator}')) {
      continue;
    }

    final original = entity.readAsStringSync();
    if (!original.contains('VitPageContent')) continue;

    var updated = original;
    final unwrapResult = _unwrapSingleChildColumnStacks(updated);
    updated = unwrapResult.source;
    columnsUnwrapped += unwrapResult.unwrapped;

    final removeResult = _removeOrphanSizedBoxFromVitPageContent(updated);
    updated = removeResult.source;
    orphansRemoved += removeResult.removed;

    if (updated != original) {
      filesChanged++;
      if (!dryRun) {
        entity.writeAsStringSync(updated);
      }
      final relative = entity.path.replaceAll('\\', '/').split('/lib/').last;
      stdout.writeln(
        '${dryRun ? '[dry-run] ' : ''}$relative '
        '(-${removeResult.removed} orphan, unwrapped ${unwrapResult.unwrapped})',
      );
    }
  }

  stdout.writeln(
    '${dryRun ? 'Would change' : 'Changed'} $filesChanged files, '
    'removed $orphansRemoved orphan gaps, unwrapped $columnsUnwrapped columns.',
  );
}

final _orphanSizedBoxLine = RegExp(
  r'^\s*(?:const\s+)?SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x[3-7]|sectionGap|sectionGapCompact|pageContentGap)[^)]*\)\s*,?\s*$',
);

({String source, int removed}) _removeOrphanSizedBoxFromVitPageContent(String source) {
  var removed = 0;
  final buffer = StringBuffer();
  var index = 0;

  while (true) {
    final start = source.indexOf('VitPageContent', index);
    if (start < 0) {
      buffer.write(source.substring(index));
      break;
    }
    buffer.write(source.substring(index, start));

    final childrenIndex = source.indexOf('children:', start);
    if (childrenIndex < 0 || childrenIndex > start + 800) {
      buffer.write('VitPageContent');
      index = start + 'VitPageContent'.length;
      continue;
    }

    final bracketStart = source.indexOf('[', childrenIndex);
    if (bracketStart < 0) {
      buffer.write(source.substring(start, childrenIndex + 'children:'.length));
      index = childrenIndex + 'children:'.length;
      continue;
    }

    final listEnd = _findMatchingBracket(source, bracketStart);
    if (listEnd < 0) {
      buffer.write(source.substring(start, bracketStart + 1));
      index = bracketStart + 1;
      continue;
    }

    buffer.write(source.substring(start, bracketStart + 1));
    final listBody = source.substring(bracketStart + 1, listEnd);
    final cleanedLines = <String>[];
    for (var lineIndex = 0; lineIndex < listBody.split('\n').length; lineIndex++) {
      final line = listBody.split('\n')[lineIndex];
      if (_orphanSizedBoxLine.hasMatch(line)) {
        final prev = lineIndex > 0 ? listBody.split('\n')[lineIndex - 1].trim() : '';
        if (prev.startsWith('if (')) continue;
        removed++;
        continue;
      }
      cleanedLines.add(line);
    }
    buffer.write(cleanedLines.join('\n'));
    buffer.write(']');
    index = listEnd + 1;
  }

  return (source: buffer.toString(), removed: removed);
}

({String source, int unwrapped}) _unwrapSingleChildColumnStacks(String source) {
  var unwrapped = 0;
  var updated = source;
  var searchFrom = 0;

  while (true) {
    final vpcStart = updated.indexOf('VitPageContent', searchFrom);
    if (vpcStart < 0) break;

    final childrenIndex = updated.indexOf('children:', vpcStart);
    if (childrenIndex < 0 || childrenIndex > vpcStart + 800) {
      searchFrom = vpcStart + 1;
      continue;
    }

    final listStart = updated.indexOf('[', childrenIndex);
    if (listStart < 0) {
      searchFrom = vpcStart + 1;
      continue;
    }

    final listEnd = _findMatchingBracket(updated, listStart);
    if (listEnd < 0) {
      searchFrom = vpcStart + 1;
      continue;
    }

    final listBody = updated.substring(listStart + 1, listEnd);
    final directItems = _splitTopLevelListItems(listBody);
    if (directItems.length != 1) {
      searchFrom = listEnd + 1;
      continue;
    }

    final onlyItem = directItems.first.trim();
    final columnBody = _extractColumnChildren(onlyItem);
    if (columnBody == null) {
      searchFrom = listEnd + 1;
      continue;
    }

    final columnItems = _splitTopLevelListItems(columnBody);
    final hasOrphanGap = columnItems.any(
      (item) => _orphanSizedBoxLine.hasMatch(item.trim()),
    );
    if (!hasOrphanGap) {
      searchFrom = listEnd + 1;
      continue;
    }

    final lifted = columnItems
        .where((item) => !_orphanSizedBoxLine.hasMatch(item.trim()))
        .join(',\n');

    final newListBody = '\n$lifted\n';
    updated = updated.replaceRange(listStart + 1, listEnd, newListBody);
    unwrapped++;
    searchFrom = listStart + newListBody.length + 1;
  }

  return (source: updated, unwrapped: unwrapped);
}

String? _extractColumnChildren(String widgetSource) {
  final columnIndex = widgetSource.indexOf('Column(');
  if (columnIndex < 0) return null;

  final childrenIndex = widgetSource.indexOf('children:', columnIndex);
  if (childrenIndex < 0) return null;

  final listStart = widgetSource.indexOf('[', childrenIndex);
  if (listStart < 0) return null;

  final listEnd = _findMatchingBracket(widgetSource, listStart);
  if (listEnd < 0) return null;

  return widgetSource.substring(listStart + 1, listEnd);
}

int _findMatchingBracket(String source, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];
    if (char == '[') depth++;
    if (char == ']') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

List<String> _splitTopLevelListItems(String listBody) {
  final items = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  var parenDepth = 0;

  for (var i = 0; i < listBody.length; i++) {
    final char = listBody[i];
    if (char == '[') depth++;
    if (char == ']') depth--;
    if (char == '(') parenDepth++;
    if (char == ')') parenDepth--;

    if (char == ',' && depth == 0 && parenDepth == 0) {
      items.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }

  if (buffer.isNotEmpty) items.add(buffer.toString());
  return items;
}

Directory _findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }
  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }
  throw StateError('Run from repo root or flutter_app/.');
}
