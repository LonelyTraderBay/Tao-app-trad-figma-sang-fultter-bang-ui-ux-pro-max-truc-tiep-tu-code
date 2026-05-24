import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

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
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getPaymentMethodVerification(widget.methodId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-233 P2PPaymentMethodVerificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
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
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PPaymentMethodVerificationPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: _selectedMethodId == null
                      ? _MethodChooser(
                          snapshot: snapshot,
                          onSelected: (methodId) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedMethodId = methodId);
                          },
                        )
                      : _VerificationFlow(
                          snapshot: snapshot,
                          methodId: _selectedMethodId!,
                          controller: _codeController,
                          submitting: _submitting,
                          onChanged: () => setState(() {}),
                          onSubmit: _canSubmit
                              ? () => _confirmSubmit(context, snapshot)
                              : null,
                        ),
                ),
              ),
            ),
          ],
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
    if (method.id == 'micro_deposit') return 'Micro-deposit Verification';
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
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Hủy',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          TextButton(
            key: P2PPaymentMethodVerificationPage.confirmSubmitKey,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Xác nhận',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
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

class _MethodChooser extends StatelessWidget {
  const _MethodChooser({required this.snapshot, required this.onSelected});

  final P2PPaymentMethodVerificationSnapshot snapshot;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OwnershipHero(),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Chọn phương thức xác minh',
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final method in snapshot.methods) ...[
          _VerificationMethodCard(
            method: method,
            onTap: () => onSelected(method.id),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x2),
        _WarningNote(note: snapshot.warningNote),
      ],
    );
  }
}

class _OwnershipHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.text1,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xác minh sở hữu',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Xác minh tài khoản ngân hàng thuộc sở hữu của bạn để đảm bảo an toàn giao dịch.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _VerificationMethodCard extends StatelessWidget {
  const _VerificationMethodCard({required this.method, required this.onTap});

  final P2PPaymentVerificationMethodDraft method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodVerificationPage.methodKey(method.id),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: method.recommended
          ? AppColors.primary30
          : AppColors.borderSolid,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MethodIcon(icon: _iconForKey(method.iconKey)),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        method.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    if (method.recommended) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const VitStatusPill(
                        label: 'Đề xuất',
                        status: VitStatusPillStatus.success,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  method.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.text3,
                      size: 11,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      method.duration,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'camera':
        return Icons.photo_camera_outlined;
      case 'upload':
        return Icons.upload_rounded;
      case 'card':
      default:
        return Icons.credit_card_rounded;
    }
  }
}

class _VerificationFlow extends StatelessWidget {
  const _VerificationFlow({
    required this.snapshot,
    required this.methodId,
    required this.controller,
    required this.submitting,
    required this.onChanged,
    required this.onSubmit,
  });

  final P2PPaymentMethodVerificationSnapshot snapshot;
  final String methodId;
  final TextEditingController controller;
  final bool submitting;
  final VoidCallback onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final method = snapshot.methods.firstWhere(
      (item) => item.id == methodId,
      orElse: () => snapshot.methods.first,
    );
    if (methodId != 'micro_deposit') {
      return _ManualVerificationPending(method: method);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CenteredMethodIntro(method: method),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var i = 0; i < snapshot.microDepositSteps.length; i++) ...[
                _StepRow(index: i + 1, text: snapshot.microDepositSteps[i]),
                if (i != snapshot.microDepositSteps.length - 1)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitInput(
          controller: controller,
          fieldKey: P2PPaymentMethodVerificationPage.codeFieldKey,
          label: 'Số tiền nhận được (VND)',
          hintText: 'Nhập số tiền (VD: 1 hoặc 2)',
          prefix: const Icon(Icons.payments_outlined),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PPaymentMethodVerificationPage.submitButtonKey,
          loading: submitting,
          onPressed: onSubmit,
          leading: const Icon(Icons.check_circle_outline_rounded),
          child: const Text('Xác nhận số tiền'),
        ),
      ],
    );
  }
}

class _CenteredMethodIntro extends StatelessWidget {
  const _CenteredMethodIntro({required this.method});

  final P2PPaymentVerificationMethodDraft method;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.primary12,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.credit_card_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Xác minh qua ${method.label}',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Chúng tôi sẽ gửi 1-2 VND vào tài khoản của bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ManualVerificationPending extends StatelessWidget {
  const _ManualVerificationPending({required this.method});

  final P2PPaymentVerificationMethodDraft method;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      icon: method.iconKey == 'camera'
          ? Icons.photo_camera_outlined
          : Icons.upload_file_rounded,
      title: method.label,
      message:
          'Luồng ${method.label} sẽ dùng bộ tải tài liệu đã xác minh KYC. Vui lòng dùng Micro-deposit cho bản mock hiện tại.',
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary12,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: AppColors.warningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
