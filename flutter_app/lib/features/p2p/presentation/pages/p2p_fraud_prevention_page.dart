import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_fraud_score_patterns.dart';
part '../widgets/p2p_fraud_checklist_actions.dart';
part '../widgets/p2p_fraud_common.dart';

class P2PFraudPreventionPage extends ConsumerStatefulWidget {
  const P2PFraudPreventionPage({super.key, this.shellRenderMode});

  static const scoreKey = Key('sc260_p2p_fraud_score');
  static const patternsKey = Key('sc260_p2p_fraud_patterns');
  static const checklistKey = Key('sc260_p2p_fraud_checklist');
  static const emergencyKey = Key('sc260_p2p_fraud_emergency');
  static const disclosureKey = Key('sc260_p2p_fraud_disclosure');

  static Key patternKey(String id) => Key('sc260_p2p_fraud_pattern_$id');

  static Key tabKey(String id) => Key('sc260_p2p_fraud_tab_$id');

  static Key checklistItemKey(String id) =>
      Key('sc260_p2p_fraud_checklist_$id');

  static Key actionKey(String id) => Key('sc260_p2p_fraud_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PFraudPreventionPage> createState() =>
      _P2PFraudPreventionPageState();
}

class _P2PFraudPreventionPageState
    extends ConsumerState<P2PFraudPreventionPage> {
  late List<P2PSafetyChecklistItemDraft> _checklist;
  String? _expandedPatternId;
  String _activeCategory = 'before';

  @override
  void initState() {
    super.initState();
    _checklist = List.of(ref.read(p2pFraudPreventionProvider).checklist);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pFraudPreventionProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final checkedCount = _checklist.where((item) => item.checked).length;
    final score = (checkedCount / _checklist.length * 100).round();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-260 P2PFraudPreventionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phòng chống gian lận',
              subtitle: 'An toàn · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SafetyScoreCard(
                        score: score,
                        checkedCount: checkedCount,
                        totalCount: _checklist.length,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _PatternSection(
                        patterns: snapshot.patterns,
                        expandedPatternId: _expandedPatternId,
                        onToggle: _togglePattern,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _ChecklistCard(
                        checklist: _checklist,
                        activeCategory: _activeCategory,
                        onCategoryChanged: _setCategory,
                        onToggle: _toggleChecklist,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _EmergencyActions(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _Disclosure(text: snapshot.disclosure),
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

  void _togglePattern(String id) {
    HapticFeedback.selectionClick();
    setState(() => _expandedPatternId = _expandedPatternId == id ? null : id);
  }

  void _setCategory(String category) {
    HapticFeedback.selectionClick();
    setState(() => _activeCategory = category);
  }

  void _toggleChecklist(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _checklist = [
        for (final item in _checklist)
          if (item.id == id) item.copyWith(checked: !item.checked) else item,
      ];
    });
  }
}
