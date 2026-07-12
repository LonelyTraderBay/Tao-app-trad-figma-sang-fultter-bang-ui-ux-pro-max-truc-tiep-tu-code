part of '../pages/staking_proof_of_reserves_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      key: StakingProofOfReservesPage.infoKey,
      variant: VitBannerVariant.info,
      icon: Icons.shield_outlined,
      message: snapshot.infoTitle,
      detail: snapshot.infoBody,
    );
  }
}

class _InnerMetric extends StatelessWidget {
  const _InnerMetric({
    required this.label,
    required this.value,
    this.valueColor,
    this.subtleBuy = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool subtleBuy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: subtleBuy ? AppColors.buy20 : null,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      semanticStatus: _proofStatusForColor(color),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

String _tabLabel(_ReserveTab tab) {
  return switch (tab) {
    _ReserveTab.overview => 'Overview',
    _ReserveTab.assets => 'By Asset',
    _ReserveTab.verify => 'Verify',
  };
}

_ReserveTab _reserveTabFromKey(String key) {
  return _ReserveTab.values.firstWhere(
    (tab) => tab.name == key,
    orElse: () => _ReserveTab.overview,
  );
}

VitStatusPillStatus _proofStatusForColor(Color color) {
  if (color == AppColors.buy) {
    return VitStatusPillStatus.success;
  }
  if (color == AppColors.warn) {
    return VitStatusPillStatus.warning;
  }
  if (color == AppColors.sell) {
    return VitStatusPillStatus.error;
  }
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return VitStatusPillStatus.info;
  }
  return VitStatusPillStatus.neutral;
}
