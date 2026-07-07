import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';

void main() {
  group('Stage 2 design tokens', () {
    test('map documented dark color values', () {
      expect(AppColors.bg, const Color(0xFF07090D));
      expect(AppColors.surface, const Color(0xFF10141B));
      expect(AppColors.surface2, const Color(0xFF171C24));
      expect(AppColors.surface3, const Color(0xFF222936));
      expect(AppColors.borderSolid, const Color(0xFF2D3440));
      expect(AppColors.primary, const Color(0xFFE58A00));
      expect(AppColors.primaryDark, const Color(0xFFB96000));
      expect(AppColors.primarySoft, const Color(0xFFF5A524));
      expect(AppColors.buy, const Color(0xFF10B981));
      expect(AppColors.sell, const Color(0xFFEF4444));
      // ignore: deprecated_member_use_from_same_package
      expect(AppColors.warn, const Color(0xFFF5A524));
      expect(AppColors.riskWarning, const Color(0xFFF0A63A));
      expect(AppColors.moduleAccentAmber, const Color(0xFFF5A524));
      expect(AppColors.accent, const Color(0xFF8B5CF6));
      expect(AppColors.text1, const Color(0xFFF5F7FA));
      expect(AppColors.text2, const Color(0xFFA7AFBF));
      expect(AppColors.text3, const Color(0xFF667085));
      expect(AppColors.statusBattery, const Color(0xFF34D399));
    });

    test('expose alpha helpers used by shared widgets', () {
      expect(AppColors.primary12, const Color(0x1FE58A00));
      expect(AppColors.buy15, const Color(0x2610B981));
      expect(AppColors.sell15, const Color(0x26EF4444));
      // ignore: deprecated_member_use_from_same_package
      expect(AppColors.warn08, const Color(0x14F5A524));
      expect(AppColors.riskWarning08, const Color(0x14F0A63A));
    });

    test('exposes a canonical module accent registry', () {
      expect(AppModuleAccents.registry['trade'], AppModuleAccents.trade);
      expect(AppModuleAccents.registry['earn'], AppModuleAccents.earn);
      expect(
        AppModuleAccents.registry['cross_module'],
        AppModuleAccents.crossModule,
      );
      expect(
        AppModuleAccents.forKey('prediction'),
        AppModuleAccents.predictions,
      );
      expect(AppModuleAccents.forKey('open-arena'), AppModuleAccents.arena);
      expect(AppModuleAccents.forKey('missing'), AppModuleAccents.neutral);
      expect(AppModuleAccents.keys, containsAll(['wallet', 'p2p', 'support']));
      expect(AppModuleAccents.arena, AppColors.moduleAccentAmber);
      expect(AppModuleAccents.p2p, AppColors.moduleAccentAmber);
    });

    test('exposes canonical asset color lookup', () {
      expect(AppAssetColors.registry['BTC'], AppAssetColors.btc);
      expect(AppAssetColors.registry['ETH'], AppAssetColors.eth);
      expect(AppAssetColors.forSymbol('bitcoin'), AppAssetColors.btc);
      expect(AppAssetColors.forSymbol('polygon'), AppAssetColors.matic);
      expect(AppAssetColors.forSymbol('unknown'), AppAssetColors.neutralChain);
    });

    test('exposes data visualization color roles', () {
      expect(AppDataVizColors.positive, AppColors.buy);
      expect(AppDataVizColors.negative, AppColors.sell);
      expect(AppDataVizColors.correlationVeryLow, AppAssetColors.cyanChain);
      expect(
        AppDataVizColors.correlation(.9),
        AppDataVizColors.correlationVeryHigh,
      );
      expect(
        AppDataVizColors.correlation(.2),
        AppDataVizColors.correlationVeryLow,
      );
    });

    test('map gradients, typography, spacing, radii, and device metrics', () {
      expect(AppGradients.navCenter.colors.last, const Color(0xFFB96000));
      expect(AppGradients.portfolio.colors, const [
        Color(0xFF1C140A),
        Color(0xFF11141A),
        Color(0xFF07090D),
      ]);
      expect(AppTextStyles.pageTitle.fontSize, 26);
      expect(AppTextStyles.heroNumber.fontFeatures, isNotEmpty);
      expect(AppSpacing.contentPad, 20);
      expect(AppRadii.card, 16);
      expect(DeviceMetrics.viewport, const Size(440, 956));
      expect(DeviceMetrics.safeTop, 59);
    });
  });
}
