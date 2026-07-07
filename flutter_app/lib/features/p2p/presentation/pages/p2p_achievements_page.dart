import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_achievements_page_sections.dart';
part '../widgets/p2p_achievements_page_common.dart';

const double _p2pAchievementsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pAchievementsNativeNavClearance =
    _p2pAchievementsVisualNavClearance - AppSpacing.x4;
const double _p2pAchievementsVisualClearance = AppSpacing.x3;
const double _p2pAchievementsNativeClearance = AppSpacing.x2;

class P2PAchievementsPage extends ConsumerWidget {
  const P2PAchievementsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc275_p2p_achievements_summary');
  static const tradingLevelKey = Key('sc275_p2p_achievements_trading_level');

  static Key categoryKey(String id) => Key('sc275_p2p_achievements_cat_$id');

  static Key achievementKey(String id) =>
      Key('sc275_p2p_achievements_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pAchievementsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pAchievementsVisualNavClearance +
                  _p2pAchievementsVisualClearance
            : _p2pAchievementsNativeNavClearance +
                  _p2pAchievementsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-275 P2PAchievementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pAchievementsPageScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
   rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        _SummaryCard(snapshot: snapshot),
                        for (final category in snapshot.categories)
                          _AchievementCategory(
                            snapshot: snapshot,
                            category: category,
                          ),
                        _TradingLevelLink(snapshot: snapshot),
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
