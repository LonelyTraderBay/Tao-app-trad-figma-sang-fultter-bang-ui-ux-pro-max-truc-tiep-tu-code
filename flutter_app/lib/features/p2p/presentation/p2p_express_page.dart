import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PExpressPage extends ConsumerStatefulWidget {
  const P2PExpressPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc211_p2p_express_content');
  static const amountFieldKey = Key('sc211_p2p_express_amount');
  static const ctaKey = Key('sc211_p2p_express_cta');
  static const buyToggleKey = Key('sc211_p2p_express_buy');
  static const sellToggleKey = Key('sc211_p2p_express_sell');
  static const marketplaceKey = Key('sc211_p2p_express_marketplace');

  static Key quickAmountKey(int amount) =>
      Key('sc211_p2p_express_quick_$amount');

  static Key paymentKey(String id) => Key('sc211_p2p_express_payment_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PExpressPage> createState() => _P2PExpressPageState();
}

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
    final snapshot = ref.watch(p2pRepositoryProvider).getExpress();
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
      color: active ? color : Colors.transparent,
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
                color: active ? Colors.white : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: active ? Colors.white : AppColors.text3,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(
                color: amount > 0 && bestAd == null
                    ? AppColors.sell20
                    : amount > 0
                    ? color.withValues(alpha: .45)
                    : AppColors.borderSolid,
                width: 2,
              ),
              borderRadius: AppRadii.inputRadius,
            ),
            child: SizedBox(
              height: AppSpacing.buttonStandard,
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
                    child: TextField(
                      key: P2PExpressPage.amountFieldKey,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => onChanged(),
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nhập số tiền...',
                        hintStyle: AppTextStyles.base.copyWith(
                          color: AppColors.text3,
                        ),
                        isCollapsed: true,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: AppSpacing.x6,
                    height: AppSpacing.x6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: const Icon(
                      Icons.bolt_outlined,
                      color: Colors.white,
                      size: AppSpacing.iconSm,
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
            padding: const EdgeInsets.all(AppSpacing.x3),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
              Text(
                'Express hoạt động thế nào?',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                children: [
                  Container(
                    width: AppSpacing.x6,
                    height: AppSpacing.x6,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Icon(
                      _stepIcon(step.iconKey),
                      color: AppColors.primary,
                      size: AppSpacing.iconSm,
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
      padding: const EdgeInsets.all(AppSpacing.x3),
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

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x5,
      height: AppSpacing.x5,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withValues(alpha: .16)),
      child: Text(
        symbol.substring(0, 1),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.amount,
    required this.selected,
    required this.color,
    required this.onPressed,
  });

  final int amount;
  final bool selected;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      key: P2PExpressPage.quickAmountKey(amount),
      onPressed: onPressed,
      label: Text(_formatVnd(amount)),
      backgroundColor: selected
          ? color.withValues(alpha: .15)
          : AppColors.surface2,
      side: BorderSide(
        color: selected ? color.withValues(alpha: .45) : AppColors.borderSolid,
      ),
      labelStyle: AppTextStyles.micro.copyWith(
        color: selected ? color : AppColors.text2,
        fontWeight: AppTextStyles.bold,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    required this.method,
    required this.selected,
    required this.onPressed,
  });

  final P2PPaymentMethodDraft method;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      key: P2PExpressPage.paymentKey(method.id),
      onPressed: onPressed,
      avatar: selected
          ? const Icon(Icons.check_circle_outline, size: AppSpacing.iconSm)
          : null,
      label: Text(method.bankName),
      backgroundColor: selected ? AppColors.primary12 : AppColors.surface2,
      side: BorderSide(
        color: selected ? AppColors.primary40 : AppColors.borderSolid,
      ),
      labelStyle: AppTextStyles.micro.copyWith(
        color: selected ? AppColors.primary : AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _MerchantOfferRow extends StatelessWidget {
  const _MerchantOfferRow({required this.ad, required this.onMerchant});

  final P2PAdDraft ad;
  final VoidCallback onMerchant;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x3),
        child: Row(
          children: [
            Container(
              width: AppSpacing.x6,
              height: AppSpacing.x6,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                ad.merchant.substring(0, 1),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
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
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x1,
                    children: [
                      Text(
                        '${ad.completedOrders} đơn',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        '${ad.completionRate.toStringAsFixed(1)}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        ad.avgResponseTime,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onMerchant,
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferMetric extends StatelessWidget {
  const _OfferMetric({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SmallTextChip extends StatelessWidget {
  const _SmallTextChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

IconData _stepIcon(String key) {
  return switch (key) {
    'amount' => Icons.payments_outlined,
    'match' => Icons.bolt_outlined,
    'confirm' => Icons.check_circle_outline,
    _ => Icons.info_outline,
  };
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _formatAmount(double value) {
  if (value == 0) return '0.00';
  if (value == value.roundToDouble()) return value.toStringAsFixed(2);
  return value.toStringAsFixed(6);
}
