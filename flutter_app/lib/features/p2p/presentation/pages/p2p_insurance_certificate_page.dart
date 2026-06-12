import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

part '../widgets/p2p_insurance_certificate_page_sections.dart';
part '../widgets/p2p_insurance_certificate_page_common.dart';

class P2PInsuranceCertificatePage extends ConsumerStatefulWidget {
  const P2PInsuranceCertificatePage({super.key, this.shellRenderMode});

  static const cardKey = Key('sc239_p2p_insurance_certificate_card');
  static const downloadKey = Key('sc239_p2p_insurance_certificate_download');
  static const shareKey = Key('sc239_p2p_insurance_certificate_share');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PInsuranceCertificatePage> createState() =>
      _P2PInsuranceCertificatePageState();
}

class _P2PInsuranceCertificatePageState
    extends ConsumerState<P2PInsuranceCertificatePage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pInsuranceCertificateProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-239 P2PInsuranceCertificatePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chứng nhận bảo hiểm',
            subtitle: 'Bảo hiểm · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pInsurance),
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
                        _ActionRow(
                          snapshot: snapshot,
                          onFeedback: (message) {
                            setState(() => _feedback = message);
                          },
                        ),
                        if (_feedback != null) ...[
                          const SizedBox(height: AppSpacing.x4),
                          _FeedbackBanner(message: _feedback!),
                        ],
                        const SizedBox(height: AppSpacing.x4),
                        _CertificateCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _DisclosureCard(snapshot: snapshot),
                        VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: 0,
                          children: const [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Insurance certificate state review',
                              message:
                                  'Certificate identity, coverage disclosure, download and share feedback, and policy limits remain visible before exporting P2P insurance proof.',
                              contractId: 'SC-239',
                            ),
                          ],
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
