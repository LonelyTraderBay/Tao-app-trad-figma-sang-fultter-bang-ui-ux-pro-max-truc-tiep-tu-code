import 'package:vit_trade_flutter/features/admin/domain/entities/admin_entities.dart';

export 'package:vit_trade_flutter/features/admin/domain/entities/admin_entities.dart';

enum AdminDashboardLoadStatus { ready, loading, empty, error, offline }

final class AdminHomeViewState {
  const AdminHomeViewState({
    required this.snapshot,
    this.status = AdminDashboardLoadStatus.ready,
    this.message,
  });

  final AdminHomeSnapshot snapshot;
  final AdminDashboardLoadStatus status;
  final String? message;

  bool get hasDashboards => snapshot.dashboards.isNotEmpty;
}

final class AdminHomeController {
  const AdminHomeController({required this.state});

  final AdminHomeViewState state;

  AdminDashboardLink? dashboardById(String id) {
    for (final dashboard in state.snapshot.dashboards) {
      if (dashboard.id == id) return dashboard;
    }
    return null;
  }
}

final class AdminAnalyticsViewState {
  const AdminAnalyticsViewState({
    required this.snapshot,
    this.status = AdminDashboardLoadStatus.ready,
    this.message,
  });

  final AdminAnalyticsSnapshot snapshot;
  final AdminDashboardLoadStatus status;
  final String? message;
}

final class AdminAnalyticsController {
  const AdminAnalyticsController({required this.state});

  final AdminAnalyticsViewState state;

  AdminAnalyticsRangeOption activeRange(AdminAnalyticsRange range) {
    return state.snapshot.ranges.firstWhere(
      (option) => option.range == range,
      orElse: () => state.snapshot.ranges.first,
    );
  }
}

final class AdminAbTestsViewState {
  const AdminAbTestsViewState({
    required this.snapshot,
    this.status = AdminDashboardLoadStatus.ready,
    this.message,
  });

  final AdminAbTestsSnapshot snapshot;
  final AdminDashboardLoadStatus status;
  final String? message;
}

final class AdminAbTestsController {
  const AdminAbTestsController({required this.state});

  final AdminAbTestsViewState state;

  AdminAbTestSummary? testById(String id) {
    for (final test in state.snapshot.tests) {
      if (test.id == id) return test;
    }
    return null;
  }
}

final class AdminFunnelsViewState {
  const AdminFunnelsViewState({
    required this.snapshot,
    this.status = AdminDashboardLoadStatus.ready,
    this.message,
  });

  final AdminFunnelsSnapshot snapshot;
  final AdminDashboardLoadStatus status;
  final String? message;
}

final class AdminFunnelsController {
  const AdminFunnelsController({required this.state});

  final AdminFunnelsViewState state;

  AdminConversionFunnel selectedFunnel(String? selectedFunnelId) {
    return state.snapshot.funnels.firstWhere(
      (funnel) => funnel.id == selectedFunnelId,
      orElse: () => state.snapshot.funnels.first,
    );
  }
}
