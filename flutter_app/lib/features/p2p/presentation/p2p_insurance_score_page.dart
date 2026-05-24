import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PInsuranceScorePage extends ConsumerWidget {
  const P2PInsuranceScorePage({super.key, this.shellRenderMode});

  static const scoreCardKey = Key('sc240_p2p_insurance_score_card');
  static const factorsKey = Key('sc240_p2p_insurance_score_factors');
  static Key quickActionKey(String label) => Key('sc240_quick_$label');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRepositoryProvider).getInsuranceScore();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-240 P2PInsuranceScorePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Điểm bảo vệ',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ScoreOverviewCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _FactorBreakdownCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _QuickActionsCard(actions: snapshot.quickActions),
                      const SizedBox(height: AppSpacing.x5),
                      _TierPathCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _DisclosureCard(text: snapshot.disclosure),
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
}

class _ScoreOverviewCard extends StatelessWidget {
  const _ScoreOverviewCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.scoreCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          _ScoreRing(snapshot: snapshot),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.gradeLabel,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            snapshot.gradeDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            borderColor: AppColors.buy20,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.buy,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+${snapshot.potentialGain} điểm có thể cải thiện',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
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

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.overallScore / snapshot.maxScore;
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppModuleAccents.p2p,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${snapshot.overallScore}',
                style: AppTextStyles.display.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '/ ${snapshot.maxScore}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                snapshot.grade,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactorBreakdownCard extends StatelessWidget {
  const _FactorBreakdownCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.factorsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: AppColors.text2,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Chi tiết điểm số',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          for (var i = 0; i < snapshot.factors.length; i++) ...[
            _ScoreFactorRow(factor: snapshot.factors[i]),
            if (i != snapshot.factors.length - 1)
              const Divider(height: AppSpacing.x6, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _ScoreFactorRow extends StatelessWidget {
  const _ScoreFactorRow({required this.factor});

  final P2PInsuranceScoreFactorDraft factor;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(factor.toneKey);
    final progress = factor.score / factor.maxScore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(_iconFor(factor.iconKey), color: color, size: 17),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    factor.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    factor.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${factor.score}',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/${factor.maxScore}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: AppColors.surface3),
                        FractionallySizedBox(
                          widthFactor: progress,
                          alignment: Alignment.centerLeft,
                          child: ColoredBox(color: color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 62,
                child: Text(
                  factor.statusLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (factor.recommendation != null) ...[
          const SizedBox(height: AppSpacing.x3),
          Padding(
            padding: const EdgeInsets.only(left: 46),
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.bolt_rounded, color: color, size: 14),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      factor.recommendation!,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.actions});

  final List<P2PInsuranceScoreQuickActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.north_east_rounded,
                color: AppColors.buy,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Cải thiện nhanh',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final action in actions) ...[
            _QuickActionRow(action: action),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.action});

  final P2PInsuranceScoreQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(action.toneKey);
    final enabled = action.route != null;
    return VitCard(
      key: P2PInsuranceScorePage.quickActionKey(action.label),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              context.go(action.route!);
            }
          : null,
      child: Opacity(
        opacity: enabled ? 1 : .55,
        child: Row(
          children: [
            Container(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                action.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              action.gain,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (enabled) ...[
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 17,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TierPathCard extends StatelessWidget {
  const _TierPathCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                color: AppColors.accent,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Lộ trình nâng cấp',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          for (var i = 0; i < snapshot.tierRequirements.length; i++) ...[
            _TierCard(
              tier: snapshot.tierRequirements[i],
              score: snapshot.overallScore,
            ),
            if (i != snapshot.tierRequirements.length - 1)
              const Center(
                child: SizedBox(
                  height: AppSpacing.x5,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier, required this.score});

  final P2PInsuranceScoreTierDraft tier;
  final int score;

  @override
  Widget build(BuildContext context) {
    final color = tier.isCurrent
        ? AppModuleAccents.p2p
        : (tier.isUnlocked ? AppColors.buy : AppColors.text3);
    final progress = tier.requiredScore == 0
        ? 1.0
        : (score / tier.requiredScore).clamp(0.0, 1.0);

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: tier.isCurrent ? AppColors.primary40 : AppColors.divider,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                tier.isUnlocked
                    ? Icons.check_circle_outline_rounded
                    : Icons.lock_outline_rounded,
                color: color,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  tier.isCurrent ? '${tier.name} - HIỆN TẠI' : tier.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                tier.coveragePct,
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          if (!tier.isUnlocked) ...[
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Text(
                  'Tiến độ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const Spacer(),
                Text(
                  '$score/${tier.requiredScore}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: SizedBox(
                height: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface3),
                    FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: const ColoredBox(color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final requirement in tier.requirements)
                _RequirementChip(label: requirement, passed: tier.isUnlocked),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: passed ? AppColors.buy10 : AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: passed ? AppColors.buy : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: 16,
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

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'buy' => AppColors.buy,
    'primary' => AppModuleAccents.p2p,
    'accent' => AppColors.accent,
    'warn' => AppColors.warn,
    'sell' => AppColors.sell,
    _ => AppColors.text2,
  };
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'user_check' => Icons.verified_user_outlined,
    'bar_chart' => Icons.bar_chart_rounded,
    'shield' => Icons.shield_outlined,
    'award' => Icons.workspace_premium_outlined,
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.shield_outlined,
  };
}
