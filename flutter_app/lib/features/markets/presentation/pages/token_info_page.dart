import 'dart:math' as math;

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
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

part '../widgets/token_info_tabs_widgets.dart';
part '../widgets/token_info_market_widgets.dart';
part '../widgets/token_info_detail_widgets.dart';

const _marketPrimary = AppColors.primary;

enum _TokenInfoTab { overview, onchain, project }

class TokenInfoPage extends ConsumerStatefulWidget {
  const TokenInfoPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc045_token_info_content');
  static const overviewTabKey = Key('sc045_tab_overview');
  static const onchainTabKey = Key('sc045_tab_onchain');
  static const projectTabKey = Key('sc045_tab_project');
  static const chartButtonKey = Key('sc045_chart_button');

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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

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
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      customGap: 14,
                      children: [
                        if (_tab == _TokenInfoTab.overview)
                          _OverviewTab(snapshot: snapshot)
                        else if (_tab == _TokenInfoTab.onchain)
                          _OnchainTab(snapshot: snapshot)
                        else
                          _ProjectTab(snapshot: snapshot),
                        const _Disclaimer(),
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
