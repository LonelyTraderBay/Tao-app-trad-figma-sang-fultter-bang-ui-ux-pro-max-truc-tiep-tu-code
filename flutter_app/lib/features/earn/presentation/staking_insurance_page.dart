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

enum _InsuranceTab { overview, plans, positions, claims }

class StakingInsurancePage extends ConsumerStatefulWidget {
  const StakingInsurancePage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc365_info_banner');
  static const tabsKey = Key('sc365_tabs');
  static const overviewSummaryKey = Key('sc365_overview_summary');
  static const benefitsKey = Key('sc365_benefits');
  static const warningKey = Key('sc365_warning');
  static const planSheetKey = Key('sc365_plan_sheet');
  static const claimSheetKey = Key('sc365_claim_sheet');
  static const positionsKey = Key('sc365_positions');
  static const claimsKey = Key('sc365_claims');

  static Key tabKey(String id) => Key('sc365_tab_$id');

  static Key planKey(String id) => Key('sc365_plan_$id');

  static Key positionKey(String id) => Key('sc365_position_$id');

  static Key claimKey(String id) => Key('sc365_claim_$id');

  static Key addInsuranceKey(String id) => Key('sc365_add_insurance_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInsurancePage> createState() =>
      _StakingInsurancePageState();
}

class _StakingInsurancePageState extends ConsumerState<StakingInsurancePage> {
  _InsuranceTab _tab = _InsuranceTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInsuranceRepositoryProvider)
        .getInsurance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-365 StakingInsurancePage',
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
                    _InsuranceTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _InsuranceTab.overview)
                      _OverviewTab(snapshot: snapshot),
                    if (_tab == _InsuranceTab.plans)
                      _PlansTab(snapshot: snapshot, onOpenPlan: _showPlan),
                    if (_tab == _InsuranceTab.positions)
                      _PositionsTab(
                        snapshot: snapshot,
                        onAddInsurance: (position) {
                          HapticFeedback.lightImpact();
                          setState(() => _tab = _InsuranceTab.plans);
                        },
                      ),
                    if (_tab == _InsuranceTab.claims)
                      _ClaimsTab(
                        snapshot: snapshot,
                        onFileClaim: () => _showClaimForm(snapshot),
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

  Future<void> _showPlan(StakingInsurancePlanDraft plan) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SheetFrame(child: _PlanSheet(plan: plan)),
    );
  }

  Future<void> _showClaimForm(StakingInsuranceSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SheetFrame(child: _ClaimSheet(snapshot: snapshot)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceTabs extends StatelessWidget {
  const _InsuranceTabs({required this.active, required this.onChanged});

  final _InsuranceTab active;
  final ValueChanged<_InsuranceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingInsurancePage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _InsuranceTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                selected: active == tab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _InsuranceTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: StakingInsurancePage.tabKey(tab.name),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x4),
          child: Column(
            children: [
              Text(
                _tabLabel(tab),
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primarySoft : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: selected ? AppSpacing.buttonHero : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primarySoft : Colors.transparent,
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final insuredPositions = snapshot.positions.where((p) => p.insured).length;
    final totalInsured = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, p) => sum + p.usdValue);
    final totalPremium = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, position) {
          final plan = snapshot.planById(position.insurancePlanId);
          return sum +
              (plan == null ? 0 : position.usdValue * plan.premium / 100);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingInsurancePage.overviewSummaryKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá trị được bảo hiểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          _formatUsd(totalInsured),
                          style: AppTextStyles.heroNumber.copyWith(
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.buy10,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.buy, width: 2),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.buy,
                      size: AppSpacing.iconLg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Vị thế có BH',
                      value: '$insuredPositions/${snapshot.positions.length}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Phí/năm',
                      value: _formatUsd(totalPremium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _BenefitsGrid(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _WarningNote(snapshot: snapshot),
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInsurancePage.benefitsKey,
      label: 'Lợi ích Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio: 1.55,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return _BenefitCard(benefit: benefit);
          },
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final StakingInsuranceBenefitDraft benefit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            decoration: BoxDecoration(
              color: _iconFillColor(benefit.icon),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _iconBorder(benefit.icon)),
            ),
            child: Icon(
              _benefitIcon(benefit.icon),
              color: _iconColor(benefit.icon),
              size: AppSpacing.iconMd,
            ),
          ),
          const Spacer(),
          Text(
            benefit.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            benefit.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.warningKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.warningTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x3),
                for (final bullet in snapshot.warningBullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: AppSpacing.x1,
                          height: AppSpacing.x1,
                          margin: const EdgeInsets.only(top: AppSpacing.x3),
                          decoration: const BoxDecoration(
                            color: AppColors.warn,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            bullet,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                      ],
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

class _PlansTab extends StatelessWidget {
  const _PlansTab({required this.snapshot, required this.onOpenPlan});

  final StakingInsuranceSnapshot snapshot;
  final ValueChanged<StakingInsurancePlanDraft> onOpenPlan;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chọn Plan Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        for (final plan in snapshot.plans)
          _PlanCard(plan: plan, onTap: () => onOpenPlan(plan)),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onTap});

  final StakingInsurancePlanDraft plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.planKey(plan.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        _StatusPill(
                          label: '${plan.coverage}% Coverage',
                          color: AppColors.buy,
                        ),
                        _StatusPill(
                          label: '${plan.cooldownDays}d Claim',
                          color: AppColors.primarySoft,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan.premium.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.primarySoft,
                    ),
                  ),
                  Text(
                    'Premium',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _PlanMetric(
                  label: 'Max Claim',
                  value: _formatUsd(plan.maxClaim),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _PlanMetric(
                  label: 'Processing',
                  value: '${plan.cooldownDays} ngày',
                ),
              ),
            ],
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color == AppColors.buy ? AppColors.buy15 : AppColors.primary15,
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

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
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
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot, required this.onAddInsurance});

  final StakingInsuranceSnapshot snapshot;
  final ValueChanged<StakingInsurancePositionDraft> onAddInsurance;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInsurancePage.positionsKey,
      label: 'Vị thế Staking',
      accentColor: AppColors.primarySoft,
      children: [
        for (final position in snapshot.positions)
          _PositionCard(
            position: position,
            plan: snapshot.planById(position.insurancePlanId),
            onAddInsurance: () => onAddInsurance(position),
          ),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.plan,
    required this.onAddInsurance,
  });

  final StakingInsurancePositionDraft position;
  final StakingInsurancePlanDraft? plan;
  final VoidCallback onAddInsurance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.amount)} ${position.asset} · ${_formatUsd(position.usdValue)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              if (position.insured)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.buy,
                      size: AppSpacing.iconSm,
                    ),
                    SizedBox(width: AppSpacing.x2),
                    _StatusPill(label: 'Insured', color: AppColors.buy),
                  ],
                )
              else
                const _NeutralPill(label: 'No Insurance'),
            ],
          ),
          if (position.insured && plan != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.md,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  _SheetRow(label: 'Plan:', value: plan!.name),
                  _SheetRow(
                    label: 'Coverage:',
                    value: '${plan!.coverage}%',
                    valueColor: AppColors.buy,
                  ),
                  _SheetRow(
                    label: 'Premium/year:',
                    value: _formatUsd(position.usdValue * plan!.premium / 100),
                    valueColor: AppColors.primarySoft,
                  ),
                ],
              ),
            ),
          ],
          if (!position.insured) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              key: StakingInsurancePage.addInsuranceKey(position.id),
              height: AppSpacing.buttonCompact,
              onPressed: onAddInsurance,
              child: const Text('Thêm bảo hiểm'),
            ),
          ],
        ],
      ),
    );
  }
}

class _NeutralPill extends StatelessWidget {
  const _NeutralPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ClaimsTab extends StatelessWidget {
  const _ClaimsTab({required this.snapshot, required this.onFileClaim});

  final StakingInsuranceSnapshot snapshot;
  final VoidCallback onFileClaim;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingInsurancePage.claimsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Claim History', style: AppTextStyles.baseMedium),
            ),
            VitCtaButton(
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              onPressed: onFileClaim,
              child: const Text('File Claim'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final claim in snapshot.claims) ...[
          _ClaimCard(claim: claim),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim});

  final StakingInsuranceClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.claimKey(claim.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(claim.position, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${claim.date} · ${claim.reason}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const _StatusPill(label: 'Approved', color: AppColors.buy),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ClaimMetric(
                  label: 'Loss',
                  value: '-\$${claim.loss.toStringAsFixed(2)}',
                  color: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ClaimMetric(
                  label: 'Coverage',
                  value: '${claim.coverage}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ClaimMetric(
                  label: 'Payout',
                  value: '+\$${claim.payout.toStringAsFixed(2)}',
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

class _ClaimMetric extends StatelessWidget {
  const _ClaimMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x2),
      child: Column(
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
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
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

class _PlanSheet extends StatelessWidget {
  const _PlanSheet({required this.plan});

  final StakingInsurancePlanDraft plan;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingInsurancePage.planSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetTitle(title: plan.name),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                _SheetRow(
                  label: 'Coverage',
                  value: '${plan.coverage}%',
                  valueColor: AppColors.buy,
                ),
                _SheetRow(label: 'Premium', value: '${plan.premium}% APY'),
                _SheetRow(
                  label: 'Max Claim',
                  value: _formatUsd(plan.maxClaim),
                  valueColor: AppColors.primarySoft,
                ),
                _SheetRow(
                  label: 'Claim Processing',
                  value: '${plan.cooldownDays} ngày',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Tính năng',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final feature in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Text(
              'Ví dụ: Stake \$10,000 với plan này, phí bảo hiểm là \$${(10000 * plan.premium / 100).toStringAsFixed(0)}/năm. Nếu slashing mất \$1,000, khoản bồi thường dự kiến là \$${(1000 * plan.coverage / 100).toStringAsFixed(0)}.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chọn plan này'),
          ),
        ],
      ),
    );
  }
}

class _ClaimSheet extends StatelessWidget {
  const _ClaimSheet({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final insuredPositions = snapshot.positions
        .where((p) => p.insured)
        .toList();

    return SingleChildScrollView(
      key: StakingInsurancePage.claimSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'File Claim'),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Chọn vị thế',
            child: _StaticSelect(
              value: insuredPositions.isEmpty
                  ? 'Không có vị thế'
                  : insuredPositions.first.product,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Lý do claim',
            child: _StaticSelect(value: snapshot.claimReasons.first),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Số lượng bị mất (USD)',
            child: const _TextInput(hint: '0.00', numeric: true),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Mô tả chi tiết',
            child: const _TextInput(
              hint: 'Mô tả sự cố và cung cấp bằng chứng...',
              minLines: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit Claim'),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    snapshot.claimEvidenceNote,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _StaticSelect extends StatelessWidget {
  const _StaticSelect({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          const Icon(
            Icons.expand_more_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.hint,
    this.numeric = false,
    this.minLines = 1,
  });

  final String hint;
  final bool numeric;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: TextField(
        minLines: minLines,
        maxLines: minLines,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.multiline,
        cursorColor: AppColors.primary,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(color: AppColors.text3),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

String _tabLabel(_InsuranceTab tab) {
  return switch (tab) {
    _InsuranceTab.overview => 'Tổng quan',
    _InsuranceTab.plans => 'Plans',
    _InsuranceTab.positions => 'Vị thế',
    _InsuranceTab.claims => 'Claims',
  };
}

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    'cost' => Icons.attach_money_rounded,
    'audit' => Icons.check_circle_outline_rounded,
    _ => Icons.shield_outlined,
  };
}

Color _iconColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy,
    'clock' => AppColors.primarySoft,
    'cost' => AppColors.warn,
    'audit' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

Color _iconFillColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy10,
    'clock' => AppColors.primary12,
    'cost' => AppColors.warn10,
    'audit' => AppColors.accent12,
    _ => AppColors.primary12,
  };
}

Color _iconBorder(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy20,
    'clock' => AppColors.primary30,
    'cost' => AppColors.warningBorder,
    'audit' => AppColors.accent30,
    _ => AppColors.primary30,
  };
}

String _formatUsd(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  final parts = value.toStringAsFixed(2).split('.');
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

extension on StakingInsuranceSnapshot {
  StakingInsurancePlanDraft? planById(String? id) {
    if (id == null) return null;
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}
