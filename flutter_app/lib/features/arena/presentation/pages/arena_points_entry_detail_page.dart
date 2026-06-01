import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part '../widgets/arena_points_entry_detail_page_sections.dart';
part '../widgets/arena_points_entry_detail_page_common.dart';

class ArenaPointsEntryDetailPage extends ConsumerStatefulWidget {
  const ArenaPointsEntryDetailPage({
    super.key,
    required this.entryId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc200_entry_content');
  static const challengeLinkKey = Key('sc200_challenge_link');
  static const modeLinkKey = Key('sc200_mode_link');
  static const copyRefKey = Key('sc200_copy_ref');
  static const supportKey = Key('sc200_support');

  final String entryId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPointsEntryDetailPage> createState() =>
      _ArenaPointsEntryDetailPageState();
}

class _ArenaPointsEntryDetailPageState
    extends ConsumerState<ArenaPointsEntryDetailPage> {
  bool _copied = false;
  bool _supportOpened = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaPointsEntryDetail(widget.entryId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-200 ArenaPointsEntryDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết giao dịch điểm',
              subtitle: 'Arena Points · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaPointsEntryDetailPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: snapshot.entry == null
                      ? VitPageContent(
                          padding: VitContentPadding.none,
                          children: [
                            VitEmptyState(
                              icon: Icons.warning_amber_rounded,
                              title: snapshot.emptyTitle,
                              message: snapshot.emptySubtitle,
                            ),
                          ],
                        )
                      : VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: AppSpacing.x5,
                          children: [
                            _AmountHero(entry: snapshot.entry!),
                            _EntryDetails(entry: snapshot.entry!),
                            _BalanceCard(entry: snapshot.entry!),
                            _ReferenceCard(
                              entry: snapshot.entry!,
                              copied: _copied,
                              onCopy: () => _copyReference(snapshot.entry!),
                            ),
                            _AuditNotice(disclaimer: snapshot.disclaimer),
                            if (_supportOpened)
                              const VitStatusPill(
                                label: 'Hỗ trợ đã nhận yêu cầu',
                                status: VitStatusPillStatus.info,
                                size: VitStatusPillSize.md,
                              ),
                            _EntryActions(
                              entry: snapshot.entry!,
                              onSupport: () {
                                HapticFeedback.selectionClick();
                                setState(() => _supportOpened = true);
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyReference(ArenaPointsEntryDraft entry) {
    HapticFeedback.selectionClick();
    Clipboard.setData(ClipboardData(text: entry.refId));
    setState(() => _copied = true);
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaLedger);
  }
}
