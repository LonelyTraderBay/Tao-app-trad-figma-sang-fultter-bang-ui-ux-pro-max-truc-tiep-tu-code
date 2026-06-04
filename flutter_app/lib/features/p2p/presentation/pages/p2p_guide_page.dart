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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_guide_tabs_faq.dart';
part '../widgets/p2p_guide_steps_safety.dart';
part '../widgets/p2p_guide_video_common.dart';

class P2PGuidePage extends ConsumerStatefulWidget {
  const P2PGuidePage({super.key, this.shellRenderMode});

  static const tabsKey = Key('sc280_p2p_guide_tabs');
  static const faqListKey = Key('sc280_p2p_guide_faq_list');
  static const buyModeKey = Key('sc280_p2p_guide_buy_mode');
  static const sellModeKey = Key('sc280_p2p_guide_sell_mode');
  static const startKey = Key('sc280_p2p_guide_start');
  static const supportKey = Key('sc280_p2p_guide_support');

  static Key tabKey(String id) => Key('sc280_p2p_guide_tab_$id');
  static Key faqKey(String id) => Key('sc280_p2p_guide_faq_$id');
  static Key videoKey(String id) => Key('sc280_p2p_guide_video_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PGuidePage> createState() => _P2PGuidePageState();
}

class _P2PGuidePageState extends ConsumerState<P2PGuidePage> {
  late String _tab;
  String _mode = 'buy';
  String? _expandedFaqId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pGuideProvider);
    _ensureState(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-280 P2PGuidePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GuideTabs(
                tabs: snapshot.tabs,
                active: _tab,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() => _tab = value);
                },
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
                    child: _GuideBody(
                      snapshot: snapshot,
                      activeTab: _tab,
                      mode: _mode,
                      expandedFaqId: _expandedFaqId,
                      onModeChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _mode = value);
                      },
                      onFaqToggle: (faqId) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _expandedFaqId = _expandedFaqId == faqId
                              ? null
                              : faqId;
                        });
                      },
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

  void _ensureState(P2PGuideSnapshot snapshot) {
    if (_initialized) return;
    _tab = snapshot.defaultTab;
    _expandedFaqId = snapshot.faqItems.isEmpty
        ? null
        : snapshot.faqItems.first.id;
    _initialized = true;
  }
}
