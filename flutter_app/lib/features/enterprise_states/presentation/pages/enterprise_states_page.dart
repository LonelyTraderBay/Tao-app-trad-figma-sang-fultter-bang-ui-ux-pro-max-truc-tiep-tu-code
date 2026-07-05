import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/enterprise_states_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/enterprise_states_hero_tabs.dart';
part '../widgets/enterprise_states_preview_kit.dart';
part '../widgets/enterprise_states_references.dart';

class EnterpriseStatesPage extends ConsumerStatefulWidget {
  const EnterpriseStatesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc320_enterprise_states_content');
  static const backKey = Key('sc320_back');
  static const marketCtaKey = Key('sc320_market_cta');
  static const kycCtaKey = Key('sc320_kyc_cta');
  static const loginCtaKey = Key('sc320_login_cta');

  static Key sectionKey(EnterpriseStateSection section) =>
      Key('sc320_section_${section.name}');
  static Key stateKey(EnterprisePreviewState state) =>
      Key('sc320_state_${state.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<EnterpriseStatesPage> createState() =>
      _EnterpriseStatesPageState();
}

class _EnterpriseStatesPageState extends ConsumerState<EnterpriseStatesPage> {
  EnterpriseStateSection _section = EnterpriseStateSection.stateKit;
  EnterprisePreviewState _preview = EnterprisePreviewState.loading;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(enterpriseStatesControllerProvider).reference();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-320 EnterpriseStatesPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            backKey: EnterpriseStatesPage.backKey,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppSpacing.enterpriseStatesContentPadding,
                child: _SectionTabs(
                  tabs: snapshot.tabs,
                  active: _section,
                  onChanged: (section) {
                    HapticFeedback.selectionClick();
                    setState(() => _section = section);
                  },
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: EnterpriseStatesPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.enterpriseStatesScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: AppSpacing.x5,
                      children: [
                        Padding(
                          padding: AppSpacing.enterpriseStatesContentPadding,
                          child: switch (_section) {
                            EnterpriseStateSection.stateKit =>
                              _StateKitSection(
                                snapshot: snapshot,
                                activeState: _preview,
                                onStateChanged: (state) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _preview = state);
                                },
                                onMarkets: () =>
                                    context.go(snapshot.marketRoute),
                                onKyc: () => context.go(snapshot.kycRoute),
                              ),
                            EnterpriseStateSection.applied =>
                              _AppliedSection(snapshot: snapshot),
                            EnterpriseStateSection.security =>
                              _SecuritySection(snapshot: snapshot),
                          },
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
