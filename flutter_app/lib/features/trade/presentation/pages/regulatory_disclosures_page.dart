import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

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

    return Material(
      color: _legalBackground,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Regulatory Disclosures',
            semanticLabel: 'SC-084 RegulatoryDisclosuresPage',
            contentKey: RegulatoryDisclosuresPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            onBack: () => context.go(AppRoutePaths.trade),
            children: [
              VitTradeSection(
                title: 'Overview',
                child: _LegalHero(snapshot: snapshot),
              ),
              VitTradeComplianceSection(
                title: 'Disclosure review',
                statusPill: const VitStatusPill(
                  label: 'Disclosure route visible',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Active tab',
                    value: _activeTabId!,
                  ),
                  VitTradeComplianceItem(
                    label: 'Contacts',
                    value: '${snapshot.contacts.length} routes',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Disclosures',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LegalTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTabId!,
                      onChanged: (id) => setState(() => _activeTabId = id),
                    ),
                    _LegalTabBody(
                      snapshot: snapshot,
                      activeTabId: _activeTabId!,
                      onNotice: (notice) => setState(() => _notice = notice),
                    ),
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      density: VitDensity.compact,
                      title: 'Disclosure review state',
                      message:
                          'Legal tabs, product disclosures, contact routes, notice result and investor next step are reviewed before regulated action.',
                      contractId: 'regulatory-disclosures-review',
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_notice != null)
            _RegulatoryNoticePanel(
              text: _notice!,
              onClose: () => setState(() => _notice = null),
            ),
        ],
      ),
    );
  }
}
