import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PBlacklistPage extends ConsumerStatefulWidget {
  const P2PBlacklistPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc277_p2p_blacklist_summary');
  static const searchKey = Key('sc277_p2p_blacklist_search');
  static const infoKey = Key('sc277_p2p_blacklist_info');
  static const addKey = Key('sc277_p2p_blacklist_add');

  static Key filterKey(String id) => Key('sc277_p2p_blacklist_filter_$id');

  static Key entryKey(String id) => Key('sc277_p2p_blacklist_entry_$id');

  static Key unblockKey(String id) => Key('sc277_p2p_blacklist_unblock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PBlacklistPage> createState() => _P2PBlacklistPageState();
}

class _P2PBlacklistPageState extends ConsumerState<P2PBlacklistPage> {
  final _searchController = TextEditingController();
  final _removedIds = <String>{};
  String _filterId = 'all';
  String? _expandedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getBlacklist();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final entries = snapshot.entries
        .where((item) => !_removedIds.contains(item.id))
        .toList();
    final filtered = _filterEntries(entries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-277 P2PBlacklistPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: _AddButton(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.addRoute);
                },
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.contentPad,
                          0,
                          AppSpacing.contentPad,
                          AppSpacing.x4,
                        ),
                        child: _SummaryCard(
                          snapshot: snapshot,
                          entries: entries,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
                        child: VitSearchBar(
                          key: P2PBlacklistPage.searchKey,
                          controller: _searchController,
                          placeholder: snapshot.searchHint,
                          variant: VitSearchBarVariant.compact,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _FilterRail(
                        snapshot: snapshot,
                        entries: entries,
                        activeId: _filterId,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _filterId = id);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.contentPad,
                          AppSpacing.x2,
                          AppSpacing.contentPad,
                          0,
                        ),
                        child: Text(
                          '${filtered.length} kết quả',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
                        child: _EntryList(
                          snapshot: snapshot,
                          entries: filtered,
                          expandedId: _expandedId,
                          onToggle: (id) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _expandedId = _expandedId == id ? null : id;
                            });
                          },
                          onUnblock: (id) {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _removedIds.add(id);
                              if (_expandedId == id) _expandedId = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
                        child: _InfoNote(snapshot: snapshot),
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

  List<P2PBlacklistEntryDraft> _filterEntries(
    List<P2PBlacklistEntryDraft> entries,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return entries.where((entry) {
      final matchesSearch =
          query.isEmpty || entry.username.toLowerCase().contains(query);
      final matchesFilter = _filterId == 'all' || entry.reasonId == _filterId;
      return matchesSearch && matchesFilter;
    }).toList();
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: P2PBlacklistPage.addKey,
      width: 36,
      height: 36,
      child: Material(
        color: AppColors.sell10,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: AppColors.sell,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot, required this.entries});

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    final counts = _reasonCounts(entries);
    return VitCard(
      key: P2PBlacklistPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _ReasonIconBubble(
                icon: Icons.person_remove_alt_1_outlined,
                color: AppColors.sell,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entries.length} người dùng',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${entries.where((item) => item.recent30d).length} chặn trong 30 ngày qua',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final reason in snapshot.reasons)
                if ((counts[reason.id] ?? 0) > 0)
                  _ReasonCountPill(
                    reason: reason,
                    count: counts[reason.id] ?? 0,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.snapshot,
    required this.entries,
    required this.activeId,
    required this.onChanged,
  });

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final counts = _reasonCounts(entries);
    final filters = [
      P2PBlacklistReasonDraft(
        id: 'all',
        label: 'Tất cả (${entries.length})',
        iconKey: 'info',
        toneKey: 'primary',
      ),
      ...snapshot.reasons
          .where((reason) => (counts[reason.id] ?? 0) > 0)
          .map(
            (reason) => P2PBlacklistReasonDraft(
              id: reason.id,
              label: '${reason.label} (${counts[reason.id]})',
              iconKey: reason.iconKey,
              toneKey: reason.toneKey,
            ),
          ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              filter: filter,
              selected: filter.id == activeId,
              onTap: () => onChanged(filter.id),
            ),
            const SizedBox(width: AppSpacing.x2),
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

  final P2PBlacklistReasonDraft filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = filter.id == 'all' ? AppColors.primary : _reasonColor(filter);
    return Material(
      key: P2PBlacklistPage.filterKey(filter.id),
      color: selected ? color.withValues(alpha: .14) : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: .42)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            filter.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? color : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.snapshot,
    required this.entries,
    required this.expandedId,
    required this.onToggle,
    required this.onUnblock,
  });

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;
  final String? expandedId;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onUnblock;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return VitCard(
        padding: const EdgeInsets.all(AppSpacing.x5),
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
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < entries.length; index++) ...[
          _EntryCard(
            entry: entries[index],
            reason: _findReason(snapshot.reasons, entries[index].reasonId),
            expanded: expandedId == entries[index].id,
            onToggle: () => onToggle(entries[index].id),
            onUnblock: () => onUnblock(entries[index].id),
          ),
          if (index != entries.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.reason,
    required this.expanded,
    required this.onToggle,
    required this.onUnblock,
  });

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return VitCard(
      key: P2PBlacklistPage.entryKey(entry.id),
      radius: VitCardRadius.lg,
      borderColor: expanded ? color.withValues(alpha: .38) : null,
      clip: true,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  _Avatar(entry: entry, reason: reason),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                entry.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            if (entry.isVerified) ...[
                              const SizedBox(width: AppSpacing.x2),
                              const Icon(
                                Icons.verified_outlined,
                                color: AppColors.primary,
                                size: 11,
                              ),
                            ],
                            if (entry.badge != null) ...[
                              const SizedBox(width: AppSpacing.x2),
                              VitStatusPill(
                                label: entry.badge == 'elite' ? 'Elite' : 'Pro',
                                status: VitStatusPillStatus.purple,
                                size: VitStatusPillSize.sm,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Row(
                          children: [
                            _SmallReasonPill(reason: reason),
                            const SizedBox(width: AppSpacing.x3),
                            Text(
                              _timeAgo(entry.blockedAt),
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _ExpandedEntry(entry: entry, reason: reason, onUnblock: onUnblock),
        ],
      ),
    );
  }
}

class _ExpandedEntry extends StatelessWidget {
  const _ExpandedEntry({
    required this.entry,
    required this.reason,
    required this.onUnblock,
  });

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_reasonIcon(reason.iconKey), color: color, size: 14),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    entry.reasonText,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _TinyStat(
                  value: '${entry.tradesBefore}',
                  label: 'Đơn trước chặn',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _TinyStat(
                  value: '${entry.completionRate.toStringAsFixed(1)}%',
                  label: 'Tỷ lệ HT',
                  color: entry.completionRate < 50
                      ? AppColors.sell
                      : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _TinyStat(
                  value: _shortDate(entry.blockedAt),
                  label: 'Ngày chặn',
                ),
              ),
            ],
          ),
          if (entry.orderId != null) ...[
            const SizedBox(height: AppSpacing.x3),
            _OrderLink(orderId: entry.orderId!),
          ],
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: P2PBlacklistPage.unblockKey(entry.id),
                  variant: VitCtaButtonVariant.success,
                  height: 40,
                  onPressed: onUnblock,
                  leading: const Icon(Icons.check_circle_outline_rounded),
                  child: const Text('Bỏ chặn'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.ghost,
                  height: 40,
                  onPressed: () => HapticFeedback.selectionClick(),
                  leading: const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.warn,
                  ),
                  child: const Text('Báo cáo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.entry, required this.reason});

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.sell10,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.sell20, width: 1.5),
          ),
          child: Center(
            child: Text(
              entry.username.characters.first.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: Icon(
              _reasonIcon(reason.iconKey),
              color: Colors.white,
              size: 8,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.snapshot});

  final P2PBlacklistSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PBlacklistPage.infoKey,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoText,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonCountPill extends StatelessWidget {
  const _ReasonCountPill({required this.reason, required this.count});

  final P2PBlacklistReasonDraft reason;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_reasonIcon(reason.iconKey), color: color, size: 10),
          const SizedBox(width: AppSpacing.x1),
          Text(
            reason.label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              '$count',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallReasonPill extends StatelessWidget {
  const _SmallReasonPill({required this.reason});

  final P2PBlacklistReasonDraft reason;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        reason.label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ReasonIconBubble extends StatelessWidget {
  const _ReasonIconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({required this.value, required this.label, this.color});

  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x2),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderLink extends StatelessWidget {
  const _OrderLink({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Đơn liên quan: $orderId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, int> _reasonCounts(List<P2PBlacklistEntryDraft> entries) {
  final counts = <String, int>{};
  for (final entry in entries) {
    counts[entry.reasonId] = (counts[entry.reasonId] ?? 0) + 1;
  }
  return counts;
}

P2PBlacklistReasonDraft _findReason(
  List<P2PBlacklistReasonDraft> reasons,
  String id,
) {
  return reasons.firstWhere(
    (reason) => reason.id == id,
    orElse: () => reasons.last,
  );
}

IconData _reasonIcon(String iconKey) {
  return switch (iconKey) {
    'alert' => Icons.report_problem_outlined,
    'clock' => Icons.schedule_rounded,
    'ban' => Icons.block_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'info' => Icons.info_outline_rounded,
    _ => Icons.block_rounded,
  };
}

Color _reasonColor(P2PBlacklistReasonDraft reason) {
  return switch (reason.toneKey) {
    'danger' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    'primary' => AppColors.primary,
    _ => AppColors.text3,
  };
}

String _timeAgo(String raw) {
  final blockedAt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (blockedAt == null) return raw;
  final diff = DateTime.now().difference(blockedAt);
  final days = diff.inDays;
  if (days < 1) return 'Hôm nay';
  if (days == 1) return '1 ngày trước';
  if (days < 30) return '$days ngày trước';
  if (days < 365) return '${days ~/ 30} tháng trước';
  return '${days ~/ 365} năm trước';
}

String _shortDate(String raw) {
  final blockedAt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (blockedAt == null) return raw;
  return '${blockedAt.day}/${blockedAt.month}/${blockedAt.year}';
}
