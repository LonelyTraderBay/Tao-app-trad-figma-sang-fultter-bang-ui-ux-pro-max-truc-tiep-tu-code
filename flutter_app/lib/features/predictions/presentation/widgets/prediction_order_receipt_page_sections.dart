part of '../pages/prediction_order_receipt_page.dart';

class _MissingReceipt extends StatelessWidget {
  const _MissingReceipt({required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.missingReceiptKey,
        padding: AppSpacing.predictionReceiptScrollPadding(bottomInset),
        child: const VitEmptyState(
          title: 'Không tìm thấy',
          message: 'Lệnh không tồn tại hoặc đã bị xoá',
          icon: Icons.warning_amber_rounded,
        ),
      ),
    );
  }
}

class _ReceiptContent extends StatelessWidget {
  const _ReceiptContent({required this.snapshot, required this.bottomInset});

  final PredictionOrderReceiptSnapshot snapshot;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final receipt = snapshot.receipt!;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.contentKey,
        padding: AppSpacing.predictionReceiptScrollPadding(bottomInset),
        child: VitPageContent(
          padding: VitContentPadding.relaxed,
          customGap: AppSpacing.predictionReceiptContentGap,
          children: [
            _ReceiptHero(receipt: receipt),
            if (snapshot.highRiskContractId != null)
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.success,
                title: 'Prediction receipt state tracked',
                message:
                    'Submitted status, receipt detail, portfolio history and support recovery stay bound to the shared prediction contract.',
                contractId: snapshot.highRiskContractId,
              ),
            _OrderSummary(receipt: receipt),
            _TimelineCard(receipt: receipt),
            _TimestampCard(receipt: receipt),
            _ShareReceiptButton(receipt: receipt),
            const _DisclosureCard(),
            _ReceiptActions(receipt: receipt),
          ],
        ),
      ),
    );
  }
}

class _ReceiptHero extends StatelessWidget {
  const _ReceiptHero({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final status = _statusConfig(receipt.status);

    return VitCard(
      padding: AppSpacing.predictionReceiptHeroPadding,
      child: Column(
        children: [
          Wrap(
            spacing: AppSpacing.predictionReceiptHeroPillGap,
            runSpacing: AppSpacing.predictionReceiptHeroPillGap,
            alignment: WrapAlignment.center,
            children: [
              _SoftPill(
                label: isBuy ? '↑ Buy' : '↓ Sell',
                color: isBuy ? AppColors.buy : AppColors.sell,
                background: isBuy ? AppColors.buy10 : AppColors.sell10,
              ),
              _SoftPill(
                label: status.label,
                color: status.color,
                background: status.background,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.predictionReceiptHeroOutcomeGap),
          Text(
            receipt.outcome,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.predictionReceiptHeroEventGap),
          Text(
            receipt.eventTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final fillPct = receipt.shares <= 0
        ? 0
        : ((receipt.filledShares / receipt.shares) * 100).round();

    return VitPageSection(
      label: 'Tổng quan lệnh',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: AppSpacing.predictionReceiptCardPadding,
          child: Column(
            children: [
              _SummaryRow(
                label: 'Loại lệnh',
                value: receipt.orderType == 'market' ? 'Market' : 'Limit',
              ),
              _SummaryRow(label: 'Outcome', value: receipt.outcome),
              _SummaryRow(
                label: 'Shares',
                value:
                    '${_formatShares(receipt.filledShares)}/${_formatShares(receipt.shares)}',
                mono: true,
              ),
              _SummaryRow(
                label: 'Giá đặt',
                value: _formatPrice(receipt.price),
                mono: true,
              ),
              if (receipt.avgPrice > 0)
                _SummaryRow(
                  label: 'Giá khớp TB',
                  value: _formatPrice(receipt.avgPrice),
                  mono: true,
                ),
              _SummaryRow(
                label: 'Tổng giá trị',
                value: _formatMoney(receipt.total),
                mono: true,
              ),
              _SummaryRow(
                label: 'Phí (2%)',
                value: _formatMoney(receipt.fee),
                mono: true,
              ),
              if (receipt.status != 'canceled' && receipt.status != 'rejected')
                _FillProgress(percent: fillPct),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final timeline = receipt.timeline.isEmpty
        ? [
            PredictionReceiptTimelineDraft(
              label: 'Lệnh đã gửi',
              date: receipt.createdAt,
              done: true,
            ),
          ]
        : receipt.timeline;

    return VitPageSection(
      label: 'Tiến trình',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          padding: AppSpacing.predictionReceiptCardPadding,
          child: Column(
            children: [
              for (var i = 0; i < timeline.length; i++)
                _TimelineStep(
                  step: timeline[i],
                  isLast: i == timeline.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimestampCard extends StatelessWidget {
  const _TimestampCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.predictionReceiptCardPadding,
      child: Column(
        children: [
          _SummaryRow(label: 'Tạo lúc', value: receipt.createdAt),
          _SummaryRow(label: 'Cập nhật', value: receipt.updatedAt),
          _SummaryRow(
            label: 'Mã lệnh',
            value: receipt.id.toUpperCase(),
            valueColor: AppColors.accent,
            mono: true,
            trailingIcon: Icons.copy_rounded,
          ),
        ],
      ),
    );
  }
}

class _ShareReceiptButton extends StatelessWidget {
  const _ShareReceiptButton({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Chia sẻ chi tiết lệnh ${receipt.id}',
      child: Material(
        color: AppColors.primary12,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: const BorderSide(
            color: AppColors.primary15,
            width: AppSpacing.predictionReceiptShareBorderWidth,
          ),
        ),
        child: InkWell(
          key: PredictionOrderReceiptPage.shareKey,
          onTap: () {},
          borderRadius: AppRadii.inputRadius,
          child: SizedBox(
            height: AppSpacing.inputHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.ios_share_rounded,
                  color: _predictionPrimary,
                  size: AppSpacing.predictionReceiptShareIcon,
                ),
                const SizedBox(width: AppSpacing.predictionReceiptShareIconGap),
                Flexible(
                  child: Text(
                    'Chia sẻ chi tiết lệnh',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: _predictionPrimary,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.predictionReceiptDisclosurePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: AppSpacing.predictionReceiptDisclosureIcon,
          ),
          const SizedBox(width: AppSpacing.predictionReceiptDisclosureGap),
          Expanded(
            child: Text(
              'Probability không phải certainty. Giá thị trường dự đoán phản ánh ước lượng cộng đồng và có thể thay đổi bất cứ lúc nào. Đây không phải lời khuyên đầu tư.',
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptActions extends StatelessWidget {
  const _ReceiptActions({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewEventKey,
          onPressed: () =>
              context.go(AppRoutePaths.marketsPredictionEvent(receipt.eventId)),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xem sự kiện'),
        ),
        const SizedBox(height: AppSpacing.predictionReceiptActionGap),
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewPortfolioKey,
          onPressed: () => context.go(AppRoutePaths.profilePredictions),
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Xem danh mục'),
        ),
      ],
    );
  }
}
