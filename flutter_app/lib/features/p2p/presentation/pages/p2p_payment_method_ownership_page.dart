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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PPaymentMethodOwnershipPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodOwnershipPage({
    super.key,
    required this.methodId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc234_payment_ownership_content');
  static const submitButtonKey = Key('sc234_payment_ownership_submit');
  static const confirmSubmitKey = Key('sc234_payment_ownership_confirm');

  static Key uploadKey(String id) => Key('sc234_upload_$id');
  static Key removeKey(String id) => Key('sc234_remove_$id');
  static Key documentKey(String id) => Key('sc234_document_$id');

  final String methodId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodOwnershipPage> createState() =>
      _P2PPaymentMethodOwnershipPageState();
}

class _P2PPaymentMethodOwnershipPageState
    extends ConsumerState<P2PPaymentMethodOwnershipPage> {
  final Set<String> _uploaded = {};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      p2pPaymentMethodOwnershipControllerProvider(widget.methodId),
    );
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.p2pPaymentBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.p2pPaymentBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;
    final canSubmit = controller.canSubmit(_uploaded) && !_submitting;

    return VitPageLayout(
      semanticLabel: 'SC-234 P2PPaymentMethodOwnershipPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Proof of Ownership',
            subtitle: 'Thanh toán · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
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
                    key: P2PPaymentMethodOwnershipPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.p2pPaymentScrollPadding(bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _OwnershipHero(),
                        const SizedBox(height: AppSpacing.x5),
                        Text(
                          'Tài liệu cần thiết',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        for (final document in snapshot.documents) ...[
                          _OwnershipDocumentCard(
                            document: document,
                            uploaded: _uploaded.contains(document.id),
                            onUpload: () => _markUploaded(document.id),
                            onRemove: () => _removeUpload(document.id),
                          ),
                          const SizedBox(height: AppSpacing.x3),
                        ],
                        const SizedBox(height: AppSpacing.x3),
                        VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: 0,
                          children: const [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Payment ownership submission review',
                              message:
                                  'Required documents, optional evidence, upload and remove state, confirmation dialog, submitting state, and return path are reviewed before payment method ownership is approved.',
                              contractId: 'SC-234',
                            ),
                          ],
                        ),
                        VitCtaButton(
                          key: P2PPaymentMethodOwnershipPage.submitButtonKey,
                          loading: _submitting,
                          onPressed: canSubmit
                              ? () => _confirmSubmit(context, controller)
                              : null,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          child: const Text('Gửi xác minh'),
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

  void _markUploaded(String id) {
    HapticFeedback.lightImpact();
    setState(() => _uploaded.add(id));
  }

  void _removeUpload(String id) {
    HapticFeedback.selectionClick();
    setState(() => _uploaded.remove(id));
  }

  Future<void> _confirmSubmit(
    BuildContext context,
    P2PPaymentMethodOwnershipController controller,
  ) async {
    final preview = controller.submitPreview(_uploaded);
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
        content: Text(
          preview.confirmMessage,
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
            key: P2PPaymentMethodOwnershipPage.confirmSubmitKey,
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
    context.go(preview.saveRoute);
  }
}

class _OwnershipHero extends StatelessWidget {
  const _OwnershipHero();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pPaymentCardPadding,
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
              Icons.credit_card_rounded,
              color: AppColors.text1,
              size: AppSpacing.p2pPaymentHeroIcon,
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
                  'Upload tài liệu chứng minh tài khoản thuộc sở hữu của bạn',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnershipDocumentCard extends StatelessWidget {
  const _OwnershipDocumentCard({
    required this.document,
    required this.uploaded,
    required this.onUpload,
    required this.onRemove,
  });

  final P2POwnershipDocumentDraft document;
  final bool uploaded;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodOwnershipPage.documentKey(document.id),
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pPaymentCardPadding,
      child: Row(
        children: [
          _DocumentIcon(uploaded: uploaded),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        document.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    if (document.optional) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const VitStatusPill(
                        label: 'Optional',
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
                if (uploaded) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Đã upload',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          if (uploaded)
            IconButton(
              key: P2PPaymentMethodOwnershipPage.removeKey(document.id),
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
              color: AppColors.text3,
              iconSize: AppSpacing.iconMd,
              tooltip: 'Xóa tài liệu',
            )
          else
            _UploadButton(
              key: P2PPaymentMethodOwnershipPage.uploadKey(document.id),
              onTap: onUpload,
            ),
        ],
      ),
    );
  }
}

class _DocumentIcon extends StatelessWidget {
  const _DocumentIcon({required this.uploaded});

  final bool uploaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: uploaded ? AppColors.buy15 : AppColors.primary12,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(
        uploaded
            ? Icons.check_circle_outline_rounded
            : Icons.photo_camera_outlined,
        color: uploaded ? AppColors.buy : AppModuleAccents.p2p,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.primary12,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: AppColors.primary20),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: AppSpacing.p2pPaymentOptionPadding,
            child: Text(
              'Upload',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
