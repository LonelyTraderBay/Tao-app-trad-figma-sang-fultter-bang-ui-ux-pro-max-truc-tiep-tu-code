import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingTaxGuidePage extends ConsumerStatefulWidget {
  const StakingTaxGuidePage({super.key, this.shellRenderMode});

  static const disclaimerKey = Key('sc356_tax_disclaimer');
  static const overviewKey = Key('sc356_tax_overview');
  static const summaryKey = Key('sc356_tax_summary');
  static const historyToolKey = Key('sc356_tax_history_tool');
  static const taxReportsToolKey = Key('sc356_tax_reports_tool');
  static const calculatorResultKey = Key('sc356_tax_calculator_result');

  static Key jurisdictionKey(String id) => Key('sc356_tax_jurisdiction_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTaxGuidePage> createState() =>
      _StakingTaxGuidePageState();
}

class _StakingTaxGuidePageState extends ConsumerState<StakingTaxGuidePage> {
  final _rewardsController = TextEditingController();
  final _rateController = TextEditingController();
  String? _activeTab;
  String _selectedJurisdiction = 'us';

  @override
  void dispose() {
    _rewardsController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingTaxGuideRepositoryProvider).getGuide();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-356 StakingTaxGuidePage',
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
                    _DisclaimerBanner(snapshot: snapshot),
                    _TaxTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = tab);
                      },
                    ),
                    if (activeTab == 'overview')
                      _OverviewTab(snapshot: snapshot)
                    else if (activeTab == 'jurisdictions')
                      _JurisdictionTab(
                        snapshot: snapshot,
                        selectedId: _selectedJurisdiction,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedJurisdiction = id);
                        },
                      )
                    else
                      _CalculatorTab(
                        snapshot: snapshot,
                        rewardsController: _rewardsController,
                        rateController: _rateController,
                        onChanged: () => setState(() {}),
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

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner({required this.snapshot});

  final StakingTaxGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingTaxGuidePage.disclaimerKey,
      constraints: const BoxConstraints(minHeight: 136),
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
            size: 24,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.disclaimerTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.disclaimerBody,
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

class _TaxTabs extends StatelessWidget {
  const _TaxTabs({
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

  final StakingTaxGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.overviewTitle,
          children: [
            VitCard(
              key: StakingTaxGuidePage.overviewKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.overviewBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  for (final event in snapshot.incomeEvents) ...[
                    _IncomeEventCard(event: event),
                    if (event != snapshot.incomeEvents.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: snapshot.summaryTitle,
          children: [
            VitCard(
              key: StakingTaxGuidePage.summaryKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final summary in snapshot.countrySummaries) ...[
                    _CountrySummaryRow(summary: summary),
                    if (summary != snapshot.countrySummaries.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: snapshot.toolsTitle,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  _ToolRow(
                    key: StakingTaxGuidePage.historyToolKey,
                    icon: Icons.receipt_long_rounded,
                    title: 'Lịch sử Staking',
                    subtitle: 'Xem tất cả giao dịch staking',
                    onTap: () => context.go(snapshot.historyRoute),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _ToolRow(
                    key: StakingTaxGuidePage.taxReportsToolKey,
                    icon: Icons.file_download_outlined,
                    title: 'Báo cáo Thuế',
                    subtitle: 'Xuất CSV/PDF cho khai thuế',
                    onTap: () => context.go(snapshot.taxReportsRoute),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _FooterCard(text: snapshot.footer),
      ],
    );
  }
}

class _IncomeEventCard extends StatelessWidget {
  const _IncomeEventCard({required this.event});

  final StakingTaxIncomeEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            event.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            event.example,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountrySummaryRow extends StatelessWidget {
  const _CountrySummaryRow({required this.summary});

  final StakingTaxCountrySummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CodeBadge(code: summary.code),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary.country,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${summary.treatment} · CGT: ${summary.cgt}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            children: [
              Icon(icon, color: AppColors.text1, size: 22),
              const SizedBox(width: AppSpacing.x3),
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
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                color: AppColors.text3,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JurisdictionTab extends StatelessWidget {
  const _JurisdictionTab({
    required this.snapshot,
    required this.selectedId,
    required this.onChanged,
  });

  final StakingTaxGuideSnapshot snapshot;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.jurisdictions.firstWhere(
      (item) => item.id == selectedId,
      orElse: () => snapshot.jurisdictions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final jurisdiction in snapshot.jurisdictions)
              _JurisdictionChip(
                jurisdiction: jurisdiction,
                selected: jurisdiction.id == selected.id,
                onTap: () => onChanged(jurisdiction.id),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _JurisdictionDetail(jurisdiction: selected),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Tài liệu tham khảo',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final resource in selected.resources) ...[
                    _ResourceRow(resource: resource),
                    if (resource != selected.resources.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        const _WarningNote(
          text:
              'Thông tin trên chỉ mang tính tổng quan. Quy định thuế có thể thay đổi. Vui lòng tham khảo chuyên gia thuế hoặc website cơ quan thuế chính thức.',
        ),
      ],
    );
  }
}

class _JurisdictionChip extends StatelessWidget {
  const _JurisdictionChip({
    required this.jurisdiction,
    required this.selected,
    required this.onTap,
  });

  final StakingTaxJurisdictionDraft jurisdiction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        key: StakingTaxGuidePage.jurisdictionKey(jurisdiction.id),
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary20 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CodeBadge(code: jurisdiction.code, small: true),
              const SizedBox(width: AppSpacing.x2),
              Text(
                jurisdiction.name.split('(').first.trim(),
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.text2,
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

class _JurisdictionDetail extends StatelessWidget {
  const _JurisdictionDetail({required this.jurisdiction});

  final StakingTaxJurisdictionDraft jurisdiction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CodeBadge(code: jurisdiction.code, large: true),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jurisdiction.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      jurisdiction.taxAuthority,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Cách xử lý thuế:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            jurisdiction.treatment,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _JurisdictionMetric(
                  label: 'Thuế suất',
                  value: jurisdiction.rate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _JurisdictionMetric(
                  label: 'Biểu mẫu',
                  value: jurisdiction.reportingForm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JurisdictionMetric extends StatelessWidget {
  const _JurisdictionMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final StakingTaxResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.public_rounded, color: AppColors.primary, size: 17),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              resource.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.primary,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _CalculatorTab extends StatelessWidget {
  const _CalculatorTab({
    required this.snapshot,
    required this.rewardsController,
    required this.rateController,
    required this.onChanged,
  });

  final StakingTaxGuideSnapshot snapshot;
  final TextEditingController rewardsController;
  final TextEditingController rateController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final rewards = double.tryParse(rewardsController.text);
    final rate = double.tryParse(rateController.text);
    final hasResult =
        rewards != null && rate != null && rewards >= 0 && rate >= 0;
    final taxOwed = hasResult ? rewards * (rate / 100) : 0.0;
    final afterTax = hasResult ? rewards - taxOwed : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      border: Border.all(
                        color: AppColors.primary20,
                        width: 1.5,
                      ),
                      borderRadius: AppRadii.cardRadius,
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.calculatorTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          snapshot.calculatorSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              VitInput(
                controller: rewardsController,
                fieldKey: const Key('sc356_tax_rewards_input'),
                label: 'Tổng phần thưởng staking (USD)',
                hintText: '1000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.savings_rounded),
                onChanged: (_) => onChanged(),
              ),
              const SizedBox(height: AppSpacing.x3),
              VitInput(
                controller: rateController,
                fieldKey: const Key('sc356_tax_rate_input'),
                label: 'Thuế suất của bạn (%)',
                hintText: '30',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.percent_rounded),
                onChanged: (_) => onChanged(),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                snapshot.calculatorHint,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (hasResult) ...[
                const SizedBox(height: AppSpacing.x4),
                _TaxResultCard(
                  rewards: rewards,
                  rate: rate,
                  taxOwed: taxOwed,
                  afterTax: afterTax,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _WarningNote(text: snapshot.calculatorDisclaimer),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: snapshot.faqTitle,
          children: [for (final faq in snapshot.faqs) _FaqCard(faq: faq)],
        ),
        const SizedBox(height: AppSpacing.x4),
        _FooterCard(text: snapshot.footer),
      ],
    );
  }
}

class _TaxResultCard extends StatelessWidget {
  const _TaxResultCard({
    required this.rewards,
    required this.rate,
    required this.taxOwed,
    required this.afterTax,
  });

  final double rewards;
  final double rate;
  final double taxOwed;
  final double afterTax;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingTaxGuidePage.calculatorResultKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết quả:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          _ResultRow(label: 'Tổng phần thưởng', value: _money(rewards)),
          const SizedBox(height: AppSpacing.x2),
          _ResultRow(
            label:
                'Thuế phải nộp (${rate.toStringAsFixed(rate.truncateToDouble() == rate ? 0 : 1)}%)',
            value: '-${_money(taxOwed)}',
            color: AppColors.sell,
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _ResultRow(
            label: 'Sau thuế',
            value: _money(afterTax),
            color: AppColors.buy,
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.color,
    this.highlight = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: highlight ? AppColors.text1 : AppColors.text3,
              fontWeight: highlight ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontSize: highlight ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faq});

  final StakingTaxFaqDraft faq;

  @override
  Widget build(BuildContext context) {
    return VitCard(
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
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.6,
        ),
      ),
    );
  }
}

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({
    required this.code,
    this.small = false,
    this.large = false,
  });

  final String code;
  final bool small;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 48.0 : (small ? 24.0 : 36.0);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: large ? AppRadii.cardRadius : AppRadii.mdRadius,
      ),
      child: Text(
        code,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
          fontSize: small ? 10 : (large ? 16 : 14),
        ),
      ),
    );
  }
}

String _money(double value) {
  final fixed = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 2,
  );
  final parts = fixed.split('.');
  final head = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < head.length; i++) {
    final remaining = head.length - i;
    buffer.write(head[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$${buffer.toString()}';
}
