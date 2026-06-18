import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_actions.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_hero.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_prediction.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_quality.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_related.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_rules.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class ArenaModeDetailPage extends ConsumerStatefulWidget {
  const ArenaModeDetailPage({
    super.key,
    required this.modeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc189_mode_detail_content');
  static const creatorKey = Key('sc189_creator');
  static const trustKey = Key('sc189_trust');
  static const infoKey = Key('sc189_info');
  static const useModeKey = Key('sc189_use_mode');
  static const createRoomKey = Key('sc189_create_room');
  static const predictionKey = Key('sc189_prediction_context');

  static Key roomKey(String id) => Key('sc189_room_$id');
  static Key relatedModeKey(String id) => Key('sc189_related_mode_$id');

  final String modeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaModeDetailPage> createState() =>
      _ArenaModeDetailPageState();
}

class _ArenaModeDetailPageState extends ConsumerState<ArenaModeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaModeDetail(widget.modeId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-189 ArenaModeDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.mode.title,
            subtitle: 'Chế độ chơi · Open Arena',
            showBack: true,
            onBack: _close,
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
                    key: ArenaModeDetailPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.arenaBottomScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x5,
                      children: [
                        VitCard(
                          padding: AppSpacing.zeroInsets,
                          child: ArenaModeHero(
                            creatorKey: ArenaModeDetailPage.creatorKey,
                            trustKey: ArenaModeDetailPage.trustKey,
                            snapshot: snapshot,
                            onCreator: () => _go(
                              AppRoutePaths.arenaCreator(snapshot.creator.id),
                            ),
                            onTrust: () => _go(
                              AppRoutePaths.arenaTrust(snapshot.creator.id),
                            ),
                          ),
                        ),
                        VitCard(
                          padding: AppSpacing.zeroInsets,
                          child: ArenaModeDescriptionCard(
                            description: snapshot.mode.description,
                          ),
                        ),
                        VitCard(
                          padding: AppSpacing.zeroInsets,
                          child: ArenaModeRulesSummary(rows: snapshot.ruleRows),
                        ),
                        ArenaModeQualitySection(
                          infoKey: ArenaModeDetailPage.infoKey,
                          metrics: snapshot.qualityMetrics,
                          onInfo: _showTrustSheet,
                        ),
                        ArenaModeActions(
                          useModeKey: ArenaModeDetailPage.useModeKey,
                          createRoomKey: ArenaModeDetailPage.createRoomKey,
                          onUseMode: () => _go(AppRoutePaths.arenaStudio),
                          onCreateRoom: () => _go(AppRoutePaths.arenaStudio),
                        ),
                        if (snapshot.relatedRooms.isNotEmpty)
                          ArenaModeRelatedRooms(
                            roomKey: ArenaModeDetailPage.roomKey,
                            rooms: snapshot.relatedRooms,
                            onRoom: (id) =>
                                _go(AppRoutePaths.arenaChallenge(id)),
                          ),
                        if (snapshot.relatedModes.isNotEmpty)
                          ArenaModeRelatedModes(
                            relatedModeKey: ArenaModeDetailPage.relatedModeKey,
                            modes: snapshot.relatedModes,
                            onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                          ),
                        ArenaModePredictionContext(
                          predictionKey: ArenaModeDetailPage.predictionKey,
                          contextDraft: snapshot.predictionContext,
                          onTap: () => _go(
                            AppRoutePaths.marketsPredictionEvent(
                              snapshot.predictionContext.eventId,
                            ),
                          ),
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

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }

  void _showTrustSheet() {
    HapticFeedback.selectionClick();
    final snapshot = ref
        .read(arenaReadModelControllerProvider)
        .getArenaModeDetail(widget.modeId);

    showVitBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .55),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => ArenaModeTrustSheet(snapshot: snapshot),
    );
  }
}
