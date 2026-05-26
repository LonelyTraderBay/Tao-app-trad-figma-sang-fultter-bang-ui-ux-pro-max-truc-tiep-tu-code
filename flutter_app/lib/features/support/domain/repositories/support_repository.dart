import 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';

abstract interface class SupportRepository {
  SupportHubSnapshot getSupportHub();

  HelpCenterSnapshot getHelpCenter();

  AnnouncementsSnapshot getAnnouncements();
}
