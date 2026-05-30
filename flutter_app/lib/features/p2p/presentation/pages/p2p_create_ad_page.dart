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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_create_ad_sections.dart';

class P2PCreateAdPage extends ConsumerStatefulWidget {
  const P2PCreateAdPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc226_p2p_create_content');
  static const priceFieldKey = P2PCreateAdUiKeys.priceFieldKey;
  static const marginFieldKey = P2PCreateAdUiKeys.marginFieldKey;
  static const totalFieldKey = P2PCreateAdUiKeys.totalFieldKey;
  static const minFieldKey = P2PCreateAdUiKeys.minFieldKey;
  static const maxFieldKey = P2PCreateAdUiKeys.maxFieldKey;
  static const publishButtonKey = P2PCreateAdUiKeys.publishButtonKey;
  static const confirmPublishKey = P2PCreateAdUiKeys.confirmPublishKey;

  static Key adTypeKey(P2PTradeType type) => P2PCreateAdUiKeys.adTypeKey(type);
  static Key assetKey(String asset) => P2PCreateAdUiKeys.assetKey(asset);
  static Key currencyKey(String currency) =>
      P2PCreateAdUiKeys.currencyKey(currency);
  static Key priceTypeKey(String type) => P2PCreateAdUiKeys.priceTypeKey(type);
  static Key paymentKey(String payment) =>
      P2PCreateAdUiKeys.paymentKey(payment);
  static Key paymentWindowKey(int minutes) =>
      P2PCreateAdUiKeys.paymentWindowKey(minutes);

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
    final snapshot = ref.watch(p2pCreateAdProvider);
    final formController = P2PCreateAdController(
      state: P2PCreateAdViewState(snapshot: snapshot),
    );
    final preview = formController.preview(_draft());
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
                              'Giá thị trường: ${preview.marketPriceLabel} $_currency',
                          child: VitInput(
                            controller: _priceController,
                            fieldKey: P2PCreateAdPage.priceFieldKey,
                            hintText: preview.marketPriceLabel,
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
                        P2PCreateAdFloatingPriceBlock(
                          controller: _marginController,
                          preview: preview,
                          onChanged: () => setState(() {}),
                        ),
                      if (preview.effectivePrice > 0) ...[
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          preview.priceDiffLabel,
                          style: AppTextStyles.micro.copyWith(
                            color: preview.priceDiffPercent >= 0
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
                      P2PCreateAdPaymentsBlock(
                        options: snapshot.paymentOptions,
                        selected: _selectedPayments,
                        onToggle: _togglePayment,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      P2PCreateAdPaymentWindowBlock(
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
                      P2PCreateAdRequirementCard(
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
                      P2PCreateAdMultilineBlock(
                        label: 'Điều kiện giao dịch (tuỳ chọn)',
                        controller: _termsController,
                        hintText:
                            'VD: Chỉ giao dịch với tài khoản đã xác minh KYC...',
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      P2PCreateAdMultilineBlock(
                        label: 'Tin nhắn tự động (tuỳ chọn)',
                        controller: _autoReplyController,
                        hintText:
                            'VD: Cảm ơn bạn! Vui lòng chuyển khoản theo thông tin bên dưới.',
                        hint: 'Gửi tự động khi đối tác tạo đơn.',
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      P2PCreateAdWarningCard(text: snapshot.warningNote),
                      const SizedBox(height: AppSpacing.x5),
                      P2PCreateAdLivePreviewCard(
                        expanded: _previewExpanded,
                        onTap: () => setState(
                          () => _previewExpanded = !_previewExpanded,
                        ),
                        preview: preview,
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
                  onPressed: preview.canPublish && !_submitting
                      ? () => _confirmPublish(context, preview)
                      : null,
                  variant: _adType == P2PTradeType.buy
                      ? VitCtaButtonVariant.success
                      : VitCtaButtonVariant.danger,
                  loading: _submitting,
                  child: Text(
                    _submitting ? 'Đang đăng...' : preview.publishLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  P2PCreateAdDraft _draft() {
    return P2PCreateAdDraft(
      adType: _adType,
      asset: _asset,
      currency: _currency,
      priceType: _priceType,
      paymentWindow: _paymentWindow,
      tradingHours: _tradingHours,
      requireKyc: _requireKyc,
      requiredKycLevel: _requiredKycLevel,
      selectedPayments: _selectedPayments,
      priceText: _priceController.text,
      marginText: _marginController.text,
      totalText: _totalController.text,
      minLimitText: _minController.text,
      maxLimitText: _maxController.text,
    );
  }

  void _togglePayment(String payment) {
    HapticFeedback.selectionClick();
    final formController = P2PCreateAdController(
      state: P2PCreateAdViewState(snapshot: ref.read(p2pCreateAdProvider)),
    );
    final nextPayments = formController.toggledPayments(
      _selectedPayments,
      payment,
    );
    setState(() {
      _selectedPayments
        ..clear()
        ..addAll(nextPayments);
    });
  }

  Future<void> _confirmPublish(
    BuildContext context,
    P2PCreateAdPreview preview,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Xác nhận đăng quảng cáo',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              P2PCreateAdConfirmRow(label: 'Loại', value: preview.typeLabel),
              P2PCreateAdConfirmRow(
                label: 'Tài sản',
                value: preview.totalAmountLabel,
              ),
              P2PCreateAdConfirmRow(
                label: 'Giá',
                value: '${preview.priceLabel}/$_asset',
              ),
              P2PCreateAdConfirmRow(
                label: 'Thanh toán',
                value: preview.paymentSummary,
              ),
              P2PCreateAdConfirmRow(
                label: 'Limit',
                value: preview.limitSummary,
              ),
              P2PCreateAdConfirmRow(
                label: 'Fee',
                value: preview.feeReviewLabel,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                '${preview.escrowReviewLabel}\n${preview.riskReviewLabel}',
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
            color: selected ? color : AppColors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text3,
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
