import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _safetyPrimary = AppColors.primary;
const _safetyTabsBackground = AppColors.surface;
const _safetyCard = AppColors.surface;
const _safetyWarningBackground = AppColors.warningBg;
const _safetyWarningBorder = Color(0x665A3A00);

class CopySafetyCenterPage extends ConsumerStatefulWidget {
  const CopySafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc083_copy_safety_center_content');
  static Key tabKey(String id) => Key('sc083_tab_$id');
  static Key metricKey(String name) => Key('sc083_metric_$name');
  static Key toolKey(String id) => Key('sc083_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopySafetyCenterPage> createState() =>
      _CopySafetyCenterPageState();
}

class _CopySafetyCenterPageState extends ConsumerState<CopySafetyCenterPage> {
  String? _activeTabId;
  String? _expandedMetric;
  bool _showEmergencyPanel = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getCopySafetyCenter();
    _activeTabId ??= snapshot.defaultTabId;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-083 CopySafetyCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Safety Center',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: CopySafetyCenterPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroBanner(snapshot: snapshot),
                        const SizedBox(height: 25),
                        _SafetyTabs(
                          tabs: snapshot.tabs,
                          activeId: _activeTabId!,
                          onChanged: (id) => setState(() => _activeTabId = id),
                        ),
                        const SizedBox(height: 27),
                        _SafetyTabBody(
                          activeTabId: _activeTabId!,
                          snapshot: snapshot,
                          expandedMetric: _expandedMetric,
                          onMetricToggle: (name) => setState(() {
                            _expandedMetric = _expandedMetric == name
                                ? null
                                : name;
                          }),
                          onEmergency: () =>
                              setState(() => _showEmergencyPanel = true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showEmergencyPanel)
              _EmergencyPanel(
                onClose: () => setState(() => _showEmergencyPanel = false),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 95),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: _safetyPrimary.withValues(alpha: .11),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _safetyPrimary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _safetyPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.body.copyWith(
                    color: _safetyPrimary,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _safetyPrimary,
                    fontSize: 10.5,
                    height: 1.25,
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

class _SafetyTabs extends StatelessWidget {
  const _SafetyTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeCopySafetyCenterTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _safetyTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopySafetyCenterPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _safetyPrimary
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 65 : 0,
                      height: 2,
                      color: _safetyPrimary,
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

class _SafetyTabBody extends StatelessWidget {
  const _SafetyTabBody({
    required this.activeTabId,
    required this.snapshot,
    required this.expandedMetric,
    required this.onMetricToggle,
    required this.onEmergency,
  });

  final String activeTabId;
  final TradeCopySafetyCenterSnapshot snapshot;
  final String? expandedMetric;
  final ValueChanged<String> onMetricToggle;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context) {
    return switch (activeTabId) {
      'metrics' => _MetricsTab(
        metrics: snapshot.trustMetrics,
        expandedMetric: expandedMetric,
        onMetricToggle: onMetricToggle,
      ),
      'guidelines' => _GuidelinesTab(snapshot: snapshot),
      'tools' => _ToolsTab(
        tools: snapshot.safetyTools,
        onEmergency: onEmergency,
      ),
      'enforcement' => _EnforcementTab(actions: snapshot.enforcementActions),
      _ => _VerificationTab(snapshot: snapshot),
    };
  }
}

class _VerificationTab extends StatelessWidget {
  const _VerificationTab({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.verificationIntro,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 19),
        for (final tier in snapshot.verificationTiers) ...[
          _VerificationTierCard(tier: tier),
          if (tier != snapshot.verificationTiers.last)
            const SizedBox(height: 18),
        ],
        const SizedBox(height: 29),
        _WarningCard(text: snapshot.warningText),
      ],
    );
  }
}

class _VerificationTierCard extends StatelessWidget {
  const _VerificationTierCard({required this.tier});

  final TradeCopyVerificationTier tier;

  @override
  Widget build(BuildContext context) {
    final color = Color(tier.colorHex);
    return Container(
      constraints: BoxConstraints(
        minHeight: tier.tier == 'Basic'
            ? 207
            : tier.tier == 'Verified'
            ? 260
            : 296,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: color, size: 20),
              const SizedBox(width: 9),
              Text(
                tier.tier,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _ListBlock(label: 'Requirements:', items: tier.requirements),
          const SizedBox(height: 17),
          _ListBlock(label: 'Benefits:', items: tier.benefits, check: true),
        ],
      ),
    );
  }
}

class _ListBlock extends StatelessWidget {
  const _ListBlock({
    required this.label,
    required this.items,
    this.check = false,
  });

  final String label;
  final List<String> items;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                '${check ? '/' : '*'} $item',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ),
            if (item != items.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _safetyWarningBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _safetyWarningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({
    required this.metrics,
    required this.expandedMetric,
    required this.onMetricToggle,
  });

  final List<TradeCopyTrustMetric> metrics;
  final String? expandedMetric;
  final ValueChanged<String> onMetricToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Understanding trust metrics:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 13),
        for (final metric in metrics) ...[
          _MetricCard(
            metric: metric,
            expanded: expandedMetric == metric.name,
            onTap: () => onMetricToggle(metric.name),
          ),
          if (metric != metrics.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.metric,
    required this.expanded,
    required this.onTap,
  });

  final TradeCopyTrustMetric metric;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          InkWell(
            key: CopySafetyCenterPage.metricKey(metric.name),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          metric.description,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _MetricInfo(
                    label: 'Good Range',
                    text: metric.goodRange,
                    color: AppColors.buy,
                  ),
                  const SizedBox(height: 8),
                  _MetricInfo(
                    label: 'Bad Range',
                    text: metric.badRange,
                    color: AppColors.sell,
                  ),
                  const SizedBox(height: 8),
                  _MetricInfo(
                    label: 'Why It Matters',
                    text: metric.whyMatters,
                    color: _safetyPrimary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricInfo extends StatelessWidget {
  const _MetricInfo({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$label\n$text',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1.35,
        ),
      ),
    );
  }
}

class _GuidelinesTab extends StatelessWidget {
  const _GuidelinesTab({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GuidelineList(
          title: 'Prohibited Provider Behaviors',
          color: AppColors.sell,
          items: snapshot.prohibitedBehaviors,
          icon: Icons.cancel_outlined,
        ),
        const SizedBox(height: 18),
        _GuidelineList(
          title: 'Follower Responsibilities',
          color: _safetyPrimary,
          items: snapshot.followerResponsibilities,
          icon: Icons.check_circle_outline_rounded,
        ),
        const SizedBox(height: 18),
        _ReportingSteps(steps: snapshot.reportingSteps),
      ],
    );
  }
}

class _GuidelineList extends StatelessWidget {
  const _GuidelineList({
    required this.title,
    required this.color,
    required this.items,
    required this.icon,
  });

  final String title;
  final Color color;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _SectionPanel(
      title: title,
      color: color,
      child: Column(
        children: [
          for (final item in items) ...[
            _IconTextRow(icon: icon, color: color, text: item),
            if (item != items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ReportingSteps extends StatelessWidget {
  const _ReportingSteps({required this.steps});

  final List<TradeCopyReportingStep> steps;

  @override
  Widget build(BuildContext context) {
    return _SectionPanel(
      title: 'Reporting Procedures',
      color: AppColors.warn,
      child: Column(
        children: [
          for (final step in steps) ...[
            _SimpleCard(title: step.title, body: step.description),
            if (step != steps.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ToolsTab extends StatelessWidget {
  const _ToolsTab({required this.tools, required this.onEmergency});

  final List<TradeCopySafetyTool> tools;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context) {
    return _SectionPanel(
      title: 'Safety Tools',
      color: _safetyPrimary,
      child: Column(
        children: [
          for (final tool in tools) ...[
            _ToolButton(tool: tool, onEmergency: onEmergency),
            if (tool != tools.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.tool, required this.onEmergency});

  final TradeCopySafetyTool tool;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context) {
    final color = Color(tool.colorHex);
    return InkWell(
      key: CopySafetyCenterPage.toolKey(tool.id),
      onTap: () {
        if (tool.routePath != null) {
          context.go(tool.routePath!);
        } else {
          onEmergency();
        }
      },
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              tool.id == 'block'
                  ? Icons.block_rounded
                  : tool.id == 'report'
                  ? Icons.flag_outlined
                  : Icons.warning_amber_rounded,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.title,
                    style: AppTextStyles.caption.copyWith(
                      color: tool.id == 'emergency' ? color : AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tool.description,
                    style: AppTextStyles.micro.copyWith(
                      color: tool.id == 'emergency' ? color : AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EnforcementTab extends StatelessWidget {
  const _EnforcementTab({required this.actions});

  final List<TradeCopyEnforcementAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent enforcement actions taken to protect users:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 14),
        for (final action in actions) ...[
          _EnforcementCard(action: action),
          if (action != actions.last) const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        _SimpleCard(
          title: 'Transparent enforcement',
          body:
              'All actions are logged. If you believe an action was unfair, contact support.',
          color: _safetyPrimary,
        ),
      ],
    );
  }
}

class _EnforcementCard extends StatelessWidget {
  const _EnforcementCard({required this.action});

  final TradeCopyEnforcementAction action;

  @override
  Widget build(BuildContext context) {
    final color = switch (action.action) {
      'suspended' => AppColors.sell,
      'warned' => AppColors.warn,
      _ => AppColors.buy,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.action.toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  action.providerName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${action.date} - ${action.reason}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
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

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.title,
    required this.color,
    required this.child,
  });

  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _IconTextRow extends StatelessWidget {
  const _IconTextRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  const _SimpleCard({required this.title, required this.body, this.color});

  final String title;
  final String body;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
        border: color == null ? null : Border.all(color: color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: AppTextStyles.micro.copyWith(
              color: color ?? AppColors.text3,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyPanel extends StatelessWidget {
  const _EmergencyPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0x99000000)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Emergency stop activated',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'All copies would be stopped and positions queued for close in the backend flow.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: onClose,
                  borderRadius: AppRadii.inputRadius,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _safetyPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
