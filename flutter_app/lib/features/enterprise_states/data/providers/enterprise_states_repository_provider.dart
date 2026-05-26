import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/enterprise_states/domain/repositories/enterprise_states_repository.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/repositories/mock_enterprise_states_repository.dart';

final enterpriseStatesRepositoryProvider = Provider<EnterpriseStatesRepository>(
  (ref) {
    return const MockEnterpriseStatesRepository();
  },
);
