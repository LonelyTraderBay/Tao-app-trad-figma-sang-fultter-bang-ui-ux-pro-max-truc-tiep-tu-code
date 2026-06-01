part of '../pages/savings_notifications_page.dart';

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.snapshot,
    required this.settings,
    required this.enabledCount,
    required this.onToggle,
  });

  final SavingsNotificationsSnapshot snapshot;
  final List<SavingsNotificationSettingDraft> settings;
  final int enabledCount;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationsPage.settingsListKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SettingsSummary(
          title: snapshot.settingsTitle,
          subtitle:
              '${snapshot.settingsSubtitle} Đang bật $enabledCount/${settings.length} loại thông báo.',
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final priority in SavingsNotificationPriority.values) ...[
          _PrioritySection(
            priority: priority,
            settings: settings
                .where((setting) => setting.priority == priority)
                .toList(),
            onToggle: onToggle,
          ),
          if (priority != SavingsNotificationPriority.values.last)
            const SizedBox(height: AppSpacing.x5),
        ],
        const SizedBox(height: AppSpacing.x5),
        _Disclaimer(text: snapshot.disclaimer),
      ],
    );
  }
}

class _SettingsSummary extends StatelessWidget {
  const _SettingsSummary({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrioritySection extends StatelessWidget {
  const _PrioritySection({
    required this.priority,
    required this.settings,
    required this.onToggle,
  });

  final SavingsNotificationPriority priority;
  final List<SavingsNotificationSettingDraft> settings;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (settings.isEmpty) return const SizedBox.shrink();
    final color = _priorityColor(priority);
    return VitPageSection(
      label: _priorityLabel(priority),
      accentColor: color,
      children: [
        Column(
          children: [
            for (final setting in settings) ...[
              _SettingCard(
                key: SavingsNotificationsPage.settingKey(setting.id),
                setting: setting,
                color: color,
                onToggle: () => onToggle(setting.id),
              ),
              if (setting != settings.last)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    super.key,
    required this.setting,
    required this.color,
    required this.onToggle,
  });

  final SavingsNotificationSettingDraft setting;
  final Color color;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _settingsIcon(setting.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  setting.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _ToggleSwitch(on: setting.enabled, onTap: onToggle),
        ],
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 24,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: on ? AppColors.primary : AppColors.borderSolid,
            borderRadius: AppRadii.mdRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox(
              width: 16,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.onAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
