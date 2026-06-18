part of '../pages/arena_flow_map_page.dart';

class _FlowHero extends StatelessWidget {
  const _FlowHero({required this.stats});

  final List<ArenaFlowStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.accent,
      padding: AppSpacing.arenaFlowMapHeroPadding,
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
              height: AppSpacing.arenaFlowMapHeroLineHeight,
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
      padding: AppSpacing.arenaFlowMapStatPadding,
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
              padding: AppSpacing.arenaFlowMapSectionTogglePadding,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: AppSpacing.arenaFlowMapSectionIcon,
                  ),
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
                      size: AppSpacing.arenaFlowMapInlineIcon,
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
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              ColoredBox(
                color: AppColors.surface2,
                child: Padding(
                  padding: AppSpacing.arenaFlowMapRouteHeaderPadding,
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
              ),
              for (final route in routes) ...[
                _RouteRow(route: route),
                if (route != routes.last)
                  const Divider(
                    height: AppSpacing.arenaFlowMapDividerHeight,
                    color: AppColors.divider,
                  ),
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
      padding: AppSpacing.arenaFlowMapRouteRowPadding,
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
