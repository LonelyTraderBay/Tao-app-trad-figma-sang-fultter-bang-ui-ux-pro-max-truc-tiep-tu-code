import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

/// Cross-app page spacing tier. Parent [VitPageContent] owns [sectionGap];
/// section widgets own [innerGap].
enum VitPageRhythm { compact, standard, form, relaxed, flush }

extension VitPageRhythmMetrics on VitPageRhythm {
  double get sectionGap {
    switch (this) {
      case VitPageRhythm.compact:
        return AppSpacing.pageRhythmCompactSectionGap;
      case VitPageRhythm.standard:
        return AppSpacing.pageRhythmStandardSectionGap;
      case VitPageRhythm.form:
        return AppSpacing.pageRhythmFormSectionGap;
      case VitPageRhythm.relaxed:
        return AppSpacing.pageRhythmRelaxedSectionGap;
      case VitPageRhythm.flush:
        return AppSpacing.zero;
    }
  }

  double get innerGap {
    switch (this) {
      case VitPageRhythm.compact:
        return AppSpacing.pageRhythmCompactInnerGap;
      case VitPageRhythm.standard:
        return AppSpacing.pageRhythmStandardInnerGap;
      case VitPageRhythm.form:
        return AppSpacing.pageRhythmFormInnerGap;
      case VitPageRhythm.relaxed:
        return AppSpacing.pageRhythmRelaxedInnerGap;
      case VitPageRhythm.flush:
        return AppSpacing.zero;
    }
  }
}
