import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/copy_audit_log_controls.dart';
part '../widgets/copy_audit_log_events.dart';
part '../widgets/copy_audit_log_summary.dart';

const _auditPrimary = AppColors.primary;
const _auditAmber = AppColors.caution;
const _auditPurple = AppColors.accent;
const _auditGreen = AppColors.buy;
const double _auditVisualScrollClearance = 108;
const double _auditNativeScrollClearance = 72;
const double _auditSpace = AppSpacing.x2;
const double _auditTinySpace = AppSpacing.x1;
const double _auditEventIconExtent = 36;
const double _auditSummaryCardExtent = 64;
const double _auditMetadataConfigExtent = 34;
const double _auditNoticeLineHeight = 1.22;
const double _auditTitleLineHeight = 1.12;
const double _auditBodyLineHeight = 1.22;
const double _auditMetaLineHeight = 1.05;
const double _auditSheetTitleLineHeight = 1.15;
const double _auditSheetActionExtent = 44;

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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _auditVisualScrollClearance
            : _auditNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: EdgeInsets.only(bottom: scrollEndClearance),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _ComplianceNotice(snapshot: snapshot),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review copy audit evidence',
                        message:
                            'Search, filter, and export audit evidence with retention, risk, and config-change context preserved.',
                        contractId: 'Copy ID: ${snapshot.copyId}',
                        density: VitDensity.compact,
                      ),
                      _AuditSearchField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                      ),
                      _AuditFilterTabs(
                        tabs: snapshot.tabs,
                        activeId: _activeFilter,
                        onChanged: (id) => setState(() => _activeFilter = id),
                      ),
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
                          if (event != events.last)
                            const SizedBox(height: _auditSpace),
                        ],
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
        borderRadius: AppRadii.sheetTopLargeRadius,
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: AppSpacing.copyAuditSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VitSheetHandle(),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  'Export Audit Log',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: _auditSheetTitleLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Chọn định dạng export',
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4 + AppSpacing.x1),
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
                    const SizedBox(height: AppSpacing.x3),
                ],
                const SizedBox(height: AppSpacing.rowPy),
                VitCtaButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  variant: VitCtaButtonVariant.secondary,
                  height: _auditSheetActionExtent,
                  child: const Text('Hủy'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
