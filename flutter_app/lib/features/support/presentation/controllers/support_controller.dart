import 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

export 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';
export 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

final class SupportController implements SupportRepository {
  const SupportController(this._repository);

  final SupportRepository _repository;

  @override
  Future<SupportHubSnapshot> getSupportHub() {
    return _repository.getSupportHub();
  }

  @override
  Future<HelpCenterSnapshot> getHelpCenter() {
    return _repository.getHelpCenter();
  }

  @override
  Future<AnnouncementsSnapshot> getAnnouncements() {
    return _repository.getAnnouncements();
  }
}
