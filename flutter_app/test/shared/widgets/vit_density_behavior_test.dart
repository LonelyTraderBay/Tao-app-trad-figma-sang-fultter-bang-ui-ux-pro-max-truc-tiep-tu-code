import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shared primitives expose opt-in compact density', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var infoRowTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitPageContent(
              key: ValueKey('density_content'),
              density: VitDensity.compact,
              children: [
                Text('first compact section'),
                Text('second compact section'),
              ],
            ),
            const SizedBox(height: 8),
            const VitCard(
              key: ValueKey('density_card'),
              density: VitDensity.compact,
              child: Text('compact card'),
            ),
            const SizedBox(height: 8),
            const VitMetricCard(
              label: 'Compact metric',
              value: '\$12.4K',
              density: VitDensity.compact,
            ),
            const SizedBox(height: 8),
            const VitSectionHeader(
              title: 'Compact section',
              density: VitDensity.compact,
            ),
            const SizedBox(height: 8),
            VitInfoRow(
              label: 'Network',
              value: 'Ethereum',
              density: VitDensity.compact,
              leading: const Icon(Icons.account_tree_outlined),
              onTap: () => infoRowTaps++,
            ),
          ],
        ),
      ),
    );

    final contentPadding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_content')),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect(
      contentPadding.padding,
      const EdgeInsetsDirectional.only(
        start: AppSpacing.contentPad,
        end: AppSpacing.contentPad,
        top: AppSpacing.pageContentTopCompact,
      ),
    );

    final contentGap = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_content')),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(contentGap.height, AppSpacing.pageContentGapTight);

    final cardPadding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_card')),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect(cardPadding.padding, VitDensity.compact.cardPadding);
    expect(VitDensity.hero.pageContentGap, AppSpacing.pageContentGapDefault);
    expect(VitDensity.tool.cardVerticalPadding, AppSpacing.x2);
    expect(find.text('Compact section'), findsOneWidget);

    final infoRowBox = tester.widget<ConstrainedBox>(
      find
          .ancestor(
            of: find.text('Network'),
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
    expect(infoRowBox.constraints.minHeight, VitDensity.compact.controlHeight);

    await tester.tap(find.text('Network'));
    await tester.pump();

    expect(infoRowTaps, 1);
    final infoNode = tester.getSemantics(find.byType(VitInfoRow));
    expect(infoNode.label, 'Network, Ethereum');
    semantics.dispose();
  });
}
