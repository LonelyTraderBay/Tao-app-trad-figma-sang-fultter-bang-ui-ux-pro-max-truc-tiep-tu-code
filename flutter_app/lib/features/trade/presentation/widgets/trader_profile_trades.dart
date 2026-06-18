part of '../pages/trader_profile_page.dart';

class _TradesTab extends StatelessWidget {
  const _TradesTab({required this.trades});

  final List<TradeTraderRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final trade in trades) ...[
          _TradeCard(trade: trade),
          if (trade != trades.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({required this.trade});

  final TradeTraderRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final isProfit = trade.pnl >= 0;
    final sideColor = trade.side == 'long' ? _profileGreen : _profileRed;
    return _Panel(
      padding: AppSpacing.traderProfileTradeCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                trade.pair,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _MiniBadge(label: trade.side.toUpperCase(), color: sideColor),
              if (trade.status == 'open') ...[
                const SizedBox(width: AppSpacing.x2 + AppSpacing.x1),
                const _MiniBadge(label: 'OPEN', color: _profilePrimary),
              ],
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _signedUsd(trade.pnl),
                    style: AppTextStyles.caption.copyWith(
                      color: isProfit ? _profileGreen : _profileRed,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: AppSpacing.tradeBotLineHeightTight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.traderProfileTinyGap),
                  Text(
                    '${trade.pnlPct >= 0 ? '+' : ''}${trade.pnlPct.toStringAsFixed(2)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: isProfit ? _profileGreen : _profileRed,
                      height: AppSpacing.tradeBotLineHeightTight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x4 - AppSpacing.x1,
                  runSpacing: AppSpacing.x2,
                  children: [
                    _TradePrice(
                      label: 'Entry:',
                      value: _formatPrice(trade.entry),
                    ),
                    if (trade.exit != null)
                      _TradePrice(
                        label: 'Exit:',
                        value: _formatPrice(trade.exit!),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                trade.time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TradePrice extends StatelessWidget {
  const _TradePrice({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: AppSpacing.tradeBotLineHeightTight,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: '\$$value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
