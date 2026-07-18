import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/widgets/settings/trade_bot_radio_icon.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../widgets/settings/bot_emergency_stop_page_sections.dart';
part '../../widgets/settings/bot_emergency_stop_page_common.dart';

const _stopPrimary = AppColors.primary;
const _stopGreen = AppColors.buy;
const _stopRed = AppColors.sell;
const _stopOptionBorder = AppColors.borderSolid;

class BotEmergencyStopPage extends ConsumerStatefulWidget {
  const BotEmergencyStopPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc121_bot_emergency_stop_content');
  static const cancelKey = Key('sc121_bot_emergency_stop_cancel');
  static const submitKey = Key('sc121_bot_emergency_stop_submit');
  static const closePositionsKey = Key(
    'sc121_bot_emergency_stop_close_positions',
  );
  static const confirmationKey = Key('sc121_bot_emergency_stop_confirm');

  static Key reasonKey(String reasonId) =>
      Key('sc121_bot_emergency_stop_reason_$reasonId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEmergencyStopPage> createState() =>
      _BotEmergencyStopPageState();
}

class _BotEmergencyStopPageState extends ConsumerState<BotEmergencyStopPage> {
  String? _reasonId;
  bool _closePositions = false;
  bool _confirmed = false;
  bool _stopping = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeBotEmergencyStopControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const stickyActionsHeight = AppSpacing.inputHeight + AppSpacing.x4;
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        stickyActionsHeight;

    return VitTradeDetailScaffold(
      title: 'Emergency Stop',
      subtitle: 'Dừng khẩn cấp tất cả bot đang chạy',
      semanticLabel: 'Dừng khẩn cấp toàn bộ bot giao dịch',
      semanticIdentifier: 'SC-121',
      contentKey: BotEmergencyStopPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      bottomInset: scrollEndClearance,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      footer: _StickyActions(
        bottomPadding:
            AppSpacing.contentPad + MediaQuery.paddingOf(context).bottom,
        canSubmit: _reasonId != null && _confirmed && !_stopping,
        stopping: _stopping,
        onCancel: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeBots,
          mode: BackNavigationMode.historyThenFallback,
        ),
        onSubmit: _submit,
      ),
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu dừng khẩn cấp',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeBotEmergencyStopSnapshotProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          return [
            VitBotSubpageHero(
              primaryLabel: 'Bot cần dừng',
              primaryValue: '${snapshot.bots.length}',
              primaryColor: _stopRed,
              secondaryLabel: 'Lý do',
              secondaryValue: _reasonId == null ? '—' : 'Đã chọn',
              secondaryColor: _reasonId == null ? AppColors.text3 : _stopGreen,
            ),
            VitTradeSection(
              title: 'Cảnh báo khẩn cấp',
              child: _WarningBanner(snapshot: snapshot),
            ),
            VitTradeSection(
              title: 'Bots to Stop (${snapshot.bots.length})',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final bot in snapshot.bots) _BotCard(bot: bot)],
              ),
            ),
            VitTradeSection(
              title: 'Reason for Emergency Stop',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final reason in snapshot.reasons)
                    _ReasonOption(
                      reason: reason,
                      selected: reason.id == _reasonId,
                      onTap: () => setState(() => _reasonId = reason.id),
                    ),
                ],
              ),
            ),
            VitTradeSection(
              title: 'Additional Actions',
              child: _CheckActionCard(
                key: BotEmergencyStopPage.closePositionsKey,
                selected: _closePositions,
                title: snapshot.closePositionsTitle,
                description: snapshot.closePositionsDescription,
                danger: false,
                onTap: () {
                  setState(() => _closePositions = !_closePositions);
                },
              ),
            ),
            VitTradeSection(
              title: 'Confirmation',
              child: _CheckActionCard(
                key: BotEmergencyStopPage.confirmationKey,
                selected: _confirmed,
                title: snapshot.confirmationTitle,
                description: snapshot.confirmationDescription,
                danger: true,
                onTap: () => setState(() => _confirmed = !_confirmed),
              ),
            ),
            VitTradeSection(
              title: 'Hỗ trợ',
              child: _SupportNotice(snapshot: snapshot),
            ),
            const VitBotRiskReviewFooter(
              title: 'Emergency stop review',
              message:
                  'Selected bots, reason, close-position choice, confirmation, risk impact and next step are reviewed before the stop request is submitted.',
              contractId: 'bot-emergency-stop-review',
            ),
          ];
        },
      ),
    );
  }

  Future<void> _submit() async {
    final controller = ref.read(tradeBotEmergencyStopControllerProvider).value;
    if (controller == null ||
        !controller.canSubmit(reasonId: _reasonId, confirmed: _confirmed) ||
        _stopping) {
      return;
    }
    setState(() => _stopping = true);
    final result = await controller.submit(
      TradeBotEmergencyStopDraft(
        reasonId: _reasonId!,
        closePositions: _closePositions,
        confirmed: _confirmed,
      ),
    );
    if (!mounted) return;
    context.go(result.redirectPath);
  }
}
