import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  testWidgets('VitTabBar variants render and dispatch changes', (tester) async {
    var selected = '';
    var pillActive = 'spot';
    var segmentActive = 'overview';
    var underlineActive = 'open';

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 360,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VitTabBar(
                    activeKey: pillActive,
                    onChanged: (key) {
                      selected = 'pill:$key';
                      setState(() => pillActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'spot',
                        label: 'Spot',
                        icon: Icons.show_chart_rounded,
                        widgetKey: Key('pill_spot'),
                      ),
                      VitTabItem(
                        key: 'margin',
                        label: 'Margin',
                        widgetKey: Key('pill_margin'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  VitTabBar(
                    variant: VitTabBarVariant.segment,
                    activeKey: segmentActive,
                    onChanged: (key) {
                      selected = 'segment:$key';
                      setState(() => segmentActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'overview',
                        label: 'Overview',
                        widgetKey: Key('segment_overview'),
                      ),
                      VitTabItem(
                        key: 'history',
                        label: 'History',
                        widgetKey: Key('segment_history'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  VitTabBar(
                    variant: VitTabBarVariant.underline,
                    activeKey: underlineActive,
                    onChanged: (key) {
                      selected = 'underline:$key';
                      setState(() => underlineActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'open',
                        label: 'Open',
                        widgetKey: Key('underline_open'),
                      ),
                      VitTabItem(
                        key: 'closed',
                        label: 'Closed',
                        widgetKey: Key('underline_closed'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(VitTabBar), findsNWidgets(3));
    expect(find.text('Spot'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pill_margin')));
    await tester.pump();
    expect(selected, 'pill:margin');

    await tester.tap(find.byKey(const Key('segment_history')));
    await tester.pump();
    expect(selected, 'segment:history');

    await tester.tap(find.byKey(const Key('underline_closed')));
    await tester.pump();
    expect(selected, 'underline:closed');
  });
}
