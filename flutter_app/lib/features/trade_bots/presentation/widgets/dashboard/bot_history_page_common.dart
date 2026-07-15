part of '../../pages/dashboard/bot_history_page.dart';

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeBotHistoryTrade trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.side == TradeBotHistorySide.buy;
    final sideColor = isBuy ? _historyGreen : _historyRed;
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBuy
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: sideColor,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        VitAccentPill(
                          label: trade.side.name.toUpperCase(),
                          accentColor: sideColor,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          trade.pair,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${trade.botName} - ${trade.strategy}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (trade.pnl != 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trade.pnl >= 0 ? '+' : ''}${trade.pnl.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: trade.pnl >= 0 ? _historyGreen : _historyRed,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'PnL',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _DetailBox(label: 'Qty', value: _formatQty(trade.qty)),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: _DetailBox(
                  label: 'Price',
                  value: '\$${_formatNumber(trade.price)}',
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: _DetailBox(
                  label: 'Fee',
                  value: '\$${trade.fee.toStringAsFixed(3)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Divider(
            color: AppColors.borderSolid,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  trade.timestamp,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              VitStatusPill(
                label: trade.status,
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportNote extends StatelessWidget {
  const _ExportNote({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Export Options',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Download your complete trade history for tax reporting, accounting, or analysis. Available formats: CSV, PDF, Excel.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: BotHistoryPage.exportAllKey,
            height: VitDensity.compact.controlHeight,
            onPressed: onTap,
            leading: const Icon(Icons.download_rounded),
            child: const Text('Export All Trades'),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'No trades found',
      icon: Icons.history_rounded,
    );
  }
}

String _formatNumber(double value) {
  final hasFraction = (value - value.truncateToDouble()).abs() > 0.0001;
  final raw = hasFraction
      ? value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')
      : value.toStringAsFixed(0);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return buffer.toString();
}

String _formatQty(double value) {
  final text = value.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
