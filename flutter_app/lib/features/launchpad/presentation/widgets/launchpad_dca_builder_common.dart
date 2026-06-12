import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

enum LaunchpadDcaBuilderTab { strategies, history, create }

class LaunchpadDcaHeaderCreateButton extends StatelessWidget {
  const LaunchpadDcaHeaderCreateButton({
    super.key,
    required this.buttonKey,
    required this.onTap,
  });

  final Key buttonKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.launchpadBox36,
      height: AppSpacing.launchpadBox36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          key: buttonKey,
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.add_rounded,
            color: AppColors.text1,
            size: AppSpacing.launchpadIcon3xl,
          ),
        ),
      ),
    );
  }
}

class LaunchpadDcaTabs extends StatelessWidget {
  const LaunchpadDcaTabs({
    super.key,
    required this.tabsKey,
    required this.activeTab,
    required this.onChanged,
  });

  final Key tabsKey;
  final LaunchpadDcaBuilderTab activeTab;
  final ValueChanged<LaunchpadDcaBuilderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'strategies', label: 'Chien luoc'),
          VitTabItem(key: 'history', label: 'Lich su'),
          VitTabItem(key: 'create', label: 'Tao moi'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) =>
            onChanged(LaunchpadDcaBuilderTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

String launchpadDcaFormatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String launchpadDcaFormatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String launchpadDcaFrequencyLabel(LaunchpadDcaFrequency frequency) {
  return switch (frequency) {
    LaunchpadDcaFrequency.daily => 'Hang ngay',
    LaunchpadDcaFrequency.weekly => 'Hang tuan',
    LaunchpadDcaFrequency.biweekly => '2 tuan/lan',
    LaunchpadDcaFrequency.monthly => 'Hang thang',
  };
}

IconData launchpadDcaFrequencyIcon(LaunchpadDcaFrequency frequency) {
  return switch (frequency) {
    LaunchpadDcaFrequency.daily => Icons.calendar_view_day_outlined,
    LaunchpadDcaFrequency.weekly => Icons.calendar_view_week_outlined,
    LaunchpadDcaFrequency.biweekly => Icons.date_range_outlined,
    LaunchpadDcaFrequency.monthly => Icons.calendar_month_outlined,
  };
}
