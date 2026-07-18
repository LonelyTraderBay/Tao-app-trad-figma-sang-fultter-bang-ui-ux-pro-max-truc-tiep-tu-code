import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';

/// Device chrome frame (dynamic island + home indicator) that wraps [child]
/// for screenshot-friendly visual QA rendering ([ShellRenderMode.visualQa]).
class VitPhoneFrame extends StatelessWidget {
  const VitPhoneFrame({
    super.key,
    required this.child,
    this.showDynamicIsland = true,
    this.showHomeIndicator = true,
  });

  static const frameKey = Key('vit_phone_frame_surface');
  static const dynamicIslandKey = Key('vit_dynamic_island');
  static const homeIndicatorKey = Key('vit_home_indicator');

  final Widget child;
  final bool showDynamicIsland;
  final bool showHomeIndicator;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        gradient: AppGradients.frameOuter,
        shape: RoundedRectangleBorder(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameHeight = constraints.hasBoundedHeight
              ? math.max(DeviceMetrics.height, constraints.maxHeight)
              : DeviceMetrics.height;
          return Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: frameKey,
              width: DeviceMetrics.width,
              height: frameHeight,
              child: ColoredBox(
                color: AppColors.frameBg,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: child),
                    if (showDynamicIsland) const _DynamicIsland(),
                    if (showHomeIndicator) const _HomeIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      key: VitPhoneFrame.dynamicIslandKey,
      top: DeviceMetrics.dynamicIslandTop,
      left: (DeviceMetrics.width - DeviceMetrics.dynamicIslandWidth) / 2,
      child: SizedBox(
        width: DeviceMetrics.dynamicIslandWidth,
        height: DeviceMetrics.dynamicIslandHeight,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.dynamicIslandBg,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.divider),
              borderRadius: AppRadii.dynamicIslandRadius,
            ),
            shadows: [
              BoxShadow(
                color: AppColors.phoneChromeShadow,
                blurRadius: DeviceMetrics.phoneChromeShadowBlur,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: DeviceMetrics.dynamicIslandSensorLeft,
                top:
                    (DeviceMetrics.dynamicIslandHeight -
                        DeviceMetrics.dynamicIslandSensorSize) /
                    2,
                child: SizedBox.square(
                  dimension: DeviceMetrics.dynamicIslandSensorSize,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: AppColors.phoneSensor,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: DeviceMetrics.dynamicIslandLensRight,
                top:
                    (DeviceMetrics.dynamicIslandHeight -
                        DeviceMetrics.dynamicIslandLensSize) /
                    2,
                child: SizedBox.square(
                  dimension: DeviceMetrics.dynamicIslandLensSize,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.3, -0.3),
                        colors: [
                          AppColors.phoneLensStart,
                          AppColors.phoneLensMid,
                          AppColors.phoneLensEnd,
                        ],
                        stops: [0, 0.6, 1],
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      key: VitPhoneFrame.homeIndicatorKey,
      left: (DeviceMetrics.width - DeviceMetrics.homeBarWidth) / 2,
      bottom: DeviceMetrics.homeBarBottomInset,
      child: SizedBox(
        width: DeviceMetrics.homeBarWidth,
        height: DeviceMetrics.homeBarHeight,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.homeBar,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
          ),
        ),
      ),
    );
  }
}
