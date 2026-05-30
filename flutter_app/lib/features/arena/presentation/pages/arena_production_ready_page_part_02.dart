part of 'arena_production_ready_page.dart';

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.flow, required this.onRoute});

  final ArenaProductionFlowDraft flow;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(flow.id);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_flowIcon(flow.id), color: color, size: 17),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  flow.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Container(
                width: AppSpacing.x4,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < flow.steps.length; i++)
            _FlowStepRow(
              flowId: flow.id,
              step: flow.steps[i],
              color: color,
              first: i == 0,
              last: i == flow.steps.length - 1,
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
    required this.color,
    required this.first,
    required this.last,
    required this.onRoute,
  });

  final String flowId;
  final ArenaProductionFlowStepDraft step;
  final Color color;
  final bool first;
  final bool last;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: first ? color : AppColors.transparent,
                    border: Border.all(color: color, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: color.withValues(alpha: .30),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: InkWell(
              key: ArenaProductionReadyPage.flowStepKey(flowId, step.label),
              onTap: () => onRoute(step.route),
              borderRadius: AppRadii.smRadius,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: last ? 0 : AppSpacing.x4,
                  left: AppSpacing.x1,
                  right: AppSpacing.x1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      step.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrySection extends StatelessWidget {
  const _RegistrySection({required this.screens});

  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'D - Live vs Release-gated vs QA',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Clear labels: Live = implemented local UI, Release-gated = not user-available, QA = internal only.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              for (final status in ArenaProductionScreenStatus.values) ...[
                Expanded(
                  child: _StatusMetric(status: status, screens: screens),
                ),
                if (status != ArenaProductionScreenStatus.values.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final status in ArenaProductionScreenStatus.values) ...[
          _StatusGroup(status: status, screens: screens),
          const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.status, required this.screens});

  final ArenaProductionScreenStatus status;
  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final count = screens.where((screen) => screen.status == status).length;
    final color = _statusColor(status);

    return Column(
      children: [
        Text(
          '$count',
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          _statusLabel(status),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({required this.status, required this.screens});

  final ArenaProductionScreenStatus status;
  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final items = screens.where((screen) => screen.status == status).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    final color = _statusColor(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${_statusLabel(status)} (${items.length})',
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                _RegistryRow(
                  screen: items[i],
                  color: color,
                  divider: i < items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegistryRow extends StatelessWidget {
  const _RegistryRow({
    required this.screen,
    required this.color,
    required this.divider,
  });

  final ArenaProductionScreenDraft screen;
  final Color color;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screen.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  screen.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            screen.version,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HandoffSection extends StatelessWidget {
  const _HandoffSection({required this.snapshot});

  final ArenaProductionReadySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final allScreens = [
      ...snapshot.canonicalScreens,
      ...snapshot.supportingScreens,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'E - Dev Handoff Pack',
          accentColor: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '4 handoff boards: Route Registry, Component Registry, Trust & Governance Rules, Points Ledger / Resolution Dictionary.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _HandoffBoard(
          icon: Icons.map_outlined,
          color: AppColors.accent,
          title: '1. Route Registry',
          child: Column(
            children: [
              for (final screen in allScreens)
                _RouteRegistryLine(screen: screen),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _HandoffBoard(
          icon: Icons.layers_outlined,
          color: AppColors.primary,
          title: '2. Component Registry (${snapshot.components.length})',
          child: Column(
            children: [
              for (final component in snapshot.components)
                _ComponentLine(component: component),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final dictionary in snapshot.dictionaries) ...[
          _DictionaryBoard(dictionary: dictionary),
          const SizedBox(height: AppSpacing.x4),
        ],
        _HandoffBoard(
          icon: Icons.check_circle_outline,
          color: AppColors.buy,
          title: 'QA Checklist - Pre-ship',
          child: Column(
            children: [
              for (final item in snapshot.qaItems) _ChecklistLine(label: item),
            ],
          ),
        ),
      ],
    );
  }
}

class _HandoffBoard extends StatelessWidget {
  const _HandoffBoard({
    required this.icon,
    required this.color,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final Color color;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          child,
        ],
      ),
    );
  }
}

class _RouteRegistryLine extends StatelessWidget {
  const _RouteRegistryLine({required this.screen});

  final ArenaProductionScreenDraft screen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          _StatusPill(status: screen.status),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              screen.route,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            screen.version,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
