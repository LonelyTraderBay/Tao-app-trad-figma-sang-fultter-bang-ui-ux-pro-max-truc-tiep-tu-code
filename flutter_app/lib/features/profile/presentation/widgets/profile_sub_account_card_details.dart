part of '../pages/sub_account_page.dart';

class _SubAccountDetails extends StatelessWidget {
  const _SubAccountDetails({required this.account, required this.typeColor});

  final ProfileSubAccount account;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.profileSubAccountDetailsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSpacing.profileSubAccountDetailsDividerHeight,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.profileSubAccountDetailsTopGap),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Volume 30d',
                  value: _formatCompact(account.tradingVolume30d, prefix: r'$'),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _DetailMetric(
                  label: 'API Keys',
                  value: '${account.apiKeyCount}',
                  color: AppColors.warn,
                ),
              ),
              Expanded(
                child: _DetailMetric(
                  label: 'T\u1EA1o ng\u00E0y',
                  value: account.createdAt,
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.profileSubAccountDetailsMetricGap),
          Text(
            'Quy\u1EC1n h\u1EA1n:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(
            height: AppSpacing.profileSubAccountPermissionLabelGap,
          ),
          Wrap(
            spacing: AppSpacing.profileSubAccountPermissionGap,
            runSpacing: AppSpacing.profileSubAccountPermissionGap,
            children: [
              for (final permission in account.permissions)
                VitAccentPill(
                  label: _permissionLabel(permission),
                  accentColor: AppColors.text3,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.profileSubAccountEmailGap),
          Text.rich(
            TextSpan(
              text: 'Email: ',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              children: [
                TextSpan(
                  text: account.email,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.profileSubAccountActionsGap),
          Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Chuy\u1EC3n ti\u1EC1n',
                  color: AppColors.primary,
                  background: AppColors.primary08,
                ),
              ),
              const SizedBox(width: AppSpacing.profileSubAccountActionGap),
              Expanded(
                child: _ActionChip(
                  icon: Icons.key_rounded,
                  label: 'API Key',
                  color: AppColors.warn,
                  background: AppColors.warn08,
                ),
              ),
              const SizedBox(width: AppSpacing.profileSubAccountActionGap),
              Expanded(
                child: _ActionChip(
                  icon: Icons.settings_outlined,
                  label: 'C\u00E0i \u0111\u1EB7t',
                  color: AppColors.sell,
                  background: AppColors.sell10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.profileSubAccountDetailLabelGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.profileSubAccountActionHeight,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.profileSubAccountActionIcon,
            ),
            const SizedBox(width: AppSpacing.profileSubAccountActionIconGap),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
