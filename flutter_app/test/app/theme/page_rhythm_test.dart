import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';

void main() {
  test('page rhythm tokens align with VitPageRhythm metrics', () {
    expect(
      VitPageRhythm.compact.sectionGap,
      AppSpacing.pageRhythmCompactSectionGap,
    );
    expect(
      VitPageRhythm.compact.innerGap,
      AppSpacing.pageRhythmCompactInnerGap,
    );
    expect(
      VitPageRhythm.standard.sectionGap,
      AppSpacing.pageRhythmStandardSectionGap,
    );
    expect(VitPageRhythm.form.sectionGap, AppSpacing.pageRhythmFormSectionGap);
    expect(VitPageRhythm.flush.sectionGap, AppSpacing.zero);
  });

  test('home aliases point at compact page rhythm', () {
    expect(
      HomeSpacingTokens.homeSectionGap,
      AppSpacing.pageRhythmCompactSectionGap,
    );
    expect(
      HomeSpacingTokens.homeSectionInnerGap,
      AppSpacing.pageRhythmCompactInnerGap,
    );
  });
}
