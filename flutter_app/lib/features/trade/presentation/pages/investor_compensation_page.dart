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

part '../widgets/investor_compensation_page_sections.dart';
part '../widgets/investor_compensation_page_common.dart';

const _compBackground = AppColors.bg;
const _compPanel = AppColors.surface;
const _compPanel2 = AppColors.surface2;
const _compBorder = AppColors.borderSolid;
const _compPrimary = AppColors.primary;
const _compGreen = AppColors.buy;
const _compAmber = AppColors.caution;
const _compRed = AppColors.sell;

class InvestorCompensationPage extends ConsumerStatefulWidget {
  const InvestorCompensationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc104_investor_compensation_content');
  static const faqKey = Key('sc104_investor_compensation_faq');
  static Key tabKey(String id) => Key('sc104_investor_compensation_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<InvestorCompensationPage> createState() =>
      _InvestorCompensationPageState();
}

class _InvestorCompensationPageState
    extends ConsumerState<InvestorCompensationPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getInvestorCompensation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-104 InvestorCompensationPage',
      child: Material(
        color: _compBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Investor Compensation',
            subtitle: 'FSCS Protection',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: InvestorCompensationPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 12,
                    children: [
                      _ProtectionCard(snapshot: snapshot),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          customGap: 8,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Compensation coverage review',
                              message:
                                  'Eligibility, coverage limit, claim path, exclusions and next steps are reviewed before relying on protection.',
                              contractId: 'investor-compensation-review',
                            ),
                            VitStatusPill(
                              label: 'Coverage has limits',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      _InfoNotice(snapshot: snapshot),
                      _Tabs(activeId: _tab, onChanged: _setTab),
                      if (_tab == 'overview')
                        _Overview(snapshot: snapshot)
                      else if (_tab == 'eligibility')
                        _Eligibility(snapshot: snapshot)
                      else
                        _ClaimGuide(snapshot: snapshot),
                      const _FaqButton(),
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
