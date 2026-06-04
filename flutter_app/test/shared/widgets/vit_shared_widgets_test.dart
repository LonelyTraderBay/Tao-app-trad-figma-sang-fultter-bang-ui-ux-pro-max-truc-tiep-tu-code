import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
  testWidgets('showVitBottomSheet opens and returns a typed value', (
    tester,
  ) async {
    Future<String?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showVitBottomSheet<String>(
                    context: context,
                    builder: (sheetContext) {
                      return SafeArea(
                        top: false,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop('selected'),
                          child: const Text('Choose value'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Choose value'), findsOneWidget);

    await tester.tap(find.text('Choose value'));
    await tester.pumpAndSettle();

    expect(await result, 'selected');
    expect(find.text('Choose value'), findsNothing);
  });

  testWidgets('VitCard supports tap and visual variants', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCard(
              padding: const EdgeInsets.all(16),
              onTap: () => taps++,
              child: const Text('standard card'),
            ),
            const SizedBox(height: 8),
            const VitCard(
              variant: VitCardVariant.hero,
              padding: EdgeInsets.all(16),
              child: Text('hero card'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('standard card'));
    await tester.pump();

    expect(taps, 1);
    expect(find.text('hero card'), findsOneWidget);

    final heroContainer = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('hero card'),
            matching: find.byType(Container),
          )
          .first,
    );
    final heroDecoration = heroContainer.decoration! as BoxDecoration;
    expect(heroDecoration.boxShadow, const [
      BoxShadow(
        color: AppColors.primary08,
        blurRadius: 12,
        spreadRadius: -4,
        offset: Offset(0, 4),
      ),
    ]);
  });

  testWidgets('VitCtaButton and VitIconButton expose action states', (
    tester,
  ) async {
    var ctaTaps = 0;
    var iconTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              onPressed: () => ctaTaps++,
              leading: const Icon(Icons.add_rounded),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
            VitIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () => iconTaps++,
            ),
            const SizedBox(height: 8),
            const VitCtaButton(loading: true, child: Text('Loading')),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pump();

    expect(ctaTaps, 1);
    expect(iconTaps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('VitSearchBar handles input, clear, and filter action', (
    tester,
  ) async {
    String query = '';
    var filters = 0;

    await tester.pumpWidget(
      _wrap(
        VitSearchBar(
          placeholder: 'Search assets',
          onChanged: (value) => query = value,
          onFilterTap: () => filters++,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'btc');
    await tester.pump();

    expect(query, 'btc');
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(query, '');

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump();

    expect(filters, 1);
  });

  testWidgets('VitInput renders label, affixes, errors, and password mode', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'secret');

    await tester.pumpWidget(
      _wrap(
        VitInput(
          controller: controller,
          label: 'Password',
          hintText: 'Enter password',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: const Icon(Icons.visibility_outlined),
          errorText: 'Required',
          obscureText: true,
        ),
      ),
    );

    expect(find.text('Password'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);

    final container = tester.widget<Container>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.border, isA<Border>());

    controller.dispose();
  });

  testWidgets('status and state primitives render shared Home-proof states', (
    tester,
  ) async {
    var retry = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitStatusPill(
              label: 'Live',
              status: VitStatusPillStatus.success,
              pulse: true,
              count: 3,
            ),
            const SizedBox(height: 8),
            const VitSkeletonList(rows: 2),
            const SizedBox(height: 8),
            const VitEmptyState(title: 'No assets'),
            const SizedBox(height: 8),
            VitErrorState(onAction: () => retry++),
            const SizedBox(height: 8),
            const VitOfflineBanner(detail: 'Updated 2 minutes ago.'),
          ],
        ),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    expect(find.text('No assets'), findsOneWidget);
    expect(find.text('Offline. Showing latest cached data.'), findsOneWidget);

    await tester.ensureVisible(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(retry, 1);
  });
}
