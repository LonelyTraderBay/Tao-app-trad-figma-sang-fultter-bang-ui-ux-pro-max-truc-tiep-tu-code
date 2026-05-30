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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

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
        child: Column(
          children: [
            VitHeader(
              title: 'Audit Log',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
              trailing: _ExportHeaderButton(
                onTap: () => _showExportSheet(snapshot),
              ),
            ),
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
    showModalBottomSheet<void>(
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

class _ExportHeaderButton extends StatelessWidget {
  const _ExportHeaderButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyAuditLogPage.exportActionKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _auditChip,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Icon(
          Icons.file_download_outlined,
          color: AppColors.text1,
          size: 21,
        ),
      ),
    );
  }
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeCopyAuditLogSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _auditPrimary.withValues(alpha: .08),
        border: Border.all(color: _auditPrimary),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _auditPrimary, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.complianceDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditSearchField extends StatelessWidget {
  const _AuditSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _auditChip,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _auditMuted, size: 19),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              key: CopyAuditLogPage.searchFieldKey,
              controller: controller,
              onChanged: onChanged,
              cursorColor: _auditPrimary,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: AppTextStyles.medium,
                height: 1,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Tìm kiếm event, pair, ID...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: _auditMuted,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditFilterTabs extends StatelessWidget {
  const _AuditFilterTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeCopyAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tab in tabs) ...[
          _AuditFilterPill(
            key: CopyAuditLogPage.tabKey(tab.id),
            tab: tab,
            active: tab.id == activeId,
            onTap: () => onChanged(tab.id),
          ),
          if (tab != tabs.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _AuditFilterPill extends StatelessWidget {
  const _AuditFilterPill({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeCopyAuditTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: _tabWidth(tab.id),
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _auditPrimary.withValues(alpha: .14) : _auditChip,
          borderRadius: AppRadii.lgRadius,
          border: Border.all(
            color: active ? _auditPrimary : AppColors.transparent,
          ),
        ),
        child: Text(
          tab.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _auditPrimary : _auditMuted,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }

  double _tabWidth(String id) {
    return switch (id) {
      'all' => 69,
      'trade' => 73,
      'config' => 74,
      'risk' => 61,
      'system' => 82,
      _ => 68,
    };
  }
}

class _AuditEventCard extends StatelessWidget {
  const _AuditEventCard({super.key, required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _auditCard,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: Icon(_eventIcon(event), color: color, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                _EventMetaRow(event: event, color: color),
                if (_hasVisibleMetadata(event)) ...[
                  const SizedBox(height: 13),
                  _EventMetadataPanel(event: event),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetaRow extends StatelessWidget {
  const _EventMetaRow({required this.event, required this.color});

  final TradeCopyAuditEvent event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded, color: AppColors.text3, size: 11),
        const SizedBox(width: 5),
        Text(
          event.timestamp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        _TypeBadge(type: event.type, color: color),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.color});

  final TradeCopyAuditEventType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _eventTypeLabel(type),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _EventMetadataPanel extends StatelessWidget {
  const _EventMetadataPanel({required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final metadata = event.metadata!;
    if (event.type == TradeCopyAuditEventType.config) {
      return Container(
        height: 29,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _auditPanel,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '${metadata.oldValue} → ${metadata.newValue}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
      decoration: BoxDecoration(
        color: _auditPanel,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Provider Price',
                  value: _formatUsd(metadata.providerPrice ?? 0),
                ),
              ),
              Expanded(
                child: _MetadataValue(
                  label: 'Your Price',
                  value: _formatUsd(metadata.yourPrice ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Slippage',
                  value: '${(metadata.slippagePct ?? 0).toStringAsFixed(2)}%',
                  valueColor: _auditAmber,
                ),
              ),
              if (metadata.pnl != null)
                Expanded(
                  child: _MetadataValue(
                    label: 'P/L',
                    value: _formatSignedUsd(metadata.pnl!),
                    valueColor: metadata.pnl! >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetadataValue extends StatelessWidget {
  const _MetadataValue({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyAuditState extends StatelessWidget {
  const _EmptyAuditState({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: CopyAuditLogPage.emptyStateKey,
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            searching ? 'Không tìm thấy event phù hợp' : 'Chưa có event nào',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.events});

  final List<TradeCopyAuditEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Thống kê tổng quan',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total Events',
                value: '${events.length}',
                color: AppColors.text1,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                label: 'Trades',
                value: '${_count(events, TradeCopyAuditEventType.trade)}',
                color: _auditPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Config Changes',
                value: '${_count(events, TradeCopyAuditEventType.config)}',
                color: _auditPurple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                label: 'Risk Alerts',
                value: '${_count(events, TradeCopyAuditEventType.risk)}',
                color: AppColors.sell,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static int _count(
    List<TradeCopyAuditEvent> events,
    TradeCopyAuditEventType type,
  ) {
    return events.where((event) => event.type == type).length;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _auditPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportFormatButton extends StatelessWidget {
  const _ExportFormatButton({
    super.key,
    required this.format,
    required this.onTap,
  });

  final TradeCopyAuditExportFormat format;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _auditChip,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    format.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.file_download_outlined,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

bool _hasVisibleMetadata(TradeCopyAuditEvent event) {
  final metadata = event.metadata;
  if (metadata == null) return false;
  if (event.type == TradeCopyAuditEventType.config) {
    return metadata.oldValue != null || metadata.newValue != null;
  }
  return metadata.providerPrice != null ||
      metadata.yourPrice != null ||
      metadata.slippagePct != null ||
      metadata.pnl != null;
}

IconData _eventIcon(TradeCopyAuditEvent event) {
  return switch (event.type) {
    TradeCopyAuditEventType.trade => Icons.show_chart_rounded,
    TradeCopyAuditEventType.config => Icons.settings_outlined,
    TradeCopyAuditEventType.risk => Icons.error_outline_rounded,
    TradeCopyAuditEventType.system => Icons.check_circle_outline_rounded,
  };
}

Color _eventColor(TradeCopyAuditEvent event) {
  if (event.severity == TradeCopyAuditSeverity.critical) {
    return AppColors.sell;
  }
  if (event.severity == TradeCopyAuditSeverity.warning) {
    return _auditAmber;
  }
  return switch (event.type) {
    TradeCopyAuditEventType.trade => _auditPrimary,
    TradeCopyAuditEventType.config => _auditPurple,
    TradeCopyAuditEventType.risk => AppColors.sell,
    TradeCopyAuditEventType.system => _auditGreen,
  };
}

String _eventTypeLabel(TradeCopyAuditEventType type) {
  return switch (type) {
    TradeCopyAuditEventType.trade => 'TRADE',
    TradeCopyAuditEventType.config => 'CONFIG',
    TradeCopyAuditEventType.risk => 'RISK',
    TradeCopyAuditEventType.system => 'SYSTEM',
  };
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value.round())}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatNumber(value.abs().round())}';
}

String _formatNumber(int value) {
  final chars = value.toString().split('').reversed.toList();
  final groups = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    groups.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return groups.reversed.join(',');
}
