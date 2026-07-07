// Pixel baselines for the shared widgets extracted from Home in Phase 1 of
// the "home is the mandatory UI standard" migration (VitServiceTile.fromAction,
// VitBalanceBreakdownRow, VitRiskDisclaimerNote) — other modules adopting
// these should render identically to these baselines. Regenerate with the
// same Flutter version used in CI:
// `flutter test --update-goldens test/features/home/golden/`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(
  Widget child, {
  double width = 200,
  double height = 140,
  double padding = 12,
}) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('golden: VitServiceTile.fromAction', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitServiceTile.fromAction(
          icon: Icons.bolt_rounded,
          label: 'Quick Buy',
          accentColor: AppColors.primary,
          badgeLabel: 'New',
          onTap: () {},
        ),
        width: 120,
        height: 120,
      ),
    );

    await expectLater(
      find.byType(VitServiceTile),
      matchesGoldenFile('goldens/vit_service_tile_from_action.png'),
    );
  });

  testWidgets('golden: VitBalanceBreakdownRow', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitBalanceBreakdownRow(
          onNavigate: (_) {},
          items: const [
            VitBalanceBreakdownItem(
              label: 'Spot',
              value: '\$1,234.56',
              icon: Icons.swap_horiz_rounded,
              tooltip: 'Spot wallet',
              route: '/wallet',
            ),
            VitBalanceBreakdownItem(
              label: 'Earn',
              value: '\$500.00',
              icon: Icons.savings_outlined,
              tooltip: 'Earn wallet',
              route: '/earn',
            ),
            VitBalanceBreakdownItem(
              label: 'Funding',
              value: '\$88.00',
              icon: Icons.account_balance_outlined,
              tooltip: 'Funding wallet',
              route: '/wallet/transfer',
            ),
          ],
        ),
        width: 328,
        height: 90,
        padding: 0,
      ),
    );

    await expectLater(
      find.byType(VitBalanceBreakdownRow),
      matchesGoldenFile('goldens/vit_balance_breakdown_row.png'),
    );
  });

  testWidgets('golden: VitRiskDisclaimerNote', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const VitRiskDisclaimerNote(
          message:
              'Predictions sử dụng vị thế thực. Arena sử dụng Points (không phải tiền thật).',
        ),
        width: 320,
        height: 60,
      ),
    );

    await expectLater(
      find.byType(VitRiskDisclaimerNote),
      matchesGoldenFile('goldens/vit_risk_disclaimer_note.png'),
    );
  });
}
