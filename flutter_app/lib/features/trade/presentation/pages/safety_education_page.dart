import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/safety_education_page_sections.dart';
part '../widgets/safety_education_page_common.dart';

const _safetyPrimary = AppColors.primary;

class SafetyEducationPage extends ConsumerStatefulWidget {
  const SafetyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc080_safety_education_content');
  static Key tabKey(String id) => Key('sc080_tab_$id');
  static Key scamKey(String id) => Key('sc080_scam_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SafetyEducationPage> createState() =>
      _SafetyEducationPageState();
}

class _SafetyEducationPageState extends ConsumerState<SafetyEducationPage> {
  late String _activeTabId;
  String? _expandedScamId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getSafetyEducation();
    if (!_initialized) {
      _activeTabId = snapshot.defaultTabId;
      _initialized = true;
    }

    return VitTradeHubScaffold(
      title: 'An toàn & Bảo mật',
      semanticLabel: 'SC-080 SafetyEducationPage',
      contentKey: SafetyEducationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.compact,
            title: 'Xem lại tín hiệu an toàn copy trading',
            message:
                'Xác nhận dấu hiệu lừa đảo, xác minh provider, giới hạn báo cáo và bước tiếp theo trước khi copy.',
          ),
        ),
        VitTradeComplianceSection(
          title: 'An toàn copy trading',
          statusPill: VitStatusPill(
            label: 'Tab: $_activeTabId',
            status: VitStatusPillStatus.warning,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Lừa đảo theo dõi',
              value: '${snapshot.scams.length}',
            ),
            VitTradeComplianceItem(
              label: 'Cảnh báo đỏ',
              value: '${snapshot.redFlags.length}',
            ),
          ],
        ),
        VitTradeSection(
          title: 'Giáo dục',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBanner(snapshot: snapshot),
              _SafetyTabs(
                tabs: snapshot.tabs,
                activeId: _activeTabId,
                onChanged: (id) {
                  setState(() {
                    _activeTabId = id;
                    _expandedScamId = null;
                  });
                },
              ),
              if (_activeTabId == 'scams')
                _ScamsTab(
                  scams: snapshot.scams,
                  expandedId: _expandedScamId,
                  onToggle: (id) => setState(
                    () => _expandedScamId = _expandedScamId == id ? null : id,
                  ),
                )
              else if (_activeTabId == 'redflags')
                _RedFlagsTab(flags: snapshot.redFlags)
              else if (_activeTabId == 'verification')
                _VerificationTab(tiers: snapshot.verificationTiers)
              else
                _ReportTab(reasons: snapshot.reportReasons),
            ],
          ),
        ),
      ],
    );
  }
}
