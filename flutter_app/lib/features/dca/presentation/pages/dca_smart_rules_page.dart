import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
part '../widgets/dca_smart_rules_tabs_stats.dart';
part '../widgets/dca_smart_rules_cards.dart';
part '../widgets/dca_smart_rules_info_common.dart';

enum _RulesTab { mine, templates, history }

class DCASmartRulesPage extends ConsumerStatefulWidget {
  const DCASmartRulesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc179_smart_rules_content');
  static const createRuleKey = Key('sc179_create_rule');

  static Key tabKey(String tabName) => Key('sc179_tab_$tabName');
  static Key ruleKey(String id) => Key('sc179_rule_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCASmartRulesPage> createState() => _DCASmartRulesPageState();
}

class _DCASmartRulesPageState extends ConsumerState<DCASmartRulesPage> {
  _RulesTab _activeTab = _RulesTab.mine;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaSmartRulesProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-179 DCASmartRulesPage',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Smart DCA Rules',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DCASmartRulesPage.contentKey,
                physics: const ClampingScrollPhysics(),
                padding: AppSpacing.dcaBottomInsetPadding(scrollBottom),
                child: VitPageContent(
                  customGap: AppSpacing.x5,
                  children: [
                    if (_activeTab == _RulesTab.mine) ..._buildMine(snapshot),
                    if (_activeTab == _RulesTab.templates)
                      ..._buildTemplates(snapshot),
                    if (_activeTab == _RulesTab.history)
                      ..._buildHistory(snapshot),
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Smart DCA rule execution review',
                      message:
                          'Rule conditions, automated trade actions, trigger history, success rate, delete preview, and create-rule confirmation are reviewed before DCA automation changes.',
                      contractId: 'SC-179',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMine(DcaSmartRulesSnapshot snapshot) {
    return [
      _StatsCard(snapshot: snapshot),
      VitPageSection(
        label: 'Cac luat hien co',
        children: [
          for (final rule in snapshot.smartRules)
            _RuleCard(
              key: DCASmartRulesPage.ruleKey(rule.id),
              rule: rule,
              onDelete: _showDeleteNotice,
            ),
        ],
      ),
      VitCtaButton(
        key: DCASmartRulesPage.createRuleKey,
        onPressed: _showCreateNotice,
        leading: const Icon(Icons.add_rounded),
        child: const Text('Create Custom Rule'),
      ),
      const _InfoCard(
        icon: Icons.info_outline_rounded,
        text:
            'Smart rules tu dong dieu chinh DCA dua tren dieu kien thi truong. Giup toi uu hoa gia mua trung binh.',
      ),
    ];
  }

  List<Widget> _buildTemplates(DcaSmartRulesSnapshot snapshot) {
    const categories = ['Entry', 'Exit', 'Adjust'];
    return [
      VitPageSection(
        label: 'Rule Templates',
        children: [
          for (final category in categories)
            _TemplateGroup(
              category: category,
              templates: snapshot.templates
                  .where((template) => template.category == category)
                  .toList(),
            ),
        ],
      ),
    ];
  }

  List<Widget> _buildHistory(DcaSmartRulesSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Rule Trigger History',
        children: [
          for (final entry in snapshot.history) _HistoryCard(entry: entry),
        ],
      ),
      const _ImpactCard(),
      const _SuccessCard(
        text:
            'Smart rules da giup giam gia mua trung binh 8.2% so voi DCA tieu chuan.',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showCreateNotice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Create rule flow ready')));
  }

  void _showDeleteNotice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Rule delete preview ready')));
  }
}
