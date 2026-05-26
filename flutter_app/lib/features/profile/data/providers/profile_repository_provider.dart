import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const MockProfileRepository(),
);
