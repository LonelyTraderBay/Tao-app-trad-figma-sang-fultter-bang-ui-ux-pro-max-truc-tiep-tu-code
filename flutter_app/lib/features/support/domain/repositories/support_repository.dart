import 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';

/// Data source contract for the Support feature: read snapshots for the
/// support hub, help center, and announcements screens.
abstract interface class SupportRepository {
  Future<SupportHubSnapshot> getSupportHub();

  Future<HelpCenterSnapshot> getHelpCenter();

  Future<AnnouncementsSnapshot> getAnnouncements();
}
