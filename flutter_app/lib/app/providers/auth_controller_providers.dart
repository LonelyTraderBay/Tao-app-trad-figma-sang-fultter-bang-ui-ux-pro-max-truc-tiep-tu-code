import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/auth/data/providers/auth_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/auth/presentation/controllers/auth_controller.dart';

export 'package:vit_trade_flutter/features/auth/presentation/controllers/auth_controller.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(repository: ref.watch(data.authRepositoryProvider));
});
