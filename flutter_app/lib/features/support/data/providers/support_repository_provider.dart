import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';
import 'package:vit_trade_flutter/features/support/data/repositories/mock_support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return const MockSupportRepository();
});
