import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

final class AppGradients {
  const AppGradients._();

  static const LinearGradient navCenter = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient portfolio = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C140A), Color(0xFF11141A), AppColors.bg],
    stops: [0, 0.58, 1],
  );

  static const RadialGradient frameOuter = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.1,
    colors: [Color(0xFF17110A), Color(0xFF050607)],
    stops: [0, 0.7],
  );
}
