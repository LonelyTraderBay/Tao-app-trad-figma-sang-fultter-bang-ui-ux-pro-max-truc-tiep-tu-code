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

part '../widgets/product_governance_overview_tabs.dart';
part '../widgets/product_governance_products.dart';
part '../widgets/product_governance_reviews_distribution.dart';

const _govBackground = AppColors.bg;
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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollClearance =
        chromeInset +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.x6 + AppSpacing.x6
            : AppSpacing.x5 + AppSpacing.x5);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-100 ProductGovernancePage',
      child: Material(
        color: _govBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Product Governance',
            subtitle: 'MiFID II Oversight',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ProductGovernancePage.contentKey,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.rowPy,
                    right: AppSpacing.contentPad,
                    bottom: scrollClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.compact,
                    children: [
                      _ComplianceNotice(snapshot: snapshot),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        density: VitDensity.compact,
                        title: 'Product governance review',
                        message:
                            'Review target market, negative market, risk level, distribution channel, fee disclosure, and next review deadline before approving copy products.',
                        contractId: 'SC-100 product governance review',
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
