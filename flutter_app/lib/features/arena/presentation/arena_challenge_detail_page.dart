import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _ChallengeTab { rules, evidence, participants, activity }

class ArenaChallengeDetailPage extends ConsumerStatefulWidget {
  const ArenaChallengeDetailPage({
    super.key,
    required this.challengeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc190_challenge_detail_content');
  static const modeLinkKey = Key('sc190_mode_link');
  static const creatorKey = Key('sc190_creator');
  static const safetyKey = Key('sc190_safety');
  static const predictionKey = Key('sc190_prediction');
  static const evidenceCtaKey = Key('sc190_evidence_cta');
  static const reportKey = Key('sc190_report');
  static const blockKey = Key('sc190_block');

  static Key tabKey(String id) => Key('sc190_tab_$id');

  final String challengeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaChallengeDetailPage> createState() =>
      _ArenaChallengeDetailPageState();
}

class _ArenaChallengeDetailPageState
    extends ConsumerState<ArenaChallengeDetailPage> {
  _ChallengeTab _activeTab = _ChallengeTab.rules;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaChallengeDetail(widget.challengeId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-190 ArenaChallengeDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết challenge',
              subtitle: 'Thử thách · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaChallengeDetailPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _ChallengeIntro(
                        snapshot: snapshot,
                        onMode: () => _go(
                          AppRoutePaths.arenaMode(snapshot.challenge.modeId),
                        ),
                      ),
                      _LiveStatusCard(challenge: snapshot.challenge),
                      const _PoolFeeCard(),
                      _RewardCard(tiers: snapshot.rewardTiers),
                      _RefundCard(text: snapshot.challenge.refundPolicy),
                      _TeamsSection(teams: snapshot.teams),
                      _RuleSummaryCard(rows: snapshot.ruleRows),
                      _GovernanceCard(
                        challenge: snapshot.challenge,
                        rows: snapshot.governanceRows,
                      ),
                      _ClarityCard(score: snapshot.challenge.clarityScore),
                      _CreatorCard(
                        creator: snapshot.creator,
                        onTap: () => _go(
                          AppRoutePaths.arenaCreator(snapshot.creator.id),
                        ),
                      ),
                      _SafetyLinkCard(
                        onTap: () => _go(AppRoutePaths.arenaSafety),
                      ),
                      _Tabs(
                        active: _activeTab,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      _TabContent(snapshot: snapshot, active: _activeTab),
                      _WarningStack(
                        warnings: [
                          'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính.',
                          'Không thỏa thuận giao dịch ngoài nền tảng.',
                        ],
                      ),
                      _PredictionBridgeCard(
                        contextDraft: snapshot.predictionContext,
                        onTap: () => _go(
                          AppRoutePaths.marketsPredictionEvent(
                            snapshot.predictionContext.eventId,
                          ),
                        ),
                      ),
                      _SafetySnapshotCard(
                        rows: snapshot.safetyRows,
                        onSafety: () => _go(AppRoutePaths.arenaSafety),
                      ),
                      _ActionStack(
                        onEvidence: _showEvidenceSheet,
                        onReport: _showReportSheet,
                        onBlock: _showBlockSheet,
                        onLeave: _showLeaveSheet,
                      ),
                      _CommunityRulesLink(
                        onTap: () => _go(AppRoutePaths.arenaSafety),
                      ),
                      const _ArenaFooterNotice(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }

  void _showEvidenceSheet() => _showActionSheet(
    title: 'Gửi bằng chứng',
    icon: Icons.camera_alt_outlined,
    body:
        'Challenge này đang dùng API CoinGecko để chốt kết quả. Bạn vẫn có thể gửi ghi chú hoặc bằng chứng bổ sung nếu phát hiện sai lệch.',
  );

  void _showReportSheet() => _showActionSheet(
    title: 'Báo cáo challenge',
    icon: Icons.flag_outlined,
    body:
        'Báo cáo chỉ dùng cho nội dung, hành vi hoặc rule không rõ ràng. Không dùng để thay đổi kết quả nếu không có bằng chứng.',
  );

  void _showBlockSheet() => _showActionSheet(
    title: 'Chặn creator',
    icon: Icons.block_outlined,
    body:
        'Bạn sẽ không thấy lời mời hoặc room mới từ creator này trên bề mặt Open Arena.',
  );

  void _showLeaveSheet() => _showActionSheet(
    title: 'Rời challenge',
    icon: Icons.cancel_outlined,
    body:
        'Challenge đã bắt đầu nên entry points không được hoàn lại, trừ khi room bị void theo rule đã công bố.',
  );

  void _showActionSheet({
    required String title,
    required IconData icon,
    required String body,
  }) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: Colors.black.withValues(alpha: .55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x5,
            AppSpacing.x5,
            AppSpacing.x5,
            AppSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBubble(icon: icon, color: _arenaAccent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                body,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              VitCtaButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đã hiểu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeIntro extends StatelessWidget {
  const _ChallengeIntro({required this.snapshot, required this.onMode});

  final ArenaChallengeDetailSnapshot snapshot;
  final VoidCallback onMode;

  @override
  Widget build(BuildContext context) {
    final challenge = snapshot.challenge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            VitStatusPill(
              label: challenge.statusLabel,
              status: VitStatusPillStatus.success,
              icon: Icons.monitor_heart_outlined,
              size: VitStatusPillSize.sm,
              pulse: true,
            ),
            VitStatusPill(
              label: challenge.layoutLabel,
              status: VitStatusPillStatus.info,
              icon: Icons.groups_2_outlined,
              size: VitStatusPillSize.sm,
            ),
            VitStatusPill(
              label: challenge.privacyLabel,
              status: VitStatusPillStatus.neutral,
              icon: Icons.public_outlined,
              size: VitStatusPillSize.sm,
            ),
            const VitStatusPill(
              label: 'Points Only',
              status: VitStatusPillStatus.orange,
              icon: Icons.star_border_rounded,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          challenge.title,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text1,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        _InlineAction(
          key: ArenaChallengeDetailPage.modeLinkKey,
          label: challenge.modeName,
          icon: Icons.chevron_right_rounded,
          color: _arenaAccent,
          onTap: onMode,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          challenge.description,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _LiveStatusCard extends StatelessWidget {
  const _LiveStatusCard({required this.challenge});

  final ArenaChallengeDetailDraft challenge;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: 'Entry Points',
                  value: '${challenge.entryPoints}',
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Prize Pool',
                  value: _formatCompact(challenge.prizePool),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                size: 15,
                color: AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Đã kết thúc',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const _LiveDot(),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Live',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Đếm ngược',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                const Icon(
                  Icons.timer_outlined,
                  size: 15,
                  color: AppColors.sell,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  challenge.countdownLabel,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Người tham gia',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '${challenge.slotsFilled} / ${challenge.slotsTotal}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 8,
              value: challenge.fillPercent / 100,
              color: AppColors.sell,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PoolFeeCard extends StatelessWidget {
  const _PoolFeeCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _SmallIcon(
                icon: Icons.receipt_long_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Chi tiết Pool & Phí',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'MINH BẠCH',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(Icons.expand_more_rounded, color: AppColors.text3),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.tiers});

  final List<ArenaRewardTierDraft> tiers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SmallIcon(
                icon: Icons.workspace_premium_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Cách chia thưởng',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Winner Takes All',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final tier in tiers)
            Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.primary,
                    size: 17,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      tier.label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    tier.value,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
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

class _RefundCard extends StatelessWidget {
  const _RefundCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.sync_outlined,
      title: 'Chính sách hoàn điểm',
      text: text,
      color: AppColors.primary,
    );
  }
}

class _TeamsSection extends StatelessWidget {
  const _TeamsSection({required this.teams});

  final List<ArenaTeamDraft> teams;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VitModuleSectionHeader(
          title: 'Thành viên',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < teams.length; index++) ...[
              Expanded(child: _TeamCard(team: teams[index])),
              if (index != teams.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});

  final ArenaTeamDraft team;

  Color get _color =>
      team.accent == VitArenaTeamAccent.sol ? _arenaAccent : AppColors.sell;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _color.withValues(alpha: .34),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  team.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x1,
            runSpacing: AppSpacing.x1,
            children: [
              for (final member in team.members)
                _MemberChip(member: member, color: _color),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.member, required this.color});

  final ArenaTeamMemberDraft member;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InitialBadge(name: member.name, color: color),
          const SizedBox(width: AppSpacing.x1),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
              height: 1.2,
            ),
          ),
          if (member.role.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.x1),
            Text(
              member.role,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({required this.rows});

  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return _RowsSection(
      title: 'Tóm tắt luật chơi',
      accentColor: AppColors.buy,
      rows: rows,
    );
  }
}

class _GovernanceCard extends StatelessWidget {
  const _GovernanceCard({required this.challenge, required this.rows});

  final ArenaChallengeDetailDraft challenge;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.buy, size: 18),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Governance & Trust',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                label: challenge.trustRiskLabel,
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: challenge.policyVersion,
                status: VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value),
        ],
      ),
    );
  }
}

class _ClarityCard extends StatelessWidget {
  const _ClarityCard({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fact_check_outlined,
                color: AppColors.buy,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Rule Clarity Score',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 7,
              value: score / 100,
              color: AppColors.buy,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Text(
                '$score/100 - Rõ ràng',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Luật càng rõ, room càng tin tưởng',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator, required this.onTap});

  final ArenaChallengeCreatorDraft creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.creatorKey,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBubble(
            icon: Icons.workspace_premium_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creator.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    Text(
                      creator.role,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.buy,
                        size: 11,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Fair Play',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _SafetyLinkCard extends StatelessWidget {
  const _SafetyLinkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.safetyKey,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBubble(
            icon: Icons.health_and_safety_outlined,
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An toàn & báo cáo',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Quy tắc, report vi phạm',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final _ChallengeTab active;
  final ValueChanged<_ChallengeTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = [
      (_ChallengeTab.rules, 'Luật chơi', Icons.menu_book_outlined),
      (_ChallengeTab.evidence, 'Bằng chứng', Icons.camera_alt_outlined),
      (_ChallengeTab.participants, 'Thành viên', Icons.groups_2_outlined),
      (_ChallengeTab.activity, 'Hoạt động', Icons.timeline_outlined),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            VitStatusPill(
              key: ArenaChallengeDetailPage.tabKey(entries[index].$1.name),
              label: entries[index].$2,
              icon: entries[index].$3,
              status: active == entries[index].$1
                  ? VitStatusPillStatus.info
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.md,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(entries[index].$1);
              },
            ),
            if (index != entries.length - 1)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.snapshot, required this.active});

  final ArenaChallengeDetailSnapshot snapshot;
  final _ChallengeTab active;

  @override
  Widget build(BuildContext context) {
    return switch (active) {
      _ChallengeTab.rules => _RulesList(rules: snapshot.rules),
      _ChallengeTab.evidence => const _EvidencePanel(),
      _ChallengeTab.participants => _ParticipantsPanel(teams: snapshot.teams),
      _ChallengeTab.activity => _ActivityPanel(activity: snapshot.activity),
    };
  }
}

class _RulesList extends StatelessWidget {
  const _RulesList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (var index = 0; index < rules.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${index + 1}.',
                    style: AppTextStyles.caption.copyWith(
                      color: _arenaAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rules[index],
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (index != rules.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _EvidencePanel extends StatelessWidget {
  const _EvidencePanel();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.camera_alt_outlined,
      title: 'Bằng chứng',
      text:
          'Chưa có bằng chứng gửi từ app này. Kết quả chính dùng API CoinGecko và tự động đối soát.',
      color: _arenaAccent,
    );
  }
}

class _ParticipantsPanel extends StatelessWidget {
  const _ParticipantsPanel({required this.teams});

  final List<ArenaTeamDraft> teams;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final team in teams) ...[
            Row(
              children: [
                _InitialBadge(
                  name: team.name,
                  color: team.accent == VitArenaTeamAccent.sol
                      ? _arenaAccent
                      : AppColors.sell,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    team.name,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '${team.members.length} người',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            if (team != teams.last) const Divider(color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.activity});

  final List<String> activity;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final item in activity) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.buy),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != activity.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _WarningStack extends StatelessWidget {
  const _WarningStack({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < warnings.length; index++) ...[
          _InfoBanner(
            text: warnings[index],
            color: index == 0 ? AppColors.primary : AppColors.warn,
            icon: index == 0
                ? Icons.info_outline_rounded
                : Icons.warning_amber_rounded,
          ),
          if (index != warnings.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _PredictionBridgeCard extends StatelessWidget {
  const _PredictionBridgeCard({
    required this.contextDraft,
    required this.onTap,
  });

  final ArenaPredictionContextDraft contextDraft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.predictionKey,
      onTap: onTap,
      borderColor: _arenaAccent.withValues(alpha: .25),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: _arenaAccent,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: _arenaAccent,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Prediction Markets',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Bối cảnh thị trường',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contextDraft.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                'Xác suất "${contextDraft.outcomeName}":',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${contextDraft.probability}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 6,
              value: contextDraft.probability / 100,
              color: AppColors.sell,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _InlineAction(
            label: 'Xem thị trường dự đoán',
            icon: Icons.open_in_new_rounded,
            color: _arenaAccent,
            onTap: onTap,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Thông tin chỉ mang tính tham khảo. Arena Points và Prediction Markets là 2 hệ thống hoàn toàn riêng biệt.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetySnapshotCard extends StatelessWidget {
  const _SafetySnapshotCard({required this.rows, required this.onSafety});

  final List<ArenaRuleSummaryRow> rows;
  final VoidCallback onSafety;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.buy,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'An toàn nhanh',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value),
          const SizedBox(height: AppSpacing.x3),
          _InlineAction(
            label: 'An toàn & báo cáo',
            icon: Icons.flag_outlined,
            color: AppColors.sell,
            onTap: onSafety,
          ),
        ],
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.onEvidence,
    required this.onReport,
    required this.onBlock,
    required this.onLeave,
  });

  final VoidCallback onEvidence;
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            VitCard(
              width: 52,
              height: 52,
              radius: VitCardRadius.lg,
              onTap: () => HapticFeedback.selectionClick(),
              child: const Center(
                child: Icon(Icons.share_outlined, color: AppColors.text2),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaChallengeDetailPage.evidenceCtaKey,
                onPressed: onEvidence,
                leading: const Icon(Icons.camera_alt_outlined),
                child: const Text('Gửi bằng chứng'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                label: 'Rời',
                icon: Icons.cancel_outlined,
                color: AppColors.primary,
                onTap: onLeave,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.reportKey,
                label: 'Báo cáo',
                icon: Icons.flag_outlined,
                color: AppColors.sell,
                onTap: onReport,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.blockKey,
                label: 'Chặn',
                icon: Icons.block_outlined,
                color: AppColors.text3,
                onTap: onBlock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommunityRulesLink extends StatelessWidget {
  const _CommunityRulesLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.menu_book_outlined, size: 16),
        label: Text(
          'Quy tắc cộng đồng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RowsSection extends StatelessWidget {
  const _RowsSection({
    required this.title,
    required this.accentColor,
    required this.rows,
  });

  final String title;
  final Color accentColor;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitModuleSectionHeader(title: title, accentColor: accentColor),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (final row in rows)
                _SummaryRow(label: row.label, value: row.value),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                height: 1.4,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: AppSpacing.x1),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Icon(icon, color: color, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
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
      children: [
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.buy,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SmallIcon extends StatelessWidget {
  const _SmallIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: 17);
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

class _InitialBadge extends StatelessWidget {
  const _InitialBadge({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        initial,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ArenaFooterNotice extends StatelessWidget {
  const _ArenaFooterNotice();

  @override
  Widget build(BuildContext context) {
    return const _InfoBanner(
      text:
          'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
      icon: Icons.shield_outlined,
      color: _arenaAccent,
    );
  }
}

String _formatCompact(int value) {
  if (value >= 1000 && value % 1000 == 0) return '${value ~/ 1000}K';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return '$value';
}
