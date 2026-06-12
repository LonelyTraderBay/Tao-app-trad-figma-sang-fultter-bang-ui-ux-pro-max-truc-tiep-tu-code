import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_dispute_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeEscalationCard extends StatelessWidget {
  const P2PDisputeEscalationCard({
    super.key,
    required this.escalateKey,
    required this.levels,
    required this.currentLevel,
    required this.currentLevelData,
    required this.nextLevelData,
    required this.onEscalate,
  });

  final Key escalateKey;
  final List<P2PDisputeLevelDraft> levels;
  final int currentLevel;
  final P2PDisputeLevelDraft currentLevelData;
  final P2PDisputeLevelDraft? nextLevelData;
  final VoidCallback? onEscalate;

  @override
  Widget build(BuildContext context) {
    final color = p2pDisputeLevelColor(currentLevel);
    final nextLevel = nextLevelData;
    return VitCard(
      padding: AppSpacing.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Cấp độ xử lý',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              P2PDisputeSmallPill(label: 'Cấp $currentLevel/4', color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < levels.length; index++) ...[
                Expanded(
                  child: _LevelNode(
                    level: levels[index],
                    isCompleted: levels[index].level < currentLevel,
                    isActive: levels[index].level == currentLevel,
                  ),
                ),
                if (index < levels.length - 1)
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.p2pDisputeLevelConnectorPadding,
                      child: Container(
                        height: AppSpacing.p2pDisputeLevelConnectorHeight,
                        color: levels[index].level < currentLevel
                            ? p2pDisputeLevelColor(levels[index].level)
                            : AppColors.borderSolid,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: color.withValues(alpha: .18),
            padding: AppSpacing.p2pDisputeCompactCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    p2pDisputeLevelIcon(currentLevelData.iconKey),
                    color: AppColors.onAccent,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cấp $currentLevel: ${currentLevelData.shortLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        currentLevelData.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: AppColors.text3,
                            size: AppSpacing.p2pDisputeMetaIcon,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                          Text(
                            'Dự kiến: ${currentLevelData.avgTime}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (nextLevel != null) ...[
            const SizedBox(height: AppSpacing.x3),
            Material(
              color: AppColors.warn10,
              borderRadius: AppRadii.inputRadius,
              child: InkWell(
                key: escalateKey,
                onTap: onEscalate,
                borderRadius: AppRadii.inputRadius,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: AppSpacing.inputHeight,
                  ),
                  padding: AppSpacing.p2pDisputeEscalatePadding,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.warn15),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          'Chuyển lên Cấp ${nextLevel.level}: ${nextLevel.shortLabel}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({
    required this.level,
    required this.isCompleted,
    required this.isActive,
  });

  final P2PDisputeLevelDraft level;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = p2pDisputeLevelColor(level.level);
    return Opacity(
      opacity: isActive || isCompleted ? 1 : .42,
      child: Column(
        children: [
          Container(
            width: AppSpacing.p2pDisputeLevelNodeSize,
            height: AppSpacing.p2pDisputeLevelNodeSize,
            decoration: BoxDecoration(
              color: isActive
                  ? color
                  : isCompleted
                  ? color.withValues(alpha: .12)
                  : AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
              border: isActive ? null : Border.all(color: color),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_circle_outline_rounded
                  : p2pDisputeLevelIcon(level.iconKey),
              color: isActive ? AppColors.onAccent : color,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            level.shortLabel,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: isActive ? color : AppColors.text3,
              fontWeight: isActive ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
