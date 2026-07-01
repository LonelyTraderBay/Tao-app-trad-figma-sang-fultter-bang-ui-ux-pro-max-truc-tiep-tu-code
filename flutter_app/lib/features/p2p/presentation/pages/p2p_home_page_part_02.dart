part of 'p2p_home_page.dart';

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.merchantFilter,
    required this.paymentFilter,
    required this.paymentMethods,
    required this.onMerchant,
    required this.onPayment,
    required this.onClear,
  });

  final String merchantFilter;
  final String paymentFilter;
  final List<String> paymentMethods;
  final ValueChanged<String> onMerchant;
  final ValueChanged<String> onPayment;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PHomePage.filterKey,
      radius: VitCardRadius.standard,
      padding: AppSpacing.p2pHomeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại merchant',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _ChipButton(
                label: 'Tất cả',
                active: merchantFilter == 'all',
                onTap: () => onMerchant('all'),
              ),
              _ChipButton(
                label: 'Elite',
                active: merchantFilter == 'elite',
                onTap: () => onMerchant('elite'),
              ),
              _ChipButton(
                label: 'Pro',
                active: merchantFilter == 'pro',
                onTap: () => onMerchant('pro'),
              ),
              _ChipButton(
                label: 'Xác minh',
                active: merchantFilter == 'verified',
                onTap: () => onMerchant('verified'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Thanh toán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _ChipButton(
                label: 'Tất cả',
                active: paymentFilter.isEmpty,
                onTap: () => onPayment(''),
              ),
              for (final method in paymentMethods)
                _ChipButton(
                  label: method,
                  active: paymentFilter == method,
                  onTap: () => onPayment(method),
                ),
            ],
          ),
          if (merchantFilter != 'all' || paymentFilter.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              onPressed: onClear,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: AppSpacing.p2pHomeClearFilterPadding,
              leading: const Icon(Icons.close_rounded),
              child: const Text('Xóa bộ lọc'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count offer',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const _EscrowPill(label: 'Escrow'),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.ad,
    required this.tradeType,
    required this.onOpen,
    required this.onMerchant,
    required this.onReport,
  });

  final P2PAdDraft ad;
  final P2PTradeType tradeType;
  final VoidCallback onOpen;
  final VoidCallback onMerchant;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final actionColor = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    final badge = ad.merchantBadge;
    return VitCard(
      key: P2PHomePage.adKey(ad.id),
      radius: VitCardRadius.large,
      onTap: onOpen,
      padding: AppSpacing.p2pHomeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _MerchantAvatar(ad: ad),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ad.merchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (ad.merchantVerified) ...[
                          const SizedBox(width: AppSpacing.x1),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppModuleAccents.p2p,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                        if (badge != null) ...[
                          const SizedBox(width: AppSpacing.x2),
                          _Badge(label: badge == 'elite' ? 'Elite' : 'Pro'),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${ad.completedOrders} đơn · '
                      '${ad.completionRate.toStringAsFixed(1)}% · '
                      '${ad.merchantRating?.toStringAsFixed(1) ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                key: P2PHomePage.adMenuKey(ad.id),
                tooltip: 'Tùy chọn offer',
                color: AppColors.surface2,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.text2,
                ),
                onSelected: (value) {
                  if (value == 'merchant') onMerchant();
                  if (value == 'report') onReport();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'merchant', child: Text('Xem merchant')),
                  PopupMenuItem(value: 'report', child: Text('Báo cáo offer')),
                ],
              ),
              const SizedBox(width: AppSpacing.x2),
              _ActionButton(
                label: tradeType == P2PTradeType.buy ? 'Mua' : 'Bán',
                color: actionColor,
                onTap: onOpen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.x1),
                child: Text(
                  ad.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.x1),
                child: Text(
                  _priceDelta(ad),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (ad.priceType == 'floating') ...[
                const SizedBox(width: AppSpacing.x2),
                const _Badge(label: 'Thả nổi', color: AppColors.accent),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giới hạn ${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${_formatAmount(ad.available)} ${ad.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final method in ad.paymentMethods.take(3))
                      _PaymentPill(label: method),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                ad.avgResponseTime,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (ad.isNewMerchant) ...[
            const SizedBox(height: AppSpacing.x2),
            const VitBanner(
              variant: VitBannerVariant.warning,
              icon: Icons.warning_amber_rounded,
              message: 'Merchant mới - kiểm tra kỹ trước khi giao dịch',
            ),
          ],
        ],
      ),
    );
  }

  String _priceDelta(P2PAdDraft ad) {
    final margin = ((ad.price - 25300) / 25300) * 100;
    return '${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(2)}%';
  }
}

class _EmptyOffers extends StatelessWidget {
  const _EmptyOffers({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: P2PHomePage.emptyKey,
      icon: Icons.search_off_rounded,
      title: snapshot.emptyTitle,
      message: snapshot.emptySubtitle,
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      accentColor: AppModuleAccents.p2p,
      semanticLabel: 'P2P filter $label',
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: color == AppColors.buy
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      child: Text(label),
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.ad});

  final P2PAdDraft ad;

  @override
  Widget build(BuildContext context) {
    final color = ad.merchantBadge == 'elite'
        ? AppColors.warn
        : ad.merchantBadge == 'pro'
        ? AppColors.accent
        : AppModuleAccents.p2p;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        VitAssetAvatar(
          label: ad.merchant,
          accentColor: color,
          size: AppSpacing.buttonCompact,
          radius: AppRadii.pillRadius,
          border: true,
        ),
        Positioned(
          right: -AppSpacing.x1,
          bottom: -AppSpacing.x1,
          child: SizedBox(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            child: Material(
              color: ad.isOnline ? AppColors.buy : AppColors.text3,
              shape: CircleBorder(
                side: BorderSide(
                  color: AppColors.surface,
                  width: AppSpacing.dividerHairline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
