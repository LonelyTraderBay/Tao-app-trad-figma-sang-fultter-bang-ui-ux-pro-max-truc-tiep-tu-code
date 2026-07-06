import 'package:vit_trade_flutter/features/admin/domain/entities/admin_entities.dart';

abstract interface class AdminRepository {
  AdminHomeSnapshot getHome();

  AdminAnalyticsSnapshot getAnalytics();

  AdminAbTestsSnapshot getAbTests();

  AdminFunnelsSnapshot getFunnels();
}
