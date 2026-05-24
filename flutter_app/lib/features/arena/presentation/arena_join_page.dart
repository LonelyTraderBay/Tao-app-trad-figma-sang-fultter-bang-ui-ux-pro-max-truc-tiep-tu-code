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

class ArenaJoinPage extends ConsumerStatefulWidget {
  const ArenaJoinPage({
    super.key,
    required this.challengeId,
    this.shellRenderMode,
  });

  final String challengeId;
  final ShellRenderMode? shellRenderMode;

  static const contentKey = Key('sc191_join_content');
  static const safetyPolicyKey = Key('sc191_safety_policy');
  static const rulesCheckboxKey = Key('sc191_rules_checkbox');
  static const pointsCheckboxKey = Key('sc191_points_checkbox');
  static const confirmKey = Key('sc191_confirm_join');
  static const declineKey = Key('sc191_decline_join');

  @override
  ConsumerState<ArenaJoinPage> createState() => _ArenaJoinPageState();
}

class _ArenaJoinPageState extends ConsumerState<ArenaJoinPage> {
  bool _readRules = false;
  bool _understandPoints = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaJoin(widget.challengeId);
    final challenge = snapshot.challenge;
    final hasEnough = snapshot.currentBalance >= challenge.entryPoints;
    final remainingBalance = snapshot.currentBalance - challenge.entryPoints;
    final canJoin = hasEnough && _readRules && _understandPoints;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-191 ArenaJoinPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tham gia challenge',
              subtitle: 'Đăng ký · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ArenaJoinPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: DeviceMetrics.width,
                  ),
                  child: VitPageContent(
                    children: [
                      _ChallengeSummaryCard(challenge: challenge),
                      _RoomInfoCard(challenge: challenge),
                      _CreatorCard(creator: snapshot.creator),
                      _RulesCard(rules: snapshot.rules),
                      _BalanceCard(
                        currentBalance: snapshot.currentBalance,
                        entryPoints: challenge.entryPoints,
                        remainingBalance: remainingBalance,
                        hasEnough: hasEnough,
                      ),
                      _NoticeCard(text: snapshot.refundNotice),
                      _SafetyPolicyLink(
                        onTap: () => _go(AppRoutePaths.arenaSafety),
                      ),
                      _AcknowledgementStack(
                        readRules: _readRules,
                        understandPoints: _understandPoints,
                        onRules: () => _toggleRules(),
                        onPoints: () => _togglePoints(),
                      ),
                      _ActionStack(
                        entryPoints: challenge.entryPoints,
                        canJoin: canJoin,
                        onConfirm: _confirmJoin,
                        onDecline: _decline,
                      ),
                      const SizedBox(
                        height:
                            DeviceMetrics.nativeBottomChrome + AppSpacing.x6,
                      ),
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

  void _toggleRules() {
    HapticFeedback.selectionClick();
    setState(() => _readRules = !_readRules);
  }

  void _togglePoints() {
    HapticFeedback.selectionClick();
    setState(() => _understandPoints = !_understandPoints);
  }

  void _confirmJoin() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.arenaChallenge(widget.challengeId));
  }

  void _decline() {
    HapticFeedback.selectionClick();
    _close();
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
    context.go(AppRoutePaths.arenaChallenge(widget.challengeId));
  }
}

class _ChallengeSummaryCard extends StatelessWidget {
  const _ChallengeSummaryCard({required this.challenge});

  final ArenaChallengeDetailDraft challenge;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                challenge.modeName,
                style: AppTextStyles.caption.copyWith(
                  color: _arenaAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '·',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              Text(
                challenge.layoutLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomInfoCard extends StatelessWidget {
  const _RoomInfoCard({required this.challenge});

  final ArenaChallengeDetailDraft challenge;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          _InfoRow(
            label: 'Quyền riêng tư',
            value: challenge.privacyLabel,
            icon: Icons.public_rounded,
          ),
          _InfoRow(
            label: 'Người tham gia',
            value: '${challenge.slotsFilled}/${challenge.slotsTotal}',
          ),
          _InfoRow(label: 'Kết thúc', value: challenge.countdownLabel),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: AppSpacing.x1),
          ],
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator});

  final ArenaChallengeCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.mdRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: _arenaAccent,
            ),
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
                Text(
                  creator.role,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    final visibleRules = rules.take(4).toList();
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tóm tắt luật',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var i = 0; i < visibleRules.length; i++) ...[
            _RuleLine(index: i + 1, text: visibleRules[i]),
            if (i != visibleRules.length - 1)
              const SizedBox(height: AppSpacing.x2),
          ],
          if (rules.length > visibleRules.length) ...[
            const SizedBox(height: AppSpacing.x2),
            Text(
              '+${rules.length - visibleRules.length} luật khác',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$index.',
            style: AppTextStyles.caption.copyWith(
              color: _arenaAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.currentBalance,
    required this.entryPoints,
    required this.remainingBalance,
    required this.hasEnough,
  });

  final int currentBalance;
  final int entryPoints;
  final int remainingBalance;
  final bool hasEnough;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          _BalanceRow(
            label: 'Số dư Arena Points',
            value: '${_formatPoints(currentBalance)} pts',
            color: hasEnough ? AppColors.buy : AppColors.sell,
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _BalanceRow(
            label: 'Entry Points',
            value: '-${_formatPoints(entryPoints)} pts',
            color: _arenaAccent,
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _BalanceRow(
            label: 'Sau khi tham gia',
            value: '${_formatPoints(remainingBalance)} pts',
            color: AppColors.text1,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.value,
    required this.color,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: (emphasized ? AppTextStyles.body : AppTextStyles.caption)
                .copyWith(
                  color: emphasized ? AppColors.text1 : AppColors.text2,
                  fontWeight: emphasized ? AppTextStyles.bold : null,
                ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyPolicyLink extends StatelessWidget {
  const _SafetyPolicyLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        key: ArenaJoinPage.safetyPolicyKey,
        onPressed: onTap,
        icon: const Icon(Icons.shield_outlined, size: 16),
        label: Text(
          'Xem chính sách hủy/void',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AcknowledgementStack extends StatelessWidget {
  const _AcknowledgementStack({
    required this.readRules,
    required this.understandPoints,
    required this.onRules,
    required this.onPoints,
  });

  final bool readRules;
  final bool understandPoints;
  final VoidCallback onRules;
  final VoidCallback onPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AcknowledgementRow(
          key: ArenaJoinPage.rulesCheckboxKey,
          checked: readRules,
          label: 'Tôi đã đọc luật chơi và hiểu các điều kiện của challenge này',
          onTap: onRules,
        ),
        const SizedBox(height: AppSpacing.x3),
        _AcknowledgementRow(
          key: ArenaJoinPage.pointsCheckboxKey,
          checked: understandPoints,
          label:
              'Tôi hiểu đây là Arena Points — không phải tài sản tài chính và không thể rút ra ngoài',
          onTap: onPoints,
        ),
      ],
    );
  }
}

class _AcknowledgementRow extends StatelessWidget {
  const _AcknowledgementRow({
    super.key,
    required this.checked,
    required this.label,
    required this.onTap,
  });

  final bool checked;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: checked ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadii.smRadius,
                  border: Border.all(
                    color: checked ? AppColors.primary : AppColors.borderSolid,
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.entryPoints,
    required this.canJoin,
    required this.onConfirm,
    required this.onDecline,
  });

  final int entryPoints;
  final bool canJoin;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: ArenaJoinPage.confirmKey,
          onPressed: canJoin ? onConfirm : null,
          child: Text('Xác nhận tham gia · ${_formatPoints(entryPoints)} pts'),
        ),
        const SizedBox(height: AppSpacing.x3),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            key: ArenaJoinPage.declineKey,
            onPressed: onDecline,
            child: Text(
              'Từ chối',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatPoints(int value) {
  if (value.abs() >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(1)}K';
  }
  return value.toString();
}
