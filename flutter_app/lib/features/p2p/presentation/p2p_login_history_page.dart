import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PLoginHistoryPage extends ConsumerStatefulWidget {
  const P2PLoginHistoryPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc257_p2p_login_history_stats');
  static const filtersKey = Key('sc257_p2p_login_history_filters');
  static const warningKey = Key('sc257_p2p_login_history_warning');
  static const eventsKey = Key('sc257_p2p_login_history_events');
  static const infoKey = Key('sc257_p2p_login_history_info');
  static const emptyKey = Key('sc257_p2p_login_history_empty');
  static const downloadKey = Key('sc257_p2p_login_history_download');

  static Key filterKey(String id) => Key('sc257_p2p_login_history_filter_$id');

  static Key eventKey(String id) => Key('sc257_p2p_login_history_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLoginHistoryPage> createState() =>
      _P2PLoginHistoryPageState();
}

class _P2PLoginHistoryPageState extends ConsumerState<P2PLoginHistoryPage> {
  String _filter = 'all';
  String? _expandedEventId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getLoginHistory();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final filteredEvents = snapshot.events
        .where((event) {
          if (_filter == 'success') return event.status == 'success';
          if (_filter == 'suspicious') return event.isRiskEvent;
          return true;
        })
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-257 P2PLoginHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sử đăng nhập',
              subtitle: 'Bảo mật · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: _DownloadButton(
                key: P2PLoginHistoryPage.downloadKey,
                onTap: () => HapticFeedback.selectionClick(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppModuleAccents.p2p,
                backgroundColor: AppColors.surface2,
                onRefresh: () async {
                  HapticFeedback.selectionClick();
                  await Future<void>.delayed(const Duration(milliseconds: 120));
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LoginStats(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _FilterTabs(
                          activeFilter: _filter,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _filter = value;
                              _expandedEventId = null;
                            });
                          },
                        ),
                        if (snapshot.riskEventCount > 0 &&
                            _filter != 'success') ...[
                          const SizedBox(height: AppSpacing.x4),
                          _RiskWarning(snapshot: snapshot),
                        ],
                        const SizedBox(height: AppSpacing.x4),
                        if (filteredEvents.isEmpty)
                          _EmptyState(snapshot: snapshot)
                        else
                          _LoginEventList(
                            events: filteredEvents,
                            expandedEventId: _expandedEventId,
                            onToggle: _toggleExpanded,
                          ),
                        const SizedBox(height: AppSpacing.x6),
                        _SecurityInfo(snapshot: snapshot),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleExpanded(String eventId) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedEventId = _expandedEventId == eventId ? null : eventId;
    });
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 36,
      child: Material(
        color: AppColors.searchBg,
        borderRadius: AppRadii.mdRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class _LoginStats extends StatelessWidget {
  const _LoginStats({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PLoginHistoryPage.statsKey,
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.shield_outlined,
            value: '${snapshot.events.length}',
            label: 'Tổng số',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_outline_rounded,
            value: '${snapshot.successCount}',
            label: 'Thành công',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.warning_amber_rounded,
            value: '${snapshot.riskEventCount}',
            label: 'Đáng ngờ',
            color: AppColors.warn,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
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

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.activeFilter, required this.onChanged});

  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      ('all', 'Tất cả'),
      ('success', 'Thành công'),
      ('suspicious', 'Đáng ngờ'),
    ];

    return Wrap(
      key: P2PLoginHistoryPage.filtersKey,
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final filter in filters)
          _FilterPill(
            key: P2PLoginHistoryPage.filterKey(filter.$1),
            label: filter.$2,
            selected: activeFilter == filter.$1,
            onTap: () => onChanged(filter.$1),
          ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PLoginHistoryPage.warningKey,
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phát hiện ${snapshot.riskEventCount} đăng nhập đáng ngờ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.warningBody,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginEventList extends StatelessWidget {
  const _LoginEventList({
    required this.events,
    required this.expandedEventId,
    required this.onToggle,
  });

  final List<P2PLoginEventDraft> events;
  final String? expandedEventId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLoginHistoryPage.eventsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < events.length; index++) ...[
          _LoginEventCard(
            event: events[index],
            expanded: expandedEventId == events[index].id,
            onTap: () => onToggle(events[index].id),
          ),
          if (index != events.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _LoginEventCard extends StatelessWidget {
  const _LoginEventCard({
    required this.event,
    required this.expanded,
    required this.onTap,
  });

  final P2PLoginEventDraft event;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(event.status);

    return VitCard(
      key: P2PLoginHistoryPage.eventKey(event.id),
      radius: VitCardRadius.lg,
      borderColor: event.status == 'suspicious' ? AppColors.warn : null,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventIcon(event: event, color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _EventMainInfo(event: event)),
                const SizedBox(width: AppSpacing.x2),
                _EventTrailing(event: event, color: color, expanded: expanded),
              ],
            ),
          ),
          if (expanded) _ExpandedDetails(event: event),
        ],
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.event, required this.color});

  final P2PLoginEventDraft event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(_deviceIcon(event.deviceType), color: color, size: 22),
    );
  }
}

class _EventMainInfo extends StatelessWidget {
  const _EventMainInfo({required this.event});

  final P2PLoginEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                event.deviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 15,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (event.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const _SmallBadge(label: 'Hiện tại', color: AppColors.buy),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${event.os} · ${event.browser}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _InlineMeta(
              icon: Icons.location_on_outlined,
              text: '${event.city}, ${event.country}',
            ),
            Text(
              '·',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _InlineMeta(icon: Icons.access_time_rounded, text: event.timestamp),
          ],
        ),
      ],
    );
  }
}

class _EventTrailing extends StatelessWidget {
  const _EventTrailing({
    required this.event,
    required this.color,
    required this.expanded,
  });

  final P2PLoginEventDraft event;
  final Color color;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 92),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(event: event, color: color),
          const SizedBox(height: AppSpacing.x2),
          AnimatedRotation(
            turns: expanded ? .5 : 0,
            duration: const Duration(milliseconds: 180),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.event, required this.color});

  final P2PLoginEventDraft event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_statusIcon(event.status), color: color, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                event.statusLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.event});

  final P2PLoginEventDraft event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _DetailValue(label: 'IP Address', value: event.ip),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: _DetailValue(
                    label: 'Login Method',
                    value: event.methodLabel,
                  ),
                ),
              ],
            ),
            if (event.status == 'suspicious') ...[
              const SizedBox(height: AppSpacing.x3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đăng nhập đáng ngờ',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.warn,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              'Vị trí không quen thuộc. Nếu không phải bạn, hãy đổi mật khẩu ngay.',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text2,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 11),
        const SizedBox(width: AppSpacing.x1),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
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
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
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

class _SecurityInfo extends StatelessWidget {
  const _SecurityInfo({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PLoginHistoryPage.infoKey,
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final tip in snapshot.securityTips) ...[
                    Text(
                      tip,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.55,
                      ),
                    ),
                    if (tip != snapshot.securityTips.last)
                      const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2PLoginHistoryPage.emptyKey,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x7),
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  return switch (status) {
    'failed' => AppColors.sell,
    'suspicious' => AppColors.warn,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'failed' => Icons.cancel_outlined,
    'suspicious' => Icons.warning_amber_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'desktop' => Icons.desktop_windows_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.phone_iphone_rounded,
  };
}
