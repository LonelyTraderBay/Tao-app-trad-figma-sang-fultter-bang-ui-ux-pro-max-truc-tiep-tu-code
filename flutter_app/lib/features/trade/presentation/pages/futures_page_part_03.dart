part of 'futures_page.dart';

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _warningBackground,
        border: Border.all(color: _warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Giao dịch hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ. Chỉ giao dịch số tiền bạn có thể chấp nhận mất.',
              style: AppTextStyles.captionSm.copyWith(
                color: AppColors.primary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturesSafetyChecklist extends StatelessWidget {
  const _FuturesSafetyChecklist();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Leverage limit and margin are reviewed before confirmation.',
      'Liquidation price and fee preview are visible before opening risk.',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: _warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Futures order review',
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 9),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in snapshot.positions) ...[
          _PositionCard(position: position),
          const SizedBox(height: 12),
        ],
        _FuturesAccountCard(snapshot: snapshot),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final TradeFuturesPosition position;

  @override
  Widget build(BuildContext context) {
    final color = position.side == TradeFuturesSide.long
        ? _futuresGreen
        : _futuresRed;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatusPill(
                label: position.side == TradeFuturesSide.long
                    ? 'LONG'
                    : 'SHORT',
                color: color,
              ),
              const SizedBox(width: 8),
              Text(position.symbol, style: AppTextStyles.baseMedium),
              const SizedBox(width: 8),
              _StatusPill(label: '${position.leverage}x', color: _tradePrimary),
              const Spacer(),
              Text(
                '${position.pnl >= 0 ? '+' : '-'}\$${position.pnl.abs().toStringAsFixed(2)}',
                style: AppTextStyles.numericCode.copyWith(
                  color: position.pnl >= 0 ? _futuresGreen : _futuresRed,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _PositionMetric(
                label: 'Ký quỹ',
                value: _formatMoney(position.margin),
              ),
              _PositionMetric(
                label: 'Giá vào',
                value: _formatMoney(position.entryPrice),
              ),
              _PositionMetric(
                label: 'Thanh lý',
                value: _formatMoney(position.liquidPrice),
                color: _futuresRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.micro),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.numericMicro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturesAccountCard extends StatelessWidget {
  const _FuturesAccountCard({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tài khoản Futures', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          _AccountRow(
            label: 'Số dư',
            value: _formatMoney(snapshot.accountBalance),
          ),
          _AccountRow(
            label: 'Ký quỹ đang dùng',
            value: _formatMoney(snapshot.usedMargin),
          ),
          _AccountRow(
            label: 'Khả dụng',
            value: _formatMoney(snapshot.accountBalance - snapshot.usedMargin),
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.caption),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.numericCode.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.onTrade});

  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.text3,
            size: 38,
          ),
          const SizedBox(height: 12),
          Text('Chưa có lệnh Futures', style: AppTextStyles.baseMedium),
          const SizedBox(height: 6),
          Text(
            'Lệnh chờ sẽ hiển thị tại đây.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onTrade,
            child: const Text('Quay lại giao dịch'),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final left = whole.length - i;
    buffer.write(whole[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
