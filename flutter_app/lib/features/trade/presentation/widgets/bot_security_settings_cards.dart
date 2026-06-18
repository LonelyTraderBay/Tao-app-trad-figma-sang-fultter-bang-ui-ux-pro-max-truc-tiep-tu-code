part of '../pages/bot_security_settings_page.dart';

class _TwoFaCard extends StatelessWidget {
  const _TwoFaCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotSecurityCardMinHeight,
      ),
      padding: AppSpacing.tradeBotCardPadding,
      child: Row(
        children: [
          Icon(
            Icons.smartphone_rounded,
            color: enabled ? _securityGreen : AppColors.text3,
            size: AppSpacing.tradeBotCheckbox,
          ),
          const SizedBox(width: AppSpacing.tradeBotPageTopGap),
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
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  'Required for creating/deleting bots',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
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
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotApiKeyCardMinHeight,
      ),
      padding: AppSpacing.tradeBotCardPaddingLoose,
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
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                Row(
                  children: [
                    VitStatusPill(
                      label: apiKey.permissions,
                      status: VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                    const SizedBox(width: AppSpacing.tradeBotSmallGap),
                    Flexible(
                      child: Text(
                        'Created ${apiKey.created}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeBotContentGap),
                Text(
                  'Last used: ${apiKey.lastUsed}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: AppSpacing.tradeBotQuestionIcon,
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
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotIpCardMinHeight,
      ),
      padding: AppSpacing.tradeBotOptionPadding,
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
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  '${entry.label} - Added ${entry.added}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: AppSpacing.iconSm,
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
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.tradeBotPageTopGap,
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
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.tradeBotSmallGap),
                      Text(
                        activity.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.circle,
                  color:
                      activity.status == TradeBotSecurityActivityStatus.success
                      ? _securityGreen
                      : _securityAmber,
                  size: AppSpacing.tradeBotSmallGap,
                ),
            ],
          ),
          if (activity != activities.last)
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.tradeBotLineHeightTight,
              ),
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
      padding: AppSpacing.tradeBotCardPaddingTall,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.tradeBotPageTopGap,
        children: [
          Text(
            'Security Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            customGap: AppSpacing.tradeBotPageTopGap,
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
            height: AppSpacing.tradeBotLineHeightBody,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            tip,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightBody,
            ),
          ),
        ),
      ],
    );
  }
}
