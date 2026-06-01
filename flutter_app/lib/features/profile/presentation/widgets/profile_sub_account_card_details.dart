part of '../pages/sub_account_page.dart';

class _SubAccountDetails extends StatelessWidget {
  const _SubAccountDetails({required this.account, required this.typeColor});

  final ProfileSubAccount account;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 14),
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
          const SizedBox(height: 13),
          Text(
            'Quy\u1EC1n h\u1EA1n:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final permission in account.permissions)
                _SmallPill(
                  label: _permissionLabel(permission),
                  foreground: AppColors.text2,
                  background: AppColors.surface3.withValues(alpha: .72),
                  border: AppColors.cardBorder,
                ),
            ],
          ),
          const SizedBox(height: 13),
          Text.rich(
            TextSpan(
              text: 'Email: ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
              children: [
                TextSpan(
                  text: account.email,
                  style: const TextStyle(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
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
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.key_rounded,
                  label: 'API Key',
                  color: AppColors.warn,
                  background: AppColors.warn08,
                ),
              ),
              const SizedBox(width: 8),
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 12,
            height: 1,
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
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
