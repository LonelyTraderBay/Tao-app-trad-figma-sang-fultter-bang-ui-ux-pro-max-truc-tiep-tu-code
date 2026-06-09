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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/audit_trail_page_sections.dart';
part '../widgets/audit_trail_page_common.dart';

const _auditBackground = AppColors.bg;
const _auditPanel2 = AppColors.surface2;
const _auditTabsBackground = AppColors.surface;
const _auditBorder = AppColors.borderSolid;
const _auditPrimary = AppColors.primary;
const _auditGreen = AppColors.buy;
const _auditAmber = AppColors.caution;

class AuditTrailPage extends ConsumerStatefulWidget {
  const AuditTrailPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc115_audit_trail_content');
  static const searchKey = Key('sc115_audit_trail_search');
  static Key tabKey(String id) => Key('sc115_audit_trail_tab_$id');
  static Key exportKey(String format) =>
      Key('sc115_audit_trail_export_$format');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AuditTrailPage> createState() => _AuditTrailPageState();
}

class _AuditTrailPageState extends ConsumerState<AuditTrailPage> {
  String _activeTab = 'all';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getAuditTrail();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 38
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;
    final entries = _filteredEntries(snapshot.entries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-115 AuditTrailPage',
      child: Material(
        color: _auditBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Audit Trail',
            subtitle: 'MiFID II Record-Keeping',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            actions: const [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: null,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: AuditTrailPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 26, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 14,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review audit trail export',
                        message:
                            'Confirm record scope, retention limits, client identifiers, and next steps before exporting audit evidence.',
                      ),
                      _ComplianceNotice(snapshot: snapshot),
                      _StatsRow(stats: snapshot.stats),
                      _SearchAndFilter(
                        placeholder: snapshot.searchPlaceholder,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      _AuditTabs(
                        tabs: snapshot.tabs,
                        activeId: _activeTab,
                        onChanged: (id) => setState(() => _activeTab = id),
                      ),
                      const _SectionLabel('Audit Log'),
                      for (final entry in entries)
                        _AuditEntryCard(entry: entry),
                      _ExportActions(formats: snapshot.exportFormats),
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

  List<TradeAuditEntry> _filteredEntries(List<TradeAuditEntry> entries) {
    return entries.where((entry) {
      final matchesTab = switch (_activeTab) {
        'trades' => entry.category == TradeAuditCategory.trade,
        'compliance' => entry.category == TradeAuditCategory.compliance,
        'client' => entry.category == TradeAuditCategory.clientAction,
        _ => true,
      };
      if (!matchesTab) return false;
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return entry.action.toLowerCase().contains(query) ||
          entry.details.toLowerCase().contains(query) ||
          entry.id.toLowerCase().contains(query);
    }).toList();
  }
}
