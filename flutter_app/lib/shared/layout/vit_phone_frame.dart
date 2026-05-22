import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/device_metrics.dart';

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
      decoration: const BoxDecoration(gradient: AppGradients.frameOuter),
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
    return Positioned(
      key: VitPhoneFrame.dynamicIslandKey,
      top: DeviceMetrics.dynamicIslandTop,
      left: (DeviceMetrics.width - DeviceMetrics.dynamicIslandWidth) / 2,
      child: Container(
        width: DeviceMetrics.dynamicIslandWidth,
        height: DeviceMetrics.dynamicIslandHeight,
        decoration: BoxDecoration(
          color: AppColors.dynamicIslandBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x0DFFFFFF)),
          boxShadow: const [BoxShadow(color: Color(0xCC000000), blurRadius: 2)],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 22,
              top: (DeviceMetrics.dynamicIslandHeight - 5) / 2,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A0A0A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: (DeviceMetrics.dynamicIslandHeight - 12) / 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.3),
                    colors: [
                      Color(0xFF1A2540),
                      Color(0xFF0A0E1A),
                      Color(0xFF000000),
                    ],
                    stops: [0, 0.6, 1],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: VitPhoneFrame.homeIndicatorKey,
      left: (DeviceMetrics.width - DeviceMetrics.homeBarWidth) / 2,
      bottom: 8,
      child: Container(
        width: DeviceMetrics.homeBarWidth,
        height: DeviceMetrics.homeBarHeight,
        decoration: BoxDecoration(
          color: AppColors.homeBar,
          borderRadius: AppRadii.xsRadius,
        ),
      ),
    );
  }
}
