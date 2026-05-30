part of 'p2p_express_page.dart';

class _P2PExpressPageState extends ConsumerState<P2PExpressPage> {
  final TextEditingController _amountController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String _asset = 'USDT';
  String _paymentMethod = '';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _fiatAmount {
    return int.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pExpressProvider);
    final selectedAsset = snapshot.assetBySymbol(_asset);
    final bestAd = snapshot.bestAd(
      tradeType: _tradeType,
      asset: selectedAsset.symbol,
      fiatAmount: _fiatAmount,
      paymentMethod: _paymentMethod,
    );
    final topAds = snapshot.topAds(
      tradeType: _tradeType,
      asset: selectedAsset.symbol,
      fiatAmount: _fiatAmount,
    );
    final cryptoAmount = bestAd == null || _fiatAmount <= 0
        ? 0.0
        : _fiatAmount / bestAd.price;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-211 P2PExpressPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Express Trade',
              subtitle: 'Mua bán nhanh',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
              trailing: _MarketplaceButton(
                onPressed: () => context.go(AppRoutePaths.p2p),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PExpressPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TradeToggle(
                        tradeType: _tradeType,
                        onChanged: _setTradeType,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _AssetCard(
                        tradeType: _tradeType,
                        selectedAsset: selectedAsset,
                        assets: snapshot.assets,
                        onAssetChanged: _setAsset,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _AmountCard(
                        controller: _amountController,
                        tradeType: _tradeType,
                        amount: _fiatAmount,
                        bestAd: bestAd,
                        cryptoAmount: cryptoAmount,
                        quickAmounts: snapshot.quickAmountsVnd,
                        onChanged: () => setState(() {}),
                        onQuickAmount: _setAmount,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _PaymentCard(
                        selectedPayment: _paymentMethod,
                        paymentMethods: snapshot.paymentMethods,
                        onChanged: _setPayment,
                      ),
                      if (_fiatAmount > 0 && bestAd != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _BestOfferCard(
                          tradeType: _tradeType,
                          ad: bestAd,
                          topOfferCount: topAds.length,
                          marketPrice: selectedAsset.marketPriceVnd,
                          cryptoAmount: cryptoAmount,
                          onMerchant: () =>
                              context.go('/p2p/merchant/${bestAd.merchantId}'),
                          onMarketplace: () => context.go(AppRoutePaths.p2p),
                        ),
                      ],
                      if (_fiatAmount > 0 && bestAd == null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        const _NoOfferCard(),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowCard(
                        title: snapshot.escrowTitle,
                        note: _tradeType == P2PTradeType.buy
                            ? snapshot.escrowBuyNote
                            : snapshot.escrowSellNote,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _HowItWorksCard(steps: snapshot.steps),
                      const SizedBox(height: AppSpacing.x5),
                      VitCtaButton(
                        key: P2PExpressPage.ctaKey,
                        onPressed: bestAd == null
                            ? null
                            : () => _openConfirm(
                                context,
                                selectedAsset.symbol,
                                bestAd,
                                cryptoAmount,
                              ),
                        variant: _tradeType == P2PTradeType.buy
                            ? VitCtaButtonVariant.success
                            : VitCtaButtonVariant.danger,
                        leading: const Icon(Icons.bolt_outlined),
                        child: Text(
                          '${_tradeType == P2PTradeType.buy ? 'Mua nhanh' : 'Bán nhanh'} ${selectedAsset.symbol}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTradeType(P2PTradeType value) {
    HapticFeedback.selectionClick();
    setState(() {
      _tradeType = value;
      _paymentMethod = '';
    });
  }

  void _setAsset(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      _asset = value;
      _paymentMethod = '';
    });
  }

  void _setPayment(String value) {
    HapticFeedback.selectionClick();
    setState(() => _paymentMethod = _paymentMethod == value ? '' : value);
  }

  void _setAmount(int amount) {
    HapticFeedback.selectionClick();
    _amountController.text = amount.toString();
    setState(() {});
  }

  void _openConfirm(
    BuildContext context,
    String asset,
    P2PAdDraft ad,
    double cryptoAmount,
  ) {
    HapticFeedback.mediumImpact();
    final params = Uri(
      queryParameters: {
        'type': _tradeType.name,
        'asset': asset,
        'fiat': _fiatAmount.toString(),
        'crypto': cryptoAmount.toString(),
        'adId': ad.id,
        'payment': _paymentMethod.isEmpty
            ? ad.paymentMethods.first
            : _paymentMethod,
      },
    ).query;
    context.go('${AppRoutePaths.p2pExpressConfirm}?$params');
  }
}

class _MarketplaceButton extends StatelessWidget {
  const _MarketplaceButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: P2PExpressPage.marketplaceKey,
      onTap: onPressed,
      borderRadius: AppRadii.inputRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Marketplace',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeToggle extends StatelessWidget {
  const _TradeToggle({required this.tradeType, required this.onChanged});

  final P2PTradeType tradeType;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: _TradeToggleButton(
              key: P2PExpressPage.buyToggleKey,
              label: 'MUA NHANH',
              active: tradeType == P2PTradeType.buy,
              color: AppColors.buy,
              onPressed: () => onChanged(P2PTradeType.buy),
            ),
          ),
          Expanded(
            child: _TradeToggleButton(
              key: P2PExpressPage.sellToggleKey,
              label: 'BÁN NHANH',
              active: tradeType == P2PTradeType.sell,
              color: AppColors.sell,
              onPressed: () => onChanged(P2PTradeType.sell),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeToggleButton extends StatelessWidget {
  const _TradeToggleButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? color : AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.ctaHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt_outlined,
                color: active ? AppColors.onAccent : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({
    required this.tradeType,
    required this.selectedAsset,
    required this.assets,
    required this.onAssetChanged,
  });

  final P2PTradeType tradeType;
  final P2PAssetDraft selectedAsset;
  final List<P2PAssetDraft> assets;
  final ValueChanged<String> onAssetChanged;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tradeType == P2PTradeType.buy
                      ? 'Tôi muốn mua'
                      : 'Tôi muốn bán',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Chọn tài sản',
                color: AppColors.surface2,
                onSelected: onAssetChanged,
                itemBuilder: (context) => [
                  for (final asset in assets)
                    PopupMenuItem<String>(
                      value: asset.symbol,
                      child: Text('${asset.symbol} - ${asset.name}'),
                    ),
                ],
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    border: Border.all(color: AppColors.borderSolid),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x3,
                      vertical: AppSpacing.x2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _AssetMark(symbol: selectedAsset.symbol, color: color),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          selectedAsset.symbol,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        const Icon(
                          Icons.expand_more,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Giá thị trường:',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    _formatVnd(selectedAsset.marketPriceVnd),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      'VND/${selectedAsset.symbol}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
