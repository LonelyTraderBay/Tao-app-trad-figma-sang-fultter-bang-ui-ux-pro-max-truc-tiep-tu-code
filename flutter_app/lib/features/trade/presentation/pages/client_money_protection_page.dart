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

part '../widgets/client_money_protection_page_sections.dart';
part '../widgets/client_money_protection_page_common.dart';

const _moneyBackground = AppColors.bg;
const _moneyPanel = AppColors.surface;
const _moneyPanel2 = AppColors.surface2;
const _moneyBorder = AppColors.borderSolid;
const _moneyPrimary = AppColors.primary;
const _moneyGreen = AppColors.buy;

class ClientMoneyProtectionPage extends ConsumerStatefulWidget {
  const ClientMoneyProtectionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc102_client_money_content');
  static Key tabKey(String id) => Key('sc102_client_money_tab_$id');
  static const cassHistoryKey = Key('sc102_cass_history');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientMoneyProtectionPage> createState() =>
      _ClientMoneyProtectionPageState();
}

class _ClientMoneyProtectionPageState
    extends ConsumerState<ClientMoneyProtectionPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getClientMoneyProtection();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-102 ClientMoneyProtectionPage',
      child: Material(
        color: _moneyBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Client Money Protection',
            subtitle: 'CASS 7 Compliance',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ClientMoneyProtectionPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      const _ProtectionNotice(),
                      const SizedBox(height: 34),
                      _BalanceCard(snapshot: snapshot),
                      const SizedBox(height: 24),
                      _Tabs(activeId: _tab, onChanged: _setTab),
                      const SizedBox(height: 26),
                      VitPageSection(
                        customGap: 0,
                        children: [
                          if (_tab == 'overview')
                            _Overview(snapshot: snapshot)
                          else if (_tab == 'reconciliation')
                            const _Reconciliation()
                          else
                            const _Documents(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Client money protection review',
                              message:
                                  'Segregation status, reconciliation, documents, limits and next steps are reviewed before client-money actions.',
                              contractId: 'client-money-protection-review',
                            ),
                            SizedBox(height: 8),
                            VitStatusPill(
                              label: 'CASS review',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
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

  void _setTab(String id) => setState(() => _tab = id);
}
