import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc293_announcements_content');
  static const filtersKey = Key('sc293_announcements_filters');
  static const pinnedKey = Key('sc293_announcements_pinned');
  static const listKey = Key('sc293_announcements_list');
  static const emptyKey = Key('sc293_announcements_empty');

  static Key filterKey(String id) => Key('sc293_announcement_filter_$id');
  static Key announcementKey(String id) => Key('sc293_announcement_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  String _activeFilterId = 'all';
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(supportControllerProvider).getAnnouncements();
    final filter = snapshot.filters.firstWhere(
      (item) => item.id == _activeFilterId,
    );
    final filtered = filter.type == null
        ? snapshot.announcements
        : snapshot.announcements
              .where((item) => item.type == filter.type)
              .toList();
    final pinned = filtered.where((item) => item.isPinned).toList();
    final regular = filtered.where((item) => !item.isPinned).toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-293 AnnouncementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: AnnouncementsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    gap: VitContentGap.relaxed,
                    fullBleed: true,
                    children: [
                      _FilterRail(
                        filters: snapshot.filters,
                        activeFilterId: _activeFilterId,
                        onChanged: _setFilter,
                      ),
                      if (pinned.isNotEmpty)
                        _PinnedSection(
                          announcements: pinned,
                          expandedId: _expandedId,
                          onToggle: _toggleExpanded,
                        ),
                      _AnnouncementList(
                        announcements: regular,
                        showEmpty: pinned.isEmpty && regular.isEmpty,
                        expandedId: _expandedId,
                        onToggle: _toggleExpanded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setFilter(String filterId) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeFilterId = filterId;
      _expandedId = null;
    });
  }

  void _toggleExpanded(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedId = _expandedId == id ? null : id;
    });
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.activeFilterId,
    required this.onChanged,
  });

  final List<AnnouncementFilterDraft> filters;
  final String activeFilterId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: AnnouncementsPage.filtersKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        AppSpacing.x1,
      ),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              filter: filter,
              selected: filter.id == activeFilterId,
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final AnnouncementFilterDraft filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: AnnouncementsPage.filterKey(filter.id),
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary12 : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary40 : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          filter.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.primary : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}

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
    return Padding(
      key: AnnouncementsPage.pinnedKey,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
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
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < announcements.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.x3),
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
    return Padding(
      key: AnnouncementsPage.listKey,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
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
                  if (i > 0) const SizedBox(height: AppSpacing.x3),
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
                const SizedBox(height: AppSpacing.x2),
                Text(
                  announcement.title,
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  announcement.summary,
                  maxLines: expanded ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
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
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: AppSpacing.x4),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    announcement.content,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
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
