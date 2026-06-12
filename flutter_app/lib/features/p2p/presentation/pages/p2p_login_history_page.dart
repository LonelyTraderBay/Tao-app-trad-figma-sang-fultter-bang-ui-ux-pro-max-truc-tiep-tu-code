import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_login_history_summary_filters.dart';
part '../widgets/p2p_login_history_events.dart';
part '../widgets/p2p_login_history_common.dart';

class P2PLoginHistoryPage extends ConsumerStatefulWidget {
  const P2PLoginHistoryPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc257_p2p_login_history_stats');
  static const filtersKey = Key('sc257_p2p_login_history_filters');
  static const warningKey = Key('sc257_p2p_login_history_warning');
  static const eventsKey = Key('sc257_p2p_login_history_events');
  static const infoKey = Key('sc257_p2p_login_history_info');
  static const emptyKey = Key('sc257_p2p_login_history_empty');
  static const downloadKey = Key('sc257_p2p_login_history_download');

  static Key filterKey(String id) => Key('sc257_p2p_login_history_filter_$id');

  static Key eventKey(String id) => Key('sc257_p2p_login_history_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLoginHistoryPage> createState() =>
      _P2PLoginHistoryPageState();
}

class _P2PLoginHistoryPageState extends ConsumerState<P2PLoginHistoryPage> {
  String _filter = 'all';
  String? _expandedEventId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pLoginHistoryProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final filteredEvents = snapshot.events
        .where((event) {
          if (_filter == 'success') return event.status == 'success';
          if (_filter == 'suspicious') return event.isRiskEvent;
          return true;
        })
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-257 P2PLoginHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử đăng nhập',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                key: P2PLoginHistoryPage.downloadKey,
                type: VitHeaderActionType.export,
                onPressed: () => HapticFeedback.selectionClick(),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppModuleAccents.p2p,
                  backgroundColor: AppColors.surface2,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 120),
                    );
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.contentPad,
                        AppSpacing.x4,
                        AppSpacing.contentPad,
                        bottomInset,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _LoginStats(snapshot: snapshot),
                          const SizedBox(height: AppSpacing.x4),
                          _FilterTabs(
                            activeFilter: _filter,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _filter = value;
                                _expandedEventId = null;
                              });
                            },
                          ),
                          if (snapshot.riskEventCount > 0 &&
                              _filter != 'success') ...[
                            const SizedBox(height: AppSpacing.x4),
                            _RiskWarning(snapshot: snapshot),
                          ],
                          const SizedBox(height: AppSpacing.x4),
                          if (filteredEvents.isEmpty)
                            _EmptyState(snapshot: snapshot)
                          else
                            _LoginEventList(
                              events: filteredEvents,
                              expandedEventId: _expandedEventId,
                              onToggle: _toggleExpanded,
                            ),
                          const SizedBox(height: AppSpacing.x6),
                          _SecurityInfo(snapshot: snapshot),
                          VitPageContent(
                            padding: VitContentPadding.compact,
                            customGap: 0,
                            children: const [
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Login history state review',
                                message:
                                    'Risk filters, suspicious events, expanded session details, export action, and security guidance remain visible before acting on P2P account access.',
                                contractId: 'SC-257',
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _toggleExpanded(String eventId) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedEventId = _expandedEventId == eventId ? null : eventId;
    });
  }
}
