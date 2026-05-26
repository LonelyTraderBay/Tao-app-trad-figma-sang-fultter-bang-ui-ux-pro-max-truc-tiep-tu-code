import 'package:vit_trade_flutter/features/enterprise_states/domain/entities/enterprise_states_entities.dart';

abstract interface class EnterpriseStatesRepository {
  EnterpriseStatesSnapshot getReference();
}
