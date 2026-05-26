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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

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
    final snapshot = ref.watch(dcaRepositoryProvider).getSmartRules();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-179 DCASmartRulesPage',
      child: Column(
        children: [
          VitHeader(title: 'Smart DCA Rules', showBack: true, onBack: _close),
          _TopTabs(
            activeTab: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: DCASmartRulesPage.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  if (_activeTab == _RulesTab.mine) ..._buildMine(snapshot),
                  if (_activeTab == _RulesTab.templates)
                    ..._buildTemplates(snapshot),
                  if (_activeTab == _RulesTab.history)
                    ..._buildHistory(snapshot),
                ],
              ),
            ),
          ),
        ],
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

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _RulesTab activeTab;
  final ValueChanged<_RulesTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'Luat cua toi',
            tab: _RulesTab.mine,
            active: activeTab == _RulesTab.mine,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Mau',
            tab: _RulesTab.templates,
            active: activeTab == _RulesTab.templates,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Lich su',
            tab: _RulesTab.history,
            active: activeTab == _RulesTab.history,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _RulesTab tab;
  final bool active;
  final ValueChanged<_RulesTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: DCASmartRulesPage.tabKey(tab.name),
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(tab),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, AppSpacing.x4, 0, 0),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: active ? 116 : 0,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final DcaSmartRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.accent10,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.accent,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Rules',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                    ),
                    Text(
                      'Automated DCA optimization',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Active',
                  value: '${snapshot.activeRules}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Success',
                  value: '${snapshot.successPercent}%',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({super.key, required this.rule, required this.onDelete});

  final DcaSmartRule rule;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_typeIcon(rule.type), color: AppColors.text3, size: 18),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          rule.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusBadge(status: rule.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _TypeBadge(type: rule.type),
                  ],
                ),
              ),
              _DeleteButton(onPressed: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _RuleText(label: 'Condition', value: rule.condition),
          const SizedBox(height: AppSpacing.x2),
          _RuleText(label: 'Action', value: rule.action),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Triggered',
                  value: '${rule.triggeredCount} times',
                ),
              ),
              if (rule.lastTriggeredLabel != null)
                Expanded(
                  child: _StatValue(
                    label: 'Last Trigger',
                    value: rule.lastTriggeredLabel!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateGroup extends StatelessWidget {
  const _TemplateGroup({required this.category, required this.templates});

  final String category;
  final List<DcaRuleTemplate> templates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$category Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final template in templates) ...[
          _TemplateCard(template: template),
          if (template != templates.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final DcaRuleTemplate template;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            template.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Column(
                children: [
                  _CodeRow(label: 'Condition', value: template.condition),
                  const SizedBox(height: AppSpacing.x2),
                  _CodeRow(
                    label: 'Action',
                    value: template.action,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.text3,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${template.popularityPercent}% users',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              SizedBox(
                height: 32,
                child: VitCtaButton(
                  onPressed: () {},
                  fullWidth: false,
                  height: 32,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  leading: const Icon(Icons.copy_rounded, size: 14),
                  child: const Text('Use'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry});

  final DcaRuleHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.ruleName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _ResultBadge(result: entry.result),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.text3,
                          size: 12,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          entry.triggeredAtLabel,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Column(
                children: [
                  _CodeRow(label: 'Condition Met', value: entry.condition),
                  const SizedBox(height: AppSpacing.x2),
                  _CodeRow(
                    label: 'Action Taken',
                    value: entry.action,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Impact',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          const Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Avg Entry Price',
                  value: '-8.2%',
                  color: AppColors.buy,
                  caption: 'vs standard DCA',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Total Saved',
                  value: r'$987',
                  color: AppColors.buy,
                  caption: 'from optimizations',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DcaSmartRuleStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return _TinyBadge(
      label: status.name.toUpperCase(),
      color: color,
      background: color.withValues(alpha: 0.15),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final DcaSmartRuleType type;

  @override
  Widget build(BuildContext context) {
    return _TinyBadge(
      label: type.name.toUpperCase(),
      color: AppColors.text2,
      background: AppColors.surface2,
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final DcaSmartRuleResult result;

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(result);
    return _TinyBadge(
      label: result.name.toUpperCase(),
      color: color,
      background: color.withValues(alpha: 0.15),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: AppColors.sell,
          ),
        ),
      ),
    );
  }
}

class _RuleText extends StatelessWidget {
  const _RuleText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _StatValue extends StatelessWidget {
  const _StatValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.caption,
  });

  final String label;
  final String value;
  final Color color;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        if (caption != null)
          Text(
            caption!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _CodeRow extends StatelessWidget {
  const _CodeRow({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}

IconData _typeIcon(DcaSmartRuleType type) {
  switch (type) {
    case DcaSmartRuleType.entry:
      return Icons.trending_down_rounded;
    case DcaSmartRuleType.exit:
      return Icons.adjust_rounded;
    case DcaSmartRuleType.adjust:
      return Icons.settings_outlined;
  }
}

Color _statusColor(DcaSmartRuleStatus status) {
  switch (status) {
    case DcaSmartRuleStatus.active:
      return AppColors.buy;
    case DcaSmartRuleStatus.paused:
      return AppColors.warn;
    case DcaSmartRuleStatus.triggered:
      return AppColors.primary;
  }
}

Color _resultColor(DcaSmartRuleResult result) {
  switch (result) {
    case DcaSmartRuleResult.executed:
      return AppColors.buy;
    case DcaSmartRuleResult.failed:
      return AppColors.sell;
    case DcaSmartRuleResult.pending:
      return AppColors.warn;
  }
}
