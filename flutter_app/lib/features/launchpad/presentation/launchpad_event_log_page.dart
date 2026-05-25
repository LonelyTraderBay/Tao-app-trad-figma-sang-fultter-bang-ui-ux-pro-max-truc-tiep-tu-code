import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

class LaunchpadEventLogPage extends ConsumerStatefulWidget {
  const LaunchpadEventLogPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc307_launchpad_event_log_content');
  static const searchKey = Key('sc307_launchpad_event_log_search');
  static const levelsKey = Key('sc307_launchpad_event_log_levels');
  static const actionsKey = Key('sc307_launchpad_event_log_actions');
  static const sourcesKey = Key('sc307_launchpad_event_log_sources');
  static const eventListKey = Key('sc307_launchpad_event_log_list');
  static const emptyKey = Key('sc307_launchpad_event_log_empty');
  static const selectAllKey = Key('sc307_launchpad_event_log_select_all');
  static const exportButtonKey = Key('sc307_launchpad_event_log_export');
  static const exportSheetKey = Key('sc307_launchpad_event_log_export_sheet');
  static const copyButtonKey = Key('sc307_launchpad_event_log_copy');

  static Key levelKey(String value) =>
      Key('sc307_launchpad_event_log_level_$value');
  static Key sourceKey(String value) =>
      Key('sc307_launchpad_event_log_source_$value');
  static Key eventKey(String id) => Key('sc307_launchpad_event_log_event_$id');
  static Key eventSelectKey(String id) =>
      Key('sc307_launchpad_event_log_select_$id');
  static Key eventExpandKey(String id) =>
      Key('sc307_launchpad_event_log_expand_$id');
  static Key formatKey(String value) =>
      Key('sc307_launchpad_event_log_format_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadEventLogPage> createState() =>
      _LaunchpadEventLogPageState();
}

class _LaunchpadEventLogPageState extends ConsumerState<LaunchpadEventLogPage> {
  final _searchController = TextEditingController();
  var _searchQuery = '';
  var _levelFilter = 'all';
  var _sourceFilter = 'all';
  var _showSourceFilters = false;
  var _showExportSheet = false;
  var _exportFormat = 'text';
  var _copied = false;
  String? _expandedEventId;
  final Set<String> _selectedEventIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getEventLog();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final filteredEvents = _filteredEvents(snapshot.events);
    final exportEvents = _selectedEventIds.isEmpty
        ? filteredEvents
        : filteredEvents
              .where((event) => _selectedEventIds.contains(event.id))
              .toList();
    final sources = _sources(snapshot.events);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-307 LaunchpadEventLogPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: LaunchpadEventLogPage.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.defaultPadding,
                        customGap: AppSpacing.x4,
                        children: [
                          _SearchField(
                            controller: _searchController,
                            query: _searchQuery,
                            onChanged: (value) => setState(() {
                              _searchQuery = value;
                              _selectedEventIds.clear();
                            }),
                            onClear: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _selectedEventIds.clear();
                            }),
                          ),
                          _LevelFilterBar(
                            events: snapshot.events,
                            activeValue: _levelFilter,
                            onChanged: (value) => setState(() {
                              _levelFilter = value;
                              _selectedEventIds.clear();
                            }),
                          ),
                          _ActionBar(
                            sourceLabel: _sourceFilter == 'all'
                                ? 'Nguon'
                                : _sourceFilter,
                            sourceOpen: _showSourceFilters,
                            selectedAll:
                                filteredEvents.isNotEmpty &&
                                _selectedEventIds.length ==
                                    filteredEvents.length,
                            exportCount: exportEvents.length,
                            onToggleSources: () => setState(
                              () => _showSourceFilters = !_showSourceFilters,
                            ),
                            onToggleSelectAll: () =>
                                _toggleSelectAll(filteredEvents),
                            onExport: () =>
                                setState(() => _showExportSheet = true),
                          ),
                          if (_showSourceFilters)
                            _SourceFilterCard(
                              sources: sources,
                              activeValue: _sourceFilter,
                              onChanged: (value) => setState(() {
                                _sourceFilter = value;
                                _showSourceFilters = false;
                                _selectedEventIds.clear();
                              }),
                            ),
                          if (filteredEvents.isEmpty)
                            const _EmptyEvents()
                          else
                            _EventList(
                              events: filteredEvents,
                              selectedIds: _selectedEventIds,
                              expandedId: _expandedEventId,
                              onSelect: _toggleEventSelection,
                              onExpand: (id) => setState(() {
                                _expandedEventId = _expandedEventId == id
                                    ? null
                                    : id;
                              }),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showExportSheet)
              Positioned.fill(
                child: _ExportSheet(
                  formats: snapshot.exportFormats,
                  activeFormat: _exportFormat,
                  count: exportEvents.length,
                  copied: _copied,
                  onFormatChanged: (value) =>
                      setState(() => _exportFormat = value),
                  onClose: () => setState(() {
                    _showExportSheet = false;
                    _copied = false;
                  }),
                  onCopy: () => _copyEvents(exportEvents),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<LaunchpadEventLogEntryDraft> _filteredEvents(
    List<LaunchpadEventLogEntryDraft> events,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    return events.where((event) {
      if (_levelFilter != 'all' && event.level.value != _levelFilter) {
        return false;
      }
      if (_sourceFilter != 'all' && event.source != _sourceFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return event.message.toLowerCase().contains(query) ||
          event.source.toLowerCase().contains(query) ||
          (event.details ?? '').toLowerCase().contains(query) ||
          event.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<String> _sources(List<LaunchpadEventLogEntryDraft> events) {
    return ['all', ...events.map((event) => event.source).toSet()];
  }

  void _toggleSelectAll(List<LaunchpadEventLogEntryDraft> filteredEvents) {
    setState(() {
      if (_selectedEventIds.length == filteredEvents.length) {
        _selectedEventIds.clear();
      } else {
        _selectedEventIds
          ..clear()
          ..addAll(filteredEvents.map((event) => event.id));
      }
    });
  }

  void _toggleEventSelection(String id) {
    setState(() {
      if (_selectedEventIds.contains(id)) {
        _selectedEventIds.remove(id);
      } else {
        _selectedEventIds.add(id);
      }
    });
  }

  Future<void> _copyEvents(List<LaunchpadEventLogEntryDraft> events) async {
    setState(() => _copied = true);
    try {
      await Clipboard.setData(
        ClipboardData(text: _formatEvents(events, _exportFormat)),
      );
    } catch (_) {
      // Widget tests and webview shells may not expose a platform clipboard.
    }
  }

  String _formatEvents(
    List<LaunchpadEventLogEntryDraft> events,
    String format,
  ) {
    switch (format) {
      case 'json':
        return '{"count":${events.length},"entries":[${events.map((event) => '{"id":"${event.id}","level":"${event.level.value}","source":"${event.source}","message":"${event.message}"}').join(',')}]}';
      case 'csv':
        return [
          'timestamp,level,source,message,tags',
          for (final event in events)
            '${event.timestamp},${event.level.value},${event.source},"${event.message}","${event.tags.join(';')}"',
        ].join('\n');
      default:
        return [
          '=== Launchpad Event Log ===',
          'Entries: ${events.length}',
          for (final event in events)
            '[${event.timestamp}] [${event.level.value.toUpperCase()}] ${event.source}\n  ${event.message}',
        ].join('\n\n');
    }
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadEventLogPage.searchKey,
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder),
        borderRadius: AppRadii.xlRadius,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          hintText: 'Tim kiem event...',
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.searchPlaceholder,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: 18,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.text3,
                    size: 18,
                  ),
                ),
        ),
      ),
    );
  }
}

class _LevelFilterBar extends StatelessWidget {
  const _LevelFilterBar({
    required this.events,
    required this.activeValue,
    required this.onChanged,
  });

  final List<LaunchpadEventLogEntryDraft> events;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = [
      'all',
      ...LaunchpadEventLogLevel.values.map((e) => e.value),
    ];
    return SingleChildScrollView(
      key: LaunchpadEventLogPage.levelsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final value in values) ...[
            Builder(
              builder: (context) {
                final level = value == 'all'
                    ? null
                    : LaunchpadEventLogLevel.values.firstWhere(
                        (item) => item.value == value,
                      );
                final count = value == 'all'
                    ? events.length
                    : events
                          .where((event) => event.level.value == value)
                          .length;
                return _FilterChipButton(
                  key: LaunchpadEventLogPage.levelKey(value),
                  label: value == 'all' ? 'Tat ca' : level!.label,
                  count: count,
                  active: activeValue == value,
                  color: level?.color ?? AppModuleAccents.launchpad,
                  onTap: () => onChanged(value),
                );
              },
            ),
            if (value != values.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.sourceLabel,
    required this.sourceOpen,
    required this.selectedAll,
    required this.exportCount,
    required this.onToggleSources,
    required this.onToggleSelectAll,
    required this.onExport,
  });

  final String sourceLabel;
  final bool sourceOpen;
  final bool selectedAll;
  final int exportCount;
  final VoidCallback onToggleSources;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: LaunchpadEventLogPage.actionsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallActionButton(
            icon: Icons.filter_alt_outlined,
            label: sourceLabel,
            trailing: sourceOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            onTap: onToggleSources,
          ),
          const SizedBox(width: AppSpacing.x5),
          _SmallActionButton(
            key: LaunchpadEventLogPage.selectAllKey,
            label: selectedAll ? 'Bo chon' : 'Chon tat ca',
            compact: true,
            onTap: onToggleSelectAll,
          ),
          const SizedBox(width: AppSpacing.x2),
          _SmallActionButton(
            key: LaunchpadEventLogPage.exportButtonKey,
            icon: Icons.copy_rounded,
            label: 'Export ($exportCount)',
            active: true,
            onTap: onExport,
          ),
        ],
      ),
    );
  }
}

class _SourceFilterCard extends StatelessWidget {
  const _SourceFilterCard({
    required this.sources,
    required this.activeValue,
    required this.onChanged,
  });

  final List<String> sources;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadEventLogPage.sourcesKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loc theo nguon',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final source in sources)
                _FilterChipButton(
                  key: LaunchpadEventLogPage.sourceKey(source),
                  label: source == 'all' ? 'Tat ca' : source,
                  active: activeValue == source,
                  color: AppModuleAccents.launchpad,
                  onTap: () => onChanged(source),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({
    required this.events,
    required this.selectedIds,
    required this.expandedId,
    required this.onSelect,
    required this.onExpand,
  });

  final List<LaunchpadEventLogEntryDraft> events;
  final Set<String> selectedIds;
  final String? expandedId;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onExpand;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: LaunchpadEventLogPage.eventListKey,
      children: [
        for (final event in events) ...[
          _EventLogCard(
            event: event,
            selected: selectedIds.contains(event.id),
            expanded: expandedId == event.id,
            onSelect: () => onSelect(event.id),
            onExpand: () => onExpand(event.id),
          ),
          if (event != events.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({
    required this.event,
    required this.selected,
    required this.expanded,
    required this.onSelect,
    required this.onExpand,
  });

  final LaunchpadEventLogEntryDraft event;
  final bool selected;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final color = event.level.color;
    return VitCard(
      key: LaunchpadEventLogPage.eventKey(event.id),
      borderColor: selected
          ? color.withValues(alpha: .44)
          : AppColors.cardBorder,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelectBox(
                  key: LaunchpadEventLogPage.eventSelectKey(event.id),
                  selected: selected,
                  color: color,
                  onTap: onSelect,
                ),
                const SizedBox(width: AppSpacing.x3),
                _EventIcon(level: event.level),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _LevelBadge(level: event.level),
                          const SizedBox(width: AppSpacing.x2),
                          Expanded(
                            child: Text(
                              event.source,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                          Text(
                            event.timestamp,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        event.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: FontWeight.w800,
                          height: 1.24,
                        ),
                      ),
                      if (event.tags.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.x2),
                        Wrap(
                          spacing: AppSpacing.x1,
                          runSpacing: AppSpacing.x1,
                          children: [
                            for (final tag in event.tags) _TagPill(label: tag),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                IconButton(
                  key: LaunchpadEventLogPage.eventExpandKey(event.id),
                  visualDensity: VisualDensity.compact,
                  onPressed: onExpand,
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          if (expanded) _EventDetails(event: event),
        ],
      ),
    );
  }
}

class _EventDetails extends StatelessWidget {
  const _EventDetails({required this.event});

  final LaunchpadEventLogEntryDraft event;

  @override
  Widget build(BuildContext context) {
    final rows = [
      if (event.details != null) ('Chi tiet', event.details!),
      if (event.txHash != null) ('TxHash', event.txHash!),
      if (event.chain != null) ('Chain', event.chain!),
      if (event.contractAddress != null) ('Contract', event.contractAddress!),
      if (event.gasUsed != null) ('Gas used', event.gasUsed!),
      if (event.blockNumber != null)
        ('Block', '#${event.blockNumber!.toString()}'),
    ];
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x3,
        AppSpacing.x2,
        AppSpacing.x3,
        AppSpacing.x3,
      ),
      child: Column(
        children: [
          for (final row in rows) _DetailRow(label: row.$1, value: row.$2),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({
    required this.formats,
    required this.activeFormat,
    required this.count,
    required this.copied,
    required this.onFormatChanged,
    required this.onClose,
    required this.onCopy,
  });

  final List<LaunchpadEventLogExportFormatDraft> formats;
  final String activeFormat;
  final int count;
  final bool copied;
  final ValueChanged<String> onFormatChanged;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadEventLogPage.exportSheetKey,
      color: Colors.black.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x3,
              AppSpacing.x5,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderSolid,
                      borderRadius: AppRadii.xlRadius,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Export Event Log',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '$count',
                        style: AppTextStyles.pageTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'events se duoc export',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  'Dinh dang',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    for (final format in formats) ...[
                      Expanded(
                        child: _ExportFormatTile(
                          key: LaunchpadEventLogPage.formatKey(format.value),
                          format: format,
                          active: activeFormat == format.value,
                          onTap: () => onFormatChanged(format.value),
                        ),
                      ),
                      if (format != formats.last)
                        const SizedBox(width: AppSpacing.x2),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCard(
                  variant: VitCardVariant.inner,
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Text(
                    _previewFor(activeFormat, count),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  key: LaunchpadEventLogPage.copyButtonKey,
                  onPressed: onCopy,
                  variant: copied
                      ? VitCtaButtonVariant.success
                      : VitCtaButtonVariant.primary,
                  leading: Icon(
                    copied ? Icons.check_rounded : Icons.copy_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  child: Text(
                    copied
                        ? 'Da copy vao clipboard'
                        : 'Copy $count events (${activeFormat.toUpperCase()})',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _previewFor(String format, int count) {
    return switch (format) {
      'json' => '{"count": $count, "entries": [...]}',
      'csv' => 'timestamp,level,source,message\n23:36:08,info,Bridge,...',
      _ =>
        '=== Launchpad Event Log ===\n[23:36:08] [INFO] Bridge\n  Bridge transaction initiated',
    };
  }
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final LaunchpadEventLogExportFormatDraft format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return InkWell(
      borderRadius: AppRadii.inputRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.x3,
          horizontal: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary30 : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Column(
          children: [
            Icon(_formatIcon(format.iconKey), color: color, size: 20),
            const SizedBox(height: AppSpacing.x2),
            Text(
              format.label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
    this.count,
  });

  final String label;
  final int? count;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.xlRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .36) : Colors.transparent,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                '($count)',
                style: AppTextStyles.micro.copyWith(
                  color: active ? color : AppColors.text3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.active = false,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final IconData? trailing;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return InkWell(
      borderRadius: AppRadii.inputRadius,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.x2 : AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary30 : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x1),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.x1),
              Icon(trailing, color: color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    super.key,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.xsRadius,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          border: Border.all(color: selected ? color : AppColors.borderSolid),
          borderRadius: AppRadii.xsRadius,
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
            : null,
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.level});

  final LaunchpadEventLogLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: .16),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(level.icon, color: level.color, size: 16),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final LaunchpadEventLogLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x1,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        level.label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: level.color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadEventLogPage.emptyKey,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Khong tim thay event',
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thu thay doi bo loc hoac tu khoa tim kiem',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

extension _EventLevelUi on LaunchpadEventLogLevel {
  String get value {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'info',
      LaunchpadEventLogLevel.success => 'success',
      LaunchpadEventLogLevel.warning => 'warning',
      LaunchpadEventLogLevel.error => 'error',
      LaunchpadEventLogLevel.debug => 'debug',
      LaunchpadEventLogLevel.tx => 'tx',
    };
  }

  String get label {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'Info',
      LaunchpadEventLogLevel.success => 'Success',
      LaunchpadEventLogLevel.warning => 'Warning',
      LaunchpadEventLogLevel.error => 'Error',
      LaunchpadEventLogLevel.debug => 'Debug',
      LaunchpadEventLogLevel.tx => 'Transaction',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadEventLogLevel.info => AppModuleAccents.launchpad,
      LaunchpadEventLogLevel.success => AppColors.buy,
      LaunchpadEventLogLevel.warning => AppColors.warn,
      LaunchpadEventLogLevel.error => AppColors.sell,
      LaunchpadEventLogLevel.debug => AppColors.text2,
      LaunchpadEventLogLevel.tx => AppColors.accent,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadEventLogLevel.info => Icons.info_outline_rounded,
      LaunchpadEventLogLevel.success => Icons.check_circle_outline_rounded,
      LaunchpadEventLogLevel.warning => Icons.warning_amber_rounded,
      LaunchpadEventLogLevel.error => Icons.error_outline_rounded,
      LaunchpadEventLogLevel.debug => Icons.bug_report_outlined,
      LaunchpadEventLogLevel.tx => Icons.bolt_rounded,
    };
  }
}

IconData _formatIcon(String iconKey) {
  return switch (iconKey) {
    'json' => Icons.data_object_rounded,
    'csv' => Icons.table_chart_outlined,
    _ => Icons.description_outlined,
  };
}
