import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
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

part '../widgets/announcements_filters_widgets.dart';
part '../widgets/announcements_list_widgets.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc293_announcements_content');
  static const filtersKey = Key('sc293_announcements_filters');
  static const pinnedKey = Key('sc293_announcements_pinned');
  static const listKey = Key('sc293_announcements_list');
  static const emptyKey = Key('sc293_announcements_empty');

  static Key filterKey(String id) => Key('sc293_announcement_filter_$id');
  static Key announcementKey(String id) => Key('sc293_announcement_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  String _activeFilterId = 'all';
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(supportControllerProvider).getAnnouncements();
    final filter = snapshot.filters.firstWhere(
      (item) => item.id == _activeFilterId,
    );
    final filtered = filter.type == null
        ? snapshot.announcements
        : snapshot.announcements
              .where((item) => item.type == filter.type)
              .toList();
    final pinned = filtered.where((item) => item.isPinned).toList();
    final regular = filtered.where((item) => !item.isPinned).toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-293 AnnouncementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
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
                    key: AnnouncementsPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.supportScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      gap: VitContentGap.relaxed,
                      fullBleed: true,
                      children: [
                        _FilterRail(
                          filters: snapshot.filters,
                          activeFilterId: _activeFilterId,
                          onChanged: _setFilter,
                        ),
                        if (pinned.isNotEmpty)
                          _PinnedSection(
                            announcements: pinned,
                            expandedId: _expandedId,
                            onToggle: _toggleExpanded,
                          ),
                        _AnnouncementList(
                          announcements: regular,
                          showEmpty: pinned.isEmpty && regular.isEmpty,
                          expandedId: _expandedId,
                          onToggle: _toggleExpanded,
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

  void _setFilter(String filterId) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeFilterId = filterId;
      _expandedId = null;
    });
  }

  void _toggleExpanded(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedId = _expandedId == id ? null : id;
    });
  }
}
