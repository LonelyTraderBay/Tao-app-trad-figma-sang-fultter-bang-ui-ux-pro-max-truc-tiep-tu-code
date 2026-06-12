part of '../pages/announcements_page.dart';

class _PinnedSection extends StatelessWidget {
  const _PinnedSection({
    required this.announcements,
    required this.expandedId,
    required this.onToggle,
  });

  final List<AnnouncementDraft> announcements;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AnnouncementsPage.pinnedKey,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.push_pin_outlined,
                color: AppModuleAccents.support,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'GHIM',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          for (var i = 0; i < announcements.length; i++) ...[
            if (i > 0)
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
            _AnnouncementCard(
              announcement: announcements[i],
              expanded: expandedId == announcements[i].id,
              onTap: () => onToggle(announcements[i].id),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementList extends StatelessWidget {
  const _AnnouncementList({
    required this.announcements,
    required this.showEmpty,
    required this.expandedId,
    required this.onToggle,
  });

  final List<AnnouncementDraft> announcements;
  final bool showEmpty;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AnnouncementsPage.listKey,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: showEmpty
          ? const VitEmptyState(
              key: AnnouncementsPage.emptyKey,
              title: 'Không có thông báo nào',
              message: 'Các cập nhật mới từ VitTrade sẽ hiển thị tại đây.',
              icon: Icons.notifications_none_rounded,
            )
          : Column(
              children: [
                for (var i = 0; i < announcements.length; i++) ...[
                  if (i > 0)
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
                  _AnnouncementCard(
                    announcement: announcements[i],
                    expanded: expandedId == announcements[i].id,
                    onTap: () => onToggle(announcements[i].id),
                  ),
                ],
              ],
            ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.expanded,
    required this.onTap,
  });

  final AnnouncementDraft announcement;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle(announcement.type);
    return VitCard(
      key: AnnouncementsPage.announcementKey(announcement.id),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeIcon(style: style),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TypePill(style: style),
                    if (announcement.isPinned) ...[
                      const SizedBox(width: AppSpacing.x3),
                      const Icon(
                        Icons.push_pin_outlined,
                        color: AppModuleAccents.support,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                Text(
                  announcement.title,
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                Text(
                  announcement.summary,
                  maxLines: expanded ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.32,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      announcement.publishedDate,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                if (expanded) ...[
                  const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
                  const Divider(color: AppColors.divider, height: 1),
                  const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
                  Text(
                    announcement.content,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final tag in announcement.tags) _Tag(label: tag),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          AnimatedRotation(
            turns: expanded ? .25 : 0,
            duration: const Duration(milliseconds: 160),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.style});

  final _AnnouncementTypeStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(style.icon, color: style.color, size: 20),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.style});

  final _AnnouncementTypeStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        '#$label',
        style: AppTextStyles.micro.copyWith(color: AppColors.text2),
      ),
    );
  }
}

final class _AnnouncementTypeStyle {
  const _AnnouncementTypeStyle({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

_AnnouncementTypeStyle _typeStyle(AnnouncementType type) {
  return switch (type) {
    AnnouncementType.promotion => const _AnnouncementTypeStyle(
      label: 'Khuyến mãi',
      icon: Icons.sell_outlined,
      color: AppColors.warn,
    ),
    AnnouncementType.newFeature => const _AnnouncementTypeStyle(
      label: 'Tính năng mới',
      icon: Icons.bolt_rounded,
      color: AppModuleAccents.support,
    ),
    AnnouncementType.listing => const _AnnouncementTypeStyle(
      label: 'Niêm yết',
      icon: Icons.campaign_outlined,
      color: AppColors.buy,
    ),
    AnnouncementType.maintenance => const _AnnouncementTypeStyle(
      label: 'Bảo trì',
      icon: Icons.settings_outlined,
      color: AppColors.text2,
    ),
    AnnouncementType.security => const _AnnouncementTypeStyle(
      label: 'Bảo mật',
      icon: Icons.shield_outlined,
      color: AppColors.sell,
    ),
    AnnouncementType.general => const _AnnouncementTypeStyle(
      label: 'Chung',
      icon: Icons.notifications_none_rounded,
      color: AppColors.accent,
    ),
  };
}
