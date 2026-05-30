import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';

part '../fixtures/mock_arena_repository_methods_part_01.dart';
part '../fixtures/mock_arena_repository_methods_part_02.dart';
part '../fixtures/mock_arena_repository_methods_part_03.dart';
part '../fixtures/mock_arena_repository_methods_part_04.dart';
part '../fixtures/mock_arena_repository_methods_part_05.dart';
part '../fixtures/mock_arena_repository_methods_part_06.dart';
part '../fixtures/mock_arena_repository_methods_part_07.dart';
part '../fixtures/mock_arena_repository_methods_part_08.dart';
part '../fixtures/mock_arena_repository_methods_part_09.dart';
part '../fixtures/mock_arena_repository_methods_part_10.dart';
part '../fixtures/mock_arena_repository_methods_part_11.dart';

// Product boundary sentinels used by copy guardrails:
// Open Arena = Points only. Prediction Markets = Real positions.
// Disallowed bridge shortcut: no_wallet_link. Never merge Points + PnL.
abstract class _MockArenaRepositoryBase implements ArenaRepository {
  const _MockArenaRepositoryBase();
}

final class MockArenaRepository extends _MockArenaRepositoryBase
    with
        _MockArenaRepositoryMethodsPart01,
        _MockArenaRepositoryMethodsPart02,
        _MockArenaRepositoryMethodsPart03,
        _MockArenaRepositoryMethodsPart04,
        _MockArenaRepositoryMethodsPart05,
        _MockArenaRepositoryMethodsPart06,
        _MockArenaRepositoryMethodsPart07,
        _MockArenaRepositoryMethodsPart08,
        _MockArenaRepositoryMethodsPart09,
        _MockArenaRepositoryMethodsPart10,
        _MockArenaRepositoryMethodsPart11 {
  const MockArenaRepository();
}

String formatArenaPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}
