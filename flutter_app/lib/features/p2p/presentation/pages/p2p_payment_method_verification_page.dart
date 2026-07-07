import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../widgets/p2p_payment_method_verification_methods.dart';
part '../widgets/p2p_payment_method_verification_flow.dart';

const double _p2pPaymentVerificationVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pPaymentVerificationNativeNavClearance =
    _p2pPaymentVerificationVisualNavClearance - AppSpacing.x4;
const double _p2pPaymentVerificationVisualClearance = AppSpacing.x3;
const double _p2pPaymentVerificationNativeClearance = AppSpacing.x2;

class P2PPaymentMethodVerificationPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodVerificationPage({
    super.key,
    required this.methodId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc233_payment_verification_content');
  static const codeFieldKey = Key('sc233_payment_verification_code');
  static const submitButtonKey = Key('sc233_payment_verification_submit');
  static const confirmSubmitKey = Key('sc233_payment_verification_confirm');

  static Key methodKey(String id) => Key('sc233_verification_method_$id');

  final String methodId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodVerificationPage> createState() =>
      _P2PPaymentMethodVerificationPageState();
}

class _P2PPaymentMethodVerificationPageState
    extends ConsumerState<P2PPaymentMethodVerificationPage> {
  final _codeController = TextEditingController();
  String? _selectedMethodId;
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      p2pPaymentMethodVerificationProvider(widget.methodId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pPaymentVerificationVisualNavClearance +
                  _p2pPaymentVerificationVisualClearance
            : _p2pPaymentVerificationNativeNavClearance +
                  _p2pPaymentVerificationNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-233 P2PPaymentMethodVerificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _selectedMethodId == null
                ? 'Xác minh phương thức'
                : _selectedTitle(snapshot),
            subtitle: _selectedMethodId == null ? 'Thanh toán · P2P' : null,
            showBack: true,
            onBack: () {
              if (_selectedMethodId != null) {
                setState(() => _selectedMethodId = null);
                return;
              }
              context.go(AppRoutePaths.p2pPaymentMethods);
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PPaymentMethodVerificationPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding:
                        P2PSpacingTokens.p2pPaymentVerificationScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.form,
                      padding: VitContentPadding.none,
                      children: [
                        if (_selectedMethodId == null)
                          _MethodChooser(
                            snapshot: snapshot,
                            onSelected: (methodId) {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedMethodId = methodId);
                            },
                          )
                        else
                          _VerificationFlow(
                            snapshot: snapshot,
                            methodId: _selectedMethodId!,
                            controller: _codeController,
                            submitting: _submitting,
                            onChanged: () => setState(() {}),
                            onSubmit: _canSubmit
                                ? () => _confirmSubmit(context, snapshot)
                                : null,
                          ),
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Payment method verification review',
                          message:
                              'Micro-deposit confirmation, ownership check, warning note, and return path are reviewed before enabling a P2P payment method for escrow trades.',
                          contractId: 'SC-233',
                        ),
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

  bool get _canSubmit =>
      _selectedMethodId == 'micro_deposit' &&
      _codeController.text.trim().isNotEmpty &&
      !_submitting;

  String _selectedTitle(P2PPaymentMethodVerificationSnapshot snapshot) {
    final method = snapshot.methods.firstWhere(
      (item) => item.id == _selectedMethodId,
      orElse: () => snapshot.methods.first,
    );
    if (method.id == 'micro_deposit') return 'Xác minh micro-deposit';
    return method.label;
  }

  Future<void> _confirmSubmit(
    BuildContext context,
    P2PPaymentMethodVerificationSnapshot snapshot,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        title: Text(
          snapshot.confirmTitle,
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
        content: Text(
          snapshot.confirmMessage,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
            key: P2PPaymentMethodVerificationPage.confirmSubmitKey,
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
    context.go(snapshot.saveRoute);
  }
}
