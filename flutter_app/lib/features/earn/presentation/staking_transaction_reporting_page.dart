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

enum _ReportingTab { summary, transactions, export }

class StakingTransactionReportingPage extends ConsumerStatefulWidget {
  const StakingTransactionReportingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc378_info');
  static const selectorsKey = Key('sc378_selectors');
  static const tabsKey = Key('sc378_tabs');
  static const summaryKey = Key('sc378_summary');
  static const rewardsKey = Key('sc378_rewards');
  static const transactionsKey = Key('sc378_transactions');
  static const exportKey = Key('sc378_export');
  static const methodSheetKey = Key('sc378_method_sheet');
  static const exportSheetKey = Key('sc378_export_sheet');
  static const footerKey = Key('sc378_footer');

  static Key tabKey(String id) => Key('sc378_tab_$id');

  static Key methodKey(String id) => Key('sc378_method_$id');

  static Key exportOptionKey(String id) => Key('sc378_export_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTransactionReportingPage> createState() =>
      _StakingTransactionReportingPageState();
}

class _StakingTransactionReportingPageState
    extends ConsumerState<StakingTransactionReportingPage> {
  _ReportingTab _tab = _ReportingTab.summary;
  late String _year;
  late String _costBasis;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingTransactionReportingRepositoryProvider)
        .getReporting();
    _year = snapshot.defaultYear;
    _costBasis = snapshot.defaultCostBasis;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingTransactionReportingRepositoryProvider)
        .getReporting();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-378 StakingTransactionReportingPage',
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
                    _InfoBanner(snapshot: snapshot),
                    _Selectors(
                      snapshot: snapshot,
                      year: _year,
                      costBasis: _costBasis,
                      onYearChanged: (year) {
                        HapticFeedback.selectionClick();
                        setState(() => _year = year);
                      },
                      onOpenCostBasis: () => _openMethodSheet(snapshot),
                    ),
                    _ReportingTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _ReportingTab.summary)
                      _SummaryTab(snapshot: snapshot, costBasis: _costBasis)
                    else if (_tab == _ReportingTab.transactions)
                      _TransactionsTab(snapshot: snapshot)
                    else
                      _ExportTab(
                        snapshot: snapshot,
                        onOpenExport: () => _openExportSheet(snapshot),
                      ),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMethodSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SheetFrame(
        child: _MethodSheet(
          methods: snapshot.costBasisMethods,
          selected: _costBasis,
          onChanged: (method) {
            setState(() => _costBasis = method);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openExportSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _SheetFrame(child: _ExportSheet(snapshot: snapshot)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _Selectors extends StatelessWidget {
  const _Selectors({
    required this.snapshot,
    required this.year,
    required this.costBasis,
    required this.onYearChanged,
    required this.onOpenCostBasis,
  });

  final StakingTransactionReportingSnapshot snapshot;
  final String year;
  final String costBasis;
  final ValueChanged<String> onYearChanged;
  final VoidCallback onOpenCostBasis;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: StakingTransactionReportingPage.selectorsKey,
      children: [
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Year',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Material(
                  color: AppColors.surface3,
                  borderRadius: AppRadii.inputRadius,
                  child: InkWell(
                    borderRadius: AppRadii.inputRadius,
                    onTap: () {
                      final currentIndex = snapshot.years.indexOf(year);
                      final nextIndex =
                          (currentIndex + 1) % snapshot.years.length;
                      onYearChanged(snapshot.years[nextIndex]);
                    },
                    child: Container(
                      height: AppSpacing.ctaHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              year,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.expand_more_rounded,
                            color: AppColors.text2,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCard(
            onTap: onOpenCostBasis,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: SizedBox(
              height: 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost Basis',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          costBasis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.filter_list_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportingTabs extends StatelessWidget {
  const _ReportingTabs({required this.active, required this.onChanged});

  final _ReportingTab active;
  final ValueChanged<_ReportingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingTransactionReportingPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _ReportingTab.values)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: StakingTransactionReportingPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : Colors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.snapshot, required this.costBasis});

  final StakingTransactionReportingSnapshot snapshot;
  final String costBasis;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingTransactionReportingPage.summaryKey,
          label: 'Tax Summary ${snapshot.defaultYear}',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  _SummaryPanel(
                    label: 'Total Staking Income',
                    value: _formatUsd(summary.totalStakingIncome),
                    body:
                        'Taxed as ordinary income at your marginal tax rate (reported on Form 1099-MISC)',
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _GainsPanel(summary: summary),
                  const SizedBox(height: AppSpacing.x4),
                  _CostBasisPanel(summary: summary, method: costBasis),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingTransactionReportingPage.rewardsKey,
          label: 'Staking Rewards by Asset',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final reward in summary.rewardsByAsset) ...[
                    _RewardAssetRow(reward: reward),
                    if (reward != summary.rewardsByAsset.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.label,
    required this.value,
    required this.body,
  });

  final String label;
  final String value;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.baseMedium)),
              const SizedBox(width: AppSpacing.x3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            body,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _GainsPanel extends StatelessWidget {
  const _GainsPanel({required this.summary});

  final StakingTaxSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Capital Gains',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              Text(
                _formatUsd(summary.totalCapitalGains),
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Short-term (<1 year)',
                  value: _formatUsd(summary.shortTermGains),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SmallMetric(
                  label: 'Long-term (>=1 year)',
                  value: _formatUsd(summary.longTermGains),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Reported on Form 8949 and Schedule D. Long-term gains taxed at lower rates.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostBasisPanel extends StatelessWidget {
  const _CostBasisPanel({required this.summary, required this.method});

  final StakingTaxSummaryDraft summary;
  final String method;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Cost Basis',
                  value: _formatUsd(summary.costBasis),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SmallMetric(
                  label: 'Proceeds',
                  value: _formatUsd(summary.proceeds),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Using $method method',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardAssetRow extends StatelessWidget {
  const _RewardAssetRow({required this.reward});

  final StakingTaxRewardAssetDraft reward;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.asset, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatAmount(reward.amount)} ${reward.asset}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(reward.usdValue),
                style: AppTextStyles.baseMedium.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Taxable income',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingTransactionReportingPage.transactionsKey,
      label: 'All Transactions ${snapshot.defaultYear}',
      accentColor: AppColors.primarySoft,
      children: [
        for (final tx in snapshot.transactions) _TransactionCard(tx: tx),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.tx});

  final StakingTaxTransactionDraft tx;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_typeLabel(tx.type)} ${_formatAmount(tx.amount)} ${tx.asset}',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tx.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(tx.usdValue),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  if (tx.taxable) ...[
                    const SizedBox(height: AppSpacing.x1),
                    const _StatusPill(label: 'Taxable', color: AppColors.warn),
                  ],
                ],
              ),
            ],
          ),
          if (tx.costBasis != null) ...[
            const SizedBox(height: AppSpacing.x3),
            const Divider(color: AppColors.borderSolid, height: 1),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cost Basis:',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  _formatUsd(tx.costBasis!),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExportTab extends StatelessWidget {
  const _ExportTab({required this.snapshot, required this.onOpenExport});

  final StakingTransactionReportingSnapshot snapshot;
  final VoidCallback onOpenExport;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingTransactionReportingPage.exportKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Generate Tax Forms',
          accentColor: AppColors.primarySoft,
          children: [
            _ExportCategoryCard(
              title: 'IRS Tax Forms (PDF)',
              subtitle: 'Form 1099-MISC, 8949, Schedule D',
              icon: Icons.description_outlined,
              color: AppColors.sell,
              onTap: onOpenExport,
            ),
            _ExportCategoryCard(
              title: 'Third-Party Integrations',
              subtitle: 'TurboTax, CoinTracker, Koinly',
              icon: Icons.open_in_new_rounded,
              color: AppColors.primarySoft,
              onTap: onOpenExport,
            ),
            _ExportCategoryCard(
              title: 'Raw Data Export',
              subtitle: 'CSV, JSON formats',
              icon: Icons.data_object_rounded,
              color: AppColors.buy,
              onTap: onOpenExport,
            ),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.warningBorder,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Important Tax Notice', style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.taxNotice,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Helpful Resources',
          accentColor: AppColors.primarySoft,
          children: [
            for (final resource in snapshot.resources)
              _ResourceRow(resource: resource),
          ],
        ),
      ],
    );
  }
}

class _ExportCategoryCard extends StatelessWidget {
  const _ExportCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
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
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Expanded(child: Text(resource.label, style: AppTextStyles.caption)),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _MethodSheet extends StatelessWidget {
  const _MethodSheet({
    required this.methods,
    required this.selected,
    required this.onChanged,
  });

  final List<StakingCostBasisMethodDraft> methods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.methodSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Select Cost Basis Method'),
          const SizedBox(height: AppSpacing.x4),
          for (final method in methods) ...[
            _MethodOption(
              method: method,
              selected: method.value == selected,
              onTap: () => onChanged(method.value),
            ),
            if (method != methods.last) const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Once you choose a method for a tax year, use it consistently. Consult a tax professional for guidance.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
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

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final StakingCostBasisMethodDraft method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.methodKey(method.value),
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.primary : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.label, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  method.description,
                  style: AppTextStyles.caption.copyWith(
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

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.exportSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Export Options'),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(title: 'Tax Forms (PDF)', options: snapshot.taxForms),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(
            title: 'Third-Party Integrations',
            options: snapshot.integrations,
          ),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(title: 'Raw Data', options: snapshot.rawDataFormats),
        ],
      ),
    );
  }
}

class _ExportGroup extends StatelessWidget {
  const _ExportGroup({required this.title, required this.options});

  final String title;
  final List<StakingTaxExportOptionDraft> options;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppColors.primarySoft,
      children: [
        for (final option in options)
          VitCard(
            key: StakingTransactionReportingPage.exportOptionKey(option.name),
            onTap: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.name, style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        option.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.text2),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
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

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

String _tabLabel(_ReportingTab tab) {
  return switch (tab) {
    _ReportingTab.summary => 'Summary',
    _ReportingTab.transactions => 'Transactions',
    _ReportingTab.export => 'Export',
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'stake' => 'Staked',
    'unstake' => 'Unstaked',
    'reward' => 'Reward',
    _ => type,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
}
