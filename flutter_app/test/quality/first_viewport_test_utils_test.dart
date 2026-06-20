import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../helpers/first_viewport_test_utils.dart';

void main() {
  for (final viewport in VitFirstViewport.requiredPhones) {
    testWidgets(
      'first-viewport helpers validate route content at ${viewport.label}',
      (tester) async {
        configureFirstViewport(tester, viewport);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        label: 'SC-TEST Account Summary',
                        child: SizedBox(
                          height: 80,
                          child: Text('Account Summary'),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(onPressed: _noop, child: Text('Continue')),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: VitBottomNav(),
            ),
          ),
        );

        final viewportRect = firstViewportRect(tester);
        final navTop = firstViewportBottomNavTop(tester);
        final usableRect = firstViewportUsableRect(tester);

        expect(viewportRect.size, viewport.size);
        expect(navTop, lessThan(viewport.size.height));
        expect(usableRect.bottom, navTop);

        expectRouteSemanticInFirstViewport(
          tester,
          routeName: 'HarnessRoute',
          semanticLabel: 'SC-TEST Account Summary',
        );
        expectActionableInFirstViewport(
          tester,
          find.byType(ElevatedButton),
          routeName: 'HarnessRoute',
        );
      },
    );
  }
}

void _noop() {}
