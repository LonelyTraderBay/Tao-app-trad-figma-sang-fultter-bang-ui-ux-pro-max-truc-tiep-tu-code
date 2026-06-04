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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/safety_education_page_sections.dart';
part '../widgets/safety_education_page_common.dart';

const _safetyPrimary = AppColors.primary;
const _safetyCard = AppColors.surface;
const _safetyTabs = AppColors.surface;
const _safetyHeroBackground = AppColors.primary15;

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

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 132 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-080 SafetyEducationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'An toàn & Bảo mật',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: SafetyEducationPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroBanner(snapshot: snapshot),
                      const SizedBox(height: 25),
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
                      const SizedBox(height: 25),
                      if (_activeTabId == 'scams')
                        _ScamsTab(
                          scams: snapshot.scams,
                          expandedId: _expandedScamId,
                          onToggle: (id) => setState(
                            () => _expandedScamId = _expandedScamId == id
                                ? null
                                : id,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
