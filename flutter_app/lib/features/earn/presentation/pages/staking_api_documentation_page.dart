import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_auth.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_endpoints.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_examples.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_overview.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class StakingApiDocumentationPage extends ConsumerStatefulWidget {
  const StakingApiDocumentationPage({super.key, this.shellRenderMode});

  static const infoKey = StakingApiDocumentationKeys.info;
  static const statsKey = StakingApiDocumentationKeys.stats;
  static const tabsKey = StakingApiDocumentationKeys.tabs;
  static const endpointsKey = StakingApiDocumentationKeys.endpoints;
  static const detailKey = StakingApiDocumentationKeys.detail;
  static const examplesKey = StakingApiDocumentationKeys.examples;
  static const authKey = StakingApiDocumentationKeys.auth;
  static const footerKey = StakingApiDocumentationKeys.footer;
  static const copyResponseKey = StakingApiDocumentationKeys.copyResponse;
  static const copyExampleKey = StakingApiDocumentationKeys.copyExample;
  static const sandboxKey = StakingApiDocumentationKeys.sandbox;

  static Key tabKey(String id) => StakingApiDocumentationKeys.tab(id);

  static Key endpointKey(String method, String path) =>
      StakingApiDocumentationKeys.endpoint(method, path);

  static Key languageKey(String id) => StakingApiDocumentationKeys.language(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingApiDocumentationPage> createState() =>
      _StakingApiDocumentationPageState();
}

class _StakingApiDocumentationPageState
    extends ConsumerState<StakingApiDocumentationPage> {
  late StakingApiDocumentationTab _tab;
  late String _language;
  int _selectedEndpoint = 0;
  bool _responseCopied = false;
  bool _exampleCopied = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingApiDocumentationRepositoryProvider)
        .getDocumentation();
    _tab = stakingApiDocumentationTabFromId(snapshot.defaultTab);
    _language = snapshot.defaultLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingApiDocumentationRepositoryProvider)
        .getDocumentation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-379 StakingAPIDocumentationPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: snapshot.title,
            subtitle: 'Tài liệu API stake — không lời khuyên đầu tư',
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.standard,
                        padding: AppSpacing.zeroInsets,
                        child: StakingApiDocumentationInfoBanner(
                          snapshot: snapshot,
                        ),
                      ),
                      StakingApiDocumentationQuickStats(stats: snapshot.stats),
                      StakingApiDocumentationTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == StakingApiDocumentationTab.endpoints)
                        StakingApiDocumentationEndpointsTab(
                          snapshot: snapshot,
                          selectedIndex: _selectedEndpoint,
                          responseCopied: _responseCopied,
                          onSelect: (index) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedEndpoint = index;
                              _responseCopied = false;
                            });
                          },
                          onCopyResponse: () {
                            _copy(
                              snapshot
                                  .endpoints[_selectedEndpoint]
                                  .responseJson,
                            );
                            setState(() => _responseCopied = true);
                          },
                        )
                      else if (_tab == StakingApiDocumentationTab.examples)
                        StakingApiDocumentationExamplesTab(
                          snapshot: snapshot,
                          language: _language,
                          copied: _exampleCopied,
                          onLanguageChanged: (language) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _language = language;
                              _exampleCopied = false;
                            });
                          },
                          onCopy: (source) {
                            _copy(source);
                            setState(() => _exampleCopied = true);
                          },
                        )
                      else
                        StakingApiDocumentationAuthTab(snapshot: snapshot),
                      StakingApiDocumentationFooterNote(
                        note: snapshot.footerNote,
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

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
