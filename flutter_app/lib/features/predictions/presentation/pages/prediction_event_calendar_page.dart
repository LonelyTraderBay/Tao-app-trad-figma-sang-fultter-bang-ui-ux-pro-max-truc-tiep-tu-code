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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../widgets/prediction_event_calendar_controls.dart';
part '../widgets/prediction_event_calendar_events.dart';
part '../widgets/prediction_event_calendar_notifications.dart';

const _predictionPrimary = AppColors.primary;

enum _CalendarTab { calendar, upcoming, notifications }

class PredictionEventCalendarPage extends ConsumerStatefulWidget {
  const PredictionEventCalendarPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc039_event_calendar_content');
  static const filterButtonKey = Key('sc039_filter_button');
  static const calendarTabKey = Key('sc039_tab_calendar');
  static const upcomingTabKey = Key('sc039_tab_upcoming');
  static const notificationsTabKey = Key('sc039_tab_notifications');

  static Key categoryKey(String category) => Key('sc039_category_$category');
  static Key eventKey(String id) => Key('sc039_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionEventCalendarPage> createState() =>
      _PredictionEventCalendarPageState();
}

class _PredictionEventCalendarPageState
    extends ConsumerState<PredictionEventCalendarPage> {
  _CalendarTab _activeTab = _CalendarTab.calendar;
  bool _showFilter = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getEventCalendar(category: _category);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-039 PredictionEventCalendarPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Event Calendar',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
              trailing: _FilterButton(
                active: _showFilter,
                onTap: () => setState(() => _showFilter = !_showFilter),
              ),
            ),
            _EventCalendarTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionEventCalendarPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      if (_showFilter)
                        _CategoryFilters(
                          snapshot: snapshot,
                          selectedCategory: _category,
                          onChanged: (category) =>
                              setState(() => _category = category),
                        ),
                      ...switch (_activeTab) {
                        _CalendarTab.calendar => [
                          _StatsCard(snapshot: snapshot),
                          for (final month in snapshot.months)
                            _MonthSection(month: month),
                        ],
                        _CalendarTab.upcoming => [
                          _UpcomingSection(snapshot: snapshot),
                        ],
                        _CalendarTab.notifications => [
                          _NotificationSettings(),
                          _WatchingSection(snapshot: snapshot),
                          const _NotificationInfo(),
                        ],
                      },
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
