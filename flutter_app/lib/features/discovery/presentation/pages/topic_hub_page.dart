import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/discovery_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/topic_hub_header.dart';
part '../widgets/topic_hub_sections.dart';
part '../widgets/topic_hub_cards.dart';
part '../widgets/topic_hub_common.dart';

class TopicHubPage extends ConsumerStatefulWidget {
  const TopicHubPage({
    super.key,
    this.initialTopicId = 'crypto',
    this.useDetailEndpoint = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc284_topic_hub_content');
  static const topicRailKey = Key('sc284_topic_hub_rail');
  static const offlineKey = Key('sc284_topic_hub_offline');
  static const heroKey = Key('sc284_topic_hub_hero');
  static const predictionsSectionKey = Key('sc284_topic_hub_predictions');
  static const roomsSectionKey = Key('sc284_topic_hub_rooms');
  static const modesSectionKey = Key('sc284_topic_hub_modes');
  static const creatorsSectionKey = Key('sc284_topic_hub_creators');
  static const createRoomKey = Key('sc284_topic_hub_create_room');
  static const disclosureKey = Key('sc284_topic_hub_disclosure');
  static const searchActionKey = Key('sc284_topic_hub_search_action');

  static Key topicKey(String id) => Key('sc284_topic_$id');
  static Key predictionKey(String id) => Key('sc284_prediction_$id');
  static Key roomKey(String id) => Key('sc284_room_$id');
  static Key modeKey(String id) => Key('sc284_mode_$id');
  static Key creatorKey(String id) => Key('sc284_creator_$id');

  final String initialTopicId;
  final bool useDetailEndpoint;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TopicHubPage> createState() => _TopicHubPageState();
}

class _TopicHubPageState extends ConsumerState<TopicHubPage> {
  late String _selectedTopicId;

  @override
  void initState() {
    super.initState();
    _selectedTopicId = widget.initialTopicId;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(discoveryControllerProvider)
        .topicHub(
          topicId: _selectedTopicId,
          detailEndpoint: widget.useDetailEndpoint,
        );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-284 TopicHubPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
            actions: [
              VitHeaderActionItem(
                key: TopicHubPage.searchActionKey,
                type: VitHeaderActionType.search,
                onPressed: () => context.go(snapshot.searchRoute),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopicRail(
                topics: snapshot.topics,
                selectedTopicId: snapshot.selectedTopic.id,
                onSelect: (topicId) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedTopicId = topicId);
                },
              ),
              if (snapshot.showOfflineBanner)
                Padding(
                  key: TopicHubPage.offlineKey,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                  ),
                  child: VitOfflineBanner(
                    message: snapshot.staleMessage,
                    detail: snapshot.staleDetail,
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TopicHubPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x2,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: _TopicContent(snapshot: snapshot),
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
