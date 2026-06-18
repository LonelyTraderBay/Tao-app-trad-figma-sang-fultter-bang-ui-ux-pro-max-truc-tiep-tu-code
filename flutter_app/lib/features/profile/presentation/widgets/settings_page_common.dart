part of '../pages/settings_page.dart';

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SettingsPage.appInfoKey,
      height: AppSpacing.settingsAppInfoHeight,
      padding: AppSpacing.settingsAppInfoPadding,
      radius: VitCardRadius.lg,
      borderColor: _settingsBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TH\u00D4NG TIN \u1EE8NG D\u1EE4NG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.settingsAppInfoTitleGap),
          for (final row in rows) ...[
            SizedBox(
              height: AppSpacing.settingsAppInfoRowHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.settingsAppInfoValueGap),
                  Text(
                    row.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'bell' => Icons.notifications_none_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.circle_outlined,
  };
}
