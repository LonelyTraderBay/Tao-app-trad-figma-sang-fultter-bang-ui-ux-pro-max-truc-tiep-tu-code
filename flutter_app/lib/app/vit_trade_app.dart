import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../shared/layout/shell_render_mode.dart';
import 'router/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';

class VitTradeApp extends StatelessWidget {
  const VitTradeApp({super.key, this.routerConfig, this.shellRenderMode});

  final GoRouter? routerConfig;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    final resolvedShellRenderMode = shellRenderMode ?? defaultShellRenderMode();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
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
          bodySmall: AppTextStyles.caption,
          bodyMedium: AppTextStyles.body,
          bodyLarge: AppTextStyles.base,
          titleMedium: AppTextStyles.baseMedium,
          titleLarge: AppTextStyles.sectionTitle,
          headlineMedium: AppTextStyles.heroNumber,
        ),
      ),
    );
  }
}
