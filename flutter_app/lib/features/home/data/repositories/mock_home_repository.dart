import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

final class MockHomeRepository implements HomeRepository {
  const MockHomeRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  @override
  Future<HomeSnapshot> fetchHome() async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw StateError('home_fetch_failed');
    }
    return HomeMockData.snapshot;
  }
}
