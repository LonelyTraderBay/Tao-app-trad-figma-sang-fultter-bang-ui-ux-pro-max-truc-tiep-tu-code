import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_blacklist_summary_filters.dart';
part '../widgets/p2p_blacklist_entries.dart';
part '../widgets/p2p_blacklist_common.dart';

class P2PBlacklistPage extends ConsumerStatefulWidget {
  const P2PBlacklistPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc277_p2p_blacklist_summary');
  static const searchKey = Key('sc277_p2p_blacklist_search');
  static const infoKey = Key('sc277_p2p_blacklist_info');
  static const addKey = Key('sc277_p2p_blacklist_add');

  static Key filterKey(String id) => Key('sc277_p2p_blacklist_filter_$id');

  static Key entryKey(String id) => Key('sc277_p2p_blacklist_entry_$id');

  static Key unblockKey(String id) => Key('sc277_p2p_blacklist_unblock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PBlacklistPage> createState() => _P2PBlacklistPageState();
}

class _P2PBlacklistPageState extends ConsumerState<P2PBlacklistPage> {
  final _searchController = TextEditingController();
  final _removedIds = <String>{};
  String _filterId = 'all';
  String? _expandedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pBlacklistProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final entries = snapshot.entries
        .where((item) => !_removedIds.contains(item.id))
        .toList();
    final filtered = _filterEntries(entries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-277 P2PBlacklistPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                key: P2PBlacklistPage.addKey,
                type: VitHeaderActionType.add,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.addRoute);
                },
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.contentPad,
                            0,
                            AppSpacing.contentPad,
                            AppSpacing.x4,
                          ),
                          child: _SummaryCard(
                            snapshot: snapshot,
                            entries: entries,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.contentPad,
                          ),
                          child: VitSearchBar(
                            key: P2PBlacklistPage.searchKey,
                            controller: _searchController,
                            placeholder: snapshot.searchHint,
                            variant: VitSearchBarVariant.compact,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _FilterRail(
                          snapshot: snapshot,
                          entries: entries,
                          activeId: _filterId,
                          onChanged: (id) {
                            HapticFeedback.selectionClick();
                            setState(() => _filterId = id);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.contentPad,
                            AppSpacing.x2,
                            AppSpacing.contentPad,
                            0,
                          ),
                          child: Text(
                            '${filtered.length} kết quả',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.contentPad,
                          ),
                          child: _EntryList(
                            snapshot: snapshot,
                            entries: filtered,
                            expandedId: _expandedId,
                            onToggle: (id) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _expandedId = _expandedId == id ? null : id;
                              });
                            },
                            onUnblock: (id) {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                _removedIds.add(id);
                                if (_expandedId == id) _expandedId = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.contentPad,
                          ),
                          child: _InfoNote(snapshot: snapshot),
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

  List<P2PBlacklistEntryDraft> _filterEntries(
    List<P2PBlacklistEntryDraft> entries,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return entries.where((entry) {
      final matchesSearch =
          query.isEmpty || entry.username.toLowerCase().contains(query);
      final matchesFilter = _filterId == 'all' || entry.reasonId == _filterId;
      return matchesSearch && matchesFilter;
    }).toList();
  }
}
