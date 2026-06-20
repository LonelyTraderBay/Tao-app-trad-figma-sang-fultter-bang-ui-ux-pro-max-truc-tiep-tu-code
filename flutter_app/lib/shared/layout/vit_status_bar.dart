import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';

class VitStatusBar extends StatelessWidget {
  const VitStatusBar({super.key, this.time});

  final String? time;

  String _timeLabel() {
    if (time != null) return time!;
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DeviceMetrics.safeTop,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          DeviceMetrics.statusBarPadStart,
          0,
          DeviceMetrics.statusBarPadEnd,
          DeviceMetrics.statusBarPadBottom,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _timeLabel(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusBarText,
                fontWeight: AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CellSignalIcon(),
                SizedBox(width: DeviceMetrics.statusBarIconGap),
                Icon(
                  Icons.wifi_rounded,
                  color: AppColors.statusBarIcon,
                  size: DeviceMetrics.statusBarWifiIcon,
                ),
                SizedBox(width: DeviceMetrics.statusBarIconGap),
                _BatteryIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CellSignalIcon extends StatelessWidget {
  const _CellSignalIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: DeviceMetrics.statusCellSignalWidth,
      height: DeviceMetrics.statusCellSignalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _SignalBar(height: DeviceMetrics.statusSignalBarLow),
          SizedBox(width: DeviceMetrics.statusSignalBarGap),
          _SignalBar(height: DeviceMetrics.statusSignalBarMedium),
          SizedBox(width: DeviceMetrics.statusSignalBarGap),
          _SignalBar(height: DeviceMetrics.statusSignalBarHigh),
          SizedBox(width: DeviceMetrics.statusSignalBarGap),
          _SignalBar(
            height: DeviceMetrics.statusSignalBarFull,
            color: AppColors.statusBarIconDim,
          ),
        ],
      ),
    );
  }
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({
    required this.height,
    this.color = AppColors.statusBarIcon,
  });

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DeviceMetrics.statusSignalBarWidth,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.statusSignalRadius,
          ),
        ),
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: DeviceMetrics.statusBatteryWidth,
      height: DeviceMetrics.statusBatteryHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: DeviceMetrics.statusBatteryBodyWidth,
            height: DeviceMetrics.statusBatteryHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.statusBarIconDim),
                  borderRadius: AppRadii.statusBatteryBodyRadius,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(
                  DeviceMetrics.statusBatteryPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: DeviceMetrics.statusBatteryFillWidth,
                    height: double.infinity,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: AppColors.statusBattery,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.statusBatteryFillRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: DeviceMetrics.statusBatteryTerminalWidth,
            height: DeviceMetrics.statusBatteryTerminalHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.statusBarIconDim,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.statusBatteryTerminalRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
