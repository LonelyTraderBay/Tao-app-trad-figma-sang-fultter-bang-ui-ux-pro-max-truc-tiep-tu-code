import 'package:vit_trade_flutter/features/admin/domain/entities/admin_entities.dart';

/// Data source contract for the Admin feature: read snapshots for the
/// home, analytics, A/B tests, and funnels screens.
abstract interface class AdminRepository {
  Future<AdminHomeSnapshot> getHome();

  Future<AdminAnalyticsSnapshot> getAnalytics();

  Future<AdminAbTestsSnapshot> getAbTests();

  Future<AdminFunnelsSnapshot> getFunnels();
}
