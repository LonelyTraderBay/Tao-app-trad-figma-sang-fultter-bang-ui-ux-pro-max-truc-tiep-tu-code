import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/data/repositories/mock_arena_repository.dart';

import 'package:vit_trade_flutter/features/arena/data/repositories/fail_closed_arena_repository.dart';

final arenaRepositoryProvider = Provider<ArenaRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Arena',
    mock: () => const MockArenaRepository(),
    failClosed: () => const FailClosedArenaRepository(),
  ),
);
