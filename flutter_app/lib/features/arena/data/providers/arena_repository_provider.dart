import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/data/repositories/mock_arena_repository.dart';

final arenaRepositoryProvider = Provider<ArenaRepository>(
  (ref) => const MockArenaRepository(),
);
