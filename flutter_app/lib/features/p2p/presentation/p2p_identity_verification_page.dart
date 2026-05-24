import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class P2PIdentityVerificationPage extends ConsumerStatefulWidget {
  const P2PIdentityVerificationPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc249_p2p_identity_hero');
  static const documentTypesKey = Key('sc249_p2p_identity_document_types');
  static Key documentTypeKey(String id) => Key('sc249_p2p_identity_doc_$id');
  static const guidelinesKey = Key('sc249_p2p_identity_guidelines');
  static const frontUploadKey = Key('sc249_p2p_identity_front_upload');
  static const backUploadKey = Key('sc249_p2p_identity_back_upload');
  static const securityKey = Key('sc249_p2p_identity_security');
  static const submitKey = Key('sc249_p2p_identity_submit');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PIdentityVerificationPage> createState() =>
      _P2PIdentityVerificationPageState();
}

class _P2PIdentityVerificationPageState
    extends ConsumerState<P2PIdentityVerificationPage> {
  String? _selectedTypeId;
  bool _frontUploaded = false;
  bool _backUploaded = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getIdentityVerification();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final selectedDocument = _selectedTypeId == null
        ? null
        : snapshot.documentTypes.firstWhere(
            (document) => document.id == _selectedTypeId,
            orElse: () => snapshot.documentTypes.first,
          );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-249 P2PIdentityVerificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Identity Verification',
              subtitle: 'KYC · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
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
                      _IdentityHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      if (selectedDocument == null)
                        _DocumentTypePicker(
                          documents: snapshot.documentTypes,
                          onSelected: (document) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedTypeId = document.id);
                          },
                        )
                      else ...[
                        _GuidelinesCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        _UploadSection(
                          selectedDocument: selectedDocument,
                          frontUploaded: _frontUploaded,
                          backUploaded: _backUploaded,
                          onFrontUpload: () {
                            HapticFeedback.selectionClick();
                            setState(() => _frontUploaded = true);
                          },
                          onBackUpload: _frontUploaded
                              ? () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _backUploaded = true);
                                }
                              : null,
                          onFrontRemove: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _frontUploaded = false;
                              _backUploaded = false;
                            });
                          },
                          onBackRemove: () {
                            HapticFeedback.selectionClick();
                            setState(() => _backUploaded = false);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        _SecurityCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        VitCtaButton(
                          key: P2PIdentityVerificationPage.submitKey,
                          onPressed: _frontUploaded && _backUploaded
                              ? () {
                                  HapticFeedback.selectionClick();
                                  context.go(snapshot.nextRoute);
                                }
                              : null,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          child: const Text('Tiếp tục'),
                        ),
                      ],
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
}

class _IdentityHero extends StatelessWidget {
  const _IdentityHero({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: AppColors.primary15,
              borderRadius: AppRadii.lgRadius,
              border: Border.all(color: AppColors.primary20),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
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

class _DocumentTypePicker extends StatelessWidget {
  const _DocumentTypePicker({
    required this.documents,
    required this.onSelected,
  });

  final List<P2PIdentityDocumentTypeDraft> documents;
  final ValueChanged<P2PIdentityDocumentTypeDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PIdentityVerificationPage.documentTypesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn loại giấy tờ',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final document in documents) ...[
          VitCard(
            key: P2PIdentityVerificationPage.documentTypeKey(document.id),
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            onTap: () => onSelected(document),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  decoration: BoxDecoration(
                    color: AppColors.primary12,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    _documentIcon(document.iconKey),
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.label,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        document.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
          if (document != documents.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.guidelinesKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: Icons.info_outline_rounded,
            title: 'Hướng dẫn chụp ảnh',
            color: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final guide in snapshot.guidelines) ...[
            _ChecklistRow(text: guide, color: AppColors.buy),
            if (guide != snapshot.guidelines.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.selectedDocument,
    required this.frontUploaded,
    required this.backUploaded,
    required this.onFrontUpload,
    required this.onBackUpload,
    required this.onFrontRemove,
    required this.onBackRemove,
  });

  final P2PIdentityDocumentTypeDraft selectedDocument;
  final bool frontUploaded;
  final bool backUploaded;
  final VoidCallback onFrontUpload;
  final VoidCallback? onBackUpload;
  final VoidCallback onFrontRemove;
  final VoidCallback onBackRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Upload hình ảnh',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _UploadCard(
          key: P2PIdentityVerificationPage.frontUploadKey,
          label: 'Mặt trước',
          title: 'Chụp hoặc tải ảnh mặt trước',
          subtitle: '${selectedDocument.label} · JPG, PNG · Tối đa 10MB',
          uploaded: frontUploaded,
          enabled: true,
          onUpload: onFrontUpload,
          onRemove: onFrontRemove,
        ),
        const SizedBox(height: AppSpacing.x4),
        _UploadCard(
          key: P2PIdentityVerificationPage.backUploadKey,
          label: 'Mặt sau',
          title: 'Chụp hoặc tải ảnh mặt sau',
          subtitle: frontUploaded
              ? 'JPG, PNG · Tối đa 10MB'
              : 'Upload mặt trước trước',
          uploaded: backUploaded,
          enabled: frontUploaded,
          onUpload: onBackUpload,
          onRemove: onBackRemove,
        ),
      ],
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    super.key,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.uploaded,
    required this.enabled,
    required this.onUpload,
    required this.onRemove,
  });

  final String label;
  final String title;
  final String subtitle;
  final bool uploaded;
  final bool enabled;
  final VoidCallback? onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          radius: VitCardRadius.lg,
          variant: uploaded ? VitCardVariant.inner : VitCardVariant.ghost,
          borderColor: uploaded
              ? AppColors.buy20
              : enabled
              ? AppColors.borderSolid
              : AppColors.cardBorder,
          padding: const EdgeInsets.all(AppSpacing.x4),
          onTap: enabled && !uploaded ? onUpload : null,
          child: uploaded
              ? Row(
                  children: [
                    Container(
                      width: AppSpacing.inputHeight,
                      height: AppSpacing.inputHeight,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.lgRadius,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$label đã sẵn sàng',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            'Quality score 92%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Xóa ảnh',
                      variant: VitIconButtonVariant.ghost,
                      onPressed: onRemove,
                    ),
                  ],
                )
              : Opacity(
                  opacity: enabled ? 1 : .52,
                  child: SizedBox(
                    height: 154,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: AppSpacing.x7,
                          height: AppSpacing.x7,
                          decoration: BoxDecoration(
                            color: AppColors.primary12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.photo_camera_outlined,
                            color: AppModuleAccents.p2p,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.securityKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.verified_user_outlined,
            title: 'Bảo mật & Quyền riêng tư',
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final note in snapshot.securityNotes) ...[
            _ChecklistRow(text: note, color: AppColors.buy),
            if (note != snapshot.securityNotes.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: color,
            size: 13,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
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

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'badge' => Icons.badge_outlined,
    'passport' => Icons.contact_page_outlined,
    _ => Icons.credit_card_rounded,
  };
}
