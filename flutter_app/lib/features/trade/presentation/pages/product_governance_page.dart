import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

part '../widgets/product_governance_overview_tabs.dart';
part '../widgets/product_governance_products.dart';
part '../widgets/product_governance_reviews_distribution.dart';

const _govBorder = AppColors.borderSolid;
const _govGreen = AppColors.buy;
const _govPrimary = AppColors.primary;
const _govAmber = AppColors.caution;
const _govRed = AppColors.sell;

class ProductGovernancePage extends ConsumerStatefulWidget {
  const ProductGovernancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc100_product_governance_content');
  static Key tabKey(String id) => Key('sc100_product_tab_$id');
  static Key productKey(String id) => Key('sc100_product_$id');
  static Key targetMarketKey(String id) => Key('sc100_target_market_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProductGovernancePage> createState() =>
      _ProductGovernancePageState();
}

class _ProductGovernancePageState extends ConsumerState<ProductGovernancePage> {
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getProductGovernance();
    _tab ??= snapshot.defaultTab;
    return VitTradeHubScaffold(
      title: 'Product Governance',
      subtitle: 'MiFID II Oversight',
      semanticLabel: 'SC-100 ProductGovernancePage',
      contentKey: ProductGovernancePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.compact,
            title: 'Product governance review',
            message:
                'Review target market, negative market, risk level, distribution channel, fee disclosure, and next review deadline before approving copy products.',
            contractId: 'SC-100 product governance review',
          ),
        ),
        VitTradeSection(
          title: 'Notice',
          child: _ComplianceNotice(snapshot: snapshot),
        ),
        VitTradeComplianceSection(
          title: 'Governance review',
          statusPill: const VitStatusPill(
            label: 'Review required',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Products',
              value: '${snapshot.products.length} tracked',
            ),
            VitTradeComplianceItem(label: 'Active tab', value: _tab!),
          ],
        ),
        VitTradeSection(
          title: 'Products',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Stats(products: snapshot.products),
              _Tabs(
                activeId: _tab!,
                onChanged: (id) => setState(() => _tab = id),
              ),
              if (_tab == 'products')
                _ProductsTab(products: snapshot.products)
              else if (_tab == 'reviews')
                _ReviewsTab(products: snapshot.products)
              else
                _DistributionTab(products: snapshot.products),
            ],
          ),
        ),
      ],
    );
  }
}
