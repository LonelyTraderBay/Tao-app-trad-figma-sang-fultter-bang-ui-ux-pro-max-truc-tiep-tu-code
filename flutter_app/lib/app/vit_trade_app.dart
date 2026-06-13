import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class VitTradeApp extends StatelessWidget {
  const VitTradeApp({super.key, this.routerConfig, this.shellRenderMode});

  final GoRouter? routerConfig;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    final resolvedShellRenderMode = shellRenderMode ?? defaultShellRenderMode();

    return ProviderScope(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bg,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: _VitTradeMaterialApp(
          routerConfig:
              routerConfig ??
              createAppRouter(shellRenderMode: resolvedShellRenderMode),
        ),
      ),
    );
  }
}

class _VitTradeMaterialApp extends StatelessWidget {
  const _VitTradeMaterialApp({this.routerConfig});

  final GoRouter? routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VitTrade Flutter',
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.sell,
          onPrimary: AppColors.navCenterIcon,
          onSecondary: AppColors.text1,
          onSurface: AppColors.text1,
          onError: AppColors.navCenterIcon,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.jumbo,
          displayMedium: AppTextStyles.display,
          displaySmall: AppTextStyles.amountLg,
          headlineLarge: AppTextStyles.amountLg,
          headlineMedium: AppTextStyles.heroNumber,
          headlineSmall: AppTextStyles.sectionTitle,
          titleLarge: AppTextStyles.sectionTitle,
          titleMedium: AppTextStyles.baseMedium,
          titleSmall: AppTextStyles.sectionTitleSm,
          bodySmall: AppTextStyles.captionSm,
          bodyMedium: AppTextStyles.body,
          bodyLarge: AppTextStyles.base,
          labelSmall: AppTextStyles.micro,
          labelMedium: AppTextStyles.badge,
          labelLarge: AppTextStyles.control,
        ),
      ),
    );
  }
}
