import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_events.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_month.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketCalendarPage extends ConsumerStatefulWidget {
  const MarketCalendarPage({super.key, this.shellRenderMode});

  static const contentKey = MarketCalendarKeys.content;
  static const listTabKey = MarketCalendarKeys.listTab;
  static const calendarTabKey = MarketCalendarKeys.calendarTab;

  static Key typeFilterKey(String label) =>
      MarketCalendarKeys.typeFilter(label);

  static Key impactFilterKey(MarketCalendarImpact impact) =>
      MarketCalendarKeys.impactFilter(impact);

  static Key eventKey(String id) => MarketCalendarKeys.event(id);

  static Key dayKey(int day) => MarketCalendarKeys.day(day);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketCalendarPage> createState() => _MarketCalendarPageState();
}

class _MarketCalendarPageState extends ConsumerState<MarketCalendarPage> {
  String _view = 'list';
  MarketCalendarTypeFilter _typeFilter = marketCalendarTypeFilters.first;
  MarketCalendarImpact? _impactFilter;
  String? _expandedId;

  void _setType(MarketCalendarTypeFilter filter) {
    setState(() {
      _typeFilter = filter;
      _expandedId = null;
    });
  }

  void _toggleImpact(MarketCalendarImpact impact) {
    setState(() {
      _impactFilter = _impactFilter == impact ? null : impact;
      _expandedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = MarketCalendarQuery(
      type: _typeFilter.type,
      impact: _impactFilter,
    );
    final snapshot = ref
        .watch(marketControllerProvider)
        .getMarketCalendar(query: query);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-017 MarketCalendarPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sự kiện',
            subtitle: 'Sự kiện · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketCalendarViewTabs(
                activeView: _view,
                onChanged: (value) => setState(() => _view = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: MarketCalendarPage.contentKey,
                    padding: AppSpacing.marketCalendarScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: [
                        MarketCalendarStatsSummary(stats: snapshot.stats),
                        MarketCalendarTypeFilters(
                          active: _typeFilter,
                          onSelected: _setType,
                        ),
                        MarketCalendarImpactFilters(
                          activeImpact: _impactFilter,
                          onSelected: _toggleImpact,
                        ),
                        if (_view == 'list')
                          if (snapshot.events.isEmpty)
                            const VitEmptyState(
                              icon: Icons.calendar_month_rounded,
                              title: 'Không có sự kiện phù hợp',
                              message:
                                  'Thử đổi loại sự kiện hoặc mức tác động.',
                            )
                          else
                            MarketCalendarEventGroups(
                              events: snapshot.events,
                              expandedId: _expandedId,
                              onToggle: (id) => setState(() {
                                _expandedId = _expandedId == id ? null : id;
                              }),
                            )
                        else
                          MarketCalendarMonthGrid(
                            events: snapshot.events,
                            onEventDaySelected: (event) => setState(() {
                              _view = 'list';
                              _expandedId = event.id;
                            }),
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
}
