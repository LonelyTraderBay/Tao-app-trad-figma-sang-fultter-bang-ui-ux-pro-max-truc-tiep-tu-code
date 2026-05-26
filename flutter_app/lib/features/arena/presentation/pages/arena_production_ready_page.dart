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

enum _ProductionSection { screens, states, flows, registry, handoff }

class ArenaProductionReadyPage extends ConsumerStatefulWidget {
  const ArenaProductionReadyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc206_production_ready_content');
  static const tabsKey = Key('sc206_production_ready_tabs');

  static Key tabKey(String id) => Key('sc206_tab_$id');
  static Key screenKey(String name) => Key('sc206_screen_$name');
  static Key flowStepKey(String id, String label) =>
      Key('sc206_flow_${id}_$label');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaProductionReadyPage> createState() =>
      _ArenaProductionReadyPageState();
}

class _ArenaProductionReadyPageState
    extends ConsumerState<ArenaProductionReadyPage> {
  _ProductionSection _activeSection = _ProductionSection.screens;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
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
        child: Column(
          children: [
            VitHeader(
              title: 'Production Ready',
              subtitle: 'Sẵn sàng · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
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
                  '08 - Open Arena Production Ready',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'QA/Dev handoff dashboard. Trang này chỉ dành cho nội bộ, không hiển thị cho end-user.',
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
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ArenaProductionReadyPage.tabKey(config.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: 44,
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
                size: 15,
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
        const SizedBox(height: AppSpacing.x4),
        Text(
          '7 core screens đã được consolidate thành bản vFinal. Mỗi screen đã audit: trust-first, accessibility, states đầy đủ.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final screen in screens) ...[
          _ProductionScreenCard(screen: screen, onRoute: onRoute),
          if (screen != screens.last) const SizedBox(height: AppSpacing.x4),
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
      constraints: const BoxConstraints(minHeight: 132),
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
                          height: 1.2,
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
          const SizedBox(height: AppSpacing.x3),
          Text(
            screen.route,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            screen.notes,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
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
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Lưới states cho từng core screen. Chỉ hiển thị states thực sự áp dụng.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
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
        const SizedBox(height: AppSpacing.x4),
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
                const SizedBox(height: AppSpacing.x3),
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
          if (screen != screens.last) const SizedBox(height: AppSpacing.x3),
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
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Các flow chính có prototype link thật. Tap step để navigate bằng route canonical.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.45,
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
                    color: first ? color : Colors.transparent,
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
          title: 'D - Production vs Future vs QA',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Phân loại rõ ràng: Live = production, Future = chưa build, QA = internal only.',
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

class _ComponentLine extends StatelessWidget {
  const _ComponentLine({required this.component});

  final ArenaProductionComponentDraft component;

  @override
  Widget build(BuildContext context) {
    final color = _componentColor(component.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x2,
              vertical: AppSpacing.x1,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .13),
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              component.type,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  component.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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

class _DictionaryBoard extends StatelessWidget {
  const _DictionaryBoard({required this.dictionary});

  final ArenaProductionDictionaryDraft dictionary;

  @override
  Widget build(BuildContext context) {
    return _HandoffBoard(
      icon: Icons.menu_book_outlined,
      color: AppColors.warn,
      title: dictionary.category,
      child: Column(
        children: [
          for (final item in dictionary.items) _DictionaryLine(item: item),
        ],
      ),
    );
  }
}

class _DictionaryLine extends StatelessWidget {
  const _DictionaryLine({required this.item});

  final ArenaProductionDictionaryItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x2,
              vertical: AppSpacing.x1,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              item.code,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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

class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.buy,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InternalOnlyFooter extends StatelessWidget {
  const _InternalOnlyFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 14),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ArenaProductionScreenStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StateMiniPill extends StatelessWidget {
  const _StateMiniPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text2, height: 1),
      ),
    );
  }
}

class _StateLegendItem extends StatelessWidget {
  const _StateLegendItem({required this.state, required this.active});

  final ArenaProductionScreenState state;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = _stateColor(state);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_stateIcon(state), color: color, size: 12),
        const SizedBox(width: AppSpacing.x1),
        Text(
          _stateLabel(state),
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.text2 : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _StateMatrixPill extends StatelessWidget {
  const _StateMatrixPill({required this.state, required this.active});

  final ArenaProductionScreenState state;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = _stateColor(state);

    return Opacity(
      opacity: active ? 1 : .32,
      child: Container(
        constraints: const BoxConstraints(minWidth: 70),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          borderRadius: AppRadii.xsRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_stateIcon(state), color: color, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                _stateLabel(state),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: active ? AppTextStyles.bold : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _resolvedRoute(String route) {
  if (route == '/arena/production-ready') {
    return AppRoutePaths.arenaProduction;
  }
  if (route == '/arena/report/:caseId') {
    return AppRoutePaths.arenaReportCase('rpt001');
  }
  if (route == '/arena/ledger/entry/:entryId') {
    return AppRoutePaths.arenaLedgerEntry('entry001');
  }
  if (route == '/arena/challenge/:challengeId' ||
      route == '/arena/challenge/:id') {
    return AppRoutePaths.arenaChallenge('ch003');
  }
  if (route == '/arena/join/:id') {
    return AppRoutePaths.arenaJoin('ch003');
  }
  if (route == '/arena/mode/:id') {
    return AppRoutePaths.arenaMode('mode001');
  }
  if (route == '/arena/creator/:id') {
    return AppRoutePaths.arenaCreator('cr001');
  }
  return route;
}

String _statusLabel(ArenaProductionScreenStatus status) {
  return switch (status) {
    ArenaProductionScreenStatus.live => 'Live',
    ArenaProductionScreenStatus.future => 'Future',
    ArenaProductionScreenStatus.qaOnly => 'QA/Dev',
    ArenaProductionScreenStatus.archived => 'Archived',
  };
}

Color _statusColor(ArenaProductionScreenStatus status) {
  return switch (status) {
    ArenaProductionScreenStatus.live => AppColors.buy,
    ArenaProductionScreenStatus.future => AppColors.accent,
    ArenaProductionScreenStatus.qaOnly => AppColors.primary,
    ArenaProductionScreenStatus.archived => AppColors.text3,
  };
}

String _stateLabel(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => 'default',
    ArenaProductionScreenState.loading => 'loading',
    ArenaProductionScreenState.empty => 'empty',
    ArenaProductionScreenState.error => 'error',
    ArenaProductionScreenState.offline => 'offline',
    ArenaProductionScreenState.underReview => 'under_review',
    ArenaProductionScreenState.reported => 'reported',
    ArenaProductionScreenState.hidden => 'hidden',
    ArenaProductionScreenState.resolved => 'resolved',
    ArenaProductionScreenState.canceled => 'canceled',
    ArenaProductionScreenState.expired => 'expired',
  };
}

IconData _stateIcon(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => Icons.check_circle_outline,
    ArenaProductionScreenState.loading => Icons.schedule_rounded,
    ArenaProductionScreenState.empty => Icons.inbox_outlined,
    ArenaProductionScreenState.error => Icons.error_outline,
    ArenaProductionScreenState.offline => Icons.wifi_off_rounded,
    ArenaProductionScreenState.underReview => Icons.visibility_outlined,
    ArenaProductionScreenState.reported => Icons.flag_outlined,
    ArenaProductionScreenState.hidden => Icons.visibility_off_outlined,
    ArenaProductionScreenState.resolved => Icons.verified_outlined,
    ArenaProductionScreenState.canceled => Icons.block_rounded,
    ArenaProductionScreenState.expired => Icons.lock_clock_outlined,
  };
}

Color _stateColor(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => AppColors.buy,
    ArenaProductionScreenState.loading => AppColors.warn,
    ArenaProductionScreenState.empty => AppColors.text3,
    ArenaProductionScreenState.error => AppColors.sell,
    ArenaProductionScreenState.offline => AppColors.text3,
    ArenaProductionScreenState.underReview => AppColors.primary,
    ArenaProductionScreenState.reported => AppColors.sell,
    ArenaProductionScreenState.hidden => AppColors.text3,
    ArenaProductionScreenState.resolved => AppColors.buy,
    ArenaProductionScreenState.canceled => AppColors.sell,
    ArenaProductionScreenState.expired => AppColors.warn,
  };
}

Color _flowColor(String id) {
  return switch (id) {
    'creator' => AppColors.accent,
    'moderation' => AppColors.sell,
    'points_audit' => AppColors.buy,
    _ => AppColors.primary,
  };
}

IconData _flowIcon(String id) {
  return switch (id) {
    'creator' => Icons.auto_awesome_rounded,
    'moderation' => Icons.shield_outlined,
    'points_audit' => Icons.query_stats_rounded,
    _ => Icons.map_outlined,
  };
}

Color _componentColor(String type) {
  return switch (type) {
    'chip' => AppColors.buy,
    'dialog' => AppColors.sell,
    'sheet' => AppColors.warn,
    'card' => AppColors.accent,
    _ => AppColors.primary,
  };
}
