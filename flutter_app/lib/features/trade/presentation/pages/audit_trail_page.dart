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
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _auditBackground = AppColors.bg;
const _auditPanel = AppColors.surface;
const _auditPanel2 = AppColors.surface2;
const _auditTabsBackground = AppColors.surface;
const _auditBorder = AppColors.borderSolid;
const _auditPrimary = AppColors.primary;
const _auditGreen = Color(0xFF10B981);
const _auditAmber = Color(0xFFF59E0B);

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
    final snapshot = ref.watch(tradeRepositoryProvider).getAuditTrail();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Audit Trail',
              subtitle: 'MiFID II Record-Keeping',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              trailing: const _HeaderDownloadButton(),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: AuditTrailPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 26, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ComplianceNotice(snapshot: snapshot),
                    const SizedBox(height: 39),
                    _StatsRow(stats: snapshot.stats),
                    const SizedBox(height: 26),
                    _SearchAndFilter(
                      placeholder: snapshot.searchPlaceholder,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    const SizedBox(height: 24),
                    _AuditTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTab,
                      onChanged: (id) => setState(() => _activeTab = id),
                    ),
                    const SizedBox(height: 27),
                    const _SectionLabel('Audit Log'),
                    const SizedBox(height: 11),
                    for (final entry in entries) ...[
                      _AuditEntryCard(entry: entry),
                      if (entry != entries.last) const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 24),
                    _ExportActions(formats: snapshot.exportFormats),
                  ],
                ),
              ),
            ),
          ],
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

class _HeaderDownloadButton extends StatelessWidget {
  const _HeaderDownloadButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _auditPanel2,
          border: Border.all(color: _auditBorder.withValues(alpha: .65)),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: 19,
          ),
        ),
      ),
    );
  }
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeAuditTrailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.description_outlined,
            color: AppColors.text1,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.noticeTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                snapshot.noticeDescription,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<TradeAuditStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: 13),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final TradeAuditStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 11),
      decoration: BoxDecoration(
        color: _auditPanel,
        border: Border.all(color: _auditBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            stat.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.emphasized ? _auditGreen : AppColors.text1,
              fontSize: 21,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 39,
            child: TextField(
              key: AuditTrailPage.searchKey,
              onChanged: onChanged,
              cursorColor: _auditPrimary,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 1.2,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(0, 11, 12, 11),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 39,
                  minHeight: 39,
                ),
                hintText: placeholder,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                ),
                filled: true,
                fillColor: _auditPanel2,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: BorderSide(
                    color: _auditBorder.withValues(alpha: .82),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: BorderSide(
                    color: _auditBorder.withValues(alpha: .82),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: const BorderSide(color: _auditPrimary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 39,
          height: 39,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _auditPanel2,
              border: Border.all(color: _auditBorder.withValues(alpha: .82)),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: AppColors.text3,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuditTabs extends StatelessWidget {
  const _AuditTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _auditTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: AuditTrailPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _auditPrimary
                                : AppColors.text3,
                            fontSize: tab.id == 'client' ? 11 : 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: tab.id == activeId
                          ? _auditPrimary
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _auditPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _AuditEntryCard extends StatelessWidget {
  const _AuditEntryCard({required this.entry});

  final TradeAuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final style = _styleForCategory(entry.category);
    return Container(
      constraints: const BoxConstraints(minHeight: 89),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _auditPanel,
        border: Border.all(color: _auditBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.action,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    _CategoryBadge(entry: entry, color: style.color),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  entry.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _metadata(entry),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'ID: ${entry.id}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 8,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _metadata(TradeAuditEntry entry) {
    final parts = [
      entry.timestampLabel,
      if (entry.user != null) entry.user!,
      if (entry.ipAddress != null) entry.ipAddress!,
    ];
    return parts.join('  \u2022  ');
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.entry, required this.color});

  final TradeAuditEntry entry;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        entry.categoryLabel,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ExportActions extends StatelessWidget {
  const _ExportActions({required this.formats});

  final List<String> formats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final format in formats) ...[
          Expanded(
            child: SizedBox(
              height: 40,
              child: OutlinedButton.icon(
                key: AuditTrailPage.exportKey(format),
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 14),
                label: Text(
                  format,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _auditPanel2,
                  foregroundColor: AppColors.text1,
                  side: BorderSide(color: _auditBorder.withValues(alpha: .82)),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                ),
              ),
            ),
          ),
          if (format != formats.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

_AuditCategoryStyle _styleForCategory(TradeAuditCategory category) {
  return switch (category) {
    TradeAuditCategory.trade => const _AuditCategoryStyle(
      color: _auditGreen,
      icon: Icons.trending_up_rounded,
    ),
    TradeAuditCategory.compliance => const _AuditCategoryStyle(
      color: _auditPrimary,
      icon: Icons.description_outlined,
    ),
    TradeAuditCategory.clientAction => const _AuditCategoryStyle(
      color: _auditAmber,
      icon: Icons.person_outline_rounded,
    ),
    TradeAuditCategory.system => const _AuditCategoryStyle(
      color: AppColors.text3,
      icon: Icons.schedule_rounded,
    ),
  };
}

final class _AuditCategoryStyle {
  const _AuditCategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
