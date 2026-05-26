import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PCreateAdPage extends ConsumerStatefulWidget {
  const P2PCreateAdPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc226_p2p_create_content');
  static const priceFieldKey = Key('sc226_price_field');
  static const marginFieldKey = Key('sc226_margin_field');
  static const totalFieldKey = Key('sc226_total_field');
  static const minFieldKey = Key('sc226_min_field');
  static const maxFieldKey = Key('sc226_max_field');
  static const publishButtonKey = Key('sc226_publish');
  static const confirmPublishKey = Key('sc226_confirm_publish');

  static Key adTypeKey(P2PTradeType type) => Key('sc226_type_${type.name}');
  static Key assetKey(String asset) => Key('sc226_asset_$asset');
  static Key currencyKey(String currency) => Key('sc226_currency_$currency');
  static Key priceTypeKey(String type) => Key('sc226_price_type_$type');
  static Key paymentKey(String payment) => Key('sc226_payment_$payment');
  static Key paymentWindowKey(int minutes) => Key('sc226_window_$minutes');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PCreateAdPage> createState() => _P2PCreateAdPageState();
}

class _P2PCreateAdPageState extends ConsumerState<P2PCreateAdPage> {
  final _priceController = TextEditingController();
  final _marginController = TextEditingController();
  final _totalController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _minTradesController = TextEditingController();
  final _minDaysController = TextEditingController();
  final _termsController = TextEditingController();
  final _autoReplyController = TextEditingController();

  P2PTradeType _adType = P2PTradeType.sell;
  String _asset = 'USDT';
  String _currency = 'VND';
  String _priceType = 'fixed';
  int _paymentWindow = 15;
  String _tradingHours = '24/7';
  bool _requireKyc = false;
  String _requiredKycLevel = '1';
  bool _submitting = false;
  bool _previewExpanded = false;
  final Set<String> _selectedPayments = {};

  @override
  void dispose() {
    _priceController.dispose();
    _marginController.dispose();
    _totalController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _minTradesController.dispose();
    _minDaysController.dispose();
    _termsController.dispose();
    _autoReplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getCreateAd();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final footerInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;
    final marketPrice = snapshot.marketPrices[_asset] ?? 25300;
    final effectivePrice = _effectivePrice(marketPrice);
    final priceDiff = effectivePrice <= 0
        ? 0.0
        : ((effectivePrice - marketPrice) / marketPrice) * 100;
    final isValid =
        effectivePrice > 0 &&
        _parseNum(_totalController.text) > 0 &&
        _selectedPayments.isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-226 P2PCreateAdPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Đăng quảng cáo P2P',
              subtitle: 'Tạo mới · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pMyAds),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PCreateAdPage.contentKey,
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
                      _SectionLabel('Loại quảng cáo'),
                      _TradeTypePicker(
                        value: _adType,
                        onChanged: (type) => setState(() => _adType = type),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _ChipGroup(
                              label: 'Tài sản',
                              values: snapshot.assets,
                              selected: _asset,
                              keyBuilder: P2PCreateAdPage.assetKey,
                              onSelected: (value) {
                                HapticFeedback.selectionClick();
                                setState(() => _asset = value);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x4),
                          Expanded(
                            child: _ChipGroup(
                              label: 'Tiền tệ',
                              values: snapshot.currencies,
                              selected: _currency,
                              keyBuilder: P2PCreateAdPage.currencyKey,
                              onSelected: (value) {
                                HapticFeedback.selectionClick();
                                setState(() => _currency = value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel('Loại giá'),
                      _PriceTypePicker(
                        value: _priceType,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _priceType = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      if (_priceType == 'fixed')
                        _InputBlock(
                          label: 'Giá ($_currency/$_asset) *',
                          hint:
                              'Giá thị trường: ${_formatVnd(marketPrice)} $_currency',
                          child: VitInput(
                            controller: _priceController,
                            fieldKey: P2PCreateAdPage.priceFieldKey,
                            hintText: _formatVnd(marketPrice),
                            keyboardType: TextInputType.number,
                            suffix: Text(
                              _currency,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        )
                      else
                        _FloatingPriceBlock(
                          controller: _marginController,
                          marketPrice: marketPrice,
                          effectivePrice: effectivePrice,
                          currency: _currency,
                          onChanged: () => setState(() {}),
                        ),
                      if (effectivePrice > 0) ...[
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          '${priceDiff >= 0 ? 'Tăng' : 'Giảm'} ${priceDiff.abs().toStringAsFixed(2)}% so với thị trường',
                          style: AppTextStyles.micro.copyWith(
                            color: priceDiff >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x5),
                      _InputBlock(
                        label: 'Tổng $_asset giao dịch *',
                        child: VitInput(
                          controller: _totalController,
                          fieldKey: P2PCreateAdPage.totalFieldKey,
                          hintText: '0.00',
                          keyboardType: TextInputType.number,
                          suffix: Text(
                            _asset,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      Row(
                        children: [
                          Expanded(
                            child: _InputBlock(
                              label: 'Tối thiểu ($_currency) *',
                              child: VitInput(
                                controller: _minController,
                                fieldKey: P2PCreateAdPage.minFieldKey,
                                hintText: '500,000',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Expanded(
                            child: _InputBlock(
                              label: 'Tối đa ($_currency) *',
                              child: VitInput(
                                controller: _maxController,
                                fieldKey: P2PCreateAdPage.maxFieldKey,
                                hintText: '50,000,000',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _PaymentsBlock(
                        options: snapshot.paymentOptions,
                        selected: _selectedPayments,
                        onToggle: _togglePayment,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _PaymentWindowBlock(
                        values: snapshot.paymentWindows,
                        selected: _paymentWindow,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _paymentWindow = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _ChipGroup(
                        label: 'Giờ giao dịch',
                        values: snapshot.tradingHours,
                        selected: _tradingHours,
                        keyBuilder: (value) => Key('sc226_hours_$value'),
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _tradingHours = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _RequirementCard(
                        requireKyc: _requireKyc,
                        requiredKycLevel: _requiredKycLevel,
                        minTradesController: _minTradesController,
                        minDaysController: _minDaysController,
                        onKycChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _requireKyc = value);
                        },
                        onLevelChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _requiredKycLevel = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _MultilineBlock(
                        label: 'Điều kiện giao dịch (tuỳ chọn)',
                        controller: _termsController,
                        hintText:
                            'VD: Chỉ giao dịch với tài khoản đã xác minh KYC...',
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _MultilineBlock(
                        label: 'Tin nhắn tự động (tuỳ chọn)',
                        controller: _autoReplyController,
                        hintText:
                            'VD: Cảm ơn bạn! Vui lòng chuyển khoản theo thông tin bên dưới.',
                        hint: 'Gửi tự động khi đối tác tạo đơn.',
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _WarningCard(text: snapshot.warningNote),
                      const SizedBox(height: AppSpacing.x5),
                      _LivePreviewCard(
                        expanded: _previewExpanded,
                        isValid: isValid,
                        onTap: () => setState(
                          () => _previewExpanded = !_previewExpanded,
                        ),
                        adType: _adType,
                        asset: _asset,
                        currency: _currency,
                        price: effectivePrice,
                        totalAmount: _totalController.text,
                        payments: _selectedPayments,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VitStickyFooter(
              backgroundColor: AppColors.surface.withValues(alpha: .96),
              child: Padding(
                padding: EdgeInsets.only(bottom: footerInset),
                child: VitCtaButton(
                  key: P2PCreateAdPage.publishButtonKey,
                  onPressed: isValid && !_submitting
                      ? () => _confirmPublish(context, effectivePrice)
                      : null,
                  variant: _adType == P2PTradeType.buy
                      ? VitCtaButtonVariant.success
                      : VitCtaButtonVariant.danger,
                  loading: _submitting,
                  child: Text(
                    _submitting
                        ? 'Đang đăng...'
                        : 'Đăng quảng cáo ${_adType == P2PTradeType.buy ? 'MUA' : 'BÁN'} $_asset',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _effectivePrice(int marketPrice) {
    if (_priceType == 'fixed') return _parseNum(_priceController.text).round();
    final margin = _parseNum(_marginController.text);
    return (marketPrice * (1 + margin / 100)).round();
  }

  void _togglePayment(String payment) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedPayments.contains(payment)) {
        _selectedPayments.remove(payment);
      } else if (_selectedPayments.length < 5) {
        _selectedPayments.add(payment);
      }
    });
  }

  Future<void> _confirmPublish(BuildContext context, int effectivePrice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Xác nhận đăng quảng cáo',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ConfirmRow(
                label: 'Loại',
                value: _adType == P2PTradeType.buy ? 'MUA' : 'BÁN',
              ),
              _ConfirmRow(
                label: 'Tài sản',
                value: '${_totalController.text} $_asset',
              ),
              _ConfirmRow(
                label: 'Giá',
                value: '${_formatVnd(effectivePrice)} $_currency/$_asset',
              ),
              _ConfirmRow(
                label: 'Thanh toán',
                value: _selectedPayments.join(', '),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                'Tôi xác nhận thông tin chính xác và đồng ý với điều khoản đăng quảng cáo P2P.',
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Hủy',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            TextButton(
              key: P2PCreateAdPage.confirmPublishKey,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Đăng',
                style: AppTextStyles.caption.copyWith(
                  color: _adType == P2PTradeType.buy
                      ? AppColors.buy
                      : AppColors.sell,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pMyAds);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _TradeTypePicker extends StatelessWidget {
  const _TradeTypePicker({required this.value, required this.onChanged});

  final P2PTradeType value;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x1),
        child: Row(
          children: [
            Expanded(
              child: _SegmentButton(
                key: P2PCreateAdPage.adTypeKey(P2PTradeType.buy),
                label: 'Tôi muốn MUA',
                selected: value == P2PTradeType.buy,
                color: AppColors.buy,
                onTap: () => onChanged(P2PTradeType.buy),
              ),
            ),
            Expanded(
              child: _SegmentButton(
                key: P2PCreateAdPage.adTypeKey(P2PTradeType.sell),
                label: 'Tôi muốn BÁN',
                selected: value == P2PTradeType.sell,
                color: AppColors.sell,
                onTap: () => onChanged(P2PTradeType.sell),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceTypePicker extends StatelessWidget {
  const _PriceTypePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x1),
        child: Row(
          children: [
            Expanded(
              child: _SegmentButton(
                key: P2PCreateAdPage.priceTypeKey('fixed'),
                label: 'Cố định',
                selected: value == 'fixed',
                color: AppColors.primary,
                onTap: () => onChanged('fixed'),
              ),
            ),
            Expanded(
              child: _SegmentButton(
                key: P2PCreateAdPage.priceTypeKey('floating'),
                label: 'Thả nổi %',
                selected: value == 'floating',
                color: AppColors.accent,
                onTap: () => onChanged('floating'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: AppSpacing.inputHeight - AppSpacing.x2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.values,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  final String label;
  final List<String> values;
  final String selected;
  final Key Function(String value) keyBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final value in values)
              _ChoiceChipButton(
                key: keyBuilder(value),
                label: value,
                selected: selected == value,
                onTap: () => onSelected(value),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primarySoft : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputBlock extends StatelessWidget {
  const _InputBlock({required this.label, required this.child, this.hint});

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label),
        child,
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            hint!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _FloatingPriceBlock extends StatelessWidget {
  const _FloatingPriceBlock({
    required this.controller,
    required this.marketPrice,
    required this.effectivePrice,
    required this.currency,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int marketPrice;
  final int effectivePrice;
  final String currency;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _InputBlock(
      label: 'Biên độ giá (%) *',
      hint:
          'Giá = Thị trường x (1 + biên độ%). Giá hiện tại: ${_formatVnd(effectivePrice)} $currency',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInput(
            controller: controller,
            fieldKey: P2PCreateAdPage.marginFieldKey,
            hintText: '0.00',
            keyboardType: TextInputType.number,
            prefix: Text('±', style: AppTextStyles.caption),
            suffix: Text('%', style: AppTextStyles.caption),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            children: [
              for (final value in const [-1, -0.5, 0, .5, 1, 2])
                _ChoiceChipButton(
                  label: '${value >= 0 ? '+' : ''}$value%',
                  selected: controller.text == value.toString(),
                  onTap: () {
                    controller.text = value.toString();
                    onChanged();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentsBlock extends StatelessWidget {
  const _PaymentsBlock({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return _InputBlock(
      label: 'Phương thức thanh toán *',
      hint: 'Đã chọn ${selected.length}/5',
      child: Wrap(
        spacing: AppSpacing.x2,
        runSpacing: AppSpacing.x2,
        children: [
          for (final payment in options)
            _PaymentChip(
              key: P2PCreateAdPage.paymentKey(payment),
              label: payment,
              selected: selected.contains(payment),
              onTap: () => onToggle(payment),
            ),
        ],
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primarySoft : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentWindowBlock extends StatelessWidget {
  const _PaymentWindowBlock({
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return _InputBlock(
      label: 'Thời gian thanh toán',
      child: Row(
        children: [
          for (final value in values) ...[
            Expanded(
              child: _ChoiceChipButton(
                key: P2PCreateAdPage.paymentWindowKey(value),
                label: '$value phút',
                selected: selected == value,
                onTap: () => onSelected(value),
              ),
            ),
            if (value != values.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({
    required this.requireKyc,
    required this.requiredKycLevel,
    required this.minTradesController,
    required this.minDaysController,
    required this.onKycChanged,
    required this.onLevelChanged,
  });

  final bool requireKyc;
  final String requiredKycLevel;
  final TextEditingController minTradesController;
  final TextEditingController minDaysController;
  final ValueChanged<bool> onKycChanged;
  final ValueChanged<String> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Yêu cầu đối tác',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Tuỳ chọn',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Yêu cầu KYC',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Switch(
                value: requireKyc,
                activeThumbColor: AppColors.primarySoft,
                activeTrackColor: AppColors.primary20,
                onChanged: onKycChanged,
              ),
            ],
          ),
          if (requireKyc) ...[
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final level in const ['1', '2', '3'])
                  _ChoiceChipButton(
                    label: 'Cấp $level',
                    selected: requiredKycLevel == level,
                    onTap: () => onLevelChanged(level),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          VitInput(
            controller: minTradesController,
            label: 'Số đơn tối thiểu',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.x3),
          VitInput(
            controller: minDaysController,
            label: 'Số ngày tối thiểu',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _MultilineBlock extends StatelessWidget {
  const _MultilineBlock({
    required this.label,
    required this.controller,
    required this.hintText,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return _InputBlock(
      label: label,
      hint: hint,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.buttonHero + AppSpacing.x6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid, width: 1.5),
          borderRadius: AppRadii.inputRadius,
        ),
        child: TextField(
          controller: controller,
          maxLines: 3,
          cursorColor: AppColors.primary,
          style: AppTextStyles.body.copyWith(fontSize: 14, height: 1.45),
          decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  height: 1.55,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard({
    required this.expanded,
    required this.isValid,
    required this.onTap,
    required this.adType,
    required this.asset,
    required this.currency,
    required this.price,
    required this.totalAmount,
    required this.payments,
  });

  final bool expanded;
  final bool isValid;
  final VoidCallback onTap;
  final P2PTradeType adType;
  final String asset;
  final String currency;
  final int price;
  final String totalAmount;
  final Set<String> payments;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: AppRadii.inputRadius,
            child: Row(
              children: [
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Live Preview',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                _PreviewBadge(label: isValid ? '100%' : '0%'),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x4),
            _ConfirmRow(
              label: adType == P2PTradeType.buy ? 'MUA' : 'BÁN',
              value: '$totalAmount $asset',
            ),
            _ConfirmRow(label: 'Giá', value: '${_formatVnd(price)} $currency'),
            _ConfirmRow(label: 'Thanh toán', value: payments.join(', ')),
          ],
        ],
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.buy),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

num _parseNum(String value) {
  var normalized = value.replaceAll(',', '').replaceAll(' ', '').trim();
  final dotParts = normalized.split('.');
  if (dotParts.length > 2 ||
      (dotParts.length == 2 &&
          dotParts.last.length == 3 &&
          dotParts.first.length > 1)) {
    normalized = normalized.replaceAll('.', '');
  }
  return num.tryParse(normalized) ?? 0;
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
