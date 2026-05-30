import 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

export 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';
export 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

final class SupportController implements SupportRepository {
  const SupportController(this._repository);

  final SupportRepository _repository;

  @override
  SupportHubSnapshot getSupportHub() {
    return _repository.getSupportHub();
  }

  @override
  HelpCenterSnapshot getHelpCenter() {
    return _repository.getHelpCenter();
  }

  @override
  AnnouncementsSnapshot getAnnouncements() {
    return _repository.getAnnouncements();
  }
}
