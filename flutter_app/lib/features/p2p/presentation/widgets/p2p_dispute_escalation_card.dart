part of 'p2p_dispute_widgets.dart';

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
                      child: SizedBox(
                        height: AppSpacing.p2pDisputeLevelConnectorHeight,
                        child: ColoredBox(
                          color: levels[index].level < currentLevel
                              ? p2pDisputeLevelColor(levels[index].level)
                              : AppColors.borderSolid,
                        ),
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
                Material(
                  color: color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: SizedBox(
                    width: AppSpacing.x6,
                    height: AppSpacing.x6,
                    child: Icon(
                      p2pDisputeLevelIcon(currentLevelData.iconKey),
                      color: AppColors.onAccent,
                      size: AppSpacing.iconSm,
                    ),
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
            VitCard(
              key: escalateKey,
              onTap: onEscalate,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.standard,
              borderColor: AppColors.warn15,
              background: const ColoredBox(color: AppColors.warn10),
              clip: true,
              constraints: const BoxConstraints(
                minHeight: AppSpacing.inputHeight,
              ),
              padding: AppSpacing.p2pDisputeEscalatePadding,
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
          Material(
            color: isActive
                ? color
                : isCompleted
                ? color.withValues(alpha: .12)
                : AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: isActive ? BorderSide.none : BorderSide(color: color),
            ),
            child: SizedBox(
              width: AppSpacing.p2pDisputeLevelNodeSize,
              height: AppSpacing.p2pDisputeLevelNodeSize,
              child: Icon(
                isCompleted
                    ? Icons.check_circle_outline_rounded
                    : p2pDisputeLevelIcon(level.iconKey),
                color: isActive ? AppColors.onAccent : color,
                size: AppSpacing.iconSm,
              ),
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
