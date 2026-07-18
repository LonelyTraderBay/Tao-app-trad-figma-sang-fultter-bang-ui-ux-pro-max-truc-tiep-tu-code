import 'dart:async';

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
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/hub/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../widgets/payment/p2p_payment_method_add_page_sections.dart';
part '../../widgets/payment/p2p_payment_method_add_page_common.dart';

enum P2PPaymentAddType { bank, ewallet }

const double _p2pPaymentAddSectionGap = P2PSpacingTokens.p2pPaymentCardGap;
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
    final snapshotAsync = ref.watch(p2pPaymentMethodAddProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Thêm phương thức thanh toán',
        semanticIdentifier: 'SC-232',
        onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Thêm phương thức thanh toán',
        semanticIdentifier: 'SC-232',
        onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pPaymentMethodAddProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final controller = P2PPaymentMethodAddController(
          state: P2PPaymentMethodAddViewState(snapshot: snapshot),
        );
        final options = controller.optionsFor(
          bankType: _type == P2PPaymentAddType.bank,
        );
        return VitP2PFlowScaffold(
          title:
              'Thêm ${_type == P2PPaymentAddType.bank ? 'ngân hàng' : 'ví điện tử'}',
          subtitle: 'Thanh toán · P2P',
          semanticLabel: 'Thêm phương thức thanh toán',
          semanticIdentifier: 'SC-232',
          contentKey: P2PPaymentMethodAddPage.contentKey,
          shellRenderMode: mode,
          rhythm: VitPageRhythm.form,
          bottomInset: p2pFlowScrollBottomInset(
            context,
            shellRenderMode: mode,
            visualClearance: 0,
            nativeClearance: 0,
          ),
          onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
          children: [
            _TypeSelector(value: _type, onChanged: _changeType),
            VitSectionHeader(
              title: _type == P2PPaymentAddType.bank
                  ? 'Chọn ngân hàng'
                  : 'Chọn ví điện tử',
              titleColor: AppColors.text2,
            ),
            _PaymentOptionWrap(
              options: options,
              selected: _selectedMethod,
              onSelected: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _selectedMethod = value);
              },
            ),
            VitInput(
              controller: _accountController,
              fieldKey: P2PPaymentMethodAddPage.accountFieldKey,
              semanticLabel: 'Số tài khoản thanh toán P2P',
              label: _type == P2PPaymentAddType.bank
                  ? 'Số tài khoản'
                  : 'Số điện thoại / tài khoản ví',
              hintText: _type == P2PPaymentAddType.bank
                  ? snapshot.defaultBankAccountHint
                  : snapshot.defaultEwalletAccountHint,
              prefix: const Icon(Icons.account_balance_wallet_outlined),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
            ),
            VitInput(
              controller: _ownerController,
              fieldKey: P2PPaymentMethodAddPage.ownerFieldKey,
              semanticLabel: 'Tên chủ tài khoản thanh toán P2P',
              label: 'Tên chủ tài khoản',
              hintText: snapshot.ownerNameHint,
              prefix: const Icon(Icons.person_outline_rounded),
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [_UppercaseTextFormatter()],
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
            ),
            _SecurityNote(note: snapshot.securityNote),
            if (_isValidFor(controller))
              _PaymentPreview(
                preview: controller.preview(
                  selectedMethod: _selectedMethod!,
                  account: _accountController.text,
                  ownerName: _ownerController.text,
                ),
                type: _type,
              ),
            if (snapshot.highRiskContractId != null)
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Payment method add state review',
                message:
                    'Payment type, selected method, masked account preview, ownership risk, limit message, confirmation dialog, and submitting state remain visible before saving.',
                contractId: snapshot.highRiskContractId,
              ),
            Semantics(
              label: 'Xem trước và thêm phương thức thanh toán P2P',
              button: true,
              enabled: _isValidFor(controller) && !_submitting,
              child: VitCtaButton(
                key: P2PPaymentMethodAddPage.saveButtonKey,
                loading: _submitting,
                onPressed: _isValidFor(controller) && !_submitting
                    ? () => _confirmSave(context, controller)
                    : null,
                child: Text(_submitting ? 'Đang lưu...' : 'Thêm phương thức'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeType(P2PPaymentAddType type) {
    if (_type == type) return;
    unawaited(HapticFeedback.selectionClick());
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
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
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
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
            padding: P2PSpacingTokens.p2pPaymentDialogActionPadding,
            child: const Text('Hủy'),
          ),
          VitCtaButton(
            key: P2PPaymentMethodAddPage.confirmSaveKey,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            variant: VitCtaButtonVariant.primary,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: P2PSpacingTokens.p2pPaymentDialogActionPadding,
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
