import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
part '../widgets/staking_earn_hero_tabs.dart';
part '../widgets/staking_earn_products.dart';
part '../widgets/staking_earn_positions_common.dart';

enum _EarnTab { products, positions }

enum _EarnFilter { all, fixed, flexible, defi }

class StakingEarnPage extends ConsumerStatefulWidget {
  const StakingEarnPage({
    super.key,
    this.shellRenderMode,
    this.route = StakingEarnRoute.earn,
  });

  static const productsTabKey = Key('sc327_tab_products');
  static const positionsTabKey = Key('sc327_tab_positions');
  static const savingsButtonKey = Key('sc327_savings_button');
  static Key filterKey(String filter) => Key('sc327_filter_$filter');
  static Key productKey(String id) => Key('sc327_product_$id');

  final ShellRenderMode? shellRenderMode;
  final StakingEarnRoute route;

  @override
  ConsumerState<StakingEarnPage> createState() => _StakingEarnPageState();
}

class _StakingEarnPageState extends ConsumerState<StakingEarnPage> {
  _EarnTab _tab = _EarnTab.products;
  _EarnFilter _filter = _EarnFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingEarnRepositoryProvider)
        .getStakingEarn(route: widget.route);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final products = _filteredProducts(snapshot.products, _filter);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.route == StakingEarnRoute.earn
          ? 'SC-327 StakingEarnPage'
          : 'SC-328 StakingEarnPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: VitInsetScrollView(
              physics: const ClampingScrollPhysics(),
              bottomInset: bottomInset,
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                gap: VitContentGap.defaultGap,
                density: VitDensity.compact,
                children: [
                  _EarnHero(snapshot: snapshot),
                  VitCtaButton(
                    key: StakingEarnPage.savingsButtonKey,
                    onPressed: () => context.go(snapshot.savingsRoute),
                    height: AppSpacing.inputHeight,
                    leading: const Icon(Icons.savings_outlined),
                    child: const Text('Tiet kiem'),
                  ),
                  if (snapshot.highRiskContractId != null)
                    VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Yield risk states active',
                      message:
                          'Terms, validator setup, risk preview, confirmation, receipt, management and support are tracked as one Earn contract.',
                      contractId: snapshot.highRiskContractId,
                    ),
                  _MainTabs(
                    activeTab: _tab,
                    positionCount: snapshot.positions.length,
                    onChanged: (tab) {
                      HapticFeedback.selectionClick();
                      setState(() => _tab = tab);
                    },
                  ),
                  if (_tab == _EarnTab.products) ...[
                    _FilterRow(
                      activeFilter: _filter,
                      onChanged: (filter) {
                        HapticFeedback.selectionClick();
                        setState(() => _filter = filter);
                      },
                    ),
                    _ProductList(products: products),
                  ] else
                    _PositionsList(
                      snapshot: snapshot,
                      onExploreProducts: () {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = _EarnTab.products);
                      },
                    ),
                  const _YieldDisclaimer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
