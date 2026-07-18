import 'package:vit_trade_flutter/features/enterprise_states/domain/entities/enterprise_states_entities.dart';
import 'package:vit_trade_flutter/features/enterprise_states/domain/repositories/enterprise_states_repository.dart';

export 'package:vit_trade_flutter/features/enterprise_states/domain/entities/enterprise_states_entities.dart';
export 'package:vit_trade_flutter/features/enterprise_states/domain/repositories/enterprise_states_repository.dart';

final class EnterpriseStatesController {
  const EnterpriseStatesController(this._repository);

  final EnterpriseStatesRepository _repository;

  Future<EnterpriseStatesSnapshot> reference() => _repository.getReference();
}
