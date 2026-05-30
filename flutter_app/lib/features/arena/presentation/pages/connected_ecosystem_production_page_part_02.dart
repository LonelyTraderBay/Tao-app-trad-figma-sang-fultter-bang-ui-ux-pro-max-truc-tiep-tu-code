part of 'connected_ecosystem_production_page.dart';

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.flow, required this.onRoute});

  final ConnectedFlowDraft flow;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(flow.tone);
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: Icons.map_outlined, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flow.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${flow.steps.length} steps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < flow.steps.length; i++)
            _FlowStepRow(
              flowId: flow.id,
              step: flow.steps[i],
              index: i,
              isLast: i == flow.steps.length - 1,
              color: color,
              onRoute: onRoute,
            ),
        ],
      ),
    );
  }
}

class _FlowStepRow extends StatelessWidget {
  const _FlowStepRow({
    required this.flowId,
    required this.step,
    required this.index,
    required this.isLast,
    required this.color,
    required this.onRoute,
  });

  final String flowId;
  final ConnectedFlowStepDraft step;
  final int index;
  final bool isLast;
  final Color color;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ConnectedEcosystemProductionPage.flowStepKey(flowId, step.label),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: step.isBridge
                    ? color.withValues(alpha: .18)
                    : AppColors.surface2,
                border: Border.all(
                  color: step.isBridge ? color : AppColors.borderSolid,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: step.isBridge
                    ? Icon(Icons.link_rounded, color: color, size: 11)
                    : Text(
                        '${index + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 38,
                color: (step.isBridge ? color : AppColors.borderSolid)
                    .withValues(alpha: .35),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        step.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (step.isBridge) ...[
                      const SizedBox(width: AppSpacing.x2),
                      _MiniPill(label: 'BRIDGE', color: color),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                _SmallTextAction(
                  label: step.route,
                  icon: Icons.chevron_right_rounded,
                  color: color,
                  onTap: () => onRoute(step.route),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RegistrySection extends StatelessWidget {
  const _RegistrySection({
    required this.sharedItems,
    required this.separateItems,
    required this.forbiddenPatterns,
  });

  final List<ConnectedRegistryItemDraft> sharedItems;
  final List<ConnectedRegistryItemDraft> separateItems;
  final List<ConnectedForbiddenPatternDraft> forbiddenPatterns;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Shared vs Separate Registry',
          accentColor: AppModuleAccents.predictions,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Ranh giới rõ ràng: items nào được share, items nào phải tách biệt.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _RegistryBoard(
          title: 'Shared (Connect by Content)',
          items: sharedItems,
          color: AppColors.buy,
          icon: Icons.link_rounded,
        ),
        const SizedBox(height: AppSpacing.x4),
        _RegistryBoard(
          title: 'Separate (Never Merge)',
          items: separateItems,
          color: AppColors.sell,
          icon: Icons.shield_outlined,
        ),
        const SizedBox(height: AppSpacing.x5),
        const VitModuleSectionHeader(
          title: 'Forbidden UX Patterns',
          accentColor: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final pattern in forbiddenPatterns) ...[
          _ForbiddenPatternCard(pattern: pattern),
          if (pattern != forbiddenPatterns.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RegistryBoard extends StatelessWidget {
  const _RegistryBoard({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });

  final String title;
  final List<ConnectedRegistryItemDraft> items;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: icon, color: color, small: true),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final item in items) ...[
            _RegistryItemRow(item: item, color: color),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _RegistryItemRow extends StatelessWidget {
  const _RegistryItemRow({required this.item, required this.color});

  final ConnectedRegistryItemDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_rounded, color: color, size: 13),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ForbiddenPatternCard extends StatelessWidget {
  const _ForbiddenPatternCard({required this.pattern});

  final ConnectedForbiddenPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(pattern.severity);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .20),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.block_rounded, color: color, size: 15),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pattern.pattern,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    _MiniPill(
                      label: _severityLabel(pattern.severity),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  pattern.reason,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.4,
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

class _HandoffSection extends StatelessWidget {
  const _HandoffSection({
    required this.snapshot,
    required this.activeBoard,
    required this.onBoardChanged,
  });

  final ConnectedEcosystemProductionSnapshot snapshot;
  final String activeBoard;
  final ValueChanged<String> onBoardChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Dev / QA Handoff Pack',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final board in _handoffBoards) ...[
                _BoardChip(
                  board: board,
                  active: activeBoard == board.id,
                  onTap: () => onBoardChanged(board.id),
                ),
                if (board != _handoffBoards.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (activeBoard == 'routes')
          _RouteRegistry(routes: snapshot.routeRegistry)
        else if (activeBoard == 'components')
          _ComponentRegistry(components: snapshot.componentRegistry)
        else if (activeBoard == 'rules')
          _BridgeRules(rules: snapshot.bridgeRules)
        else
          _QaChecklist(items: snapshot.qaChecklist),
      ],
    );
  }
}

class _BoardChip extends StatelessWidget {
  const _BoardChip({
    required this.board,
    required this.active,
    required this.onTap,
  });

  final _HandoffBoard board;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        key: ConnectedEcosystemProductionPage.handoffKey(board.id),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : AppColors.surface2,
            border: Border.all(
              color: active
                  ? AppColors.primary.withValues(alpha: .45)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                board.icon,
                color: active ? AppColors.primary : AppColors.text2,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                board.label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteRegistry extends StatelessWidget {
  const _RouteRegistry({required this.routes});

  final List<ConnectedRouteEntryDraft> routes;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Route Registry',
      subtitle: '${routes.length} routes with bridge integration',
      children: [
        for (final route in routes)
          _HandoffRow(
            title: route.page,
            subtitle: route.route,
            trailing: _MiniPill(
              label: _bridgeTypeLabel(route.bridgeType),
              color: _bridgeTypeColor(route.bridgeType),
            ),
          ),
      ],
    );
  }
}

class _ComponentRegistry extends StatelessWidget {
  const _ComponentRegistry({required this.components});

  final List<ConnectedComponentEntryDraft> components;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Component Registry',
      subtitle: '${components.length} shared bridge components',
      children: [
        for (final component in components)
          _HandoffRow(
            title: component.name,
            subtitle: '${component.file} · ${component.disclosure}',
            trailing: _MiniPill(
              label: component.module,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}
