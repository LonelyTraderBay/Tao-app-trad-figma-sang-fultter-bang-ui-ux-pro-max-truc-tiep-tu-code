part of '../pages/topic_hub_page.dart';

class _TinySectionIcon extends StatelessWidget {
  const _TinySectionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(child: Icon(icon, color: color, size: 16)),
      ),
    );
  }
}

class _SmallAccentIcon extends StatelessWidget {
  const _SmallAccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .13),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Center(child: Icon(icon, color: color, size: 18)),
      ),
    );
  }
}

List<Widget> _withSectionGaps(List<Widget> children) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
      children[i],
    ],
  ];
}

class _ModuleBadge extends StatelessWidget {
  const _ModuleBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .24)),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.discoveryBadgePadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 10),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusMini extends StatelessWidget {
  const _StatusMini({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.discoveryMiniBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.discoveryMiniBadgePadding,
        child: Text(
          '$count',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _InlineCta extends StatelessWidget {
  const _InlineCta({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Icon(Icons.arrow_forward_rounded, color: color, size: 11),
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  const _CreatorAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.discoveryCreatorAvatarBox,
      height: AppSpacing.discoveryCreatorAvatarBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppModuleAccents.arena.withValues(alpha: .16),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Text(
            initials,
            style: AppTextStyles.micro.copyWith(
              color: AppModuleAccents.arena,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Color _accentForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.id) {
    'crypto' => AppModuleAccents.arena,
    'macro' => AppModuleAccents.predictions,
    'sports' => AppColors.buy,
    'tech' || 'ai' => AppModuleAccents.markets,
    _ => AppColors.text2,
  };
}

IconData _iconForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.iconKey) {
    'fire' => Icons.local_fire_department_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'price' => Icons.swap_vert_rounded,
    'news' => Icons.article_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
