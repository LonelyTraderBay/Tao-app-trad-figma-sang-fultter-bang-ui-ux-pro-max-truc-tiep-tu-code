import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_terms_of_service_page_sections.dart';
part '../widgets/bot_terms_of_service_page_common.dart';

const _termsBackground = AppColors.bg;
const _termsPanel = AppColors.surface;
const _termsPanel2 = AppColors.surface2;
const _termsPrimary = AppColors.primary;
const _termsAmber = AppColors.caution;
const _termsRed = AppColors.sell;

class BotTermsOfServicePage extends ConsumerStatefulWidget {
  const BotTermsOfServicePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc117_bot_terms_content');
  static const termsScrollKey = Key('sc117_bot_terms_inner_scroll');
  static const agreementKey = Key('sc117_bot_terms_agreement');
  static const ctaKey = Key('sc117_bot_terms_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotTermsOfServicePage> createState() =>
      _BotTermsOfServicePageState();
}

class _BotTermsOfServicePageState extends ConsumerState<BotTermsOfServicePage> {
  final ScrollController _termsController = ScrollController();
  bool _readToEnd = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _termsController.addListener(_markReadAtBottom);
  }

  @override
  void dispose() {
    _termsController
      ..removeListener(_markReadAtBottom)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotTermsOfService();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-117 BotTermsOfServicePage',
      child: Material(
        color: _termsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trading Bots Terms',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotTermsOfServicePage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 14,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _TermsCard(
                        snapshot: snapshot,
                        controller: _termsController,
                      ),
                      _SectionLabel(snapshot.acceptSectionLabel),
                      if (!_readToEnd) ...[_ScrollWarning(snapshot: snapshot)],
                      _AgreementCard(
                        snapshot: snapshot,
                        enabled: _readToEnd,
                        agreed: _agreed,
                        onTap: _toggleAgreement,
                      ),
                      _TermsCta(
                        snapshot: snapshot,
                        agreed: _agreed,
                        onPressed: _acceptTerms,
                      ),
                      _ComplianceNote(snapshot: snapshot),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Terms acceptance review',
                          message:
                              'Read-to-end status, agreement checkbox, suitability limits and confirmation next step are reviewed before bot access is enabled.',
                          contractId: 'bot-terms-acceptance-review',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markReadAtBottom() {
    if (_readToEnd || !_termsController.hasClients) return;
    final position = _termsController.position;
    if (position.pixels + position.viewportDimension >=
        position.maxScrollExtent - 50) {
      setState(() => _readToEnd = true);
    }
  }

  void _toggleAgreement() {
    if (!_readToEnd) return;
    setState(() => _agreed = !_agreed);
  }

  void _acceptTerms() {
    if (!_agreed) return;
    context.go(AppRoutePaths.tradeBots);
  }
}
