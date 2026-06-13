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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingVotingPage extends ConsumerStatefulWidget {
  const StakingVotingPage({super.key, this.proposalId, this.shellRenderMode});

  static const proposalKey = Key('sc390_proposal');
  static const resultsKey = Key('sc390_results');
  static const castVoteKey = Key('sc390_cast_vote');
  static const noteKey = Key('sc390_voting_power_note');
  static const submitKey = Key('sc390_submit_vote');

  static Key optionKey(String id) => Key('sc390_vote_option_$id');

  final String? proposalId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingVotingPage> createState() => _StakingVotingPageState();
}

class _StakingVotingPageState extends ConsumerState<StakingVotingPage> {
  String? _selectedVote;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingVotingRepositoryProvider)
        .getVoting(proposalId: widget.proposalId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-390 StakingVotingPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      VitPageContent(
                        padding: VitContentPadding.relaxed,
                        gap: VitContentGap.relaxed,
                        children: [
                          _ProposalSummary(snapshot: snapshot),
                          _ResultsSection(results: snapshot.results),
                          _VoteSection(
                            title: snapshot.voteTitle,
                            options: snapshot.options,
                            selectedVote: _selectedVote,
                            onSelect: (id) =>
                                setState(() => _selectedVote = id),
                          ),
                          _VotingPowerNote(snapshot: snapshot),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      VitStickyFooter(
                        child: VitCtaButton(
                          key: StakingVotingPage.submitKey,
                          onPressed: _selectedVote == null ? null : () {},
                          child: Text(snapshot.submitLabel),
                        ),
                      ),
                      SizedBox(height: bottomInset),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProposalSummary extends StatelessWidget {
  const _ProposalSummary({required this.snapshot});

  final StakingVotingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingVotingPage.proposalKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Pill(label: snapshot.category),
          const SizedBox(height: AppSpacing.x4),
          Text(snapshot.proposalTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x2),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.x6),
            child: Text(
              snapshot.proposalBody,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.stakingCommunityBodyLineHeight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  snapshot.proposedByLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.proposedBy,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
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

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({required this.results});

  final List<StakingVotingResultDraft> results;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingVotingPage.resultsKey,
      label: 'Current Results',
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x5,
          ),
          child: Column(
            children: [
              for (var index = 0; index < results.length; index++) ...[
                _ResultRow(result: results[index]),
                if (index != results.length - 1)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});

  final StakingVotingResultDraft result;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(result.tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${result.label} (${result.percent}%)',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '${_formatInt(result.votes)} votes',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: SizedBox(
            height: AppSpacing.x2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: result.id == 'yes'
                    ? 1
                    : result.percent.clamp(0, 100) / 100,
                child: SizedBox.expand(
                  child: DecoratedBox(decoration: BoxDecoration(color: color)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VoteSection extends StatelessWidget {
  const _VoteSection({
    required this.title,
    required this.options,
    required this.selectedVote,
    required this.onSelect,
  });

  final String title;
  final List<StakingVotingOptionDraft> options;
  final String? selectedVote;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingVotingPage.castVoteKey,
      label: title,
      children: [
        Row(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              Expanded(
                child: _VoteOptionCard(
                  option: options[index],
                  selected: selectedVote == options[index].id,
                  onTap: () => onSelect(options[index].id),
                ),
              ),
              if (index != options.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _VoteOptionCard extends StatelessWidget {
  const _VoteOptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final StakingVotingOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(option.tone);
    return VitCard(
      key: StakingVotingPage.optionKey(option.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x5,
      ),
      borderColor: selected ? color : AppColors.cardBorder,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            option.id == 'yes'
                ? Icons.thumb_up_alt_outlined
                : Icons.thumb_down_alt_outlined,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            option.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? color : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _VotingPowerNote extends StatelessWidget {
  const _VotingPowerNote({required this.snapshot});

  final StakingVotingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingVotingPage.noteKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${snapshot.votingPowerPrefix} '),
                  TextSpan(
                    text: snapshot.votingPower,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: ' ${snapshot.votingPowerSuffix}'),
                ],
              ),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.stakingCommunityDescriptionLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

Color _toneColor(String tone) {
  switch (tone) {
    case 'success':
      return AppColors.buy;
    case 'danger':
      return AppColors.sell;
    default:
      return AppColors.primary;
  }
}

String _formatInt(int value) {
  final source = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < source.length; i++) {
    final remaining = source.length - i;
    buffer.write(source[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
