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
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Required for creating/deleting bots',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    VitStatusPill(
                      label: apiKey.permissions,
                      status: VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Created ${apiKey.created}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
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
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${entry.label} - Added ${entry.added}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 14,
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
                          fontWeight: AppTextStyles.medium,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          activity.status ==
                              TradeBotSecurityActivityStatus.success
                          ? _securityGreen
                          : _securityAmber,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(width: 8, height: 8),
                  ),
                ),
              ],
            ),
            if (activity != activities.last)
              const Divider(color: AppColors.borderSolid, height: 1),
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
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 14,
        children: [
          Text(
            'Security Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            customGap: 14,
            children: [for (final tip in tips) _SecurityTipRow(tip: tip)],
          ),
        ],
      ),
    );
  }
}

class _SecurityTipRow extends StatelessWidget {
  const _SecurityTipRow({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.35,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            tip,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
