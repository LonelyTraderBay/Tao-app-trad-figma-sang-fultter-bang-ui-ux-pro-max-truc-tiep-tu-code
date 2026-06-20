import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/vip_history_widgets.dart';

part '../widgets/profile_vip_hero.dart';
part '../widgets/profile_vip_overview.dart';
part '../widgets/profile_vip_benefits.dart';

const _vipAccent = AppColors.primary;
const _vipGold = AppColors.warn;
const _vipSuccess = AppColors.buy;
const _vipMuted = AppColors.text3;
const _vipProfileAccent = AppModuleAccents.profile;

enum _VipTab { overview, benefits, history }

class VIPPage extends ConsumerStatefulWidget {
  const VIPPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc164_vip_content');
  static const tradeCtaKey = Key('sc164_vip_trade_cta');
  static Key tabKey(String id) => Key('sc164_vip_tab_$id');
  static Key tierRowKey(int level) => Key('sc164_vip_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<VIPPage> createState() => _VIPPageState();
}

class _VIPPageState extends ConsumerState<VIPPage> {
  _VipTab _selectedTab = _VipTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getVip();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-164 VIPPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'VIP Program',
            subtitle: 'VIP \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: VIPPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: scrollClearance),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _VipHero(snapshot: snapshot),
                      _VipTabs(
                        active: _selectedTab,
                        onChanged: (tab) => setState(() => _selectedTab = tab),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _tabContent(snapshot),
                      ),
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

  Widget _tabContent(ProfileVipSnapshot snapshot) {
    return switch (_selectedTab) {
      _VipTab.overview => _OverviewTab(
        key: const ValueKey('overview'),
        snapshot: snapshot,
      ),
      _VipTab.benefits => _BenefitsTab(
        key: const ValueKey('benefits'),
        snapshot: snapshot,
        onTrade: _openTrade,
      ),
      _VipTab.history => VipHistoryTab(
        key: const ValueKey('history'),
        snapshot: snapshot,
      ),
    };
  }

  void _openTrade() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.tradePair('btcusdt'));
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
