part of '../pages/prediction_event_detail_page.dart';

class _OrderBookSection extends StatelessWidget {
  const _OrderBookSection({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final PredictionEventDetailSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final chance = snapshot.event.outcomes.first.chance / 100;
    final bestBid = snapshot.orderBook.bids.first.price;
    final bestAsk = snapshot.orderBook.asks.first.price;
    return Column(
      children: [
        InkWell(
          key: PredictionEventDetailPage.orderBookToggleKey,
          onTap: onToggle,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.layers_rounded,
                  color: _predictionPrimary,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Order Book',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Spread ${_formatPrice(bestAsk - bestBid)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          const Padding(padding: EdgeInsets.only(top: 8)),
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _OrderBookHeader(),
                const Padding(padding: EdgeInsets.only(top: 6)),
                for (final ask in snapshot.orderBook.asks.reversed)
                  _OrderBookRow(entry: ask, isBid: false),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    '${_formatPrice(chance)} · mid price',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (final bid in snapshot.orderBook.bids)
                  _OrderBookRow(entry: bid, isBid: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _OrderBookLabel('PRICE')),
        SizedBox(width: 72, child: _OrderBookLabel('SHARES', alignEnd: true)),
        SizedBox(width: 72, child: _OrderBookLabel('TOTAL', alignEnd: true)),
      ],
    );
  }
}

class _OrderBookLabel extends StatelessWidget {
  const _OrderBookLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({required this.entry, required this.isBid});

  final PredictionOrderBookEntryDraft entry;
  final bool isBid;

  @override
  Widget build(BuildContext context) {
    final color = isBid ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(entry.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt(entry.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt((entry.price * entry.shares).round()),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
