import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/trade_repository.dart';

class CopyTradingCardDemo extends ConsumerWidget {
  const CopyTradingCardDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc401_copy_card_content');
  static const analysisKey = Key('sc401_copy_card_analysis');
  static const matrixKey = Key('sc401_copy_card_matrix');
  static const issuesKey = Key('sc401_copy_card_issues');
  static const recommendationKey = Key('sc401_copy_card_recommendation');
  static const guidelinesKey = Key('sc401_copy_card_guidelines');

  static Key variantKey(String id) => Key('sc401_variant_$id');
  static Key cardKey(String id) => Key('sc401_card_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRepositoryProvider).getCopyCardDemo();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-401 CopyTradingCardDemo',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyTradingCardDemo.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.loose,
                  children: [
                    _AnalysisHeader(snapshot: snapshot),
                    for (final variant in snapshot.variants)
                      _VariantSection(
                        key: CopyTradingCardDemo.variantKey(variant.id),
                        variant: variant,
                        metrics: snapshot.metrics,
                      ),
                    _ComparisonMatrix(issues: snapshot.issues),
                    _OriginalIssues(issues: snapshot.originalIssues),
                    _Recommendation(snapshot: snapshot),
                    _Guidelines(guidelines: snapshot.guidelines),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisHeader extends StatelessWidget {
  const _AnalysisHeader({required this.snapshot});

  final TradeCopyCardDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.analysisKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Enterprise Fintech Card Analysis',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 19),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Below are 3 variants designed to address enterprise-level fintech standards: visual hierarchy, trust-first principles, and regulatory compliance.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Improvements:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final item in snapshot.improvements)
                    _BulletLine(text: item, compact: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantSection extends StatelessWidget {
  const _VariantSection({
    super.key,
    required this.variant,
    required this.metrics,
  });

  final TradeCopyCardVariantDraft variant;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                variant.title,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (variant.badge != null) ...[
              const SizedBox(width: AppSpacing.x3),
              _Badge(label: variant.badge!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _CopyCard(variantId: variant.id, metrics: metrics),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.standard,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variant.notesTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (final item in variant.notes)
                _IconLine(icon: Icons.check_circle_rounded, text: item),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyCard extends StatelessWidget {
  const _CopyCard({required this.variantId, required this.metrics});

  final String variantId;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return switch (variantId) {
      'hero' => _HeroCopyCard(metrics: metrics),
      'tabular' => _TabularCopyCard(metrics: metrics),
      _ => _CompactCopyCard(metrics: metrics),
    };
  }
}

class _HeroCopyCard extends StatelessWidget {
  const _HeroCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.cardKey('hero'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      borderColor: AppColors.borderSolid,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                children: [
                  Text(
                    'ASSET UNDER MANAGEMENT',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    _formatUsd(metrics.aumUsd),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heroNumber.copyWith(fontSize: 33),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _TrendPill(value: metrics.aumTrendPercent),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.people_alt_outlined,
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.group_add_outlined,
                  label: 'COPIERS',
                  value: _formatCompact(metrics.copiers),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Updated ${metrics.lastUpdated}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabularCopyCard extends StatelessWidget {
  const _TabularCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.cardKey('tabular'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          _TableMetricRow(
            label: 'Total AUM',
            value: _formatUsd(metrics.aumUsd),
            trailing: _TrendSmall(value: metrics.aumTrendPercent),
          ),
          _TableMetricRow(
            label: 'Active Traders',
            value: '${metrics.traders}',
            icon: Icons.people_alt_outlined,
          ),
          _TableMetricRow(
            label: 'Total Copiers',
            value: _formatCompact(metrics.copiers),
            icon: Icons.group_add_outlined,
            showDivider: false,
          ),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last updated: ${metrics.lastUpdated}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              _SmallButton(
                label: 'View Details',
                onTap: () => HapticFeedback.selectionClick(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactCopyCard extends StatelessWidget {
  const _CompactCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.cardKey('compact'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'COPIERS',
                  value: _formatCompact(metrics.copiers),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'AUM',
                  value: _formatUsd(metrics.aumUsd),
                  emphasized: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.x4),
            child: Icon(
              Icons.dashboard_customize_outlined,
              color: AppColors.navCenterIcon,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Copy Trading',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Sao chép trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecondaryMetric extends StatelessWidget {
  const _SecondaryMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 15),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 27,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableMetricRow extends StatelessWidget {
  const _TableMetricRow({
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.text2, size: 16),
              const SizedBox(width: AppSpacing.x2),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  trailing!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: emphasized ? Border.all(color: AppColors.primary40) : null,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: emphasized ? AppColors.primary : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonMatrix extends StatelessWidget {
  const _ComparisonMatrix({required this.issues});

  final List<TradeCopyCardIssue> issues;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.matrixKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compliance Comparison Matrix',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _ScoreCard(
                label: 'Original',
                score: _score('original'),
                status: TradeCopyCardCompliance.fail,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant A',
                score: _score('variantA'),
                status: TradeCopyCardCompliance.pass,
                selected: true,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant B',
                score: _score('variantB'),
                status: TradeCopyCardCompliance.pass,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant C',
                score: _score('variantC'),
                status: TradeCopyCardCompliance.warn,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _MatrixHeader(),
          for (final issue in issues) _IssueRow(issue: issue),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x2,
            children: const [
              _Legend(status: TradeCopyCardCompliance.pass, label: 'Compliant'),
              _Legend(status: TradeCopyCardCompliance.warn, label: 'Partial'),
              _Legend(
                status: TradeCopyCardCompliance.fail,
                label: 'Non-compliant',
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _score(String column) {
    var total = 0;
    for (final issue in issues) {
      final status = switch (column) {
        'original' => issue.original,
        'variantA' => issue.variantA,
        'variantB' => issue.variantB,
        _ => issue.variantC,
      };
      total += switch (status) {
        TradeCopyCardCompliance.pass => 100,
        TradeCopyCardCompliance.warn => 50,
        TradeCopyCardCompliance.fail => 0,
      };
    }
    return (total / issues.length).round();
  }
}

class _MatrixHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(flex: 5, child: _HeaderCell('Issue Category')),
          Expanded(child: _HeaderCell('Orig')),
          Expanded(child: _HeaderCell('A')),
          Expanded(child: _HeaderCell('B')),
          Expanded(child: _HeaderCell('C')),
        ],
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.issue});

  final TradeCopyCardIssue issue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.category,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    issue.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
            ),
            Expanded(child: _ComplianceIcon(status: issue.original)),
            Expanded(child: _ComplianceIcon(status: issue.variantA)),
            Expanded(child: _ComplianceIcon(status: issue.variantB)),
            Expanded(child: _ComplianceIcon(status: issue.variantC)),
          ],
        ),
      ),
    );
  }
}

class _OriginalIssues extends StatelessWidget {
  const _OriginalIssues({required this.issues});

  final List<TradeCopyCardTextBlock> issues;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      key: CopyTradingCardDemo.issuesKey,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.sell,
      borderColor: AppColors.sell20,
      title: 'Original Card Issues (Enterprise Standards)',
      children: [
        for (final issue in issues)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  issue.body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Recommendation extends StatelessWidget {
  const _Recommendation({required this.snapshot});

  final TradeCopyCardDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      key: CopyTradingCardDemo.recommendationKey,
      icon: Icons.verified_rounded,
      iconColor: AppColors.buy,
      borderColor: AppColors.buy20,
      title: 'Final Recommendation',
      children: [
        Text(
          snapshot.recommendation,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in snapshot.recommendationReasons)
          _IconLine(icon: Icons.check_rounded, text: item),
      ],
    );
  }
}

class _Guidelines extends StatelessWidget {
  const _Guidelines({required this.guidelines});

  final List<TradeCopyCardTextBlock> guidelines;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.guidelinesKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guidelines Compliance',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < guidelines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.primary15,
                      borderRadius: AppRadii.xsRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x2,
                        vertical: AppSpacing.x1,
                      ),
                      child: Text(
                        '§${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${guidelines[i].title}: ',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          TextSpan(
                            text: guidelines[i].body,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
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

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: iconColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ...children,
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.score,
    required this.status,
    this.selected = false,
  });

  final String label;
  final int score;
  final TradeCopyCardCompliance status;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _statusTintColor(status),
          border: selected ? Border.all(color: color) : null,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(color: color),
              ),
              Text(
                '/100',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _ComplianceIcon extends StatelessWidget {
  const _ComplianceIcon({required this.status});

  final TradeCopyCardCompliance status;

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      TradeCopyCardCompliance.pass => Icons.check_circle_outline_rounded,
      TradeCopyCardCompliance.warn => Icons.error_outline_rounded,
      TradeCopyCardCompliance.fail => Icons.cancel_outlined,
    };
    return Center(child: Icon(icon, color: _statusColor(status), size: 17));
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.status, required this.label});

  final TradeCopyCardCompliance status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ComplianceIcon(status: status),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: value >= 0 ? AppColors.buy15 : AppColors.sell15,
        border: Border.all(
          color: value >= 0 ? AppColors.buy20 : AppColors.sell20,
        ),
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          '${value >= 0 ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}% vs last month',
          style: AppTextStyles.micro.copyWith(
            color: value >= 0 ? AppColors.buy : AppColors.sell,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _TrendSmall extends StatelessWidget {
  const _TrendSmall({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value >= 0 ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}%',
      style: AppTextStyles.micro.copyWith(
        color: value >= 0 ? AppColors.buy : AppColors.sell,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary15,
          borderRadius: AppRadii.smRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? AppSpacing.x1 : AppSpacing.x2),
      child: Text(
        '• $text',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.buy, size: 15),
          const SizedBox(width: AppSpacing.x2),
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

Color _statusColor(TradeCopyCardCompliance status) {
  return switch (status) {
    TradeCopyCardCompliance.pass => AppColors.buy,
    TradeCopyCardCompliance.warn => AppColors.warn,
    TradeCopyCardCompliance.fail => AppColors.sell,
  };
}

Color _statusTintColor(TradeCopyCardCompliance status) {
  return switch (status) {
    TradeCopyCardCompliance.pass => AppColors.buy15,
    TradeCopyCardCompliance.warn => AppColors.warn15,
    TradeCopyCardCompliance.fail => AppColors.sell15,
  };
}

String _formatUsd(int value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(2)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$$value';
}

String _formatCompact(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
