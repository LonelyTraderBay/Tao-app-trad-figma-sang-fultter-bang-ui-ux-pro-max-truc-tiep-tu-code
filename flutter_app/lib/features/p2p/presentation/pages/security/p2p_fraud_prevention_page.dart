import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../widgets/security/p2p_fraud_score_patterns.dart';
part '../../widgets/security/p2p_fraud_checklist_actions.dart';
part '../../widgets/security/p2p_fraud_common.dart';

const double _p2pFraudVisualClearance = AppSpacing.x3;
const double _p2pFraudNativeClearance = AppSpacing.x2;
const double _p2pFraudMajorGap = AppSpacing.x3;
const double _p2pFraudSectionGap = AppSpacing.x2;
const double _p2pFraudPatternIconBox = AppSpacing.searchBarCompactHeight;
const double _p2pFraudBodyLineHeight = 1.35;
const double _p2pFraudDisclosureLineHeight = 1.4;

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
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + _p2pFraudVisualClearance
            : DeviceMetrics.nativeBottomChrome + _p2pFraudNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    final checkedCount = _checklist.where((item) => item.checked).length;
    final score = (checkedCount / _checklist.length * 100).round();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phòng chống gian lận P2P',
      semanticIdentifier: 'SC-260',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phòng chống gian lận',
            subtitle: 'An toàn · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                    physics: const ClampingScrollPhysics(),
                    padding: P2PSpacingTokens.p2pFraudScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        _SafetyScoreCard(
                          score: score,
                          checkedCount: checkedCount,
                          totalCount: _checklist.length,
                        ),
                        _PatternSection(
                          patterns: snapshot.patterns,
                          expandedPatternId: _expandedPatternId,
                          onToggle: _togglePattern,
                        ),
                        _ChecklistCard(
                          checklist: _checklist,
                          activeCategory: _activeCategory,
                          onCategoryChanged: _setCategory,
                          onToggle: _toggleChecklist,
                        ),
                        _EmergencyActions(snapshot: snapshot),
                        _Disclosure(text: snapshot.disclosure),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: P2PSpacingTokens.p2pFraudInnerPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Rà soát phòng chống gian lận',
                            message:
                                'Chỉ số an toàn, checklist, mẫu gian lận, hành động khẩn cấp và cảnh báo pháp lý vẫn hiển thị trước khi tiếp tục giao dịch P2P.',
                            contractId: 'SC-260',
                          ),
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
