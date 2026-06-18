import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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

part '../widgets/bot_api_documentation_intro_tabs.dart';
part '../widgets/bot_api_documentation_endpoints.dart';
part '../widgets/bot_api_documentation_websocket_examples.dart';
part '../widgets/bot_api_documentation_support_common.dart';

const _apiBackground = AppColors.bg;
const _apiPrimary = AppColors.primary;
const _apiRed = AppColors.sell;

class BotApiDocumentationPage extends ConsumerStatefulWidget {
  const BotApiDocumentationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc134_bot_api_documentation_content');
  static Key tabKey(String id) => Key('sc134_bot_api_tab_$id');
  static Key languageKey(String id) => Key('sc134_bot_api_language_$id');
  static Key endpointKey(String method, String path) =>
      Key('sc134_bot_api_endpoint_${method}_$path');
  static const copyKey = Key('sc134_bot_api_copy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotApiDocumentationPage> createState() =>
      _BotApiDocumentationPageState();
}

class _BotApiDocumentationPageState
    extends ConsumerState<BotApiDocumentationPage> {
  late String _view;
  late String _language;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(tradeReadModelControllerProvider)
        .getBotApiDocumentation();
    _view = snapshot.defaultView;
    _language = snapshot.defaultLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotApiDocumentation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.tradeBotBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome + AppSpacing.tradeBotBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-134 BotAPIDocumentationPage',
      child: Material(
        color: _apiBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'API Documentation',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotApiDocumentationPage.contentKey,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      const _IntroCard(),
                      const SizedBox(height: AppSpacing.tradeBotCardGap),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot API operational review',
                              message:
                                  'Endpoints, authentication, rate limits, websocket events and support path are reviewed before bot integration.',
                              contractId: 'bot-api-documentation-review',
                            ),
                            SizedBox(height: AppSpacing.tradeBotSmallGap),
                            VitStatusPill(
                              label: 'Read-only documentation',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.tradeBotContentGap),
                      _Tabs(
                        tabs: snapshot.tabs,
                        active: _view,
                        onChanged: (view) => setState(() => _view = view),
                      ),
                      const SizedBox(height: AppSpacing.tradeBotContentGap),
                      VitPageSection(
                        customGap: 0,
                        children: [
                          if (_view == 'endpoints')
                            _EndpointsView(endpoints: snapshot.endpoints)
                          else if (_view == 'websocket')
                            _WebSocketView(
                              url: snapshot.websocketUrl,
                              events: snapshot.websocketEvents,
                            )
                          else
                            _ExamplesView(
                              examples: snapshot.codeExamples,
                              language: _language,
                              copied: _copied,
                              onLanguageChanged: (language) {
                                setState(() {
                                  _language = language;
                                  _copied = false;
                                });
                              },
                              onCopy: _copy,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.tradeBotContentGap),
                      const _SectionLabel('Rate Limits'),
                      const SizedBox(height: AppSpacing.tradeBotRowGap),
                      _RateLimitsCard(items: snapshot.rateLimits),
                      const SizedBox(height: AppSpacing.tradeBotContentGap),
                      _AuthCard(header: snapshot.authenticationHeader),
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

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
  }
}
