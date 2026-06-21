import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
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
const _termsPrimary = AppColors.primary;
const _termsAmber = AppColors.caution;
const _termsRed = AppColors.sell;
const double _termsVisualScrollClearance = 108;
const double _termsNativeScrollClearance = 72;
const double _termsSpace = AppSpacing.x2;
const double _termsTinySpace = AppSpacing.x1;
const double _termsInfoMinExtent = 82;
const double _termsCardExtent = 360;
const double _termsWarningMinExtent = 40;
const double _termsAgreementMinExtent = 96;
const double _termsComplianceMinExtent = 88;
const double _termsLineTight = 1.05;
const double _termsLineShort = 1.15;
const double _termsLineCaption = 1.2;
const double _termsLineBody = 1.26;
const double _termsLineReadable = 1.34;
const double _termsLineLegal = 1.42;

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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _termsVisualScrollClearance
            : _termsNativeScrollClearance) +
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
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollEndClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    fullBleed: true,
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
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Terms acceptance review',
                          message:
                              'Read-to-end status, agreement checkbox, suitability limits and confirmation next step are reviewed before bot access is enabled.',
                          contractId: 'bot-terms-acceptance-review',
                          density: VitDensity.compact,
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
        position.maxScrollExtent - AppSpacing.tradeBotTermsReadThreshold) {
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
