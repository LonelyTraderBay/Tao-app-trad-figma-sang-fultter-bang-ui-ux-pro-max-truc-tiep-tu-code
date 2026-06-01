part of '../pages/referral_rules_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.color,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.x1,
          height: subtitle == null ? AppSpacing.x5 : AppSpacing.x6,
          margin: const EdgeInsets.only(top: AppSpacing.x1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.tierTableKey,
      clip: true,
      child: Column(
        children: [
          const _TierHeader(),
          for (var i = 0; i < snapshot.tiers.length; i++) ...[
            _TierRow(
              tier: snapshot.tiers[i],
              current: i == snapshot.currentTierIndex,
            ),
            if (i < snapshot.tiers.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.surface2),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Hạng',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Bạn bè',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Hoa hồng',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Thưởng KYC',
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
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

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.current});

  final ReferralTierRuleDraft tier;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tier.id) {
      'bronze' => Icons.workspace_premium_rounded,
      'silver' => Icons.workspace_premium_rounded,
      'gold' => Icons.military_tech_rounded,
      'diamond' => Icons.diamond_rounded,
      _ => Icons.auto_awesome_rounded,
    };

    return Container(
      key: ReferralRulesPage.tierKey(tier.id),
      color: current ? AppColors.primary08 : AppColors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: current ? AppColors.primary : AppColors.text2,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: current ? AppColors.primary : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        tier.nameEn,
                        style: AppTextStyles.micro.copyWith(
                          color: current ? AppColors.primary : AppColors.text3,
                        ),
                      ),
                      if (current)
                        Text(
                          'Hiện tại',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tier.minFriends == 0 ? '0' : '≥ ${tier.minFriends}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${tier.commissionPercent}%',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatUsd(tier.kycBonus),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardTypes extends StatelessWidget {
  const _RewardTypes({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralRulesPage.rewardTypesKey,
      children: [
        for (var i = 0; i < snapshot.rewardTypes.length; i++) ...[
          _RewardTypeCard(rule: snapshot.rewardTypes[i]),
          if (i < snapshot.rewardTypes.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RewardTypeCard extends StatelessWidget {
  const _RewardTypeCard({required this.rule});

  final ReferralRewardTypeRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final isKyc = rule.id == 'kyc_bonus';
    final color = isKyc ? AppColors.primary : AppColors.buy;
    return VitCard(
      key: ReferralRulesPage.rewardTypeKey(rule.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.iconLg + AppSpacing.x3,
            height: AppSpacing.iconLg + AppSpacing.x3,
            decoration: BoxDecoration(
              color: isKyc ? AppColors.primary12 : AppColors.buy10,
              borderRadius: AppRadii.mdRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              isKyc ? Icons.card_giftcard_rounded : Icons.trending_up_rounded,
              color: color,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.body,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isKyc ? AppColors.primary12 : AppColors.buy10,
                    borderRadius: AppRadii.xlRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x3,
                      vertical: AppSpacing.x2,
                    ),
                    child: Text(
                      rule.highlight,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
