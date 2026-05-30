part of 'social_signals_page.dart';

class _SignalCard extends StatelessWidget {
  const _SignalCard({
    super.key,
    required this.signal,
    required this.tierConfig,
    required this.statusConfig,
    required this.expanded,
    required this.onTap,
  });

  final TradingSignalDraft signal;
  final SignalTierConfig tierConfig;
  final SignalStatusConfig statusConfig;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final directionColor = signal.direction == TradingSignalDirection.long
        ? AppColors.buy
        : AppColors.sell;
    final directionLabel = signal.direction == TradingSignalDirection.long
        ? '▲ LONG'
        : '▼ SHORT';

    return VitCard(
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      signal.providerAvatar,
                      style: const TextStyle(fontSize: 16, height: 1),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        signal.providerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _TinyBadge(
                      label: tierConfig.label,
                      color: tierConfig.color,
                      background: tierConfig.background,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${signal.providerWinRate.toStringAsFixed(1)}% win',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 8,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      signal.timeAgo,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _TinyBadge(
                      label: directionLabel,
                      color: directionColor,
                      background: directionColor.withValues(alpha: .12),
                      horizontalPadding: 8,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        signal.pair,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _TinyBadge(
                      label: statusConfig.label,
                      color: statusConfig.color,
                      background: statusConfig.color.withValues(alpha: .12),
                      height: 18,
                      fontSize: 8,
                    ),
                    const SizedBox(width: 6),
                    _TinyBadge(
                      label: _categoryLabel(signal.category).toLowerCase(),
                      color: AppColors.text3,
                      background: AppColors.surface2,
                      height: 18,
                      fontSize: 8,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SignalMetric(
                        label: 'Entry',
                        value: _formatPrice(signal.entry),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Hiện tại',
                        value: _formatPrice(signal.currentPrice),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Stop Loss',
                        value: _formatPrice(signal.stopLoss),
                        valueColor: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'PnL',
                        value: _formatPercent(signal.pnlPct),
                        valueColor: signal.pnlPct >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedSignalDetail(signal: signal),
        ],
      ),
    );
  }
}

class _ExpandedSignalDetail extends StatelessWidget {
  const _ExpandedSignalDetail({required this.signal});

  final TradingSignalDraft signal;

  @override
  Widget build(BuildContext context) {
    final confidence = _confidenceMeta(signal.confidence);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mục tiêu',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var index = 0; index < signal.targets.length; index += 1)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == signal.targets.length - 1 ? 0 : 8,
                    ),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        border: Border.all(color: AppColors.buy20),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TP${index + 1}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            _formatPrice(signal.targets[index]),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.buy,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Độ tin cậy: ',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                confidence.label,
                style: AppTextStyles.micro.copyWith(
                  color: confidence.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.schedule_rounded,
                size: 12,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                signal.expiresIn,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            signal.reasoning,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.favorite_border_rounded,
                size: 14,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                '${signal.likes}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.content_copy_rounded,
                size: 14,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                '${signal.copies} copies',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalMetric extends StatelessWidget {
  const _SignalMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
    this.height = 16,
    this.fontSize = 7,
    this.horizontalPadding = 5,
  });

  final String label;
  final Color color;
  final Color background;
  final double height;
  final double fontSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.rank,
    required this.provider,
    required this.tierConfig,
  });

  final int rank;
  final SignalProviderSummary provider;
  final SignalTierConfig tierConfig;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? tierConfig.color.withValues(alpha: .15)
                      : AppColors.surface2,
                  border: Border.all(
                    color: rank <= 3 ? tierConfig.color : AppColors.borderSolid,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: AppTextStyles.micro.copyWith(
                    color: rank <= 3 ? tierConfig.color : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(provider.avatar, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _TinyBadge(
                          label: tierConfig.label,
                          color: tierConfig.color,
                          background: tierConfig.background,
                          fontSize: 9,
                          height: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_formatCompact(provider.followers.toDouble())} followers · ${provider.totalSignals} tín hiệu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${provider.winRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.base.copyWith(
                      color: provider.winRate >= 65
                          ? AppColors.buy
                          : AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Win rate',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ProviderMetric(
                  label: 'Đang active',
                  value: '${provider.activeSignals}',
                  color: _marketPrimary,
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'Tổng signals',
                  value: '${provider.totalSignals}',
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'TB PnL',
                  value: _formatPercent(provider.avgPnl),
                  color: provider.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
