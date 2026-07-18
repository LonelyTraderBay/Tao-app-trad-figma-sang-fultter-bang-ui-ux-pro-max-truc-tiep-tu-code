import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Feature-level import/export edges allowlist.
///
/// ARCH-A1 (2026-07-17, A-Plus roadmap GĐ2) removed the trade family's two
/// known circular dependencies: the trade_core<->{trade_terminal,trade_bots,
/// trade_compliance,trade_copy} entity-export cycle (barrel exports in
/// `trade_controller.dart` / `trade_read_model.dart` trimmed back to
/// trade_core's own entities), and the trade<->trade_terminal widget
/// cross-import cycle (the `trade_product_navigation.dart`
/// contract+factory merged into trade_core; the `trade`-owned duplicate
/// deleted). The allowlist is empty on purpose — do not add a pair here to
/// paper over a new circular dependency; fix the cycle instead.
const _allowedCycleEdges = <(String, String)>{};

final _importRe = RegExp(
  r"^(?:import|export)\s+'package:vit_trade_flutter/features/([a-zA-Z0-9_]+)/",
);

Map<String, Set<String>> _buildFeatureGraph() {
  final edges = <String, Set<String>>{};
  for (final entity in Directory('lib/features').listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path.replaceAll('\\', '/');
    if (!path.endsWith('.dart')) continue;

    final fromFeature = path.split('/features/')[1].split('/')[0];
    for (final line in entity.readAsLinesSync()) {
      final match = _importRe.firstMatch(line.trim());
      if (match == null) continue;
      final toFeature = match.group(1)!;
      if (toFeature == fromFeature) continue;
      edges.putIfAbsent(fromFeature, () => {}).add(toFeature);
    }
  }
  return edges;
}

List<String>? _findFirstCycle(Map<String, Set<String>> edges) {
  final visited = <String>{};
  final onStack = <String>{};
  final path = <String>[];

  List<String>? dfs(String node) {
    visited.add(node);
    onStack.add(node);
    path.add(node);
    for (final next in edges[node] ?? const <String>{}) {
      if (onStack.contains(next)) {
        final start = path.indexOf(next);
        return [...path.sublist(start), next];
      }
      if (!visited.contains(next)) {
        final found = dfs(next);
        if (found != null) return found;
      }
    }
    onStack.remove(node);
    path.removeLast();
    return null;
  }

  for (final node in edges.keys.toList()..sort()) {
    if (visited.contains(node)) continue;
    final found = dfs(node);
    if (found != null) return found;
  }
  return null;
}

void main() {
  test('feature-level import graph has no NEW circular dependency', () {
    final edges = _buildFeatureGraph();
    final reduced = <String, Set<String>>{};
    for (final from in edges.keys) {
      for (final to in edges[from]!) {
        if (_allowedCycleEdges.contains((from, to))) continue;
        reduced.putIfAbsent(from, () => {}).add(to);
      }
    }

    final cycle = _findFirstCycle(reduced);
    expect(
      cycle,
      isNull,
      reason:
          'New feature-level import cycle found: ${cycle?.join(' -> ')}. '
          'If this is one of the already-known trade-family cycles, it '
          'should already be in _allowedCycleEdges — check the edges are '
          'listed. Otherwise this is a new circular dependency and must be '
          'resolved, not allowlisted.',
    );
  });

  test('trade_core does not gain new sibling import/export edges '
      '(ARCH-A1 hoàn tất 2026-07-17: gỡ 4 cạnh trade_core->sibling cũ, '
      'ratchet về 0)', () {
    // ARCH-A1 removed the last entity re-exports from trade_controller.dart
    // / trade_read_model.dart (trade_core -> trade_terminal/trade_bots/
    // trade_compliance/trade_copy). trade_core is a leaf that siblings
    // depend on, never the reverse — this is now a hard ban, not a ratchet.
    const maxTradeCoreSiblingEdges = 0;

    final edges = _buildFeatureGraph();
    final siblingEdges = (edges['trade_core'] ?? const <String>{})
        .where((to) => to != 'trade')
        .toList();

    expect(
      siblingEdges.length,
      lessThanOrEqualTo(maxTradeCoreSiblingEdges),
      reason:
          'trade_core imports/exports a NEW sibling module '
          '($siblingEdges) — trade_core is meant to be a leaf that '
          'siblings depend on, not the reverse. See ARCH-A1.',
    );
  });
}
