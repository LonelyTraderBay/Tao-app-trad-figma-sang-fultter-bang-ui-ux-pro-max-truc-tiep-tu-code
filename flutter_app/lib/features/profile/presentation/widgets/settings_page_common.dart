part of '../pages/settings_page.dart';

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SettingsPage.appInfoKey,
      height: 164,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      radius: VitCardRadius.lg,
      borderColor: _settingsBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TH\u00D4NG TIN \u1EE8NG D\u1EE4NG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    row.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1,
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
