import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/core/utils/accent_tone.dart';

extension AccentToneColors on AccentTone {
  Color resolve() {
    return switch (this) {
      AccentTone.buy => AppColors.buy,
      AccentTone.buyDark => AppColors.buyDark,
      AccentTone.sell => AppColors.sell,
      AccentTone.warn => AppColors.warn,
      AccentTone.warn10 => AppColors.warn10,
      AccentTone.info => AppColors.info,
      AccentTone.accent => AppColors.accent,
      AccentTone.primary => AppColors.primary,
      AccentTone.primarySoft => AppColors.primarySoft,
      AccentTone.caution => AppColors.caution,
      AccentTone.text1 => AppColors.text1,
      AccentTone.text2 => AppColors.text2,
      AccentTone.text3 => AppColors.text3,
      AccentTone.medalSilverBlue => AppColors.medalSilverBlue,
      AccentTone.medalSilverBlue10 => AppColors.medalSilverBlue10,
      AccentTone.medalBronzeMuted => AppColors.medalBronzeMuted,
      AccentTone.medalBronzeMuted10 => AppColors.medalBronzeMuted10,
      AccentTone.tierPlatinum => AppColors.tierPlatinum,
    };
  }
}
