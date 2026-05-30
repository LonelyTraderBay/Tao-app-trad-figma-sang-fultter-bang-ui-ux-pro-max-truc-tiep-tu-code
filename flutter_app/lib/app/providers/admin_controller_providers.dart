import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/admin/data/providers/admin_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/admin/presentation/controllers/admin_controller.dart';

export 'package:vit_trade_flutter/features/admin/presentation/controllers/admin_controller.dart';

final adminHomeControllerProvider = Provider<AdminHomeController>((ref) {
  final snapshot = ref.watch(data.adminRepositoryProvider).getHome();
  return AdminHomeController(state: AdminHomeViewState(snapshot: snapshot));
});

final adminAnalyticsControllerProvider = Provider<AdminAnalyticsController>((
  ref,
) {
  final snapshot = ref.watch(data.adminRepositoryProvider).getAnalytics();
  return AdminAnalyticsController(
    state: AdminAnalyticsViewState(snapshot: snapshot),
  );
});

final adminAbTestsControllerProvider = Provider<AdminAbTestsController>((ref) {
  final snapshot = ref.watch(data.adminRepositoryProvider).getAbTests();
  return AdminAbTestsController(
    state: AdminAbTestsViewState(snapshot: snapshot),
  );
});

final adminFunnelsControllerProvider = Provider<AdminFunnelsController>((ref) {
  final snapshot = ref.watch(data.adminRepositoryProvider).getFunnels();
  return AdminFunnelsController(
    state: AdminFunnelsViewState(snapshot: snapshot),
  );
});
