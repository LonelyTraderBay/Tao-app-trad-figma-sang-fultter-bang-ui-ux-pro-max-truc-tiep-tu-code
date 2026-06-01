part of '../pages/staking_community_governance_page.dart';

class _VotingPower extends StatelessWidget {
  const _VotingPower({required this.power});

  final StakingGovernanceVotingPowerDraft power;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCommunityGovernancePage.votingPowerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: const BoxDecoration(
                  color: AppColors.accent12,
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.accent,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(power.title, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      power.body,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  power.value,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 26,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Text(
                      power.share,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onProposals, required this.onForum});

  final VoidCallback onProposals;
  final VoidCallback onForum;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: StakingCommunityGovernancePage.viewProposalsKey,
          onPressed: onProposals,
          child: const Text('View Active Proposals'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: StakingCommunityGovernancePage.joinForumKey,
          onPressed: onForum,
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Join Governance Forum'),
        ),
      ],
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCommunityGovernancePage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.emphasis = false,
  });

  final String label;
  final Color color;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: _softBackground(color),
        borderRadius: AppRadii.smRadius,
        border: emphasis ? Border.all(color: _softBorder(color)) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

IconData _statIcon(String label) {
  switch (label) {
    case 'Token Holders':
      return Icons.groups_2_outlined;
    case 'Active Voters':
      return Icons.how_to_vote_outlined;
    case 'Participation Rate':
      return Icons.trending_up_rounded;
    default:
      return Icons.check_circle_outline_rounded;
  }
}

Color _toneColor(String tone) {
  switch (tone) {
    case 'accent':
      return AppColors.accent;
    case 'success':
      return AppColors.buy;
    case 'warning':
      return AppColors.warn;
    default:
      return AppColors.text3;
  }
}

Color? _toneBorder(String tone) {
  switch (tone) {
    case 'accent':
      return AppColors.accent20;
    case 'success':
      return AppColors.buy20;
    case 'warning':
      return AppColors.warningBorder;
    default:
      return null;
  }
}

Color _softBackground(Color color) {
  if (color == AppColors.buy) return AppColors.buy10;
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return AppColors.primary12;
  }
  if (color == AppColors.sell) return AppColors.sell10;
  if (color == AppColors.accent) return AppColors.accent12;
  return AppColors.surface2;
}

Color _softBorder(Color color) {
  if (color == AppColors.buy) return AppColors.buy20;
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return AppColors.primary20;
  }
  if (color == AppColors.sell) return AppColors.sell20;
  if (color == AppColors.accent) return AppColors.accent20;
  return AppColors.cardBorder;
}
