import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../widgets/investor_compensation_page_sections.dart';
part '../widgets/investor_compensation_page_common.dart';

const _compBorder = AppColors.borderSolid;
const _compPrimary = AppColors.primary;
const _compGreen = AppColors.buy;
const _compAmber = AppColors.caution;
const _compRed = AppColors.sell;

class InvestorCompensationPage extends ConsumerStatefulWidget {
  const InvestorCompensationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc104_investor_compensation_content');
  static const overviewKey = Key('sc104_investor_compensation_overview');
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
    return VitTradeHubScaffold(
      title: 'Investor Compensation',
      subtitle: 'FSCS Protection',
      semanticLabel: 'SC-104 InvestorCompensationPage',
      contentKey: InvestorCompensationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Protection',
          child: _ProtectionCard(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.compact,
                title: 'Compensation coverage review',
                message:
                    'Eligibility, coverage limit, claim path, exclusions and next steps are reviewed before relying on protection.',
                contractId: 'investor-compensation-review',
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
        VitTradeComplianceSection(
          title: 'Coverage review',
          statusPill: const VitStatusPill(
            label: 'Coverage has limits',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: const [
            VitTradeComplianceItem(label: 'Scheme', value: 'FSCS protection'),
            VitTradeComplianceItem(
              label: 'Action',
              value: 'Review eligibility before relying on coverage',
            ),
          ],
        ),
      ],
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
