part of '../pages/p2p_identity_verification_page.dart';

class _IdentityHero extends StatelessWidget {
  const _IdentityHero({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: AppSpacing.p2pKycCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            child: Material(
              color: AppColors.primary15,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
                side: const BorderSide(color: AppColors.primary20),
              ),
              child: const Center(
                child: Icon(
                  Icons.description_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
                ),
              ),
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
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.p2pKycReadableLineHeight,
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
            padding: AppSpacing.p2pKycCardPadding,
            onTap: () => onSelected(document),
            child: Row(
              children: [
                SizedBox(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  child: Material(
                    color: AppColors.primary12,
                    borderRadius: AppRadii.smRadius,
                    child: Icon(
                      _documentIcon(document.iconKey),
                      color: AppModuleAccents.p2p,
                      size: AppSpacing.iconSm,
                    ),
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
      padding: AppSpacing.p2pKycCardPadding,
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
          padding: AppSpacing.p2pKycCardPadding,
          onTap: enabled && !uploaded ? onUpload : null,
          child: uploaded
              ? Row(
                  children: [
                    SizedBox(
                      width: AppSpacing.inputHeight,
                      height: AppSpacing.inputHeight,
                      child: Material(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.lgRadius,
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                          size: AppSpacing.iconMd,
                        ),
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
                    height: AppSpacing.p2pKycUploadDropHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppSpacing.x7,
                          height: AppSpacing.x7,
                          child: Material(
                            color: AppColors.primary12,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              color: AppModuleAccents.p2p,
                              size: AppSpacing.iconMd,
                            ),
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
