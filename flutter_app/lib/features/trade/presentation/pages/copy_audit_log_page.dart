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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';

part '../widgets/copy_audit_log_controls.dart';
part '../widgets/copy_audit_log_events.dart';
part '../widgets/copy_audit_log_summary.dart';

const _auditPrimary = AppColors.primary;
const _auditAmber = AppColors.caution;
const _auditPurple = AppColors.accent;
const _auditGreen = AppColors.buy;
const _auditCard = AppColors.surface;
const _auditPanel = AppColors.surface2;
const _auditChip = AppColors.surface3;
const _auditMuted = AppColors.text3;

class CopyAuditLogPage extends ConsumerStatefulWidget {
  const CopyAuditLogPage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc077_copy_audit_log_content');
  static const searchFieldKey = Key('sc077_copy_audit_search');
  static const exportActionKey = Key('sc077_export_action');
  static const emptyStateKey = Key('sc077_empty_state');

  static Key tabKey(String id) => Key('sc077_tab_$id');
  static Key eventKey(String id) => Key('sc077_event_$id');
  static Key exportFormatKey(String id) => Key('sc077_export_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyAuditLogPage> createState() => _CopyAuditLogPageState();
}

class _CopyAuditLogPageState extends ConsumerState<CopyAuditLogPage> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopyAuditLog(copyId: widget.copyId);
    final events = _filteredEvents(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 118 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-077 CopyAuditLogPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Audit Log',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
            actions: [
              VitHeaderActionItem(
                key: CopyAuditLogPage.exportActionKey,
                type: VitHeaderActionType.export,
                onPressed: () => _showExportSheet(snapshot),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyAuditLogPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ComplianceNotice(snapshot: snapshot),
                      const SizedBox(height: 24),
                      _AuditSearchField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 25),
                      _AuditFilterTabs(
                        tabs: snapshot.tabs,
                        activeId: _activeFilter,
                        onChanged: (id) => setState(() => _activeFilter = id),
                      ),
                      const SizedBox(height: 24),
                      if (events.isEmpty)
                        _EmptyAuditState(
                          searching: _searchController.text.isNotEmpty,
                        )
                      else
                        for (final event in events) ...[
                          _AuditEventCard(
                            key: CopyAuditLogPage.eventKey(event.id),
                            event: event,
                          ),
                          if (event != events.last) const SizedBox(height: 10),
                        ],
                      const SizedBox(height: 24),
                      _SummarySection(events: snapshot.events),
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

  List<TradeCopyAuditEvent> _filteredEvents(
    TradeCopyAuditLogSnapshot snapshot,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    final activeTab = snapshot.tabs.firstWhere(
      (tab) => tab.id == _activeFilter,
      orElse: () => snapshot.tabs.first,
    );

    return snapshot.events.where((event) {
      if (activeTab.type != null && event.type != activeTab.type) {
        return false;
      }
      if (query.isEmpty) return true;
      final metadata = event.metadata;
      return event.title.toLowerCase().contains(query) ||
          event.description.toLowerCase().contains(query) ||
          event.id.toLowerCase().contains(query) ||
          (metadata?.pair?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void _showExportSheet(TradeCopyAuditLogSnapshot snapshot) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bg,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Export Audit Log',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chọn định dạng export',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                for (final format in snapshot.exportFormats) ...[
                  _ExportFormatButton(
                    key: CopyAuditLogPage.exportFormatKey(format.id),
                    format: format,
                    onTap: () {
                      ref
                          .read(tradeReadModelControllerProvider)
                          .createCopyAuditExport(
                            TradeCopyAuditExportRequest(
                              copyId: snapshot.copyId,
                              format: format.id,
                              filterId: _activeFilter,
                              searchQuery: _searchController.text,
                            ),
                          );
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                  if (format != snapshot.exportFormats.last)
                    const SizedBox(height: 8),
                ],
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: TextButton.styleFrom(
                    fixedSize: const Size.fromHeight(46),
                    backgroundColor: _auditChip,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: Text(
                    'Hủy',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
