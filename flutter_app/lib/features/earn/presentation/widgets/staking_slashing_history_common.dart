import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

enum StakingSlashingTab { history, statistics, prevention }

final class StakingSlashingHistoryKeys {
  const StakingSlashingHistoryKeys._();

  static const info = Key('sc382_info');
  static const stats = Key('sc382_stats');
  static const tabs = Key('sc382_tabs');
  static const history = Key('sc382_history');
  static const statistics = Key('sc382_statistics');
  static const trend = Key('sc382_trend');
  static const prevention = Key('sc382_prevention');
  static const export = Key('sc382_export');
  static const footer = Key('sc382_footer');

  static Key tab(String id) => Key('sc382_tab_$id');
  static Key event(String id) => Key('sc382_event_$id');
}

class StakingSlashingExportButton extends StatelessWidget {
  const StakingSlashingExportButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryKeys.export,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.file_download_outlined,
            color: AppColors.text1,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StakingSlashingFooterNote extends StatelessWidget {
  const StakingSlashingFooterNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryKeys.footer,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

class StakingSlashingStatusPill extends StatelessWidget {
  const StakingSlashingStatusPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String stakingSlashingTabLabel(StakingSlashingTab tab) {
  return switch (tab) {
    StakingSlashingTab.history => 'History',
    StakingSlashingTab.statistics => 'Statistics',
    StakingSlashingTab.prevention => 'Prevention',
  };
}

Color stakingSlashingStatusColor(String status) {
  return switch (status) {
    'partial' => AppColors.warn,
    'uncovered' => AppColors.sell,
    _ => AppColors.buy,
  };
}

String stakingSlashingStatusLabel(String status) {
  return switch (status) {
    'partial' => 'Partially Covered',
    'uncovered' => 'Not Covered',
    _ => 'Fully Covered',
  };
}

Color stakingSlashingSeverityColor(String severity) {
  return switch (severity) {
    'critical' => AppColors.sell,
    'high' => AppColors.riskHigh,
    _ => AppColors.warn,
  };
}

String stakingSlashingCapitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String stakingSlashingFormatEth(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
