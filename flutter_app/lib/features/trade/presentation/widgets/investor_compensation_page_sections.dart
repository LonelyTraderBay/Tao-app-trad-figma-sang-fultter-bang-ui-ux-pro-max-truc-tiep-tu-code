part of '../pages/investor_compensation_page.dart';

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 154),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _compPanel,
        border: Border.all(color: _compBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _compGreen.withValues(alpha: .13),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: _compGreen,
                  size: 29,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protected up to ${snapshot.coverageLimit}',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontSize: 16,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        snapshot.summary,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.text1,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  snapshot.coveredMessage,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Protection',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.automaticProtection,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
    return Container(
      height: 53,
      color: _compPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: InvestorCompensationPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _compPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _compPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('What Is FSCS?'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.overviewDescription,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 8),
              for (final item in snapshot.overviewItems) ...[
                _InfoRow(item: item),
                if (item != snapshot.overviewItems.last)
                  const SizedBox(height: 11),
              ],
            ],
          ),
        ),
        const SizedBox(height: 26),
        const _SectionLabel('Coverage Limits'),
        const SizedBox(height: 12),
        _CoverageCard(snapshot: snapshot),
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
        const Icon(Icons.check_circle_outline, color: _compGreen, size: 16),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.25,
                ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final coverage in snapshot.coverageItems) ...[
            _CoverageBox(coverage: coverage),
            if (coverage != snapshot.coverageItems.last)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 13),
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
    return Container(
      height: 68,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 11),
      decoration: BoxDecoration(
        color: _compPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coverage.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              Text(
                coverage.amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: coverage.emphasized ? _compGreen : AppColors.text1,
                  fontSize: 16,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              coverage.caption,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
