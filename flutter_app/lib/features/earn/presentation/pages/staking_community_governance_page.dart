import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingCommunityGovernancePage extends ConsumerWidget {
  const StakingCommunityGovernancePage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc388_info');
  static const overviewKey = Key('sc388_overview');
  static const activeProposalKey = Key('sc388_active_proposal');
  static const decisionsKey = Key('sc388_decisions');
  static const stepsKey = Key('sc388_steps');
  static const votingPowerKey = Key('sc388_voting_power');
  static const viewProposalsKey = Key('sc388_view_proposals');
  static const joinForumKey = Key('sc388_join_forum');
  static const footerKey = Key('sc388_footer');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingCommunityGovernanceRepositoryProvider)
        .getGovernance();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-388 StakingCommunityGovernancePage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _OverviewCard(
                      title: snapshot.statsTitle,
                      stats: snapshot.stats,
                    ),
                    _ActiveProposal(
                      proposal: snapshot.activeProposal,
                      onTap: () => context.go(snapshot.proposalsRoute),
                    ),
                    _RecentDecisions(decisions: snapshot.recentDecisions),
                    _GovernanceSteps(steps: snapshot.governanceSteps),
                    _VotingPower(power: snapshot.votingPower),
                    _ActionButtons(
                      onProposals: () => context.go(snapshot.proposalsRoute),
                      onForum: () => context.go(snapshot.forumRoute),
                    ),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                    height: 1.55,
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
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              childAspectRatio: 1.75,
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
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.tone == 'neutral' ? AppColors.text1 : color,
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
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
                    child: Divider(height: 1, color: AppColors.divider),
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
              height: 1,
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
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
