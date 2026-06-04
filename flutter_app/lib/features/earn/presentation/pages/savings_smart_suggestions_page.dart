import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_summary.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_suggestions.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_trends.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

class SavingsSmartSuggestionsPage extends ConsumerStatefulWidget {
  const SavingsSmartSuggestionsPage({super.key, this.shellRenderMode});

  static const summaryKey = SavingsSmartSuggestionsKeys.summary;
  static const suggestionsListKey = SavingsSmartSuggestionsKeys.suggestionsList;
  static const trendsListKey = SavingsSmartSuggestionsKeys.trendsList;
  static const signalsListKey = SavingsSmartSuggestionsKeys.signalsList;

  static Key filterKey(String id) => SavingsSmartSuggestionsKeys.filter(id);
  static Key suggestionKey(String id) =>
      SavingsSmartSuggestionsKeys.suggestion(id);
  static Key actionKey(String id) => SavingsSmartSuggestionsKeys.action(id);
  static Key helpfulKey(String id) => SavingsSmartSuggestionsKeys.helpful(id);
  static Key dismissKey(String id) => SavingsSmartSuggestionsKeys.dismiss(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsSmartSuggestionsPage> createState() =>
      _SavingsSmartSuggestionsPageState();
}

class _SavingsSmartSuggestionsPageState
    extends ConsumerState<SavingsSmartSuggestionsPage> {
  String? _tab;
  String _filter = 'all';
  final Set<String> _dismissed = {};
  final Set<String> _helpful = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsSmartSuggestionsRepositoryProvider)
        .getSuggestions();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-347 SavingsSmartSuggestionsPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      SavingsSmartSummary(snapshot: snapshot),
                      SavingsSmartTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (activeTab == 'suggestions') ...[
                        SavingsSmartPriorityFilters(
                          filters: snapshot.filters,
                          active: _filter,
                          onChanged: (filter) {
                            HapticFeedback.selectionClick();
                            setState(() => _filter = filter);
                          },
                        ),
                        SavingsSmartSuggestionList(
                          suggestions: _filteredSuggestions(snapshot),
                          helpful: _helpful,
                          onHelpful: _markHelpful,
                          onDismiss: _dismissSuggestion,
                        ),
                        SavingsSmartDisclaimer(text: snapshot.disclaimer),
                      ] else if (activeTab == 'trends')
                        SavingsSmartTrendList(trends: snapshot.trends)
                      else
                        SavingsSmartSignalList(signals: snapshot.signals),
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

  List<SavingsSuggestionDraft> _filteredSuggestions(
    SavingsSmartSuggestionsSnapshot snapshot,
  ) {
    final active = snapshot.suggestions.where(
      (suggestion) => !_dismissed.contains(suggestion.id),
    );
    if (_filter == 'all') return active.toList();

    return active
        .where((suggestion) => suggestion.priority.name == _filter)
        .toList();
  }

  void _markHelpful(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_helpful.contains(id)) {
        _helpful.remove(id);
      } else {
        _helpful.add(id);
      }
    });
  }

  void _dismissSuggestion(String id) {
    HapticFeedback.selectionClick();
    setState(() => _dismissed.add(id));
  }
}
