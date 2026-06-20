import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';

const arenaModeAccent = AppModuleAccents.arena;

class ArenaModeActionIcon extends StatelessWidget {
  const ArenaModeActionIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppSpacing.arenaModeActionIconDefaultSize,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: color.withValues(alpha: .20)),
            borderRadius: size >= AppSpacing.arenaModeActionIconLargeThreshold
                ? AppRadii.cardRadius
                : AppRadii.mdRadius,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: size >= AppSpacing.arenaModeActionIconLargeThreshold
              ? AppSpacing.arenaModeActionIconLargeGlyph
              : AppSpacing.arenaModeActionIconGlyph,
        ),
      ),
    );
  }
}

IconData arenaTemplateIcon(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => Icons.track_changes_rounded,
    ArenaTemplateKind.closestGuess => Icons.pin_outlined,
    ArenaTemplateKind.teamBattle => Icons.groups_rounded,
    ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
    ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
    ArenaTemplateKind.proof => Icons.verified_user_outlined,
  };
}

Color arenaTemplateColor(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => AppColors.accent,
    ArenaTemplateKind.closestGuess => AppColors.primary,
    ArenaTemplateKind.teamBattle => AppColors.accent,
    ArenaTemplateKind.bracket => AppColors.warn,
    ArenaTemplateKind.vote => AppColors.buy,
    ArenaTemplateKind.proof => AppColors.text2,
  };
}

ArenaTemplateKind arenaKindForMode(String templateId) {
  return switch (templateId) {
    'prediction' => ArenaTemplateKind.prediction,
    'team_battle' => ArenaTemplateKind.teamBattle,
    'community_vote' => ArenaTemplateKind.vote,
    'proof_challenge' => ArenaTemplateKind.proof,
    'bracket' => ArenaTemplateKind.bracket,
    _ => ArenaTemplateKind.closestGuess,
  };
}

Color arenaMetricColor(VitArenaMetricStatus status) {
  return switch (status) {
    VitArenaMetricStatus.success => AppColors.buy,
    VitArenaMetricStatus.warning => AppColors.warn,
    VitArenaMetricStatus.info => AppColors.primary,
    VitArenaMetricStatus.neutral => AppColors.text2,
  };
}

IconData arenaMetricIcon(VitArenaMetricStatus status, String label) {
  if (label == 'Fair Play') return Icons.shield_outlined;
  if (label == 'Dùng lại') return Icons.refresh_rounded;
  if (label == 'Tỷ lệ báo cáo') return Icons.flag_outlined;
  return switch (status) {
    VitArenaMetricStatus.success => Icons.check_circle_outline_rounded,
    VitArenaMetricStatus.warning => Icons.warning_amber_rounded,
    VitArenaMetricStatus.info => Icons.info_outline_rounded,
    VitArenaMetricStatus.neutral => Icons.circle_outlined,
  };
}
