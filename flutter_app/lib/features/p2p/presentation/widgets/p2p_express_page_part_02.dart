part of '../pages/p2p_express_page.dart';

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.tradeType,
    required this.amount,
    required this.bestAd,
    required this.cryptoAmount,
    required this.quickAmounts,
    required this.onChanged,
    required this.onQuickAmount,
  });

  final TextEditingController controller;
  final P2PTradeType tradeType;
  final int amount;
  final P2PAdDraft? bestAd;
  final double cryptoAmount;
  final List<int> quickAmounts;
  final VoidCallback onChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      padding: AppSpacing.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số tiền (VND)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              if (amount > 0 && bestAd != null)
                Text(
                  '≈ ${_formatAmount(cryptoAmount)} ${bestAd!.asset}',
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Material(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(
                color: amount > 0 && bestAd == null
                    ? AppColors.sell20
                    : amount > 0
                    ? color.withValues(alpha: .45)
                    : AppColors.borderSolid,
                width: AppSpacing.p2pExpressAmountBorderWidth,
              ),
            ),
            child: SizedBox(
              height: _p2pExpressAmountHeight,
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.x4),
                  Text(
                    '₫',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: VitInput(
                      fieldKey: P2PExpressPage.amountFieldKey,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => onChanged(),
                      semanticLabel: 'P2P express amount VND',
                      hintText: 'Nhập số tiền...',
                      textStyle: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Text(
                    'VND',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x3,
            children: [
              for (final quickAmount in quickAmounts)
                _QuickAmountChip(
                  amount: quickAmount,
                  selected: amount == quickAmount,
                  color: color,
                  onPressed: () => onQuickAmount(quickAmount),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.selectedPayment,
    required this.paymentMethods,
    required this.onChanged,
  });

  final String selectedPayment;
  final List<P2PPaymentMethodDraft> paymentMethods;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thanh toán qua',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
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
              for (final method in paymentMethods)
                _PaymentChip(
                  method: method,
                  selected: selectedPayment == method.bankName,
                  onPressed: () => onChanged(method.bankName),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Phương thức đã xác minh của bạn',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
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

class _BestOfferCard extends StatelessWidget {
  const _BestOfferCard({
    required this.tradeType,
    required this.ad,
    required this.topOfferCount,
    required this.marketPrice,
    required this.cryptoAmount,
    required this.onMerchant,
    required this.onMarketplace,
  });

  final P2PTradeType tradeType;
  final P2PAdDraft ad;
  final int topOfferCount;
  final int marketPrice;
  final double cryptoAmount;
  final VoidCallback onMerchant;
  final VoidCallback onMarketplace;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    final priceDiff = ((ad.price - marketPrice) / marketPrice) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          borderColor: color.withValues(alpha: .35),
          padding: AppSpacing.p2pExpressCompactCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: _p2pExpressIconBox,
                    child: Material(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: const Icon(
                        Icons.bolt_outlined,
                        color: AppColors.onAccent,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Offer tốt nhất được tìm thấy',
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  VitStatusPill(
                    label: 'Auto-Match',
                    status: tradeType == P2PTradeType.buy
                        ? VitStatusPillStatus.success
                        : VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              _MerchantOfferRow(ad: ad, onMerchant: onMerchant),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _OfferMetric(
                      label: 'Giá/${ad.asset}',
                      value: _formatVnd(ad.price),
                      caption:
                          '${priceDiff >= 0 ? '+' : ''}${priceDiff.toStringAsFixed(2)}% vs thị trường',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _OfferMetric(
                      label: tradeType == P2PTradeType.buy
                          ? 'Bạn sẽ nhận'
                          : 'Bạn sẽ bán',
                      value: _formatAmount(cryptoAmount),
                      caption: ad.asset,
                      valueColor: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  _SmallTextChip('Chấp nhận:'),
                  for (final method in ad.paymentMethods)
                    _SmallTextChip(method),
                ],
              ),
            ],
          ),
        ),
        if (topOfferCount > 1) ...[
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            onTap: onMarketplace,
            padding: AppSpacing.p2pExpressTightCardPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.repeat_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '${topOfferCount - 1} offer khác khả dụng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
                Text(
                  'Xem marketplace',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x1),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EscrowCard extends StatelessWidget {
  const _EscrowCard({required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: const BorderSide(color: AppColors.buy20),
      ),
      child: Padding(
        padding: AppSpacing.p2pExpressEscrowPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    note,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.steps});

  final List<P2PExpressStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Express hoạt động thế nào?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final step in steps)
            Padding(
              padding: AppSpacing.p2pExpressHowStepPadding,
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: _p2pExpressIconBox,
                    child: Material(
                      color: AppColors.primary12,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Icon(
                        _stepIcon(step.iconKey),
                        color: AppColors.primary,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      step.title,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
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

class _NoOfferCard extends StatelessWidget {
  const _NoOfferCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: AppSpacing.p2pExpressTightCardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: AppColors.sell,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Không tìm thấy offer phù hợp. Thử thay đổi số tiền hoặc loại coin.',
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
        ],
      ),
    );
  }
}
