import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';

Future<T?> showVitBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = true,
  Color? backgroundColor,
  Color? barrierColor,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  bool enableDrag = true,
  bool isDismissible = true,
  bool useSafeArea = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor ?? AppColors.surface,
    barrierColor: barrierColor ?? AppColors.modalScrim,
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: AppRadii.lgCorner),
        ),
    constraints: constraints,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    useSafeArea: useSafeArea,
    builder: builder,
  );
}
