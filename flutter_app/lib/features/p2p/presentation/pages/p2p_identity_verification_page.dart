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

part '../widgets/p2p_identity_verification_page_sections.dart';
part '../widgets/p2p_identity_verification_page_common.dart';

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
    final snapshot = ref.watch(p2pIdentityVerificationProvider);
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
