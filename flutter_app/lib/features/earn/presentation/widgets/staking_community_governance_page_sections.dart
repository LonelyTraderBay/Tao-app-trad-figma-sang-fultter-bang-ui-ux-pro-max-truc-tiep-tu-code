part of '../pages/staking_community_governance_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingCommunityGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCommunityGovernancePage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.how_to_vote_outlined,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingGovernanceInfoLineHeight,
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

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.title, required this.stats});

  final String title;
  final List<StakingGovernanceStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCommunityGovernancePage.overviewKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSpacing.stakingGovernanceGridColumns,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              childAspectRatio: AppSpacing.stakingGovernanceGridAspect,
            ),
            itemBuilder: (context, index) {
              return _StatTile(stat: stats[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingGovernanceStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    final icon = _statIcon(stat.label);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: _toneBorder(stat.tone),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x3),
          Text(
            stat.value,
            style: AppTextStyles.amountXs.copyWith(
              color: stat.tone == 'neutral' ? AppColors.text1 : color,
            ),
          ),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ActiveProposal extends StatelessWidget {
  const _ActiveProposal({required this.proposal, required this.onTap});

  final StakingGovernanceActiveProposalDraft proposal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.activeProposalKey,
      label: 'Active Proposals',
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      proposal.title,
                      style: AppTextStyles.baseMedium,
                    ),
                  ),
                  _Pill(
                    label: proposal.badge,
                    color: AppColors.primarySoft,
                    emphasis: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                proposal.body,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentDecisions extends StatelessWidget {
  const _RecentDecisions({required this.decisions});

  final List<StakingGovernanceDecisionDraft> decisions;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.decisionsKey,
      label: 'Recent Decisions',
      children: [
        for (final decision in decisions) _DecisionCard(decision: decision),
      ],
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({required this.decision});

  final StakingGovernanceDecisionDraft decision;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  decision.proposal,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${decision.votes} votes - ${decision.dateLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _Pill(label: decision.status, color: AppColors.buy, emphasis: true),
        ],
      ),
    );
  }
}

class _GovernanceSteps extends StatelessWidget {
  const _GovernanceSteps({required this.steps});

  final List<StakingGovernanceStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.stepsKey,
      label: 'How Governance Works',
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                _StepRow(step: steps[i]),
                if (i != steps.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.x3),
                    child: Divider(
                      height: AppSpacing.stakingGovernanceDividerHeight,
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final StakingGovernanceStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Text(
            '${step.step}',
            style: AppTextStyles.body.copyWith(
              color: AppColors.navCenterIcon,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.stakingGovernancePillLineHeight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(step.title, style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.stakingGovernanceStepLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
