import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/launchpad_home_header_widgets.dart';
part '../widgets/launchpad_home_helpers.dart';
part '../widgets/launchpad_home_shared_widgets.dart';
part '../widgets/launchpad_home_project_widgets.dart';
part '../widgets/launchpad_home_tool_widgets.dart';

const _launchpadVisualNavClearance = 112.0;
const _launchpadNativeNavClearance = 88.0;
const _launchpadActionHeight = AppSpacing.searchBarCompactHeight;
const _launchpadLineHeightDense = AppSpacing.launchpadLineHeightDense;
const _launchpadLineHeightBody = AppSpacing.launchpadLineHeightBody;
const _launchpadLineHeightCompact = AppSpacing.launchpadLineHeightCompact;
const _launchpadLineHeightTight = AppSpacing.launchpadLineHeightTight;
const _launchpadLineHeightLabel = AppSpacing.launchpadLineHeightLabel;
const _launchpadLineHeightReadable = AppSpacing.launchpadLineHeightReadable;
const _launchpadLineHeightShort = AppSpacing.launchpadLineHeightShort;

class LaunchpadPage extends ConsumerStatefulWidget {
  const LaunchpadPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc295_launchpad_content');
  static const heroKey = Key('sc295_launchpad_hero');
  static const filterActionKey = Key('sc295_launchpad_filter');
  static const performanceActionKey = Key('sc295_launchpad_performance');
  static const portfolioActionKey = Key('sc295_launchpad_portfolio');
  static const tabsKey = Key('sc295_launchpad_tabs');
  static const stakingKey = Key('sc295_launchpad_staking');
  static const advancedToolsKey = Key('sc295_launchpad_advanced_tools');
  static const riskToolsKey = Key('sc295_launchpad_risk_tools');
  static const safetyKey = Key('sc295_launchpad_safety');

  static Key projectKey(String id) => Key('sc295_launchpad_project_$id');
  static Key tabKey(String id) => Key('sc295_launchpad_tab_$id');
  static Key toolKey(String id) => Key('sc295_launchpad_tool_$id');
  static Key joinKey(String id) => Key('sc295_launchpad_join_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPage> createState() => _LaunchpadPageState();
}

class _LaunchpadPageState extends ConsumerState<LaunchpadPage> {
  var _activeTab = _LaunchpadTab.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getHome();
    final projects = _projectsFor(snapshot.projects, _activeTab);
    final activeCount = snapshot.projects
        .where((project) => project.status == LaunchpadProjectStatus.active)
        .length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _launchpadVisualNavClearance
        : _launchpadNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-295 LaunchpadPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'SC-295 LaunchpadPage scroll surface',
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
            actions: [
              VitHeaderActionItem(
                key: LaunchpadPage.filterActionKey,
                type: VitHeaderActionType.filter,
                tooltip: 'Bá»™ lá»c',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => _activeTab = _LaunchpadTab.active);
                },
              ),
              VitHeaderActionItem(
                key: LaunchpadPage.performanceActionKey,
                type: VitHeaderActionType.analytics,
                tooltip: 'Hiá»‡u suáº¥t',
                onPressed: () => context.go(snapshot.performanceRoute),
              ),
              VitHeaderActionItem(
                key: LaunchpadPage.portfolioActionKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Portfolio',
                onPressed: () => context.go(snapshot.portfolioRoute),
              ),
            ],
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: LaunchpadPage.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollEndPadding),
              child: VitPageContent(
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                  _HeroCard(activeCount: activeCount),
                  _LaunchpadTabs(
                    activeTab: _activeTab,
                    onChanged: (tab) => setState(() => _activeTab = tab),
                  ),
                  for (final project in projects)
                    _ProjectCard(project: project),
                  _StakingEntry(route: snapshot.stakingRoute),
                  _ToolSection(
                    key: LaunchpadPage.advancedToolsKey,
                    title: 'C\u00F4ng c\u1EE5 n\u00E2ng cao',
                    tools: snapshot.advancedTools,
                  ),
                  _ToolSection(
                    key: LaunchpadPage.riskToolsKey,
                    title: 'Trading & Risk Management',
                    tools: snapshot.riskTools,
                  ),
                  const _SafetyWarning(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
