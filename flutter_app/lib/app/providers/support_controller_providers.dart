import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/support/data/providers/support_repository_provider.dart';
import 'package:vit_trade_flutter/features/support/presentation/controllers/support_controller.dart';

export 'package:vit_trade_flutter/features/support/presentation/controllers/support_controller.dart';

final supportControllerProvider = Provider<SupportController>((ref) {
  return SupportController(ref.watch(supportRepositoryProvider));
});
