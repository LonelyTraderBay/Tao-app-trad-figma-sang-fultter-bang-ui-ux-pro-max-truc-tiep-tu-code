part of '../pages/provider_leaderboard_page.dart';

class _ProviderRankCard extends StatelessWidget {
  const _ProviderRankCard({
    required this.rank,
    required this.provider,
    required this.onOpen,
  });

  final int rank;
  final TradeCopyTrader provider;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final redFlags = _redFlags(provider);

    return VitCard(
      key: ProviderLeaderboardPage.providerKey(provider.id),
      height: redFlags.isEmpty ? 124 : 148,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      borderColor: AppColors.cardBorder,
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RankBadge(rank: rank),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProviderTitle(provider: provider),
                const SizedBox(height: 9),
                _MetricsRow(provider: provider),
                const SizedBox(height: 12),
                _FollowersLabel(count: provider.copiers),
                if (redFlags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final flag in redFlags) _RedFlagPill(flag: flag),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.visibility_outlined,
              color: AppColors.text3,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final podium = rank <= 3;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: podium ? _leaderWarningText.withValues(alpha: .12) : _leaderChip,
        shape: BoxShape.circle,
        border: podium
            ? Border.all(color: _leaderWarningText, width: 2)
            : Border.all(color: AppColors.transparent),
      ),
      child: Text(
        '#$rank',
        style: AppTextStyles.caption.copyWith(
          color: podium ? _leaderWarningText : AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _ProviderTitle extends StatelessWidget {
  const _ProviderTitle({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            provider.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        if (_isProviderVerified(provider)) ...[
          const SizedBox(width: 7),
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _leaderPrimary,
            size: 12,
          ),
        ],
        const SizedBox(width: 7),
        _RiskBadge(riskLevel: provider.riskLevel),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.riskLevel});

  final TradeCopyRiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(riskLevel);
    return Container(
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        _riskLabel(riskLevel),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricValue(
            label: 'ROI',
            value: _formatSignedPercent(provider.totalPnlPct),
            color: provider.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Sharpe',
            value: provider.sharpeRatio.toStringAsFixed(2),
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Max DD',
            value: '${provider.maxDrawdown.toStringAsFixed(1)}%',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FollowersLabel extends StatelessWidget {
  const _FollowersLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.group_outlined, color: AppColors.text3, size: 10),
        const SizedBox(width: 4),
        Text(
          '${_formatInteger(count)} followers',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _RedFlagPill extends StatelessWidget {
  const _RedFlagPill({required this.flag});

  final String flag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: 9,
          ),
          const SizedBox(width: 3),
          Text(
            flag,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
