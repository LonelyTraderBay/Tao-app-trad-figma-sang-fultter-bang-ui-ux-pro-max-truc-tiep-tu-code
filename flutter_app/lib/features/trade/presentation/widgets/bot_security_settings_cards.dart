part of '../pages/bot_security_settings_page.dart';

class _TwoFaCard extends StatelessWidget {
  const _TwoFaCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.fromLTRB(20, 16, 17, 16),
      child: Row(
        children: [
          Icon(
            Icons.smartphone_rounded,
            color: enabled ? _securityGreen : AppColors.text3,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '2FA for Bot Actions',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Required for creating/deleting bots',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          _Switch(
            key: BotSecuritySettingsPage.twoFaToggleKey,
            enabled: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({required this.apiKey});

  final TradeBotApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 114),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apiKey.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                      decoration: BoxDecoration(
                        color: _securityPrimary.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        apiKey.permissions,
                        style: AppTextStyles.micro.copyWith(
                          color: _securityPrimary,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Created ${apiKey.created}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Last used: ${apiKey.lastUsed}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _IpCard extends StatelessWidget {
  const _IpCard({required this.entry});

  final TradeBotIpWhitelistEntry entry;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 63),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.ip,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${entry.label} - Added ${entry.added}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activities});

  final List<TradeBotSecurityActivity> activities;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          for (final activity in activities) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.action,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.medium,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color:
                        activity.status ==
                            TradeBotSecurityActivityStatus.success
                        ? _securityGreen
                        : _securityAmber,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            if (activity != activities.last) ...[
              const SizedBox(height: 14),
              const Divider(color: AppColors.borderSolid, height: 1),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }
}

class _SecurityTipsCard extends StatelessWidget {
  const _SecurityTipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _securityPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}
