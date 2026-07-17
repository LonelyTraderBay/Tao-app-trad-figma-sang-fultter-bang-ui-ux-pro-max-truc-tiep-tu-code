import 'package:vit_trade_flutter/features/enterprise_states/domain/entities/enterprise_states_entities.dart';

/// Repository contract for fetching the enterprise states screen's
/// [EnterpriseStatesSnapshot].
abstract interface class EnterpriseStatesRepository {
  EnterpriseStatesSnapshot getReference();
}
