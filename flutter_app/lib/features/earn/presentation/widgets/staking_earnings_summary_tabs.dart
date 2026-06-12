part of '../pages/staking_earnings_calendar_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.upcomingCount,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onExport,
  });

  final StakingEarningsCalendarSnapshot snapshot;
  final int upcomingCount;
  final bool notificationsEnabled;
  final VoidCallback onToggleNotifications;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sắp nhận (30 ngày tới)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '+${_formatUsd(snapshot.totalUpcomingUsd)}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              _SummaryActionButton(
                key: StakingEarningsCalendarPage.notificationKey,
                icon: notificationsEnabled
                    ? Icons.notifications_none_rounded
                    : Icons.notifications_off_outlined,
                active: notificationsEnabled,
                onTap: onToggleNotifications,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SummaryActionButton(
                key: StakingEarningsCalendarPage.exportKey,
                icon: Icons.file_download_outlined,
                onTap: onExport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '$upcomingCount sự kiện sắp tới'
                  '${notificationsEnabled ? ' · Nhận thông báo trước 24h' : ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryActionButton extends StatelessWidget {
  const _SummaryActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.buy : AppColors.text1;
    return Material(
      color: active ? AppColors.buy10 : AppColors.surface3,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? AppColors.buy20 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.xlRadius,
          ),
          child: SizedBox(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
        ),
      ),
    );
  }
}

class _CalendarTabs extends StatelessWidget {
  const _CalendarTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingAnalyticsTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.stakingEarningsTabHeight,
      child: ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x7),
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
              activeKey: active,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
