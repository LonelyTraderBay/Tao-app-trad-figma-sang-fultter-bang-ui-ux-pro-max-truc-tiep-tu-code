part of '../pages/staking_notifications_page.dart';

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX4,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: AppSpacing.stakingNotificationsSwitchWidth,
          height: AppSpacing.stakingNotificationsSwitchHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: on ? AppColors.buy : AppColors.primary30,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
            ),
            child: Padding(
              padding: AppSpacing.earnPaddingX1,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                child: const SizedBox(
                  width: AppSpacing.stakingNotificationsSwitchThumb,
                  height: AppSpacing.stakingNotificationsSwitchThumb,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: AppColors.onAccent,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  const _PriorityPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.sell15,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          'Quan trọng',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.sell,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.stakingNotificationsPillLineHeight,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.13),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.30)),
          borderRadius: AppRadii.lgRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnLeftPaddingX2(
        true,
      ).add(AppSpacing.earnTopPaddingX1),
      child: SizedBox(
        width: AppSpacing.x2,
        height: AppSpacing.x2,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.primarySoft,
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }
}

Color _priorityColor(StakingNotificationPriority priority) {
  return switch (priority) {
    StakingNotificationPriority.high => AppColors.sell,
    StakingNotificationPriority.medium => AppColors.primarySoft,
    StakingNotificationPriority.low => AppColors.text3,
  };
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'calendar' => Icons.calendar_today_outlined,
    'trend' => Icons.trending_up_rounded,
    'reward' => Icons.attach_money_rounded,
    'zap' => Icons.bolt_rounded,
    'alert' => Icons.warning_amber_rounded,
    'clock' => Icons.schedule_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

Color _notificationColor(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => AppColors.primarySoft,
    StakingNotificationType.apyChange => AppColors.buy,
    StakingNotificationType.reward => AppColors.buy,
    StakingNotificationType.risk => AppColors.sell,
    StakingNotificationType.system => AppColors.primarySoft,
  };
}

IconData _notificationIcon(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => Icons.calendar_today_outlined,
    StakingNotificationType.apyChange => Icons.trending_up_rounded,
    StakingNotificationType.reward => Icons.attach_money_rounded,
    StakingNotificationType.risk => Icons.warning_amber_rounded,
    StakingNotificationType.system => Icons.bolt_rounded,
  };
}
