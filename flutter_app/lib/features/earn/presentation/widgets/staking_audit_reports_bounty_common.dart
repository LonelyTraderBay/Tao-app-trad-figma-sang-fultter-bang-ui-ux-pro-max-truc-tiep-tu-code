part of '../pages/staking_audit_reports_page.dart';

class _BugBountySection extends StatelessWidget {
  const _BugBountySection({required this.bugBounty, required this.onOpen});

  final StakingBugBountyDraft bugBounty;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Bug Bounty Program',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingAuditReportsPage.bugBountyKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _RoundIcon(
                    icon: Icons.shield_outlined,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bugBounty.title, style: AppTextStyles.baseMedium),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          bugBounty.subtitle,
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
                bugBounty.body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.55,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x2,
                  children: [
                    for (final payout in bugBounty.payouts)
                      _PayoutItem(payout: payout),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _ActionButton(
                key: StakingAuditReportsPage.bugBountyCtaKey,
                label: 'View on Immunefi',
                icon: Icons.open_in_new_rounded,
                primary: true,
                onTap: onOpen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayoutItem extends StatelessWidget {
  const _PayoutItem({required this.payout});

  final StakingBugBountyPayoutDraft payout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          payout.severity,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          payout.amount,
          style: AppTextStyles.baseMedium.copyWith(
            color: _toneColor(payout.tone),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.primary : AppColors.surface3;
    final fg = primary ? AppColors.text1 : AppColors.text1;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: bg,
        borderRadius: AppRadii.lgRadius,
        child: InkWell(
          borderRadius: AppRadii.lgRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: fg,
                      fontWeight: AppTextStyles.bold,
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

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

String _typeId(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'smart-contract',
    StakingAuditReportType.financial => 'financial',
    StakingAuditReportType.security => 'security',
  };
}

String _reportTypeLabel(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'Smart Contract',
    StakingAuditReportType.financial => 'Financial',
    StakingAuditReportType.security => 'Security',
  };
}

Color _reportTypeColor(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => AppColors.accent,
    StakingAuditReportType.financial => AppColors.buy,
    StakingAuditReportType.security => AppColors.warn,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}
