import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_notification_preferences_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsNotificationMasterSummaryCard extends StatelessWidget {
  const SavingsNotificationMasterSummaryCard({
    super.key,
    required this.masterEnabled,
    required this.enabledAlerts,
    required this.totalAlerts,
    required this.onChanged,
  });

  final bool masterEnabled;
  final int enabledAlerts;
  final int totalAlerts;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = masterEnabled ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: SavingsNotificationPreferencesKeys.summary,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          SizedBox.square(
            dimension: EarnSpacingTokens.savingsNotificationSummaryIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .14),
                shape: const CircleBorder(),
              ),
              child: Icon(
                masterEnabled
                    ? Icons.notifications_none_rounded
                    : Icons.notifications_off_outlined,
                color: color,
                size: EarnSpacingTokens.savingsNotificationSummaryIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  masterEnabled ? 'Thông báo đang bật' : 'Thông báo đã tắt',
                  style: savingsNotificationBodyBold.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '$enabledAlerts/$totalAlerts loại thông báo đang hoạt động',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SavingsNotificationTokenSwitch(
            key: SavingsNotificationPreferencesKeys.masterToggle,
            value: masterEnabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class SavingsNotificationQuickStats extends StatelessWidget {
  const SavingsNotificationQuickStats({
    super.key,
    required this.enabledChannels,
    required this.totalChannels,
    required this.digestFrequency,
    required this.quietHours,
  });

  final int enabledChannels;
  final int totalChannels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsNotificationPreferencesKeys.stats,
      children: [
        Expanded(
          child: SavingsNotificationStatTile(
            label: 'Kênh hoạt động',
            value: '$enabledChannels/$totalChannels',
            color: AppColors.text1,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: SavingsNotificationStatTile(
            label: 'Tần suất',
            value: savingsNotificationFrequencyLabel(digestFrequency),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: SavingsNotificationStatTile(
            label: 'Giờ im lặng',
            value: quietHours.enabled
                ? '${quietHours.startHour}h-${quietHours.endHour}h'
                : 'Tắt',
            color: quietHours.enabled ? AppColors.accent : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class SavingsNotificationStatTile extends StatelessWidget {
  const SavingsNotificationStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: savingsNotificationBodyBold.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class SavingsNotificationTabs extends StatelessWidget {
  const SavingsNotificationTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnHorizontalPaddingX4,
      child: VitSegmentedTabBar(
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
      ),
    );
  }
}
