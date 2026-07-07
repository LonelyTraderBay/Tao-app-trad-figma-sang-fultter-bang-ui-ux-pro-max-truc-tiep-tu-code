part of '../pages/investor_compensation_page.dart';

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _compBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: AppSpacing.x7 + AppSpacing.x1,
                height: AppSpacing.x7 + AppSpacing.x1,
                variant: VitCardVariant.ghost,
                borderColor: _compGreen.withValues(alpha: .24),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: _compGreen,
                  size: AppSpacing.iconMd + AppSpacing.x3,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Padding(
                  padding: AppSpacing.tradeBotDisputeDescriptionLabelPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protected up to ${snapshot.coverageLimit}',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        snapshot.summary,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.text1,
                size: AppSpacing.iconSm + AppSpacing.hairlineStroke,
              ),
              const SizedBox(width: AppSpacing.walletAssetSmallGap),
              Expanded(
                child: Text(
                  snapshot.coveredMessage,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _InfoNotice extends StatelessWidget {
  const _InfoNotice({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.inputPrefixIcon - AppSpacing.hairlineStroke,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Protection',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.automaticProtection,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Overview'),
      ('eligibility', 'Eligibility'),
      ('claim', 'How to Claim'),
    ];
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: InvestorCompensationPage.tabKey(tab.$1),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: InvestorCompensationPage.overviewKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        VitPageSection(
          label: 'What Is FSCS?',
          density: VitDensity.compact,
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.overviewDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  for (final item in snapshot.overviewItems) ...[
                    _InfoRow(item: item),
                    if (item != snapshot.overviewItems.last)
                      const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  ],
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Coverage Limits',
          density: VitDensity.compact,
          children: [_CoverageCard(snapshot: snapshot)],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final TradeInvestorCompensationInfo item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: _compGreen,
          size: AppSpacing.inputPrefixIcon - AppSpacing.hairlineStroke,
        ),
        const SizedBox(width: AppSpacing.walletAssetPillGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          for (final coverage in snapshot.coverageItems) ...[
            _CoverageBox(coverage: coverage),
            if (coverage != snapshot.coverageItems.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _WarningBox(text: snapshot.warning),
        ],
      ),
    );
  }
}

class _CoverageBox extends StatelessWidget {
  const _CoverageBox({required this.coverage});

  final TradeInvestorCompensationCoverage coverage;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coverage.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                coverage.amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: coverage.emphasized ? _compGreen : AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              coverage.caption,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}
