part of '../pages/portfolio_risk_analysis_page.dart';

class _RiskSummaryGrid extends StatelessWidget {
  const _RiskSummaryGrid({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Total Exposure',
                value: _formatUsd(snapshot.totalExposure),
                caption: 'Across ${snapshot.assetExposures.length} assets',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskSummaryCard(
                label: 'VaR (95%, 1-day)',
                value: _formatUsd(snapshot.var95.abs()),
                valueColor: AppColors.sell,
                caption: 'Max loss @ 95%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Diversification',
                value: '${snapshot.diversificationScore}/100',
                valueColor: AppColors.buy,
                caption: 'Good',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskSummaryCard(
                label: 'Risk Alerts',
                value: '${snapshot.riskAlerts.length}',
                valueColor: AppColors.sell,
                caption: 'Active warnings',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 88,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningPanel extends StatelessWidget {
  const _RiskWarningPanel({required this.alerts});

  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      borderColor: _riskWarningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _riskWarningText,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Cảnh báo rủi ro',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _riskWarningText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          for (final alert in alerts) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                '• $alert',
                style: AppTextStyles.micro.copyWith(
                  color: _riskWarningText,
                  fontWeight: AppTextStyles.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (alert != alerts.last) const SizedBox(height: 3),
          ],
        ],
      ),
    );
  }
}

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradePortfolioRiskTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 53,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: PortfolioRiskAnalysisPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          style:
                              (tab.id == activeId
                                      ? AppTextStyles.baseMedium
                                      : AppTextStyles.caption)
                                  .copyWith(
                                    color: tab.id == activeId
                                        ? _riskPrimary
                                        : AppColors.text3,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 64 : 0,
                      height: 2,
                      color: _riskPrimary,
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

class _ExposureTab extends StatelessWidget {
  const _ExposureTab({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Asset Allocation',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 220,
          child: Center(
            child: CustomPaint(
              size: const Size(170, 170),
              painter: _ExposurePiePainter(snapshot.assetExposures),
            ),
          ),
        ),
        const SizedBox(height: 25),
        for (final asset in snapshot.assetExposures) ...[
          _AssetExposureRow(asset: asset),
          if (asset != snapshot.assetExposures.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 18),
        _DiversificationNote(score: snapshot.diversificationScore),
      ],
    );
  }
}

class _AssetExposureRow extends StatelessWidget {
  const _AssetExposureRow({required this.asset});

  final TradeAssetExposure asset;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: _riskPanel,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            asset.asset,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatUsd(asset.value),
                style: AppTextStyles.numericCode.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${_formatPercent(asset.percent)}%',
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.text3,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiversificationNote extends StatelessWidget {
  const _DiversificationNote({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      borderColor: _riskPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _riskPrimary, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Diversification score $score/100. Khuyến nghị không để asset nào chiếm >30% portfolio.',
              style: AppTextStyles.caption.copyWith(color: _riskPrimary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
