part of '../pages/profile_page.dart';

class _ArenaCard extends StatelessWidget {
  const _ArenaCard({required this.arena, required this.onTap});

  final ProfileArenaBlock arena;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfilePage.arenaCardKey,
      onTap: onTap,
      height: AppSpacing.profileModuleCardHeight,
      padding: AppSpacing.profileModuleCardPadding,
      borderColor: _profileAmber.withValues(alpha: .34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_esports_outlined,
                color: _profileAmber,
                size: AppSpacing.profileModuleIcon,
              ),
              const SizedBox(width: AppSpacing.profileModuleGap),
              Expanded(
                child: Text(
                  'Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleGap),
              _TinyTag(label: 'Points only', color: _profileAmber),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _ModuleStat(
                  label: 'Arena Points',
                  value: arena.pointsLabel,
                  valueColor: _profileAmber,
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Ph\u00F2ng',
                  value: '${arena.rooms}',
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Creator',
                  value: arena.creatorScoreLabel,
                  valueColor: _profileGreen,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'V\u00E0o s\u00E2n ch\u01A1i c\u1EE7a t\u00F4i',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: _profileAmber),
                ),
              ),
              const SizedBox(width: AppSpacing.profileHeroInfoTrailingGap),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profileAmber,
                size: AppSpacing.profileModuleLinkIcon,
              ),
              const SizedBox(width: AppSpacing.profileModuleEndGap),
              const Icon(
                Icons.shield_outlined,
                color: _profileMuted,
                size: AppSpacing.profileModuleLinkIcon,
              ),
              const SizedBox(width: AppSpacing.profileHeroInfoTrailingGap),
              Flexible(
                child: Text(
                  'An to\u00E0n & B\u00E1o c\u00E1o',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: _profileMuted,
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

class _ModuleStat extends StatelessWidget {
  const _ModuleStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericMicro.copyWith(color: _profileMuted),
        ),
        const SizedBox(height: AppSpacing.profileModuleGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.control.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.profileTinyTagPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.pillRadius,
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
    );
  }
}
