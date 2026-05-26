import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/p2p_order_timeline_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2POrderTimeline(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrderTimeline('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-212 mock repository exposes P2P order timeline BE draft', () {
    final snapshot = const MockP2PRepository().getOrderTimeline('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-timeline-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.order.status, 'awaiting_seller_confirmation');
    expect(snapshot.events.length, 6);
    expect(snapshot.events.first.title, 'Order Created');
    expect(snapshot.events.last.status, P2POrderTimelineStatus.pending);
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-212 renders P2P order timeline baseline', (tester) async {
    await pumpP2POrderTimeline(tester);

    expect(find.byType(P2POrderTimelinePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Order #p2p001 Timeline'), findsOneWidget);
    expect(find.text('Order - P2P'), findsOneWidget);
    expect(find.text('Order Timeline'), findsOneWidget);
    expect(find.text('Real-time status updates'), findsOneWidget);
    expect(find.text('Order Created'), findsOneWidget);
    expect(find.text('Matched with Seller'), findsOneWidget);
    expect(find.text('Funds Locked in Escrow'), findsOneWidget);
    expect(find.text('Payment Instructions Sent'), findsOneWidget);
    expect(find.text('Marked as Paid'), findsOneWidget);
    expect(find.text('Awaiting Seller Confirmation'), findsOneWidget);
    expect(find.text('completed'), findsNWidgets(5));
    expect(find.text('pending'), findsOneWidget);
    expect(find.text('By: Seller'), findsNWidgets(3));
  });

  testWidgets('SC-212 back button returns to P2P order placeholder', (
    tester,
  ) async {
    await pumpP2POrderTimeline(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });
}
