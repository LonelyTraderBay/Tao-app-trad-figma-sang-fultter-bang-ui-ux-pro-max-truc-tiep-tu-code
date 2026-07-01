import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/regulatory_disclosures_hero_tabs.dart';
part '../widgets/regulatory_disclosures_tabs.dart';
part '../widgets/regulatory_disclosures_common.dart';
part '../widgets/regulatory_disclosures_cards.dart';
part '../widgets/regulatory_disclosures_actions.dart';

const _legalPrimary = AppColors.primary;
const _legalBackground = AppColors.bg;
const _legalGreen = AppColors.buy;
const _legalAmber = AppColors.caution;

class RegulatoryDisclosuresPage extends ConsumerStatefulWidget {
  const RegulatoryDisclosuresPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc084_regulatory_disclosures_content');
  static Key tabKey(String id) => Key('sc084_tab_$id');
  static Key contactKey(String title) => Key('sc084_contact_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryDisclosuresPage> createState() =>
      _RegulatoryDisclosuresPageState();
}

class _RegulatoryDisclosuresPageState
    extends ConsumerState<RegulatoryDisclosuresPage> {
  String? _activeTabId;
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getRegulatoryDisclosures();
    _activeTabId ??= snapshot.defaultTabId;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-084 RegulatoryDisclosuresPage',
      child: Material(
        color: _legalBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Regulatory Disclosures',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.trade),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: RegulatoryDisclosuresPage.contentKey,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.contentPad,
                        AppSpacing.tradeBotCardGap,
                        AppSpacing.contentPad,
                        scrollClearance,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        density: VitDensity.compact,
                        children: [
                          _LegalHero(snapshot: snapshot),
                          _LegalTabs(
                            tabs: snapshot.tabs,
                            activeId: _activeTabId!,
                            onChanged: (id) =>
                                setState(() => _activeTabId = id),
                          ),
                          _LegalTabBody(
                            snapshot: snapshot,
                            activeTabId: _activeTabId!,
                            onNotice: (notice) =>
                                setState(() => _notice = notice),
                          ),
                          const VitPageSection(
                            density: VitDensity.compact,
                            children: [
                              VitCard(
                                variant: VitCardVariant.inner,
                                density: VitDensity.compact,
                                child: VitPageContent(
                                  padding: VitContentPadding.none,
                                  fullBleed: true,
                                  density: VitDensity.compact,
                                  children: [
                                    VitHighRiskStatePanel(
                                      state: VitHighRiskUiState.riskReview,
                                      density: VitDensity.compact,
                                      title: 'Disclosure review state',
                                      message:
                                          'Legal tabs, product disclosures, contact routes, notice result and investor next step are reviewed before regulated action.',
                                      contractId:
                                          'regulatory-disclosures-review',
                                    ),
                                    VitStatusPill(
                                      label: 'Disclosure route visible',
                                      status: VitStatusPillStatus.info,
                                      size: VitStatusPillSize.sm,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_notice != null)
              _RegulatoryNoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}
