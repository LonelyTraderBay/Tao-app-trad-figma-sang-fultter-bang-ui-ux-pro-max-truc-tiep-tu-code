part of '../pages/bot_history_page.dart';

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeBotHistoryTrade trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.side == TradeBotHistorySide.buy;
    final sideColor = isBuy ? _historyGreen : _historyRed;
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
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
                          size: 15,
                        ),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                          decoration: BoxDecoration(
                            color: sideColor.withValues(alpha: .14),
                            borderRadius: AppRadii.smRadius,
                          ),
                          child: Text(
                            trade.side.name.toUpperCase(),
                            style: AppTextStyles.micro.copyWith(
                              color: sideColor,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          trade.pair,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Text(
                      '${trade.botName} - ${trade.strategy}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1,
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
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PnL',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DetailBox(label: 'Qty', value: _formatQty(trade.qty)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailBox(
                  label: 'Price',
                  value: '\$${_formatNumber(trade.price)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailBox(
                  label: 'Fee',
                  value: '\$${trade.fee.toStringAsFixed(3)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Divider(color: AppColors.borderSolid, height: 1),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Text(
                  trade.timestamp,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                decoration: BoxDecoration(
                  color: _historyGreen.withValues(alpha: .12),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Text(
                  trade.status,
                  style: AppTextStyles.micro.copyWith(
                    color: _historyGreen,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: 48,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Export Options',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            'Download your complete trade history for tax reporting, accounting, or analysis. Available formats: CSV, PDF, Excel.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              key: BotHistoryPage.exportAllKey,
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: _historyPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
              ),
              icon: const Icon(Icons.download_rounded, size: 15),
              label: Text(
                'Export All Trades',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.history_rounded, color: AppColors.text3, size: 48),
          const SizedBox(height: 12),
          Text(
            'No trades found',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _historyPrimary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
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
