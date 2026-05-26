import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/admin/data/repositories/mock_admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return const AdminRepository();
});
