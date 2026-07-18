import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  testWidgets(
    'VitTaskCard intrinsic height fits claimed task without dead space',
    (tester) async {
      const legacyMinHeight =
          AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x5;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: VitTaskCard(
                  title: 'Giao dịch đầu tiên',
                  subtitle: 'Hoàn thành lệnh giao dịch đầu tiên trên sàn.',
                  progress: 1,
                  rewardLabel: '+500 điểm',
                  status: VitTaskCardStatus.claimed,
                  accentColor: AppColors.buy,
                  icon: Icons.task_alt_outlined,
                ),
              ),
            ),
          ),
        ),
      );

      final cardHeight = tester.getSize(find.byType(VitCard)).height;
      expect(
        cardHeight,
        lessThan(legacyMinHeight - 20),
        reason: 'Task card must not reserve legacy CTA minHeight dead space',
      );
      expect(cardHeight, greaterThan(90));
    },
  );
}
