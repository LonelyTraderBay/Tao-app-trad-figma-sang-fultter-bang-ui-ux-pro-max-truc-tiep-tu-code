import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

final class MockHomeRepository implements HomeRepository {
  const MockHomeRepository();

  @override
  HomeSnapshot getHome() => HomeMockData.snapshot;
}
