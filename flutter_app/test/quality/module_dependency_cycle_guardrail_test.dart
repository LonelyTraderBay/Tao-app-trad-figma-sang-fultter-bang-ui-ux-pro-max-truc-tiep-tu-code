import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Feature-level import/export edges (2026-07-16, A-Plus roadmap ARCH-A2)
/// that make up the trade family's known, not-yet-fixed circular
/// dependency: the trade_core<->{trade_terminal,trade_bots,trade_compliance,
/// trade_copy} entity-export cycle, and the trade<->trade_terminal widget
/// cross-import cycle. ARCH-A1 removes these; remove the matching entry
/// here (and ratchet `_maxTradeCoreSiblingExports` down) as each is fixed —
/// do not add a NEW pair here for a cycle this test did not already know
/// about.
const _allowedCycleEdges = <(String, String)>{
  ('trade', 'trade_core'),
  ('trade', 'trade_terminal'),
  ('trade_terminal', 'trade'),
  ('trade_terminal', 'trade_core'),
  ('trade_terminal', 'trade_bots'),
  ('trade_terminal', 'trade_copy'),
  ('trade_core', 'trade_terminal'),
  ('trade_core', 'trade_bots'),
  ('trade_core', 'trade_compliance'),
  ('trade_core', 'trade_copy'),
  ('trade_bots', 'trade_core'),
  ('trade_compliance', 'trade_core'),
  ('trade_copy', 'trade_core'),
};

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

  test(
    'trade_core does not gain new sibling import/export edges '
    '(ARCH-A1 removes the existing 4)',
    () {
      // Baseline: trade_core -> {trade_terminal, trade_bots,
      // trade_compliance, trade_copy}, all pre-existing entity re-exports
      // from trade_controller.dart / trade_read_model.dart. This is a
      // ratchet, not a hard ban, because ARCH-A1 (removing these) is a
      // separate, larger GD2 task — this guardrail's job is to stop the
      // count from growing while that fix is pending.
      const maxTradeCoreSiblingEdges = 4;

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
    },
  );
}
