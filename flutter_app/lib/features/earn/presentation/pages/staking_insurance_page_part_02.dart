part of 'staking_insurance_page.dart';

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onTap});

  final StakingInsurancePlanDraft plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.planKey(plan.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
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
                    const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
    return Material(
      color: color == AppColors.buy ? AppColors.buy15 : AppColors.primary15,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: AppSpacing.earnPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.earnPaddingX3,
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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
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
                const VitAccentPill(
                  label: 'No Insurance',
                  accentColor: AppColors.text3,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          if (position.insured && plan != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              padding: AppSpacing.earnPaddingX4,
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
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
              padding: AppSpacing.earnHorizontalPaddingX4,
              onPressed: onFileClaim,
              child: const Text('File Claim'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final claim in snapshot.claims) ...[
          _ClaimCard(claim: claim),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
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
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.earnPaddingX2,
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
      child: Padding(
        padding: AppSpacing.earnContentMargin,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: Material(
            color: AppColors.surface,
            borderRadius: AppRadii.cardLargeRadius,
            child: Padding(padding: AppSpacing.earnPaddingX5, child: child),
          ),
        ),
      ),
    );
  }
}
