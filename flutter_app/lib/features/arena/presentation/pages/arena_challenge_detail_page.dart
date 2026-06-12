import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_state_cards.dart';

part 'arena_challenge_detail_page_part_01.dart';
part 'arena_challenge_detail_page_part_02.dart';
part 'arena_challenge_detail_page_part_03.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _ChallengeTab { rules, evidence, participants, activity }

class ArenaChallengeDetailPage extends ConsumerStatefulWidget {
  const ArenaChallengeDetailPage({
    super.key,
    required this.challengeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc190_challenge_detail_content');
  static const modeLinkKey = Key('sc190_mode_link');
  static const creatorKey = Key('sc190_creator');
  static const safetyKey = Key('sc190_safety');
  static const predictionKey = Key('sc190_prediction');
  static const evidenceCtaKey = Key('sc190_evidence_cta');
  static const reportKey = Key('sc190_report');
  static const blockKey = Key('sc190_block');

  static Key tabKey(String id) => Key('sc190_tab_$id');

  final String challengeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaChallengeDetailPage> createState() =>
      _ArenaChallengeDetailPageState();
}

class _ArenaChallengeDetailPageState
    extends ConsumerState<ArenaChallengeDetailPage> {
  _ChallengeTab _activeTab = _ChallengeTab.rules;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      arenaChallengeDetailControllerProvider(widget.challengeId),
    );
    final snapshot = controller.state.snapshot;
    final pointsReview = controller.pointsReview();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-190 ArenaChallengeDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết challenge',
            subtitle: 'Thử thách · Open Arena',
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
                    key: ArenaChallengeDetailPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x5,
                      children: [
                        _ChallengeIntro(
                          snapshot: snapshot,
                          onMode: () => _go(
                            AppRoutePaths.arenaMode(snapshot.challenge.modeId),
                          ),
                        ),
                        _LiveStatusCard(challenge: snapshot.challenge),
                        ArenaChallengePointsReviewCard(review: pointsReview),
                        const _PoolFeeCard(),
                        _RewardCard(tiers: snapshot.rewardTiers),
                        _RefundCard(text: snapshot.challenge.refundPolicy),
                        _TeamsSection(teams: snapshot.teams),
                        _RuleSummaryCard(rows: snapshot.ruleRows),
                        _GovernanceCard(
                          challenge: snapshot.challenge,
                          rows: snapshot.governanceRows,
                        ),
                        _ClarityCard(score: snapshot.challenge.clarityScore),
                        _CreatorCard(
                          creator: snapshot.creator,
                          onTap: () => _go(
                            AppRoutePaths.arenaCreator(snapshot.creator.id),
                          ),
                        ),
                        _SafetyLinkCard(
                          onTap: () => _go(AppRoutePaths.arenaSafety),
                        ),
                        _Tabs(
                          active: _activeTab,
                          onChanged: (tab) => setState(() => _activeTab = tab),
                        ),
                        _TabContent(snapshot: snapshot, active: _activeTab),
                        _WarningStack(
                          warnings: [
                            'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính.',
                            'Không thỏa thuận giao dịch ngoài nền tảng.',
                          ],
                        ),
                        _PredictionBridgeCard(
                          contextDraft: snapshot.predictionContext,
                          onTap: () => _go(
                            AppRoutePaths.marketsPredictionEvent(
                              snapshot.predictionContext.eventId,
                            ),
                          ),
                        ),
                        _SafetySnapshotCard(
                          rows: snapshot.safetyRows,
                          onSafety: () => _go(AppRoutePaths.arenaSafety),
                        ),
                        _ActionStack(
                          onEvidence: _showEvidenceSheet,
                          onReport: _showReportSheet,
                          onBlock: _showBlockSheet,
                          onLeave: _showLeaveSheet,
                        ),
                        _CommunityRulesLink(
                          onTap: () => _go(AppRoutePaths.arenaSafety),
                        ),
                        const _ArenaFooterNotice(),
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

  void _showEvidenceSheet() => _showActionSheet(
    title: 'Gửi bằng chứng',
    icon: Icons.camera_alt_outlined,
    body:
        'Challenge này đang dùng API CoinGecko để chốt kết quả. Bạn vẫn có thể gửi ghi chú hoặc bằng chứng bổ sung nếu phát hiện sai lệch.',
  );

  void _showReportSheet() => _showActionSheet(
    title: 'Báo cáo challenge',
    icon: Icons.flag_outlined,
    body:
        'Báo cáo chỉ dùng cho nội dung, hành vi hoặc rule không rõ ràng. Không dùng để thay đổi kết quả nếu không có bằng chứng.',
  );

  void _showBlockSheet() => _showActionSheet(
    title: 'Chặn creator',
    icon: Icons.block_outlined,
    body:
        'Bạn sẽ không thấy lời mời hoặc room mới từ creator này trên bề mặt Open Arena.',
  );

  void _showLeaveSheet() => _showActionSheet(
    title: 'Rời challenge',
    icon: Icons.cancel_outlined,
    body:
        'Challenge đã bắt đầu nên entry points không được hoàn lại, trừ khi room bị void theo rule đã công bố.',
  );

  void _showActionSheet({
    required String title,
    required IconData icon,
    required String body,
  }) {
    HapticFeedback.selectionClick();
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x5,
            AppSpacing.x5,
            AppSpacing.x5,
            AppSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBubble(icon: icon, color: _arenaAccent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              Text(
                body,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.arenaChallengeBodyLineHeight,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
              VitCtaButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đã hiểu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
