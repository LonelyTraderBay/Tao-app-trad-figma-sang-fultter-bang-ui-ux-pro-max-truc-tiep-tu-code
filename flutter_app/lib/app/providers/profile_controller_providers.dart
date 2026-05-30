import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/profile/data/providers/profile_repository_provider.dart';
import 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

export 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});
