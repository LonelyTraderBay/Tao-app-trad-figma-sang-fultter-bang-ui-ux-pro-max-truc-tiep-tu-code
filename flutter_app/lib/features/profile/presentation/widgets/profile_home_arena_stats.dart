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
      height: 137,
      padding: const EdgeInsets.all(16),
      borderColor: _profileAmber.withValues(alpha: .34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_esports_outlined,
                color: _profileAmber,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
              const SizedBox(width: 12),
              Expanded(
                child: _ModuleStat(
                  label: 'Ph\u00F2ng',
                  value: '${arena.rooms}',
                ),
              ),
              const SizedBox(width: 12),
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
                  style: AppTextStyles.micro.copyWith(
                    color: _profileAmber,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profileAmber,
                size: 14,
              ),
              const SizedBox(width: 18),
              const Icon(Icons.shield_outlined, color: _profileMuted, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'An to\u00E0n & B\u00E1o c\u00E1o',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _profileMuted,
                    fontSize: 11,
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
          style: AppTextStyles.micro.copyWith(
            color: _profileMuted,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            height: 1,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
