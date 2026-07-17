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
  testWidgets('VitDiscoveryActionCard renders badge action and tap', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitDiscoveryActionCard(
          title: 'Prediction Markets',
          badgeLabel: 'Prediction Market',
          subtitle: 'Probability markets',
          actionLabel: 'Explore',
          icon: Icons.adjust_rounded,
          accentColor: AppColors.accent,
          borderColor: AppColors.accent20,
          background: const LinearGradient(
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Prediction Market'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    await tester.tap(find.text('Prediction Markets'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('VitDiscoveryActionCard compact variant keeps action contract', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitDiscoveryActionCard(
          title: 'Open Arena',
          badgeLabel: 'Arena Points only',
          subtitle: 'Points-only room',
          actionLabel: 'Enter',
          icon: Icons.sports_esports_outlined,
          accentColor: AppColors.warn,
          borderColor: AppColors.warningBorder,
          background: const LinearGradient(
            colors: [AppColors.warn15, AppColors.warn10],
          ),
          variant: VitDiscoveryActionCardVariant.compact,
          onTap: () {},
        ),
      ),
    );

    final card = tester.widget<VitDiscoveryActionCard>(
      find.byType(VitDiscoveryActionCard),
    );

    expect(card.variant, VitDiscoveryActionCardVariant.compact);
    expect(find.text('Arena Points only'), findsOneWidget);
    expect(find.text('Enter'), findsOneWidget);
  });
}
