import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/dca/data/repositories/mock_dca_repository.dart';

final dcaRepositoryProvider = Provider<DcaRepository>((ref) {
  return const DcaRepository();
});
