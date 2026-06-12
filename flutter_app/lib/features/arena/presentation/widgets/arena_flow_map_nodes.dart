part of '../pages/arena_flow_map_page.dart';

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
                  const Divider(
                    height: AppSpacing.arenaFlowMapDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.alt_route_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.arenaFlowMapSmallIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        group.connectionNote,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.arenaFlowMapConnectionLineHeight,
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: color,
                  size: AppSpacing.arenaFlowMapInlineIcon,
                ),
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
                          height: AppSpacing.arenaFlowMapBodyLineHeight,
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
