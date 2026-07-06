import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_payment_method_add_page_sections.dart';
part '../widgets/p2p_payment_method_add_page_common.dart';

enum P2PPaymentAddType { bank, ewallet }

const double _p2pPaymentAddVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pPaymentAddNativeNavClearance =
    _p2pPaymentAddVisualNavClearance - AppSpacing.x5 + AppSpacing.x1;
const double _p2pPaymentAddScrollEnd = AppSpacing.x3;
const double _p2pPaymentAddMajorGap = AppSpacing.p2pPaymentSectionGap;
const double _p2pPaymentAddSectionGap = AppSpacing.p2pPaymentCardGap;
const double _p2pPaymentAddTypeExtent = AppSpacing.searchBarCompactHeight;
const double _p2pPaymentAddIconBox = AppSpacing.buttonCompact;
const double _p2pPaymentAddPreviewLabelWidth = 96;

class P2PPaymentMethodAddPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodAddPage({
    super.key,
    this.initialType = P2PPaymentAddType.bank,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc232_p2p_payment_method_add_content');
  static const bankTypeKey = Key('sc232_payment_add_bank_type');
  static const ewalletTypeKey = Key('sc232_payment_add_ewallet_type');
  static const accountFieldKey = Key('sc232_payment_add_account');
  static const ownerFieldKey = Key('sc232_payment_add_owner');
  static const saveButtonKey = Key('sc232_payment_add_save');
  static const confirmSaveKey = Key('sc232_payment_add_confirm');
  static const previewKey = Key('sc232_payment_add_preview');

  static Key optionKey(String value) => Key('sc232_payment_option_$value');

  final P2PPaymentAddType initialType;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodAddPage> createState() =>
      _P2PPaymentMethodAddPageState();
}

class _P2PPaymentMethodAddPageState
    extends ConsumerState<P2PPaymentMethodAddPage> {
  final _accountController = TextEditingController();
  final _ownerController = TextEditingController();

  late P2PPaymentAddType _type;
  String? _selectedMethod;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pPaymentMethodAddProvider);
    final controller = P2PPaymentMethodAddController(
      state: P2PPaymentMethodAddViewState(snapshot: snapshot),
    );
    final options = controller.optionsFor(
      bankType: _type == P2PPaymentAddType.bank,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerInset =
        (mode.usesVisualQaFrame
            ? _p2pPaymentAddVisualNavClearance
            : _p2pPaymentAddNativeNavClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-232 P2PPaymentMethodAddPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title:
                'Thêm ${_type == P2PPaymentAddType.bank ? 'ngân hàng' : 'ví điện tử'}',
            subtitle: 'Thanh toán · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PPaymentMethodAddPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pPaymentAddFormScrollPadding(
                      _p2pPaymentAddScrollEnd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TypeSelector(value: _type, onChanged: _changeType),
                        const SizedBox(height: _p2pPaymentAddMajorGap),
                        _SectionLabel(
                          _type == P2PPaymentAddType.bank
                              ? 'Chọn ngân hàng'
                              : 'Chọn ví điện tử',
                        ),
                        const SizedBox(height: _p2pPaymentAddSectionGap),
                        _PaymentOptionWrap(
                          options: options,
                          selected: _selectedMethod,
                          onSelected: (value) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedMethod = value);
                          },
                        ),
                        const SizedBox(height: _p2pPaymentAddMajorGap),
                        VitInput(
                          controller: _accountController,
                          fieldKey: P2PPaymentMethodAddPage.accountFieldKey,
                          semanticLabel: 'P2P payment account',
                          label: _type == P2PPaymentAddType.bank
                              ? 'Số tài khoản'
                              : 'Số điện thoại / tài khoản ví',
                          hintText: _type == P2PPaymentAddType.bank
                              ? snapshot.defaultBankAccountHint
                              : snapshot.defaultEwalletAccountHint,
                          prefix: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: _p2pPaymentAddMajorGap),
                        VitInput(
                          controller: _ownerController,
                          fieldKey: P2PPaymentMethodAddPage.ownerFieldKey,
                          semanticLabel: 'P2P payment account owner',
                          label: 'Tên chủ tài khoản',
                          hintText: snapshot.ownerNameHint,
                          prefix: const Icon(Icons.person_outline_rounded),
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [_UppercaseTextFormatter()],
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: _p2pPaymentAddMajorGap),
                        _SecurityNote(note: snapshot.securityNote),
                        if (_isValidFor(controller)) ...[
                          const SizedBox(height: _p2pPaymentAddMajorGap),
                          _PaymentPreview(
                            preview: controller.preview(
                              selectedMethod: _selectedMethod!,
                              account: _accountController.text,
                              ownerName: _ownerController.text,
                            ),
                            type: _type,
                          ),
                        ],
                        const SizedBox(height: _p2pPaymentAddSectionGap),
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Payment method add state review',
                          message:
                              'Payment type, selected method, masked account preview, ownership risk, limit message, confirmation dialog, and submitting state remain visible before saving.',
                          contractId: 'SC-232',
                        ),
                        const SizedBox(height: _p2pPaymentAddMajorGap),
                        Semantics(
                          label: 'Preview and add P2P payment method',
                          button: true,
                          enabled: _isValidFor(controller) && !_submitting,
                          child: VitCtaButton(
                            key: P2PPaymentMethodAddPage.saveButtonKey,
                            loading: _submitting,
                            onPressed: _isValidFor(controller) && !_submitting
                                ? () => _confirmSave(context, controller)
                                : null,
                            child: Text(
                              _submitting ? 'Đang lưu...' : 'Thêm phương thức',
                            ),
                          ),
                        ),
                        SizedBox(height: footerInset),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeType(P2PPaymentAddType type) {
    if (_type == type) return;
    HapticFeedback.selectionClick();
    setState(() {
      _type = type;
      _selectedMethod = null;
    });
  }

  bool _isValidFor(P2PPaymentMethodAddController controller) {
    return controller.canPreview(
      selectedMethod: _selectedMethod,
      account: _accountController.text,
      ownerName: _ownerController.text,
    );
  }

  Future<void> _confirmSave(
    BuildContext context,
    P2PPaymentMethodAddController controller,
  ) async {
    final preview = controller.preview(
      selectedMethod: _selectedMethod ?? '',
      account: _accountController.text,
      ownerName: _ownerController.text,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        title: Text(
          preview.confirmTitle,
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfirmRow(label: 'Phương thức', value: _selectedMethod ?? '--'),
            _ConfirmRow(label: 'Tài khoản', value: preview.maskedAccount),
            _ConfirmRow(label: 'Chủ tài khoản', value: preview.ownerName),
            _ConfirmRow(label: 'Sở hữu', value: preview.ownershipRiskMessage),
            _ConfirmRow(label: 'Giới hạn', value: preview.limitMessage),
            const SizedBox(height: AppSpacing.x3),
            Text(
              preview.confirmMessage,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        actions: [
          VitCtaButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            variant: VitCtaButtonVariant.secondary,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: AppSpacing.p2pPaymentDialogActionPadding,
            child: const Text('Hủy'),
          ),
          VitCtaButton(
            key: P2PPaymentMethodAddPage.confirmSaveKey,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            variant: VitCtaButtonVariant.primary,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: AppSpacing.p2pPaymentDialogActionPadding,
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (!context.mounted || confirmed != true) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    context.go(preview.saveRoute);
  }
}
