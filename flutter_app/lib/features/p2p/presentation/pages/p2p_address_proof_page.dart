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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_address_proof_page_sections.dart';
part '../widgets/p2p_address_proof_page_common.dart';

const _p2pAddressProofVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const _p2pAddressProofNativeNavClearance =
    _p2pAddressProofVisualNavClearance - AppSpacing.x4;
const _p2pAddressProofVisualClearance = AppSpacing.x3;
const _p2pAddressProofNativeClearance = AppSpacing.x2;
const _p2pAddressProofSectionGap = AppSpacing.x2;
const _p2pAddressProofTightGap = AppSpacing.x1;
const _p2pAddressProofCardPadding = EdgeInsets.all(AppSpacing.x2);
const _p2pAddressProofHeroIconPadding = EdgeInsetsDirectional.all(
  AppSpacing.x2,
);
const _p2pAddressProofUploadVerticalPadding = EdgeInsetsDirectional.symmetric(
  vertical: AppSpacing.x3,
);
const _p2pAddressProofDocumentExamplePadding = EdgeInsets.only(
  left: AppSpacing.buttonCompact + AppSpacing.x2,
);
const _p2pAddressProofChecklistIconPadding = EdgeInsets.only(
  top: AppSpacing.dividerHairline,
);

EdgeInsets _p2pAddressProofScrollPadding(double scrollEndPadding) =>
    EdgeInsets.fromLTRB(
      AppSpacing.contentPad,
      AppSpacing.x2,
      AppSpacing.contentPad,
      scrollEndPadding,
    );

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
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pAddressProofVisualNavClearance +
                  _p2pAddressProofVisualClearance
            : _p2pAddressProofNativeNavClearance +
                  _p2pAddressProofNativeClearance) +
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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Proof of Address',
            subtitle: 'KYC · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                    physics: const ClampingScrollPhysics(),
                    padding: _p2pAddressProofScrollPadding(scrollEndPadding),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        _AddressHero(snapshot: snapshot),
                        _RequirementsCard(snapshot: snapshot),
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
                            _ExtractedDataCard(snapshot: snapshot),
                            _AddressConfirmCard(address: _manualAddress),
                          ],
                          _SecurityCard(snapshot: snapshot),
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
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Address proof state review',
                          message:
                              'Document type, upload status, extracted address, manual confirmation, and next verification step remain visible before submitting P2P address proof.',
                          contractId: 'SC-250',
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
}
