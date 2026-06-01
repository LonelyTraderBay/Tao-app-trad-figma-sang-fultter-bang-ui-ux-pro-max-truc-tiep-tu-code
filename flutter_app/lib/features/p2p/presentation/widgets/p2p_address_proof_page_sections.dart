part of '../pages/p2p_address_proof_page.dart';

class _AddressHero extends StatelessWidget {
  const _AddressHero({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.heroKey,
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
              Icons.location_on_outlined,
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

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.requirementsKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: Icons.info_outline_rounded,
            title: 'Yêu cầu tài liệu',
            color: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final requirement in snapshot.requirements) ...[
            _ChecklistRow(text: requirement, color: AppColors.buy),
            if (requirement != snapshot.requirements.last)
              const SizedBox(height: AppSpacing.x2),
          ],
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

  final List<P2PAddressDocumentTypeDraft> documents;
  final ValueChanged<P2PAddressDocumentTypeDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PAddressProofPage.documentTypesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn loại tài liệu',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final document in documents) ...[
          VitCard(
            key: P2PAddressProofPage.documentTypeKey(document.id),
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            onTap: () => onSelected(document),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: AppSpacing.x3),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.buttonCompact + AppSpacing.x4,
                  ),
                  child: Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final example in document.examples)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x3,
                            vertical: AppSpacing.x1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: AppRadii.cardLargeRadius,
                          ),
                          child: Text(
                            example,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                    ],
                  ),
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

class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.selectedDocument,
    required this.uploaded,
    required this.onChangeType,
    required this.onUpload,
    required this.onRemove,
  });

  final P2PAddressDocumentTypeDraft selectedDocument;
  final bool uploaded;
  final VoidCallback onChangeType;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Upload tài liệu',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: onChangeType,
              style: TextButton.styleFrom(
                foregroundColor: AppModuleAccents.p2p,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Đổi loại tài liệu'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          key: P2PAddressProofPage.uploadKey,
          radius: VitCardRadius.lg,
          variant: uploaded ? VitCardVariant.inner : VitCardVariant.ghost,
          borderColor: uploaded ? AppColors.buy20 : AppColors.borderSolid,
          padding: const EdgeInsets.all(AppSpacing.x4),
          onTap: uploaded ? null : onUpload,
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
                            'Tài liệu đã sẵn sàng',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${selectedDocument.label} · OCR quality 94%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Xóa tài liệu',
                      variant: VitIconButtonVariant.ghost,
                      onPressed: onRemove,
                    ),
                  ],
                )
              : SizedBox(
                  height: 178,
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
                          Icons.cloud_upload_outlined,
                          color: AppModuleAccents.p2p,
                          size: AppSpacing.iconLg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        'Chụp hoặc tải tài liệu',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '${selectedDocument.label} · JPG, PNG, PDF · Tối đa 10MB',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ExtractedDataCard extends StatelessWidget {
  const _ExtractedDataCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.extractedDataKey,
      radius: VitCardRadius.md,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.check_circle_outline_rounded,
            title: 'Đã trích xuất thông tin',
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x3),
          _MetadataRow(label: 'Tên', value: snapshot.extractedName),
          const SizedBox(height: AppSpacing.x2),
          _MetadataRow(label: 'Ngày phát hành', value: snapshot.extractedDate),
        ],
      ),
    );
  }
}
