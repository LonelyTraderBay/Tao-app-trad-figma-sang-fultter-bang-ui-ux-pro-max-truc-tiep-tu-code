import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

void main() {
  const repository = MockAdminRepository(loadDelay: Duration.zero);

  Future<void> pumpAdminWidget(WidgetTester tester, Widget child) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(child);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('SC-180 renders admin loading skeleton state', (tester) async {
    final snapshot = await repository.getHome();
    await pumpAdminWidget(
      tester,
      ProviderScope(
        overrides: [
          adminHomeControllerProvider.overrideWithValue(
            AsyncData(
              AdminHomeController(
                state: AdminHomeViewState(
                  snapshot: snapshot,
                  status: AdminDashboardLoadStatus.loading,
                ),
              ),
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.admin),
        ),
      ),
    );

    expect(find.byType(VitSkeletonList), findsOneWidget);
  });

  testWidgets('SC-181 renders analytics offline cached state', (tester) async {
    final snapshot = await repository.getAnalytics();
    await pumpAdminWidget(
      tester,
      ProviderScope(
        overrides: [
          adminAnalyticsControllerProvider.overrideWithValue(
            AsyncData(
              AdminAnalyticsController(
                state: AdminAnalyticsViewState(
                  snapshot: snapshot,
                  status: AdminDashboardLoadStatus.offline,
                  message: 'Last cached analytics snapshot remains visible.',
                ),
              ),
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminAnalytics,
          ),
        ),
      ),
    );

    expect(find.text('Offline. Showing cached admin data.'), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
  });

  testWidgets('SC-183 renders funnel empty state', (tester) async {
    final snapshot = await repository.getFunnels();
    await pumpAdminWidget(
      tester,
      ProviderScope(
        overrides: [
          adminFunnelsControllerProvider.overrideWithValue(
            AsyncData(
              AdminFunnelsController(
                state: AdminFunnelsViewState(
                  snapshot: snapshot,
                  status: AdminDashboardLoadStatus.empty,
                ),
              ),
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminFunnels,
          ),
        ),
      ),
    );

    expect(find.text('Funnel dashboard has no data'), findsOneWidget);
  });

  testWidgets('SC-182 renders A/B test error state', (tester) async {
    final snapshot = await repository.getAbTests();
    await pumpAdminWidget(
      tester,
      ProviderScope(
        overrides: [
          adminAbTestsControllerProvider.overrideWithValue(
            AsyncData(
              AdminAbTestsController(
                state: AdminAbTestsViewState(
                  snapshot: snapshot,
                  status: AdminDashboardLoadStatus.error,
                  message: 'Experiment data is unavailable.',
                ),
              ),
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminAbtests,
          ),
        ),
      ),
    );

    expect(find.text('A/B test dashboard data unavailable'), findsOneWidget);
    expect(find.text('Experiment data is unavailable.'), findsOneWidget);
  });
}
