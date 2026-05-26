import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/copy_audit_log_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpCopyAuditLog(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyAuditLog('copy001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-077 mock repository exposes copy audit BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getCopyAuditLog(copyId: 'copy001');
    final export = repo.createCopyAuditExport(
      const TradeCopyAuditExportRequest(
        copyId: 'copy001',
        format: 'csv',
        filterId: 'all',
        searchQuery: '',
      ),
    );

    expect(snapshot.copyId, 'copy001');
    expect(snapshot.retentionYears, 5);
    expect(snapshot.events, hasLength(7));
    expect(snapshot.tabs.map((tab) => tab.id), [
      'all',
      'trade',
      'config',
      'risk',
      'system',
    ]);
    expect(snapshot.exportFormats.map((item) => item.id), [
      'csv',
      'pdf',
      'json',
    ]);
    expect(export.status, 'ready');
    expect(export.downloadUrl, '/exports/copy-audit-copy001.csv');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-077 renders audit timeline inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    expect(find.byType(CopyAuditLogPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Audit Log'), findsOneWidget);
    expect(find.text('MiFID II Compliant Audit Trail'), findsOneWidget);
    expect(find.text('Trade Executed'), findsOneWidget);
    expect(find.text('Risk Alert Triggered'), findsOneWidget);
    expect(find.text('Thống kê tổng quan'), findsOneWidget);
  });

  testWidgets('SC-077 search and filter tabs narrow the audit list', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    await tester.tap(find.byKey(CopyAuditLogPage.tabKey('risk')));
    await tester.pumpAndSettle();

    expect(find.text('Risk Alert Triggered'), findsOneWidget);
    expect(find.text('Trade Executed'), findsNothing);

    await tester.enterText(find.byKey(CopyAuditLogPage.searchFieldKey), 'DOGE');
    await tester.pumpAndSettle();

    expect(find.byKey(CopyAuditLogPage.emptyStateKey), findsOneWidget);
    expect(find.text('Không tìm thấy event phù hợp'), findsOneWidget);
  });

  testWidgets('SC-077 export action opens CSV/PDF/JSON choices', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    await tester.tap(find.byKey(CopyAuditLogPage.exportActionKey));
    await tester.pumpAndSettle();

    expect(find.text('Export Audit Log'), findsOneWidget);
    expect(find.text('CSV'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('JSON'), findsOneWidget);

    await tester.tap(find.byKey(CopyAuditLogPage.exportFormatKey('csv')));
    await tester.pumpAndSettle();

    expect(find.text('Export Audit Log'), findsNothing);
  });
}
