part of 'connected_ecosystem_production_page.dart';

class _EcosystemHero extends StatelessWidget {
  const _EcosystemHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TintIcon(
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Connected Ecosystem',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const _StatusPill(
                      label: 'PRODUCTION',
                      color: AppColors.buy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Consolidation 09A - 09D',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.arenaEcosystemMetricLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'Release-readiness handoff for Open Arena x Prediction Markets. The modules may share content/topic context while keeping financial surfaces fully separated.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.arenaEcosystemBodyLineHeight,
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

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.active, required this.onChanged});

  final _EcosystemSection active;
  final ValueChanged<_EcosystemSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ConnectedEcosystemProductionPage.tabsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final config in _sectionConfigs) ...[
            _TabPill(
              config: config,
              active: active == config.section,
              onTap: () => onChanged(config.section),
            ),
            if (config != _sectionConfigs.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.config,
    required this.active,
    required this.onTap,
  });

  final _SectionConfig config;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ConnectedEcosystemProductionPage.tabKey(config.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.arenaEcosystemTabHeight,
          child: Material(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(
                color: active
                    ? AppColors.primary.withValues(alpha: .55)
                    : AppColors.cardBorder,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: AppSpacing.arenaHorizontalPaddingX4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    config.icon,
                    color: active ? AppColors.primary : AppColors.text2,
                    size: AppSpacing.arenaEcosystemTabIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    config.label,
                    style: AppTextStyles.micro.copyWith(
                      color: active ? AppColors.primary : AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.activeHandoffBoard,
    required this.onHandoffBoardChanged,
    required this.onRoute,
  });

  final _EcosystemSection section;
  final ConnectedEcosystemProductionSnapshot snapshot;
  final String activeHandoffBoard;
  final ValueChanged<String> onHandoffBoardChanged;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _EcosystemSection.canonical => _CanonicalSection(
        screens: snapshot.canonicalScreens,
        onRoute: onRoute,
      ),
      _EcosystemSection.states => _StatesSection(states: snapshot.bridgeStates),
      _EcosystemSection.flows => _FlowsSection(
        flows: snapshot.connectedFlows,
        onRoute: onRoute,
      ),
      _EcosystemSection.registry => _RegistrySection(
        sharedItems: snapshot.sharedItems,
        separateItems: snapshot.separateItems,
        forbiddenPatterns: snapshot.forbiddenPatterns,
      ),
      _EcosystemSection.handoff => _HandoffSection(
        snapshot: snapshot,
        activeBoard: activeHandoffBoard,
        onBoardChanged: onHandoffBoardChanged,
      ),
    };
  }
}

class _CanonicalSection extends StatelessWidget {
  const _CanonicalSection({required this.screens, required this.onRoute});

  final List<ConnectedScreenDraft> screens;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final componentCount = screens
        .expand((screen) => screen.bridgeComponents)
        .toSet()
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Canonical Connected Screens',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '9 màn hình vFinal chứa bridge integration từ 09A-09D. Mỗi màn đã chọn canonical version tốt nhất.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: AppSpacing.arenaEcosystemIntroLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final screen in screens) ...[
          _CanonicalScreenCard(screen: screen, onRoute: onRoute),
          if (screen != screens.last) const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          borderColor: AppColors.buy.withValues(alpha: .22),
          padding: AppSpacing.arenaPaddingX4,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.buy,
                    size: AppSpacing.arenaEcosystemTabIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Summary',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  _SummaryMetric(
                    label: 'Total screens',
                    value: '${screens.length}',
                  ),
                  _SummaryMetric(
                    label: 'vFinal',
                    value:
                        '${screens.where((s) => s.status == ConnectedEcosystemScreenStatus.vFinal).length}',
                  ),
                  _SummaryMetric(
                    label: 'Bridge components',
                    value: '$componentCount',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CanonicalScreenCard extends StatelessWidget {
  const _CanonicalScreenCard({required this.screen, required this.onRoute});

  final ConnectedScreenDraft screen;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ConnectedEcosystemProductionPage.screenKey(screen.name),
      onTap: screen.route == '/' ? null : () => onRoute(screen.route),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.arenaEcosystemScreenMinHeight,
      ),
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  screen.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.arenaEcosystemTitleLineHeight,
                  ),
                ),
              ),
              _StatusPill(
                label: _statusLabel(screen.status),
                color: _statusColor(screen.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              _MiniPill(
                label: screen.source,
                color: AppModuleAccents.predictions,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  screen.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            screen.notes,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: AppSpacing.arenaEcosystemBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final component in screen.bridgeComponents)
                _MiniPill(label: component, color: AppColors.primary),
            ],
          ),
          if (screen.route != '/') ...[
            const SizedBox(height: AppSpacing.x2),
            _SmallTextAction(
              label: 'Mở trang',
              icon: Icons.open_in_new_rounded,
              color: AppColors.primary,
              onTap: () => onRoute(screen.route),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatesSection extends StatelessWidget {
  const _StatesSection({required this.states});

  final List<ConnectedBridgeStateDraft> states;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Bridge State Matrix',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '8 bridge-specific states. Mỗi state định nghĩa behavior, affected screens và fallback UI.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: AppSpacing.arenaEcosystemIntroLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final state in states) ...[
          _StateCard(state: state),
          if (state != states.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.state});

  final ConnectedBridgeStateDraft state;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(state.tone);
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: _toneIcon(state.tone), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    _MiniPill(label: state.id, color: color),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            state.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: AppSpacing.arenaEcosystemBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _InfoLine(
            icon: Icons.layers_outlined,
            text: 'Screens: ${state.affectedScreens.join(', ')}',
          ),
          const SizedBox(height: AppSpacing.x2),
          _InfoLine(
            icon: Icons.arrow_forward_rounded,
            text: 'Behavior: ${state.behavior}',
            color: color,
          ),
        ],
      ),
    );
  }
}

class _FlowsSection extends StatelessWidget {
  const _FlowsSection({required this.flows, required this.onRoute});

  final List<ConnectedFlowDraft> flows;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Connected E2E Flows',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '4 end-to-end flows kết nối 2 module. Bridge steps được đánh dấu bằng link icon.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: AppSpacing.arenaEcosystemIntroLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final flow in flows) ...[
          _FlowCard(flow: flow, onRoute: onRoute),
          if (flow != flows.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}
