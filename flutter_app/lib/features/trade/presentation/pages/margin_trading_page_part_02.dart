part of 'margin_trading_page.dart';

class _PriceComparison extends StatelessWidget {
  const _PriceComparison({required this.prices});

  final TradeMarginReferencePrices prices;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _marginPrimary,
            title: 'Giá tham chiếu',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .06),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PriceColumn(
                    label: 'Mark Price',
                    value: _formatPriceWithDollar(prices.markPrice),
                    large: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .12),
                    border: Border.all(
                      color: _marginPrimary.withValues(alpha: .35),
                    ),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Dùng cho thanh lý',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 9,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Last Price',
                  value: _formatPriceWithDollar(prices.lastPrice),
                ),
              ),
              Text(
                'Giá khớp lệnh gần nhất',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Index Price',
                  value: _formatPriceWithDollar(prices.indexPrice),
                  dim: true,
                ),
              ),
              Text(
                'Avg của các sàn',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _InfoBanner(
            text:
                'Mark Price được dùng để tính PnL và thanh lý, giúp tránh manipulation từ flash crash.',
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.value,
    this.large = false,
    this.dim = false,
  });

  final String label;
  final String value;
  final bool large;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: dim ? AppColors.text2 : AppColors.onAccent,
            fontSize: large ? 20 : 16,
            fontWeight: large ? AppTextStyles.bold : AppTextStyles.medium,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.snapshot});

  final TradeMarginTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 104,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                snapshot.pair.symbol,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 17,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: snapshot.defaultMode.toUpperCase(),
                color: _marginPrimary,
              ),
              const Spacer(),
              Container(
                width: 14,
                height: 8,
                decoration: BoxDecoration(
                  color: _marginRed.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Text(
                '--',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 28,
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                snapshot.pair.quoteAsset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideToggle extends StatelessWidget {
  const _SideToggle({required this.side, required this.onChanged});

  final String side;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _SideButton(
            id: 'long',
            label: 'Long',
            icon: Icons.trending_up_rounded,
            color: _marginGreen,
            active: side == 'long',
            onTap: () => onChanged('long'),
          ),
          const SizedBox(width: 8),
          _SideButton(
            id: 'short',
            label: 'Short',
            icon: Icons.trending_down_rounded,
            color: AppColors.text3,
            active: side == 'short',
            onTap: () => onChanged('short'),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = active ? color : AppColors.text3;
    return Expanded(
      child: InkWell(
        key: MarginTradingPage.sideKey(id),
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: .13)
                : AppColors.transparent,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .35)
                  : AppColors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: resolvedColor, size: 17),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: resolvedColor,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSelector extends StatelessWidget {
  const _LeverageSelector({
    required this.leverage,
    required this.expanded,
    required this.onTap,
  });

  final int leverage;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: InkWell(
        key: MarginTradingPage.leverageKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _marginAmber.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: _marginAmber,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đòn bẩy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhân ${leverage}x giá trị vị thế',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              _MiniBadge(
                label: '${leverage}x',
                color: _marginAmber,
                large: true,
              ),
              const SizedBox(width: 10),
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
    );
  }
}

class _LeverageSheet extends StatelessWidget {
  const _LeverageSheet({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [2, 3, 5, 10, 20, 50];
    return _Panel(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in options)
            InkWell(
              onTap: () => onChanged(option),
              borderRadius: AppRadii.mdRadius,
              child: Container(
                width: 55,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == option ? _marginPrimary : _marginCard,
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  '${option}x',
                  style: AppTextStyles.caption.copyWith(
                    color: selected == option
                        ? AppColors.onAccent
                        : AppColors.text2,
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

class _PriceInput extends StatelessWidget {
  const _PriceInput({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return _InputCard(label: 'Giá đặt lệnh', suffix: 'USDT', value: price);
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.amount, required this.onMaxAmount});

  final String amount;
  final VoidCallback onMaxAmount;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 97,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số lượng (BTC)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              InkWell(
                key: MarginTradingPage.maxAmountKey,
                onTap: onMaxAmount,
                borderRadius: AppRadii.smRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .08),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    'Tối đa',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            amount,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontSize: 21,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
