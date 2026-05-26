import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

enum _EcosystemSection { canonical, states, flows, registry, handoff }

class ConnectedEcosystemProductionPage extends ConsumerStatefulWidget {
  const ConnectedEcosystemProductionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc208_ecosystem_content');
  static const tabsKey = Key('sc208_ecosystem_tabs');

  static Key tabKey(String id) => Key('sc208_tab_$id');
  static Key screenKey(String name) => Key('sc208_screen_$name');
  static Key flowStepKey(String flowId, String label) =>
      Key('sc208_flow_${flowId}_$label');
  static Key handoffKey(String id) => Key('sc208_handoff_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ConnectedEcosystemProductionPage> createState() =>
      _ConnectedEcosystemProductionPageState();
}

class _ConnectedEcosystemProductionPageState
    extends ConsumerState<ConnectedEcosystemProductionPage> {
  _EcosystemSection _activeSection = _EcosystemSection.canonical;
  String _activeHandoffBoard = 'routes';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getConnectedEcosystemProduction();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-208 ConnectedEcosystemProductionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: '09E - Connected Ecosystem',
              subtitle: 'Production Ready',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ConnectedEcosystemProductionPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      const _EcosystemHero(),
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
                        activeHandoffBoard: _activeHandoffBoard,
                        onHandoffBoardChanged: (board) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeHandoffBoard = board);
                        },
                        onRoute: (route) => _go(context, route),
                      ),
                      _EcosystemFooter(text: snapshot.footerDisclosure),
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
    context.go(_resolveConnectedRoute(route));
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

class _EcosystemHero extends StatelessWidget {
  const _EcosystemHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'Bộ handoff pack production-ready cho hệ sinh thái kết nối Open Arena x Prediction Markets. 2 module liên kết qua content/topic nhưng vẫn tách biệt hoàn toàn về bản chất tài chính.',
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
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ConnectedEcosystemProductionPage.tabKey(config.id),
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
            height: 1.5,
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
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.buy,
                    size: 15,
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
      constraints: const BoxConstraints(minHeight: 136),
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                    height: 1.25,
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
              height: 1.45,
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
            height: 1.5,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
              height: 1.45,
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
            height: 1.5,
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
      color: Colors.transparent,
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

class _BridgeRules extends StatelessWidget {
  const _BridgeRules({required this.rules});

  final List<ConnectedBridgeRuleDraft> rules;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Bridge Rules',
      subtitle: 'Allowed transfer fields vs forbidden financial fields',
      children: [
        for (final rule in rules)
          _HandoffRow(
            title: rule.field,
            subtitle: rule.reason,
            leading: Icon(
              rule.allowed ? Icons.check_rounded : Icons.close_rounded,
              color: rule.allowed ? AppColors.buy : AppColors.sell,
              size: 16,
            ),
          ),
      ],
    );
  }
}

class _QaChecklist extends StatelessWidget {
  const _QaChecklist({required this.items});

  final List<ConnectedQaCheckDraft> items;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'QA Checklist',
      subtitle: '${items.length} pre-ship checks',
      children: [
        for (final item in items)
          _HandoffRow(
            title: '${item.category} · ${item.id}',
            subtitle: item.check,
            trailing: _MiniPill(
              label: _qaSeverityLabel(item.severity),
              color: _qaSeverityColor(item.severity),
            ),
          ),
      ],
    );
  }
}

class _HandoffCard extends StatelessWidget {
  const _HandoffCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final child in children) ...[
            child,
            if (child != children.last)
              const Divider(height: AppSpacing.x5, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _HandoffRow extends StatelessWidget {
  const _HandoffRow({
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.x2),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                subtitle,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.x2),
          trailing!,
        ],
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color ?? AppColors.text3, size: 13),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallTextAction extends StatelessWidget {
  const _SmallTextAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _MiniPill(label: label, color: color);
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 22),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TintIcon extends StatelessWidget {
  const _TintIcon({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 36.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: BorderRadius.circular(small ? 12 : 14),
      ),
      child: Icon(icon, color: color, size: small ? 15 : 17),
    );
  }
}

class _EcosystemFooter extends StatelessWidget {
  const _EcosystemFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _EcosystemSection section;
  final String id;
  final String label;
  final IconData icon;
}

final class _HandoffBoard {
  const _HandoffBoard({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _EcosystemSection.canonical,
    id: 'canonical',
    label: 'Canonical',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.states,
    id: 'states',
    label: 'States',
    icon: Icons.warning_amber_rounded,
  ),
  _SectionConfig(
    section: _EcosystemSection.flows,
    id: 'flows',
    label: 'E2E Flows',
    icon: Icons.map_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.registry,
    id: 'registry',
    label: 'Registry',
    icon: Icons.inventory_2_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.handoff,
    id: 'handoff',
    label: 'Handoff',
    icon: Icons.description_outlined,
  ),
];

const _handoffBoards = [
  _HandoffBoard(id: 'routes', label: 'Routes', icon: Icons.map_outlined),
  _HandoffBoard(
    id: 'components',
    label: 'Components',
    icon: Icons.inventory_2_outlined,
  ),
  _HandoffBoard(id: 'rules', label: 'Bridge Rules', icon: Icons.menu_book),
  _HandoffBoard(
    id: 'qa',
    label: 'QA Checklist',
    icon: Icons.check_circle_outline,
  ),
];

String _resolveConnectedRoute(String route) {
  return switch (route) {
    '/' => AppRoutePaths.home,
    '/markets/predictions/event/:id' => AppRoutePaths.marketsPredictionEvent(
      'pred-1',
    ),
    '/arena/challenge/:id' => AppRoutePaths.arenaChallenge('ch003'),
    '/arena/challenge/:challengeId' => AppRoutePaths.arenaChallenge('ch003'),
    '/arena/mode/:id' => AppRoutePaths.arenaMode('mode001'),
    '/profile/arena' => AppRoutePaths.profileArena,
    '/markets/predictions/portfolio' =>
      AppRoutePaths.marketsPredictionsPortfolio,
    _ => route,
  };
}

String _statusLabel(ConnectedEcosystemScreenStatus status) {
  return switch (status) {
    ConnectedEcosystemScreenStatus.vFinal => 'vFinal',
    ConnectedEcosystemScreenStatus.live => 'Live',
    ConnectedEcosystemScreenStatus.needsReview => 'Needs Review',
    ConnectedEcosystemScreenStatus.archived => 'Archived',
  };
}

Color _statusColor(ConnectedEcosystemScreenStatus status) {
  return switch (status) {
    ConnectedEcosystemScreenStatus.vFinal => AppColors.buy,
    ConnectedEcosystemScreenStatus.live => AppColors.primary,
    ConnectedEcosystemScreenStatus.needsReview => AppColors.warn,
    ConnectedEcosystemScreenStatus.archived => AppColors.text3,
  };
}

Color _toneColor(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => AppColors.primary,
    ArenaBridgeTone.arena => AppModuleAccents.arena,
    ArenaBridgeTone.prediction => AppModuleAccents.predictions,
    ArenaBridgeTone.disclosure => AppColors.buy,
    ArenaBridgeTone.danger => AppColors.sell,
    ArenaBridgeTone.blocked => AppColors.sell,
    ArenaBridgeTone.neutral => AppColors.text2,
  };
}

IconData _toneIcon(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => Icons.link_rounded,
    ArenaBridgeTone.arena => Icons.sports_esports_outlined,
    ArenaBridgeTone.prediction => Icons.shield_outlined,
    ArenaBridgeTone.disclosure => Icons.check_circle_outline,
    ArenaBridgeTone.danger => Icons.warning_amber_rounded,
    ArenaBridgeTone.blocked => Icons.block_rounded,
    ArenaBridgeTone.neutral => Icons.info_outline_rounded,
  };
}

String _bridgeTypeLabel(ConnectedBridgeType type) {
  return switch (type) {
    ConnectedBridgeType.none => 'none',
    ConnectedBridgeType.source => 'source',
    ConnectedBridgeType.target => 'target',
    ConnectedBridgeType.bidirectional => 'bidirectional',
  };
}

Color _bridgeTypeColor(ConnectedBridgeType type) {
  return switch (type) {
    ConnectedBridgeType.none => AppColors.text3,
    ConnectedBridgeType.source => AppColors.primary,
    ConnectedBridgeType.target => AppModuleAccents.arena,
    ConnectedBridgeType.bidirectional => AppModuleAccents.predictions,
  };
}

String _severityLabel(ConnectedRuleSeverity severity) {
  return switch (severity) {
    ConnectedRuleSeverity.critical => 'CRITICAL',
    ConnectedRuleSeverity.high => 'HIGH',
    ConnectedRuleSeverity.medium => 'MEDIUM',
  };
}

Color _severityColor(ConnectedRuleSeverity severity) {
  return switch (severity) {
    ConnectedRuleSeverity.critical => AppColors.sell,
    ConnectedRuleSeverity.high => AppColors.warn,
    ConnectedRuleSeverity.medium => AppColors.primary,
  };
}

String _qaSeverityLabel(ConnectedQaSeverity severity) {
  return switch (severity) {
    ConnectedQaSeverity.must => 'MUST',
    ConnectedQaSeverity.should => 'SHOULD',
    ConnectedQaSeverity.may => 'MAY',
  };
}

Color _qaSeverityColor(ConnectedQaSeverity severity) {
  return switch (severity) {
    ConnectedQaSeverity.must => AppColors.sell,
    ConnectedQaSeverity.should => AppColors.warn,
    ConnectedQaSeverity.may => AppColors.text2,
  };
}
