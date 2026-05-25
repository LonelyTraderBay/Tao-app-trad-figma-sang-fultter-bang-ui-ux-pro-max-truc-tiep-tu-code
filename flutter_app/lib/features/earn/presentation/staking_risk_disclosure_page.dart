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
import '../data/earn_repository.dart';

class StakingRiskDisclosurePage extends ConsumerStatefulWidget {
  const StakingRiskDisclosurePage({super.key, this.shellRenderMode});

  static const warningKey = Key('sc354_risk_warning');
  static const overviewKey = Key('sc354_risk_overview');
  static const assessmentCtaKey = Key('sc354_risk_assessment_cta');

  static Key tabKey(String id) => Key('sc354_risk_tab_$id');
  static Key categoryKey(String id) => Key('sc354_risk_category_$id');
  static Key productKey(String name) => Key('sc354_risk_product_$name');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskDisclosurePage> createState() =>
      _StakingRiskDisclosurePageState();
}

class _StakingRiskDisclosurePageState
    extends ConsumerState<StakingRiskDisclosurePage> {
  String? _activeTab;
  String? _expandedRisk;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRiskDisclosureRepositoryProvider)
        .getDisclosure();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-354 StakingRiskDisclosurePage',
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
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _WarningBanner(snapshot: snapshot),
                    _RiskTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = tab);
                      },
                    ),
                    if (activeTab == 'overview')
                      _OverviewTab(snapshot: snapshot)
                    else if (activeTab == 'categories')
                      _CategoriesTab(
                        snapshot: snapshot,
                        expandedRisk: _expandedRisk,
                        onToggle: (id) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _expandedRisk = _expandedRisk == id ? null : id;
                          });
                        },
                      )
                    else
                      _AssessmentTab(
                        snapshot: snapshot,
                        onStart: () => context.go(snapshot.assessmentRoute),
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
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingRiskDisclosurePage.warningKey,
      constraints: const BoxConstraints(minHeight: 144),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        border: Border.all(color: AppColors.sell20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: 26,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.warningBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.6,
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

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface2,
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(key: tab.id, label: tab.label, icon: null),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRiskDisclosurePage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(snapshot.summaryTitle),
        const SizedBox(height: AppSpacing.x3),
        _RiskSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _SectionLabel(snapshot.productSectionTitle),
        const SizedBox(height: AppSpacing.x3),
        for (final product in snapshot.products) ...[
          _RiskProductCard(product: product),
          if (product != snapshot.products.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            snapshot.disclaimer,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.summaryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.7,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final count in snapshot.riskCounts) ...[
                Expanded(child: _RiskCountTile(count: count)),
                if (count != snapshot.riskCounts.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskCountTile extends StatelessWidget {
  const _RiskCountTile({required this.count});

  final StakingRiskCountDraft count;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(count.level);
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: _riskTint(count.level),
        border: Border.all(color: color.withValues(alpha: .28)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${count.count}',
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            count.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskProductCard extends StatelessWidget {
  const _RiskProductCard({required this.product});

  final StakingRiskProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskDisclosurePage.productKey(product.name),
      radius: VitCardRadius.lg,
      constraints: BoxConstraints(
        minHeight: product.risks.length > 3 ? 125 : 94,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _RiskLevelBadge(level: product.level, prefix: true),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final risk in product.risks)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface3,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    risk,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({
    required this.snapshot,
    required this.expandedRisk,
    required this.onToggle,
  });

  final StakingRiskDisclosureSnapshot snapshot;
  final String? expandedRisk;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final category in snapshot.categories) ...[
          _RiskCategoryCard(
            category: category,
            expanded: expandedRisk == category.id,
            onTap: () => onToggle(category.id),
          ),
          if (category != snapshot.categories.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RiskCategoryCard extends StatelessWidget {
  const _RiskCategoryCard({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final StakingRiskCategoryDraft category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(category.level);
    return VitCard(
      key: StakingRiskDisclosurePage.categoryKey(category.id),
      radius: VitCardRadius.lg,
      clip: true,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _riskTint(category.level),
                        border: Border.all(
                          color: color.withValues(alpha: .28),
                          width: 1.5,
                        ),
                        borderRadius: AppRadii.lgRadius,
                      ),
                      child: Icon(
                        _categoryIcon(category.id),
                        color: color,
                        size: 22,
                      ),
                    ),
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
                                category.title,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              _RiskLevelBadge(level: category.level),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            category.description,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? .25 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _RiskCategoryDetails(category: category),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _RiskCategoryDetails extends StatelessWidget {
  const _RiskCategoryDetails({required this.category});

  final StakingRiskCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailGroup(label: 'Chi tiết:', items: category.details),
          const SizedBox(height: AppSpacing.x4),
          _DetailGroup(label: 'Ví dụ thực tế:', items: category.examples),
          const SizedBox(height: AppSpacing.x4),
          _DetailGroup(label: 'Cách giảm thiểu:', items: category.mitigation),
        ],
      ),
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: 4,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.text3,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _AssessmentTab extends StatelessWidget {
  const _AssessmentTab({required this.snapshot, required this.onStart});

  final StakingRiskDisclosureSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      border: Border.all(
                        color: AppColors.primary30,
                        width: 1.5,
                      ),
                      borderRadius: AppRadii.cardLargeRadius,
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.assessmentTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          snapshot.assessmentSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                snapshot.assessmentBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: StakingRiskDisclosurePage.assessmentCtaKey,
                height: 44,
                onPressed: onStart,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: Text(snapshot.assessmentCta),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _SectionLabel(snapshot.faqTitle),
        const SizedBox(height: AppSpacing.x3),
        for (final faq in snapshot.faqs) ...[
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  faq.answer,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          if (faq != snapshot.faqs.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RiskLevelBadge extends StatelessWidget {
  const _RiskLevelBadge({required this.level, this.prefix = false});

  final StakingDisclosureRiskLevel level;
  final bool prefix;

  @override
  Widget build(BuildContext context) {
    final label = prefix
        ? 'Rủi ro ${_riskLevelLabel(level)}'
        : _riskLevelLabel(level);
    final color = _riskColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: _riskTint(level),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

Color _riskColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}

Color _riskTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}

String _riskLevelLabel(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => 'Thấp',
    StakingDisclosureRiskLevel.medium => 'Trung bình',
    StakingDisclosureRiskLevel.high => 'Cao',
  };
}

IconData _categoryIcon(String id) {
  return switch (id) {
    'market' => Icons.trending_down_rounded,
    'liquidity' => Icons.lock_outline_rounded,
    'slashing' => Icons.report_problem_outlined,
    'smart-contract' => Icons.code_rounded,
    'counterparty' => Icons.business_rounded,
    'regulatory' => Icons.gavel_rounded,
    'technical' => Icons.public_rounded,
    _ => Icons.warning_amber_rounded,
  };
}
