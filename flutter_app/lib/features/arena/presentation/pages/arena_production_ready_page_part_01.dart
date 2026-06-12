part of 'arena_production_ready_page.dart';

class _ArenaProductionReadyPageState
    extends ConsumerState<ArenaProductionReadyPage> {
  _ProductionSection _activeSection = _ProductionSection.screens;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaProductionReady();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-206 ArenaProductionReadyPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Release Readiness',
            subtitle: 'Internal handoff - Open Arena',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaProductionReadyPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x5,
                      children: [
                        _ProductionHero(),
                        _SectionTabs(
                          active: _activeSection,
                          onChanged: (section) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeSection = section);
                          },
                        ),
                        _ActiveSection(
                          section: _activeSection,
                          snapshot: snapshot,
                          onRoute: (route) => _go(context, route),
                        ),
                        _InternalOnlyFooter(text: snapshot.disclaimer),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    HapticFeedback.selectionClick();
    context.go(_resolvedRoute(route));
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

class _ProductionHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '08 - Open Arena Release Readiness',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.arenaProductionHeroLineHeight,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                Text(
                  'QA/Dev handoff dashboard. Internal-only release checks, not an end-user production claim.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.arenaProductionBodyLineHeight,
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

  final _ProductionSection active;
  final ValueChanged<_ProductionSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ArenaProductionReadyPage.tabsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final config in _sectionConfigs) ...[
            _SectionTabPill(
              config: config,
              active: config.section == active,
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

class _SectionTabPill extends StatelessWidget {
  const _SectionTabPill({
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
        key: ArenaProductionReadyPage.tabKey(config.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.arenaProductionTabHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : AppColors.surface2,
            border: Border.all(
              color: active
                  ? AppColors.primary.withValues(alpha: .55)
                  : AppColors.cardBorder,
              width: active ? 1.5 : 1,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                config.icon,
                color: active ? AppColors.primary : AppColors.text2,
                size: AppSpacing.arenaProductionTabIcon,
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
    );
  }
}

class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _ProductionSection section;
  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _ProductionSection.screens,
    id: 'screens',
    label: 'Screens',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.states,
    id: 'states',
    label: 'States',
    icon: Icons.visibility_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.flows,
    id: 'flows',
    label: 'Flows',
    icon: Icons.map_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.registry,
    id: 'registry',
    label: 'Registry',
    icon: Icons.inventory_2_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.handoff,
    id: 'handoff',
    label: 'Handoff',
    icon: Icons.description_outlined,
  ),
];

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.onRoute,
  });

  final _ProductionSection section;
  final ArenaProductionReadySnapshot snapshot;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _ProductionSection.screens => _ScreensSection(
        screens: snapshot.canonicalScreens,
        onRoute: onRoute,
      ),
      _ProductionSection.states => _StatesSection(
        screens: snapshot.canonicalScreens,
      ),
      _ProductionSection.flows => _FlowsSection(
        flows: snapshot.flows,
        onRoute: onRoute,
      ),
      _ProductionSection.registry => _RegistrySection(
        screens: [...snapshot.canonicalScreens, ...snapshot.supportingScreens],
      ),
      _ProductionSection.handoff => _HandoffSection(snapshot: snapshot),
    };
  }
}

class _ScreensSection extends StatelessWidget {
  const _ScreensSection({required this.screens, required this.onRoute});

  final List<ArenaProductionScreenDraft> screens;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'A - Canonical Screens (vFinal)',
          accentColor: AppColors.accent,
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        Text(
          '7 core screens đã được consolidate thành bản vFinal. Mỗi screen đã audit: trust-first, accessibility, states đầy đủ.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.arenaProductionBodyLineHeight,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        for (final screen in screens) ...[
          _ProductionScreenCard(screen: screen, onRoute: onRoute),
          if (screen != screens.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        ],
      ],
    );
  }
}

class _ProductionScreenCard extends StatelessWidget {
  const _ProductionScreenCard({required this.screen, required this.onRoute});

  final ArenaProductionScreenDraft screen;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaProductionReadyPage.screenKey(screen.name),
      onTap: () => onRoute(screen.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.arenaProductionScreenMinHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        screen.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.arenaProductionTitleLineHeight,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _StatusPill(status: screen.status),
                  ],
                ),
              ),
              Text(
                screen.version,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Text(
            screen.route,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Text(
            screen.notes,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.arenaProductionBodyLineHeight,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in screen.states)
                _StateMiniPill(label: _stateLabel(state)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatesSection extends StatelessWidget {
  const _StatesSection({required this.screens});

  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final states = ArenaProductionScreenState.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'B - State Matrix',
          accentColor: AppColors.warn,
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        Text(
          'Lưới states cho từng core screen. Chỉ hiển thị states thực sự áp dụng.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.arenaProductionBodyLineHeight,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in states)
                _StateLegendItem(state: state, active: true),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        for (final screen in screens) ...[
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screen.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final state in states)
                      _StateMatrixPill(
                        state: state,
                        active: screen.states.contains(state),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (screen != screens.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        ],
      ],
    );
  }
}

class _FlowsSection extends StatelessWidget {
  const _FlowsSection({required this.flows, required this.onRoute});

  final List<ArenaProductionFlowDraft> flows;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'C - End-to-End Flows',
          accentColor: AppColors.primary,
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        Text(
          'Các flow chính có prototype link thật. Tap step để navigate bằng route canonical.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.arenaProductionBodyLineHeight,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        for (final flow in flows) ...[
          _FlowCard(flow: flow, onRoute: onRoute),
          if (flow != flows.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        ],
      ],
    );
  }
}
