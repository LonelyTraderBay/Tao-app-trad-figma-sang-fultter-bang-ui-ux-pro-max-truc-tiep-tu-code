import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const _modeTitleLineRatio = AppSpacing.arenaModeTitleLineHeight;

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
      padding: AppSpacing.arenaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ArenaModeActionIcon(
                icon: arenaTemplateIcon(snapshot.template.kind),
                color: templateColor,
                size: AppSpacing.arenaModeHeroIcon,
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
          const SizedBox(height: AppSpacing.x5),
          _CreatorRow(
            creatorKey: creatorKey,
            snapshot: snapshot,
            onTap: onCreator,
          ),
          const SizedBox(height: AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.copy_rounded,
                  label: 'Clone',
                  value: '${snapshot.mode.cloneCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.play_arrow_outlined,
                  label: 'Đang mở',
                  value: '${snapshot.mode.activeChallenges}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Hoàn thành',
                  value: '${snapshot.mode.completionRate}%',
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
      child: InkWell(
        key: creatorKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: AppSpacing.arenaVerticalPaddingX2,
          child: Row(
            children: [
              const ArenaModeActionIcon(
                icon: Icons.person_rounded,
                color: arenaModeAccent,
                size: AppSpacing.arenaModeCreatorIcon,
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
                size: AppSpacing.arenaModeChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: AppSpacing.arenaModeMiniStatPadding,
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
