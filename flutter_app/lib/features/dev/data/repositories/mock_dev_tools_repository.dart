import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/domain/repositories/dev_tools_repository.dart';

part 'mock_dev_tools_route_checker_repository.dart';
part 'mock_dev_tools_missing_screens_repository.dart';
part 'mock_dev_tools_design_performance_repository.dart';

/// Shared network-simulation helper for every Mock*Repository in this
/// feature (bẫy 12, GD4-Async-Playbook.md mục 2/9.12) — dev tools have no
/// fail-closed variant (always mock reference data), so `simulateError`
/// stays available for parity/testability even if no call-site flips it yet.
abstract class _MockDevToolsRepositoryBase {
  const _MockDevToolsRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('dev_tools_mock_fetch_failed');
  }
}
