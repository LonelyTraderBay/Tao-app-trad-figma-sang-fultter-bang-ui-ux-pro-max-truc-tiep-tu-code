import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

const _modeTitleLineRatio = ArenaSpacingTokens.arenaModeTitleLineHeight;

class ArenaModeHero extends StatelessWidget {
  const ArenaModeHero({
    super.key,
    required this.creatorKey,
    required this.trustKey,
    required this.snapshot,
    required this.onCreator,
    required this.onTrust,
  });

  final Key creatorKey;
  final Key trustKey;
  final ArenaModeDetailSnapshot snapshot;
  final VoidCallback onCreator;
  final VoidCallback onTrust;

  @override
  Widget build(BuildContext context) {
    final templateColor = arenaTemplateColor(snapshot.template.kind);
    return VitModuleHeroCard(
      accentColor: templateColor,
      padding: ArenaSpacingTokens.arenaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ArenaModeActionIcon(
                icon: arenaTemplateIcon(snapshot.template.kind),
                color: templateColor,
                size: ArenaSpacingTokens.arenaModeHeroIcon,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.mode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.heavy,
                        height: _modeTitleLineRatio,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.template.title} template',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          _CreatorRow(
            creatorKey: creatorKey,
            snapshot: snapshot,
            onTap: onCreator,
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Align(
            alignment: Alignment.centerLeft,
            child: VitStatusPill(
              key: trustKey,
              label: 'Trust Score: ${snapshot.creator.trustScore}%',
              icon: Icons.shield_outlined,
              status: VitStatusPillStatus.success,
              size: VitStatusPillSize.md,
              onTap: onTrust,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitStatusPill(
                label: snapshot.template.complexity,
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const VitStatusPill(
                label: 'Points-only',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
              for (final tag in snapshot.mode.tags)
                VitStatusPill(
                  label: tag,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _ModeHeroKpi(
                  label: 'Đang mở',
                  value: '${snapshot.mode.activeChallenges}',
                ),
              ),
              SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _ModeHeroKpi(
                    label: 'Hoàn thành',
                    value: '${snapshot.mode.completionRate}%',
                    valueColor: templateColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorRow extends StatelessWidget {
  const _CreatorRow({
    required this.creatorKey,
    required this.snapshot,
    required this.onTap,
  });

  final Key creatorKey;
  final ArenaModeDetailSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: VitCard(
        key: creatorKey,
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: Padding(
          padding: ArenaSpacingTokens.arenaVerticalPaddingX2,
          child: Row(
            children: [
              const ArenaModeActionIcon(
                icon: Icons.person_rounded,
                color: arenaModeAccent,
                size: ArenaSpacingTokens.arenaModeCreatorIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (snapshot.creator.fairPlayBadge) ...[
                const VitStatusPill(
                  label: 'Fair Play',
                  icon: Icons.shield_outlined,
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
              VitStatusPill(
                label: snapshot.creator.badge,
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: ArenaSpacingTokens.arenaModeChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeHeroKpi extends StatelessWidget {
  const _ModeHeroKpi({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor ?? AppColors.text1,
            letterSpacing: 0,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
