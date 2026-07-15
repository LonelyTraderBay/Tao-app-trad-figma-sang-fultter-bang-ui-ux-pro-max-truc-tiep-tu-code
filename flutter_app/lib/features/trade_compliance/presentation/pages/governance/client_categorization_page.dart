import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part 'client_categorization_opt_up_page.dart';
part '../../widgets/governance/client_categorization_page_chrome.dart';
part '../../widgets/governance/client_categorization_overview_tab.dart';
part '../../widgets/governance/client_categorization_protections_requirements_tab.dart';
part '../../widgets/governance/client_categorization_history_tab.dart';

const _clientBorder = AppColors.borderSolid;
const _clientGreen = AppColors.buy;
const _clientPrimary = AppColors.primary;
const _clientAmber = AppColors.caution;

class ClientCategorizationPage extends ConsumerStatefulWidget {
  const ClientCategorizationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc099_client_categorization_content');
  static const optUpKey = Key('sc099_client_opt_up');
  static const disclosuresKey = Key('sc099_client_disclosures');
  static const settingsKey = Key('sc099_client_settings');
  static Key tabKey(String id) => Key('sc099_client_tab_$id');
  static Key categoryKey(String id) => Key('sc099_client_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientCategorizationPage> createState() =>
      _ClientCategorizationPageState();
}

class _ClientCategorizationPageState
    extends ConsumerState<ClientCategorizationPage> {
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRegulatoryRepositoryProvider)
        .getClientCategorization();
    _tab ??= snapshot.defaultTab;
    final current = snapshot.categories.firstWhere(
      (item) => item.id == snapshot.currentCategoryId,
    );
    return VitTradeHubScaffold(
      title: 'Client Categorization',
      subtitle: 'MiFID II Classification',
      semanticLabel: 'SC-099 ClientCategorizationPage',
      contentKey: ClientCategorizationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      useCopyTradingInset: true,
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Client classification review',
            message:
                'Current category, protection changes, eligibility evidence, disclosure links and compliance next step are reviewed before status changes.',
            contractId: 'client-categorization-review',
          ),
        ),
        VitTradeSection(
          title: 'Current category',
          child: _CurrentCategoryCard(category: current),
        ),
        VitTradeComplianceSection(
          title: 'Classification review',
          statusPill: const VitStatusPill(
            label: 'Compliance gated',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(label: 'Category', value: current.label),
            VitTradeComplianceItem(
              label: 'Options',
              value: '${snapshot.categories.length} tiers',
            ),
          ],
        ),
        VitTradeSection(
          title: 'Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _InfoNotice(),
              VitSegmentedTabBar(
                tabs: [
                  for (final tab in const [
                    ('overview', 'Overview'),
                    ('protections', 'Protections'),
                    ('requirements', 'Requirements'),
                    ('history', 'History'),
                  ])
                    VitTabItem(
                      key: tab.$1,
                      label: tab.$2,
                      widgetKey: ClientCategorizationPage.tabKey(tab.$1),
                    ),
                ],
                activeKey: _tab!,
                onChanged: (id) => setState(() => _tab = id),
              ),
              if (_tab == 'overview')
                _OverviewTab(
                  categories: snapshot.categories,
                  currentCategoryId: snapshot.currentCategoryId,
                )
              else if (_tab == 'protections')
                _ProtectionsTab(categories: snapshot.categories)
              else if (_tab == 'requirements')
                _RequirementsTab(categories: snapshot.categories)
              else
                _HistoryTab(
                  categories: snapshot.categories,
                  history: snapshot.history,
                ),
              const _QuickLinks(),
            ],
          ),
        ),
      ],
    );
  }
}
