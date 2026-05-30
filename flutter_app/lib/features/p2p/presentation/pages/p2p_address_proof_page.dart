import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PAddressProofPage extends ConsumerStatefulWidget {
  const P2PAddressProofPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc250_p2p_address_hero');
  static const requirementsKey = Key('sc250_p2p_address_requirements');
  static const documentTypesKey = Key('sc250_p2p_address_document_types');
  static Key documentTypeKey(String id) => Key('sc250_p2p_address_doc_$id');
  static const uploadKey = Key('sc250_p2p_address_upload');
  static const extractedDataKey = Key('sc250_p2p_address_extracted_data');
  static const addressConfirmKey = Key('sc250_p2p_address_confirm');
  static const securityKey = Key('sc250_p2p_address_security');
  static const submitKey = Key('sc250_p2p_address_submit');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAddressProofPage> createState() =>
      _P2PAddressProofPageState();
}

class _P2PAddressProofPageState extends ConsumerState<P2PAddressProofPage> {
  String? _selectedTypeId;
  bool _uploaded = false;
  String _manualAddress = '';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pAddressProofProvider);
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
      semanticLabel: 'SC-250 P2PAddressProofPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Proof of Address',
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
                      _AddressHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _RequirementsCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      if (selectedDocument == null)
                        _DocumentTypePicker(
                          documents: snapshot.documentTypes,
                          onSelected: (document) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedTypeId = document.id);
                          },
                        )
                      else ...[
                        _UploadSection(
                          selectedDocument: selectedDocument,
                          uploaded: _uploaded,
                          onChangeType: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedTypeId = null;
                              _uploaded = false;
                              _manualAddress = '';
                            });
                          },
                          onUpload: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _uploaded = true;
                              _manualAddress = snapshot.extractedAddress;
                            });
                          },
                          onRemove: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _uploaded = false;
                              _manualAddress = '';
                            });
                          },
                        ),
                        if (_uploaded) ...[
                          const SizedBox(height: AppSpacing.x5),
                          _ExtractedDataCard(snapshot: snapshot),
                          const SizedBox(height: AppSpacing.x5),
                          _AddressConfirmCard(address: _manualAddress),
                        ],
                        const SizedBox(height: AppSpacing.x5),
                        _SecurityCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        VitCtaButton(
                          key: P2PAddressProofPage.submitKey,
                          onPressed: _uploaded && _manualAddress.isNotEmpty
                              ? () {
                                  HapticFeedback.selectionClick();
                                  context.go(snapshot.submitRoute);
                                }
                              : null,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          child: const Text('Gửi tài liệu'),
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

class _AddressConfirmCard extends StatelessWidget {
  const _AddressConfirmCard({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.addressConfirmKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: Icons.location_on_outlined,
            title: 'Xác nhận địa chỉ',
            color: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            address,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
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
                  'Địa chỉ này phải khớp với địa chỉ trên tài liệu và CMND/CCCD của bạn.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.securityKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.verified_user_outlined,
            title: 'Bảo mật thông tin',
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

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'receipt' => Icons.receipt_long_outlined,
    'bank_card' => Icons.credit_card_rounded,
    'government' => Icons.description_outlined,
    'home' => Icons.home_outlined,
    _ => Icons.file_present_outlined,
  };
}
