import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';

import '../../fixtures/high_risk_flow_binding.dart';

/// TEST-HR3 (A-Plus GĐ2): mỗi contract high-risk có một testWidgets pump
/// MỌI route trong screen binding của nó qua router thật
/// (`createAppRouter(initialLocation: ...)`, khuôn pumpRoute từ
/// accessibility_semantics_critical_flows_test.dart:10-24) và assert đúng
/// screen của binding render — phủ tối thiểu entry → preview → receipt →
/// history → support cho cả 9 họ, đặc biệt 6 họ chưa từng được pump theo
/// route entry (trade_spot, trade_margin_futures, trade_bots, trade_copy,
/// earn_savings_staking, launchpad_token_access).
///
/// Tương tác preview→confirm chi tiết (điền form, bấm CTA, máy trạng thái)
/// đã có test riêng theo từng họ từ GĐ2 Cụm 1 (ERR-35/S22/ERR-36) — file này
/// bổ sung chiều RỘNG: route nào khai trong binding phải mở được bằng router
/// thật, đúng màn hình, không ném exception ở viewport chuẩn 440x956.
void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder byRuntimeTypeName(String screenName) {
    return find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == screenName,
    );
  }

  // (routePath đầy đủ, kèm query) -> screenName kỳ vọng; dedupe theo route
  // để mỗi route chỉ pump một lần trong testWidgets của contract đó.
  Map<String, String> distinctRoutesOf(HighRiskFlowBinding binding) {
    final routes = <String, String>{};
    for (final screen in binding.screenBindings) {
      routes.putIfAbsent(screen.routePath, () => screen.screenName);
    }
    return routes;
  }

  const contractIds = [
    HighRiskFlowContractIds.tradeSpotOrder,
    HighRiskFlowContractIds.tradeMarginFutures,
    HighRiskFlowContractIds.tradeBots,
    HighRiskFlowContractIds.tradeCopy,
    HighRiskFlowContractIds.walletMoneyMovement,
    HighRiskFlowContractIds.p2pEscrowOrder,
    HighRiskFlowContractIds.earnSavingsStaking,
    HighRiskFlowContractIds.launchpadTokenAccess,
    HighRiskFlowContractIds.predictionMarketEvent,
  ];

  test('binding fixture phủ đủ 9 contract high-risk', () {
    expect(
      HighRiskFlowBindings.bindings.map((b) => b.contractId).toSet(),
      contractIds.toSet(),
      reason:
          'Thêm/bớt contract high-risk phải cập nhật danh sách pump ở đây '
          'để chiều rộng route không tụt lại phía sau.',
    );
  });

  for (final contractId in contractIds) {
    testWidgets('$contractId: mọi route trong binding mở đúng màn hình', (
      tester,
    ) async {
      final binding = HighRiskFlowBindings.findByContractId(contractId);
      expect(binding, isNotNull, reason: 'Thiếu binding cho $contractId');

      for (final entry in distinctRoutesOf(binding!).entries) {
        await pumpRoute(tester, entry.key);
        expect(
          byRuntimeTypeName(entry.value),
          findsWidgets,
          reason:
              '$contractId: route ${entry.key} phải render ${entry.value} '
              '(binding stage tương ứng trong high_risk_flow_binding.dart)',
        );
      }
    });
  }
}
