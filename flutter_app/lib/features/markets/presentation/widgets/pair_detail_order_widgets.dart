part of '../pages/pair_detail_page.dart';

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.snapshot});

  final MarketPairDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairOrderPanelPadding,
      child: VitCard(
        padding: AppSpacing.pairOrderCardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'So lenh ${snapshot.pair.symbol}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Mid ${_formatPrice(snapshot.depth.midPrice)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pairOrderSectionGap),
            for (final level in snapshot.depth.asks.take(4).toList().reversed)
              _DepthRow(level: level, side: MarketOrderSide.sell),
            const Divider(
              color: AppColors.divider,
              height: AppSpacing.pairOrderDividerHeight,
            ),
            for (final level in snapshot.depth.bids.take(4))
              _DepthRow(level: level, side: MarketOrderSide.buy),
          ],
        ),
      ),
    );
  }
}

class _DepthRow extends StatelessWidget {
  const _DepthRow({required this.level, required this.side});

  final MarketDepthLevel level;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: AppSpacing.pairDepthRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(level.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontFamily: 'monospace',
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              level.quantity.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Expanded(
            child: Text(
              level.cumulative.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradesPanel extends StatelessWidget {
  const _TradesPanel({required this.trades});

  final List<MarketRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairOrderPanelPadding,
      child: VitCard(
        padding: AppSpacing.pairOrderCardPadding,
        child: Column(
          children: [
            const _TradeHeader(),
            for (final trade in trades) _TradeRow(trade: trade),
          ],
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairTradeHeaderPadding,
      child: Row(
        children: [
          Expanded(child: Text('Gia', style: _tableHeaderStyle())),
          Expanded(
            child: Text(
              'Khoi luong',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            child: Text(
              'Thoi gian',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  const _TradeRow({required this.trade});

  final MarketRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final color = trade.side == MarketOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    return Padding(
      padding: AppSpacing.pairTradeRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(trade.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontFamily: 'monospace',
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.amount.toStringAsFixed(4),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Expanded(
            child: Text(
              trade.time,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}
