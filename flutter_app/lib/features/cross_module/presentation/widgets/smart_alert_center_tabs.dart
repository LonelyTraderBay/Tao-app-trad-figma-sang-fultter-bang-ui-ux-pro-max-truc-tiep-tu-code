part of '../pages/smart_alert_center.dart';

class _SmartAlertTabs extends StatelessWidget {
  const _SmartAlertTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SmartAlertTabDraft> tabs;
  final SmartAlertTab active;
  final ValueChanged<SmartAlertTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.crossModuleTabBarPadding,
            child: Row(
              children: [
                for (final tab in tabs)
                  Expanded(
                    child: InkWell(
                      key: SmartAlertCenter.tabKey(tab.tab),
                      onTap: () => onChanged(tab.tab),
                      child: Column(
                        children: [
                          Padding(
                            padding: AppSpacing.crossModuleTabLabelPadding,
                            child: Text(
                              tab.label,
                              style: AppTextStyles.caption.copyWith(
                                color: tab.tab == active
                                    ? AppColors.primary
                                    : AppColors.text3,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppSpacing.buttonHero,
                            height: AppSpacing.x1,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                end: tab.tab == active ? 1 : 0,
                              ),
                              duration: const Duration(milliseconds: 160),
                              builder: (context, value, child) =>
                                  Transform.scale(scaleX: value, child: child),
                              child: const DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadii.xlRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}

class _ActiveAlertsTab extends StatelessWidget {
  const _ActiveAlertsTab({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SmartAlertSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Canh bao hoat dong',
          children: [
            for (final alert in snapshot.alerts) _SmartAlertCard(alert: alert),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const _CreateAlertButton(),
        const SizedBox(height: AppSpacing.x4),
        _InfoPanel(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
          text:
              'Smart alerts work across all modules. Set conditions and get notified via push, email, or SMS.',
        ),
      ],
    );
  }
}

class _SmartAlertSummaryCard extends StatelessWidget {
  const _SmartAlertSummaryCard({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.crossModuleCardPadding,
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.notifications_none_rounded,
                color: AppColors.primary,
                background: AppColors.primary12,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${snapshot.alerts.length} total alerts',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricColumn(
                  label: 'Active',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Modules',
                  value: '${snapshot.moduleCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
