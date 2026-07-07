import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_social_feed_page_sections.dart';
part '../widgets/staking_social_feed_page_common.dart';

class StakingSocialFeedPage extends ConsumerStatefulWidget {
  const StakingSocialFeedPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc387_info');
  static const composerKey = Key('sc387_composer');
  static const tabsKey = Key('sc387_tabs');
  static const feedKey = Key('sc387_feed');
  static const statsKey = Key('sc387_stats');
  static const footerKey = Key('sc387_footer');

  static Key postKey(String id) => Key('sc387_post_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSocialFeedPage> createState() =>
      _StakingSocialFeedPageState();
}

class _StakingSocialFeedPageState extends ConsumerState<StakingSocialFeedPage> {
  String? _activeTabId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingSocialFeedRepositoryProvider).getFeed();
    final activeTab = snapshot.tabs.firstWhere(
      (tab) => tab.id == (_activeTabId ?? snapshot.defaultTabId),
      orElse: () => snapshot.tabs.first,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-387 StakingSocialFeedPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: snapshot.title,
            subtitle: 'Cộng đồng stake — thông tin tham khảo',
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
 rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _Composer(placeholder: snapshot.composerPlaceholder),
                      _FeedTabs(
                        tabs: snapshot.tabs,
                        activeTabId: activeTab.id,
                        onChanged: (id) => setState(() => _activeTabId = id),
                      ),
                      _PostsSection(
                        title: activeTab.sectionTitle,
                        posts: snapshot.posts,
                      ),
                      _CommunityStats(stats: snapshot.stats),
                      _FooterNote(note: snapshot.footerNote),
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
