import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
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
  testWidgets('VitSectionHeader renders plain title with default style', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const VitSectionHeader(title: 'Overview')));

    final text = tester.widget<Text>(find.text('Overview'));
    expect(text.style?.color, AppColors.text1);
    expect(text.style?.fontWeight, AppTextStyles.bold);
    expect(find.byType(DecoratedBox), findsNothing);
  });

  testWidgets('VitSectionHeader supports title style overrides', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitSectionHeader(
          title: 'Attribution',
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.extraBold,
          titleLetterSpacing: .2,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Attribution'));
    expect(text.style?.color, AppColors.text2);
    expect(text.style?.fontWeight, AppTextStyles.extraBold);
    expect(text.style?.letterSpacing, .2);
  });

  testWidgets('VitSectionHeader renders subtitle below title', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const VitSectionHeader(
          title: 'Deposit flow',
          subtitle: 'How funds move in',
          accentColor: AppColors.buy,
          variant: VitSectionHeaderVariant.markerTitle,
        ),
      ),
    );

    expect(find.text('Deposit flow'), findsOneWidget);
    expect(find.text('How funds move in'), findsOneWidget);

    final subtitle = tester.widget<Text>(find.text('How funds move in'));
    expect(subtitle.style?.color, AppColors.text3);
  });

  testWidgets('VitSectionHeader markerTitle variant renders a colored marker', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitSectionHeader(
          title: 'Leaderboard',
          variant: VitSectionHeaderVariant.markerTitle,
          accentColor: AppColors.warn,
        ),
      ),
    );

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as ShapeDecoration;
    expect(decoration.color, AppColors.warn);

    final title = tester.widget<Text>(find.text('Leaderboard'));
    expect(title.style?.fontSize, AppTextStyles.baseMedium.fontSize);
  });

  testWidgets('VitSectionHeader supports a custom icon size', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const VitSectionHeader(
          title: 'Giờ giao dịch',
          icon: Icons.schedule_rounded,
          iconColor: AppColors.buy,
          iconSize: AppSpacing.iconSm,
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.schedule_rounded));
    expect(icon.size, AppSpacing.iconSm);
    expect(icon.color, AppColors.buy);
  });
}
