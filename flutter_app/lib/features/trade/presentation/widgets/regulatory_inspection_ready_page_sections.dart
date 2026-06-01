part of '../pages/regulatory_inspection_ready_page.dart';

class _HeaderDownloadButton extends StatelessWidget {
  const _HeaderDownloadButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _inspectionPanel2,
          border: Border.all(color: _inspectionBorder.withValues(alpha: .65)),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: 19,
          ),
        ),
      ),
    );
  }
}

class _ComplianceScoreCard extends StatelessWidget {
  const _ComplianceScoreCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 203),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _inspectionGreen.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.military_tech_outlined,
                  color: _inspectionGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.scoreLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${snapshot.complianceScore}%',
                            style: AppTextStyles.heroNumber.copyWith(
                              color: _inspectionGreen,
                              fontSize: 36,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '/ 100%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 11,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(color: _inspectionPanel2),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width:
                              constraints.maxWidth *
                              snapshot.complianceScore /
                              100,
                          height: 11,
                          child: const ColoredBox(color: _inspectionGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.text1,
                  size: 15,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: AppTextStyles.bold,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(text: '${snapshot.readyTitle} '),
                      TextSpan(text: snapshot.readyDescription),
                    ],
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

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final List<TradeRegulatoryInspectionStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _QuickStatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.stat});

  final TradeRegulatoryInspectionStat stat;

  @override
  Widget build(BuildContext context) {
    final style = _styleForStat(stat.icon);
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.color, size: 14),
          const SizedBox(height: 14),
          Text(
            stat.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 17,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 8,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.framework});

  final TradeRegulatoryFramework framework;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  framework.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${framework.compliance}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _inspectionGreen,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: _inspectionGreen,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final requirement in framework.requirements) ...[
            _RequirementRow(requirement),
            if (requirement != framework.requirements.last)
              const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _inspectionGreen,
          size: 11,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.check_rounded, color: AppColors.text2, size: 9),
            ],
          ),
        ),
      ],
    );
  }
}
