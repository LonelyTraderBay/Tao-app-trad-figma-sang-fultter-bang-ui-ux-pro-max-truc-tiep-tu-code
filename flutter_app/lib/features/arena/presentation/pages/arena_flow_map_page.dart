import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

class ArenaFlowMapPage extends ConsumerStatefulWidget {
  const ArenaFlowMapPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc197_flow_map_content');
  static const checkAllKey = Key('sc197_check_all');

  static Key sectionKey(String id) => Key('sc197_section_$id');
  static Key nodeKey(String label) => Key('sc197_node_$label');
  static Key qaKey(String id) => Key('sc197_qa_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaFlowMapPage> createState() => _ArenaFlowMapPageState();
}

class _ArenaFlowMapPageState extends ConsumerState<ArenaFlowMapPage> {
  String _expandedSection = 'flow';
  final Set<String> _checkedQa = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaFlowMap();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-197 ArenaFlowMapPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Open Arena Flow Map',
              subtitle: '06F — Prototype & QA',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaFlowMapPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _FlowHero(stats: snapshot.stats),
                      _CollapsibleSection(
                        id: 'flow',
                        title: 'SECTION 1 — Flow Map',
                        badge: '${snapshot.groups.length} flows',
                        icon: Icons.map_outlined,
                        color: AppColors.primary,
                        expanded: _expandedSection == 'flow',
                        onTap: () => _toggle('flow'),
                        child: _FlowMapBody(
                          snapshot: snapshot,
                          onRoute: (route) => _go(context, route),
                        ),
                      ),
                      _CollapsibleSection(
                        id: 'handoff',
                        title: 'SECTION 2 — Handoff Notes',
                        badge: '${snapshot.handoffNotes.length} notes',
                        icon: Icons.menu_book_outlined,
                        color: AppColors.warn,
                        expanded: _expandedSection == 'handoff',
                        onTap: () => _toggle('handoff'),
                        child: _HandoffNotes(notes: snapshot.handoffNotes),
                      ),
                      _CollapsibleSection(
                        id: 'qa',
                        title: 'SECTION 3 — QA Checklist',
                        badge:
                            '${_checkedQa.length}/${snapshot.qaItems.length}',
                        icon: Icons.check_circle_outline,
                        color: AppColors.buy,
                        expanded: _expandedSection == 'qa',
                        onTap: () => _toggle('qa'),
                        child: _QaChecklist(
                          items: snapshot.qaItems,
                          checkedIds: _checkedQa,
                          onToggle: (id) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              if (!_checkedQa.add(id)) _checkedQa.remove(id);
                            });
                          },
                          onCheckAll: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _checkedQa
                                ..clear()
                                ..addAll(
                                  snapshot.qaItems.map((item) => item.id),
                                );
                            });
                          },
                        ),
                      ),
                      _FlowDisclaimer(text: snapshot.disclaimer),
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

  void _toggle(String id) {
    HapticFeedback.selectionClick();
    setState(() => _expandedSection = _expandedSection == id ? '' : id);
  }

  void _go(BuildContext context, String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _FlowHero extends StatelessWidget {
  const _FlowHero({required this.stats});

  final List<ArenaFlowStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.accent,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.map_outlined,
                color: AppColors.accent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Open Arena Module',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Flow map hoàn chỉnh cho toàn bộ module Open Arena — 10 pages, 10 routes, 4 shared component files, 12+ challenge states.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _StatTile(stat: stat)),
                if (stat != stats.last) const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final ArenaFlowStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(stat.kind);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatelessWidget {
  const _CollapsibleSection({
    required this.id,
    required this.title,
    required this.badge,
    required this.icon,
    required this.color,
    required this.expanded,
    required this.onTap,
    required this.child,
  });

  final String id;
  final String title;
  final String badge;
  final IconData icon;
  final Color color;
  final bool expanded;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ArenaFlowMapPage.sectionKey(id),
            onTap: onTap,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 17),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    badge,
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  AnimatedRotation(
                    turns: expanded ? .25 : 0,
                    duration: const Duration(milliseconds: 160),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (expanded) child,
      ],
    );
  }
}

class _FlowMapBody extends StatelessWidget {
  const _FlowMapBody({required this.snapshot, required this.onRoute});

  final ArenaFlowMapSnapshot snapshot;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RouteRegistry(routes: snapshot.routes),
        const SizedBox(height: AppSpacing.x5),
        for (final group in snapshot.groups) ...[
          _FlowGroupCard(group: group, onRoute: onRoute),
          const SizedBox(height: AppSpacing.x5),
        ],
        _SharedComponents(components: snapshot.components),
      ],
    );
  }
}

class _RouteRegistry extends StatelessWidget {
  const _RouteRegistry({required this.routes});

  final List<ArenaFlowRouteDraft> routes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionLabel(title: 'Route Registry', color: AppColors.primary),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                color: AppColors.surface2,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                  vertical: AppSpacing.x3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ROUTE',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      'STATUS',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              for (final route in routes) ...[
                _RouteRow(route: route),
                if (route != routes.last)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.route});

  final ArenaFlowRouteDraft route;

  @override
  Widget build(BuildContext context) {
    final live = route.status == 'Live';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.path,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  route.page,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitStatusPill(
            label: route.status,
            status: live
                ? VitStatusPillStatus.success
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.sm,
          ),
        ],
      ),
    );
  }
}

class _FlowGroupCard extends StatelessWidget {
  const _FlowGroupCard({required this.group, required this.onRoute});

  final ArenaFlowGroupDraft group;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(group.kind);
    return Column(
      children: [
        _SectionLabel(
          title: group.title,
          subtitle: group.subtitle,
          color: color,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            children: [
              for (final node in group.nodes) ...[
                _FlowNodeRow(node: node, onRoute: onRoute),
                if (node != group.nodes.last)
                  const Divider(height: 1, color: AppColors.divider),
              ],
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.alt_route_rounded,
                      color: AppColors.text3,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        group.connectionNote,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlowNodeRow extends StatelessWidget {
  const _FlowNodeRow({required this.node, required this.onRoute});

  final ArenaFlowNodeDraft node;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(node.kind);
    final route = node.route;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaFlowMapPage.nodeKey(node.label),
        onTap: route == null ? null : () => onRoute(route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              _FlowIcon(kind: node.kind),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      node.sublabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (node.stateLabel != null) ...[
                const SizedBox(width: AppSpacing.x2),
                VitStatusPill(
                  label: node.stateLabel!,
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
              ],
              if (route != null) ...[
                const SizedBox(width: AppSpacing.x2),
                Icon(Icons.chevron_right_rounded, color: color, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SharedComponents extends StatelessWidget {
  const _SharedComponents({required this.components});

  final List<ArenaFlowComponentDraft> components;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionLabel(
          title: 'Shared Components',
          color: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final component in components) ...[
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _FlowIcon(kind: ArenaFlowKind.verified),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        component.file,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  component.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final export in component.exports)
                      VitStatusPill(
                        label: export,
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (component != components.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _HandoffNotes extends StatelessWidget {
  const _HandoffNotes({required this.notes});

  final List<ArenaFlowNoteDraft> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final note in notes) ...[
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            borderColor: _flowColor(note.kind).withValues(alpha: .22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FlowIcon(kind: note.kind),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        note.detail,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (note != notes.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _QaChecklist extends StatelessWidget {
  const _QaChecklist({
    required this.items,
    required this.checkedIds,
    required this.onToggle,
    required this.onCheckAll,
  });

  final List<ArenaFlowQaDraft> items;
  final Set<String> checkedIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onCheckAll;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ArenaFlowQaDraft>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final percent = items.isEmpty ? 0.0 : checkedIds.length / items.length;

    return Column(
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: checkedIds.length == items.length
              ? AppColors.buy20
              : AppColors.cardBorder,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tiến độ QA',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${(percent * 100).round()}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: checkedIds.length == items.length
                          ? AppColors.buy
                          : AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              _MiniProgress(value: percent, color: AppColors.buy),
              const SizedBox(height: AppSpacing.x3),
              VitCard(
                key: ArenaFlowMapPage.checkAllKey,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.sm,
                onTap: onCheckAll,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Center(
                  child: Text(
                    'Check tất cả',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final entry in grouped.entries) ...[
          _QaCategory(
            category: entry.key,
            items: entry.value,
            checkedIds: checkedIds,
            onToggle: onToggle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _QaCategory extends StatelessWidget {
  const _QaCategory({
    required this.category,
    required this.items,
    required this.checkedIds,
    required this.onToggle,
  });

  final String category;
  final List<ArenaFlowQaDraft> items;
  final Set<String> checkedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final checked = items.where((item) => checkedIds.contains(item.id)).length;
    return Column(
      children: [
        _SectionLabel(
          title: category,
          subtitle: '$checked/${items.length}',
          color: checked == items.length ? AppColors.buy : AppColors.text3,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final item in items) ...[
                _QaRow(
                  item: item,
                  checked: checkedIds.contains(item.id),
                  onTap: () => onToggle(item.id),
                ),
                if (item != items.last)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _QaRow extends StatelessWidget {
  const _QaRow({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final ArenaFlowQaDraft item;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaFlowMapPage.qaKey(item.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: checked ? AppColors.buy : AppColors.text3,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: checked ? AppColors.text1 : AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowDisclaimer extends StatelessWidget {
  const _FlowDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: 17,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.color,
    this.subtitle,
  });

  final String title;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlowIcon extends StatelessWidget {
  const _FlowIcon({required this.kind});

  final ArenaFlowKind kind;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(kind);
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(_flowIcon(kind), color: color, size: AppSpacing.iconMd),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: Container(
        height: AppSpacing.x3,
        color: AppColors.surface3,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0).toDouble(),
          child: Container(color: color),
        ),
      ),
    );
  }
}

Color _flowColor(ArenaFlowKind kind) {
  return switch (kind) {
    ArenaFlowKind.core => AppColors.primary,
    ArenaFlowKind.discovery => AppColors.primary,
    ArenaFlowKind.creator => AppColors.buy,
    ArenaFlowKind.participant => AppColors.buy,
    ArenaFlowKind.owner => AppColors.sell,
    ArenaFlowKind.points => AppColors.warn,
    ArenaFlowKind.verified => AppColors.accent,
    ArenaFlowKind.safety => AppColors.sell,
    ArenaFlowKind.neutral => AppColors.text2,
  };
}

IconData _flowIcon(ArenaFlowKind kind) {
  return switch (kind) {
    ArenaFlowKind.core => Icons.home_outlined,
    ArenaFlowKind.discovery => Icons.search_outlined,
    ArenaFlowKind.creator => Icons.auto_awesome_outlined,
    ArenaFlowKind.participant => Icons.play_arrow_outlined,
    ArenaFlowKind.owner => Icons.star_outline_rounded,
    ArenaFlowKind.points => Icons.card_giftcard_outlined,
    ArenaFlowKind.verified => Icons.verified_outlined,
    ArenaFlowKind.safety => Icons.shield_outlined,
    ArenaFlowKind.neutral => Icons.circle_outlined,
  };
}
