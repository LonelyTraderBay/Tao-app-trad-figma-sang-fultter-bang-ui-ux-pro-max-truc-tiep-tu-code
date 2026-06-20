import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part '../widgets/token_info_tabs_widgets.dart';
part '../widgets/token_info_market_widgets.dart';
part '../widgets/token_info_detail_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _tokenInfoVisualScrollClearance = 108;
const double _tokenInfoNativeScrollClearance = 72;
const double _tokenInfoSectionGap = AppSpacing.x3;
const double _tokenInfoTabVerticalPadding = AppSpacing.x3;
const double _tokenInfoTabIndicatorHeight = AppSpacing.dividerHairline;
const double _tokenInfoTabIndicatorWidth = 96;
const double _tokenInfoHeroAvatar = AppSpacing.buttonCompact;
const double _tokenInfoHeroAvatarGap = AppSpacing.x3;
const double _tokenInfoHeroSubtitleGap = AppSpacing.x1;
const double _tokenInfoHeroPriceGap = AppSpacing.x3;
const double _tokenInfoInfoIcon = 14;
const double _tokenInfoInfoIconGap = AppSpacing.x2;
const double _tokenInfoSupplyProgressGap = AppSpacing.x2;
const double _tokenInfoSupplyProgressHeight = AppSpacing.x1;
const double _tokenInfoMetricGap = AppSpacing.x2;
const double _tokenInfoDonutSize = 70;
const double _tokenInfoDonutStroke = 16;
const double _tokenInfoDonutInset = 8;
const double _tokenInfoDistributionGap = AppSpacing.x3;
const double _tokenInfoDistributionDot = AppSpacing.x2;
const double _tokenInfoDistributionDotGap = AppSpacing.x2;
const double _tokenInfoRecordCardGap = AppSpacing.x2;
const double _tokenInfoRecordIcon = 14;
const double _tokenInfoRecordIconGap = AppSpacing.x1;
const double _tokenInfoRecordValueGap = AppSpacing.x2;
const double _tokenInfoRecordDeltaGap = AppSpacing.x2;
const double _tokenInfoChartIconBox = AppSpacing.buttonCompact;
const double _tokenInfoChartIconGap = AppSpacing.x3;
const double _tokenInfoChartSubtitleGap = AppSpacing.x1;
const double _tokenInfoOnchainIcon = AppSpacing.iconSm;
const double _tokenInfoOnchainIconGap = AppSpacing.x2;
const double _tokenInfoOnchainTitleGap = AppSpacing.x3;
const double _tokenInfoMiniStatGap = AppSpacing.x2;
const double _tokenInfoMiniStatValueGap = AppSpacing.x1;
const double _tokenInfoProjectTitleGap = AppSpacing.x2;
const double _tokenInfoProjectLinkGap = AppSpacing.x2;
const double _tokenInfoProjectLinkIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _tokenInfoProjectLinkIconGap = AppSpacing.x2;
const double _tokenInfoProjectLinkOpenIcon = 15;
const double _tokenInfoDisclaimerIcon = 14;
const double _tokenInfoDisclaimerIconGap = AppSpacing.x2;
const double _tokenInfoDisclaimerLineHeight = 1.25;
const EdgeInsets _tokenInfoHeroPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoInfoCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x3,
);
const EdgeInsets _tokenInfoInfoRowPadding = EdgeInsets.symmetric(
  vertical: AppSpacing.x2,
);
const EdgeInsets _tokenInfoSupplyCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoMetricLinePadding = EdgeInsets.symmetric(
  vertical: AppSpacing.x1,
);
const EdgeInsets _tokenInfoRecordCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoChartCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoOnchainCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoMiniStatPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoProjectCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoProjectLinkPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _tokenInfoDisclaimerPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);

enum _TokenInfoTab { overview, onchain, project }

class TokenInfoPage extends ConsumerStatefulWidget {
  const TokenInfoPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc045_token_info_content');
  static const overviewTabKey = Key('sc045_tab_overview');
  static const onchainTabKey = Key('sc045_tab_onchain');
  static const projectTabKey = Key('sc045_tab_project');
  static const chartButtonKey = Key('sc045_chart_button');
  static const marketStatsCardKey = Key('sc045_market_stats_card');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TokenInfoPage> createState() => _TokenInfoPageState();
}

class _TokenInfoPageState extends ConsumerState<TokenInfoPage> {
  _TokenInfoTab _tab = _TokenInfoTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getTokenInfo(widget.pairId);
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _tokenInfoVisualScrollClearance
            : _tokenInfoNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-045 TokenInfoPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: '${pair.baseAsset} - Thong tin',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.pairDetail(pair.id)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TokenTabs(
                active: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TokenInfoPage.contentKey,
                    padding: EdgeInsets.only(bottom: scrollEndClearance),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        if (_tab == _TokenInfoTab.overview)
                          _OverviewTab(snapshot: snapshot)
                        else if (_tab == _TokenInfoTab.onchain)
                          _OnchainTab(snapshot: snapshot)
                        else
                          _ProjectTab(snapshot: snapshot),
                        const _Disclaimer(),
                        const MarketBodyReviewSection(
                          title: 'Token state review',
                          message: 'Token information data reviewed',
                          detail:
                              'Overview, on-chain, project, chart link, empty, and refresh states remain visible.',
                          primary:
                              'Market metrics stay separated from project fundamentals.',
                          secondary:
                              'On-chain health remains informational before pair navigation.',
                          tertiary:
                              'Disclaimer content stays visible before the shared status review.',
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
