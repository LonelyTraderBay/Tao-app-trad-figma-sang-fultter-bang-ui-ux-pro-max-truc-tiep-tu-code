part of 'arena_guide_page.dart';

class _SafetyCenterCard extends StatelessWidget {
  const _SafetyCenterCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaGuidePage.safetyCenterKey,
      onTap: onPressed,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Center',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Xem quy tắc cộng đồng đầy đủ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.text3, size: 18),
        ],
      ),
    );
  }
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.help_outline, color: AppModuleAccents.arena, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Câu hỏi thường gặp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _SmallBadge(label: '$total', color: AppModuleAccents.arena),
      ],
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.items,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<ArenaGuideFaqDraft> items;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.x2,
            ),
            child: _AccordionCard(
              key: ArenaGuidePage.faqKey('$index'),
              icon: Icons.help_outline,
              title: items[index].question,
              description: items[index].answer,
              badgeColor: AppModuleAccents.arena,
              open: expandedIndex == index,
              onTap: () => onToggle(index),
            ),
          ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.help_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vẫn cần trợ giúp?',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Liên hệ đội ngũ hỗ trợ 24/7',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          TextButton.icon(
            key: ArenaGuidePage.supportKey,
            onPressed: onPressed,
            icon: const Icon(Icons.chevron_right, size: 14),
            label: const Text('Hỗ trợ'),
          ),
        ],
      ),
    );
  }
}

class _AccordionCard extends StatelessWidget {
  const _AccordionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.badgeColor,
    required this.open,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color badgeColor;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: open
                        ? badgeColor.withValues(alpha: .12)
                        : AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    icon,
                    color: open ? badgeColor : AppColors.text3,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                AnimatedRotation(
                  turns: open ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.expand_more,
                    color: open ? badgeColor : AppColors.text3,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.x3),
                child: Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ),
            ),
            crossFadeState: open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _TipPill extends StatelessWidget {
  const _TipPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .16)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: color, size: 12),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

Color _toneColor(ArenaGuideTone tone) {
  return switch (tone) {
    ArenaGuideTone.arena => AppModuleAccents.arena,
    ArenaGuideTone.info => AppColors.accent,
    ArenaGuideTone.success => AppColors.buy,
    ArenaGuideTone.warning => AppColors.warn,
    ArenaGuideTone.danger => AppColors.sell,
    ArenaGuideTone.accent => AppColors.primary,
    ArenaGuideTone.neutral => AppColors.text3,
  };
}

IconData _iconFor(String key) {
  return switch (key) {
    'auto' => Icons.auto_mode,
    'check' => Icons.check_circle_outline,
    'clock' => Icons.schedule,
    'eye' => Icons.visibility_outlined,
    'file' => Icons.description_outlined,
    'gift' => Icons.card_giftcard,
    'layers' => Icons.layers_outlined,
    'lock' => Icons.lock_outline,
    'points' => Icons.toll_outlined,
    'report' => Icons.flag_outlined,
    'search' => Icons.search,
    'shield' => Icons.shield_outlined,
    'tag' => Icons.sell_outlined,
    'target' => Icons.track_changes,
    'trophy' => Icons.emoji_events_outlined,
    'users' => Icons.group_outlined,
    'warning' => Icons.warning_amber_outlined,
    'zap' => Icons.bolt_outlined,
    _ => Icons.circle_outlined,
  };
}
