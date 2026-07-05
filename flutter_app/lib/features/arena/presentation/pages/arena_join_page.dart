import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part '../widgets/arena_join_page_sections.dart';
part '../widgets/arena_join_page_common.dart';

const _arenaAccent = AppModuleAccents.arena;
const _joinAcknowledgementLineRatio =
    AppSpacing.arenaJoinAcknowledgementLineHeight;
const _joinBodyLineRatio = AppSpacing.arenaJoinBodyLineHeight;
const _joinNoticeLineRatio = AppSpacing.arenaJoinNoticeLineHeight;

class ArenaJoinPage extends ConsumerStatefulWidget {
  const ArenaJoinPage({
    super.key,
    required this.challengeId,
    this.shellRenderMode,
  });

  final String challengeId;
  final ShellRenderMode? shellRenderMode;

  static const contentKey = Key('sc191_join_content');
  static const safetyPolicyKey = Key('sc191_safety_policy');
  static const rulesCheckboxKey = Key('sc191_rules_checkbox');
  static const pointsCheckboxKey = Key('sc191_points_checkbox');
  static const confirmKey = Key('sc191_confirm_join');
  static const declineKey = Key('sc191_decline_join');

  @override
  ConsumerState<ArenaJoinPage> createState() => _ArenaJoinPageState();
}

class _ArenaJoinPageState extends ConsumerState<ArenaJoinPage> {
  bool _readRules = false;
  bool _understandPoints = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      arenaJoinControllerProvider(widget.challengeId),
    );
    final snapshot = controller.state.snapshot;
    final challenge = snapshot.challenge;
    final hasEnough = snapshot.currentBalance >= challenge.entryPoints;
    final remainingBalance = snapshot.currentBalance - challenge.entryPoints;
    final canJoin = controller.canJoin(
      readRules: _readRules,
      understandPoints: _understandPoints,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-191 ArenaJoinPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tham gia thử thách',
            subtitle: 'Xác nhận · Open Arena',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ArenaJoinPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.arenaBottomScrollPadding(footerPadding),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: DeviceMetrics.width,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: [
                        _ChallengeSummaryCard(challenge: challenge),
                        _SafetyPolicyLink(
                          onTap: () => _go(AppRoutePaths.arenaSafety),
                        ),
                        _AcknowledgementStack(
                          readRules: _readRules,
                          understandPoints: _understandPoints,
                          onRules: () => _toggleRules(),
                          onPoints: () => _togglePoints(),
                        ),
                        _BalanceCard(
                          currentBalance: snapshot.currentBalance,
                          entryPoints: challenge.entryPoints,
                          remainingBalance: remainingBalance,
                          hasEnough: hasEnough,
                        ),
                        _JoinContextCard(
                          challenge: challenge,
                          creator: snapshot.creator,
                        ),
                        _RulesCard(rules: snapshot.rules),
                        _NoticeCard(text: snapshot.refundNotice),
                        _ActionStack(
                          entryPoints: challenge.entryPoints,
                          canJoin: canJoin,
                          onConfirm: _confirmJoin,
                          onDecline: _decline,
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

  void _toggleRules() {
    HapticFeedback.selectionClick();
    setState(() => _readRules = !_readRules);
  }

  void _togglePoints() {
    HapticFeedback.selectionClick();
    setState(() => _understandPoints = !_understandPoints);
  }

  void _confirmJoin() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.arenaChallenge(widget.challengeId));
  }

  void _decline() {
    HapticFeedback.selectionClick();
    _close();
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
    context.go(AppRoutePaths.arenaChallenge(widget.challengeId));
  }
}
