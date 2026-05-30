part of 'margin_trading_page.dart';

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.label,
    required this.suffix,
    required this.value,
  });

  final String label;
  final String suffix;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 90,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                suffix,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.available,
    required this.liquidationPrice,
  });

  final double available;
  final String liquidationPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _SummaryRow(
            'Margin khả dụng',
            _formatMoney(available),
            AppColors.onAccent,
          ),
          const SizedBox(height: 9),
          _SummaryRow('Giá thanh lý (ước tính)', liquidationPrice, _marginRed),
          const SizedBox(height: 9),
          const _SummaryRow('Phí giao dịch (0.05%)', '--', AppColors.text2),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MarginOrderReviewCard extends StatelessWidget {
  const _MarginOrderReviewCard({required this.leverage});

  final int leverage;

  @override
  Widget build(BuildContext context) {
    final checks = [
      'Risk and leverage limit are reviewed at ${leverage}x before submission.',
      'Liquidation estimate, margin availability, and fee preview remain visible.',
    ];
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .28),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Margin order review',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          for (final check in checks) ...[
            _Bullet(text: check, color: _marginAmber),
            if (check != checks.last) const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.side,
    required this.leverage,
    required this.pairSymbol,
    required this.disabled,
  });

  final String side;
  final int leverage;
  final String pairSymbol;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: MarginTradingPage.submitKey,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled
            ? _marginPrimary.withValues(alpha: .06)
            : (side == 'long' ? _marginGreen : _marginRed),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        'Mở ${side == 'long' ? 'Long' : 'Short'} $pairSymbol (${leverage}x)',
        style: AppTextStyles.body.copyWith(
          color: disabled
              ? AppColors.text3.withValues(alpha: .45)
              : AppColors.onAccent,
          fontSize: 15,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.warning});

  final TradeMarginRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .35),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _marginAmber,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.onAccent,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in warning.items) ...[
                  _Bullet(text: item, color: _marginAmber),
                  if (item != warning.items.last) const SizedBox(height: 9),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NegativeBalanceCard extends StatelessWidget {
  const _NegativeBalanceCard({required this.disclosure});

  final TradeMarginSafetyDisclosure disclosure;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginGreen.withValues(alpha: .07),
      borderColor: _marginGreen.withValues(alpha: .18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginGreen.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _marginGreen,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: _marginGreen,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  disclosure.footer,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BestExecutionCard extends StatelessWidget {
  const _BestExecutionCard({required this.disclosure, required this.onTap});

  final TradeMarginBestExecutionDisclosure disclosure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _marginPrimary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in disclosure.items) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _marginPrimary,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item != disclosure.items.last) const SizedBox(height: 5),
                ],
                const SizedBox(height: 12),
                InkWell(
                  onTap: onTap,
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _marginPrimary.withValues(alpha: .12),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      disclosure.actionLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: _marginPrimary,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeMarginPosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return _Panel(
        padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 16),
        child: Column(
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.text3,
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              'Chưa có vị thế',
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final TradeMarginPosition position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? _marginGreen : _marginRed;
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                position.pair,
                style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: '${position.side.toUpperCase()} ${position.leverage}x',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ValueText('PnL', _signedMoney(position.pnl), color),
              ),
              Expanded(
                child: _ValueText(
                  'Liq. Price',
                  _formatPrice(position.liquidationPrice),
                  _marginRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 16),
      child: Column(
        children: [
          const Icon(Icons.adjust_rounded, color: AppColors.text3, size: 34),
          const SizedBox(height: 12),
          Text(
            'Không có lệnh chờ',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Các lệnh limit đang chờ khớp sẽ hiển thị tại đây',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onAccent,
            fontSize: 15,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
