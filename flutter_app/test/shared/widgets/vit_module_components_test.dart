import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
  testWidgets('VitServiceTile corner badges keep clear of centered label', (
    tester,
  ) async {
    const tileWidth =
        (360 -
            AppSpacing.contentPad * 2 -
            AppSpacing.gridGap * (AppSpacing.serviceTileCrossAxisCount - 1)) /
        AppSpacing.serviceTileCrossAxisCount;

    for (final aspectRatio in [
      AppSpacing.serviceTileGridAspectStandard,
      AppSpacing.serviceTileGridAspectCompact,
    ]) {
      final tileHeight = tileWidth / aspectRatio;
      final density = aspectRatio == AppSpacing.serviceTileGridAspectCompact
          ? VitServiceTileDensity.compact
          : VitServiceTileDensity.standard;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: tileWidth,
                height: tileHeight,
                child: VitServiceTile(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Launchpad',
                  accentColor: AppColors.warn,
                  density: density,
                  badgeLabel: 'Token',
                  riskBadgeLabel: 'Rủi ro cao',
                ),
              ),
            ),
          ),
        ),
      );

      final labelRect = tester.getRect(find.text('Launchpad'));
      final riskRect = tester.getRect(find.text('Rủi ro cao'));
      final stateRect = tester.getRect(find.text('Token'));

      expect(
        labelRect.overlaps(riskRect),
        isFalse,
        reason: 'risk badge overlaps label at aspect $aspectRatio',
      );
      expect(
        labelRect.overlaps(stateRect),
        isFalse,
        reason: 'state badge overlaps label at aspect $aspectRatio',
      );
    }
  });

  testWidgets('VitServiceTile.fromAction renders label/badges and taps', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        VitServiceTile.fromAction(
          icon: Icons.bolt_rounded,
          label: 'Quick Buy',
          accentColor: AppColors.primary,
          badgeLabel: 'New',
          riskBadgeLabel: 'Rủi ro cao',
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Quick Buy'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Rủi ro cao'), findsOneWidget);

    await tester.tap(find.byType(VitServiceTile));
    expect(tapped, isTrue);
  });

  testWidgets('Vit module cards render labels and dispatch actions', (
    tester,
  ) async {
    var heroTaps = 0;
    var actionTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitModuleHeroCard(
              accentColor: AppColors.primary,
              onTap: () => heroTaps++,
              child: const Text('Arena points hero'),
            ),
            const SizedBox(height: 8),
            const VitMetricCard(
              label: 'Volume',
              value: '\$12.4K',
              trailing: Icon(Icons.trending_up_rounded),
            ),
            const SizedBox(height: 8),
            VitModuleSectionHeader(
              title: 'Quick actions',
              actionLabel: 'View all',
              onAction: () => actionTaps++,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Arena points hero'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('\$12.4K'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);

    await tester.tap(find.text('Arena points hero'));
    await tester.tap(find.text('View all'));
    await tester.pump();

    expect(heroTaps, 1);
    expect(actionTaps, 1);
  });

  testWidgets('VitModuleSectionHeader applies default bottomGap by density', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitModuleSectionHeader(title: 'Standard section'),
            Text('Body'),
            SizedBox(height: 16),
            VitModuleSectionHeader(
              title: 'Compact section',
              density: VitDensity.compact,
            ),
            Text('Compact body'),
          ],
        ),
      ),
    );

    final standardTop = tester.getTopLeft(find.text('Standard section'));
    final standardSize = tester.getSize(find.text('Standard section'));
    final body = tester.getTopLeft(find.text('Body'));
    expect(
      body.dy - (standardTop.dy + standardSize.height),
      AppSpacing.pageRhythmStandardInnerGap,
    );

    final compactTop = tester.getTopLeft(find.text('Compact section'));
    final compactSize = tester.getSize(find.text('Compact section'));
    final compactBody = tester.getTopLeft(find.text('Compact body'));
    expect(
      compactBody.dy - (compactTop.dy + compactSize.height),
      AppSpacing.pageRhythmCompactInnerGap,
    );
  });
}
