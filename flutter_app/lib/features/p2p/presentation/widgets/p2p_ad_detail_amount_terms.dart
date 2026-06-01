part of '../pages/p2p_ad_detail_page.dart';

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontFamily: 'Roboto',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${ad.asset == 'USDT' ? 'VND' : 'VND'}/${ad.asset}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceMeta(
                  label: 'Khả dụng',
                  value:
                      '${_formatAmount(snapshot.availableAmount)} ${ad.asset}',
                ),
              ),
              Expanded(
                child: _PriceMeta(
                  label: 'Giới hạn',
                  value:
                      '${_formatVnd(ad.minLimit)} -\n${_formatVnd(ad.maxLimit)}',
                ),
              ),
              Expanded(
                child: _PriceMeta(label: 'Phản hồi', value: ad.avgResponseTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceMeta extends StatelessWidget {
  const _PriceMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.snapshot,
    required this.selectedPercent,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.onPercent,
  });

  final P2PAdDetailSnapshot snapshot;
  final int? selectedPercent;
  final int fiatAmount;
  final double cryptoAmount;
  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhập số lượng',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Số tiền (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _InputShell(
            value: fiatAmount == 0
                ? '${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}'
                : _formatVnd(fiatAmount),
            suffix: 'VND',
            muted: fiatAmount == 0,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Số lượng (${ad.asset})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _InputShell(
            value: cryptoAmount == 0 ? '0.00' : cryptoAmount.toStringAsFixed(6),
            suffix: ad.asset,
            muted: cryptoAmount == 0,
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final percent in const [25, 50, 75, 100]) ...[
                Expanded(
                  child: _PercentButton(
                    percent: percent,
                    selected: selectedPercent == percent,
                    onTap: () => onPercent(percent),
                  ),
                ),
                if (percent != 100) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  const _InputShell({
    required this.value,
    required this.suffix,
    required this.muted,
  });

  final String value;
  final String suffix;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.base.copyWith(
                color: muted ? AppColors.text3 : AppColors.text1,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Text(
            suffix,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentButton extends StatelessWidget {
  const _PercentButton({
    required this.percent,
    required this.selected,
    required this.onTap,
  });

  final int percent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: P2PAdDetailPage.percentKey(percent),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary12 : AppColors.transparent,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '$percent%',
          style: AppTextStyles.micro.copyWith(
            color: selected ? AppModuleAccents.p2p : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent08,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Yêu cầu đối tác',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                _RequirementPill(label: 'KYC cấp ${snapshot.minKycLevel}+'),
                _RequirementPill(
                  label: '${snapshot.minCompletedTrades}+ giao dịch',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementPill extends StatelessWidget {
  const _RequirementPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent12,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Điều kiện giao dịch',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EscrowCard extends StatelessWidget {
  const _EscrowCard({required this.snapshot, required this.amount});

  final P2PAdDetailSnapshot snapshot;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Tài sản được bảo vệ bởi hệ thống Escrow VitTrade. ${amount.toStringAsFixed(2)} ${snapshot.ad.asset} sẽ được khóa cho đến khi xác nhận thanh toán thành công.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(num value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

String _formatAmount(num value) {
  final parts = value.toStringAsFixed(2).split('.');
  return '${_formatCount(parts.first)}.${parts.last}';
}

String _formatCount(String raw) {
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatCompactUsd(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).round()}K';
  return value.toString();
}

String _fixed(double value) => value.toStringAsFixed(1);
