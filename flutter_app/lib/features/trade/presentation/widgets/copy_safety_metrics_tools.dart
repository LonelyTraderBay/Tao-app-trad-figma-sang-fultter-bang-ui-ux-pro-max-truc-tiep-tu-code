part of '../pages/copy_safety_center_page.dart';

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      borderColor: _safetyWarningBorder,
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
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return VitCard(
      borderColor: AppColors.cardBorder,
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
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          metric.description,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
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
    return VitCard(
      key: CopySafetyCenterPage.toolKey(tool.id),
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(14),
      borderColor: AppColors.cardBorder,
      onTap: () {
        if (tool.routePath != null) {
          context.go(tool.routePath!);
        } else {
          onEmergency();
        }
      },
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
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tool.description,
                  style: AppTextStyles.micro.copyWith(
                    color: tool.id == 'emergency' ? color : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color, size: 18),
        ],
      ),
    );
  }
}
