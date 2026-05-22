import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/device_metrics.dart';

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
        padding: const EdgeInsets.only(left: 32, right: 28, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _timeLabel(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusBarText,
                fontFamily: 'Roboto',
                fontWeight: AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CellSignalIcon(),
                SizedBox(width: 6),
                Icon(
                  Icons.wifi_rounded,
                  color: AppColors.statusBarIcon,
                  size: 16,
                ),
                SizedBox(width: 6),
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
      width: 17,
      height: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _SignalBar(height: 3),
          SizedBox(width: 1.5),
          _SignalBar(height: 6),
          SizedBox(width: 1.5),
          _SignalBar(height: 9),
          SizedBox(width: 1.5),
          _SignalBar(height: 12, color: AppColors.statusBarIconDim),
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
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0.75),
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 13,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 23,
            height: 13,
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.statusBarIconDim),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 17,
                decoration: BoxDecoration(
                  color: AppColors.statusBattery,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Container(
            width: 3,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.statusBarIconDim,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }
}
