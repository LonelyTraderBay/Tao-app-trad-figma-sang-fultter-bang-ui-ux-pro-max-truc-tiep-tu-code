import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/profile_home_hero.dart';
part '../widgets/profile_home_vip_prediction.dart';
part '../widgets/profile_home_arena_stats.dart';
part '../widgets/profile_home_menu_actions.dart';

const _profileBackground = AppColors.bg;
const _profilePanel2 = AppColors.surface2;
const _profileBorder = AppColors.cardBorder;
const _profileGreen = AppColors.buy;
const _profileAmber = AppColors.warn;
const _profilePurple = AppColors.accent;
const _profileRed = AppColors.sell;
const _profileMuted = AppColors.text3;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc156_profile_content');
  static const copyReferralKey = Key('sc156_profile_copy_referral');
  static const editProfileKey = Key('sc156_profile_edit');
  static const logoutKey = Key('sc156_profile_logout');
  static const predictionCardKey = Key('sc156_profile_prediction_card');
  static const arenaCardKey = Key('sc156_profile_arena_card');
  static const productHubKey = Key('sc156_profile_product_hub');
  static Key productShortcutKey(String id) => Key('sc156_profile_product_$id');
  static Key menuKey(String id) => Key('sc156_profile_menu_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _copiedReferral = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getProfile();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.profileBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.profileBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-156 ProfilePage',
      child: Material(
        color: _profileBackground,
        child: VitAutoHideHeaderScaffold(
          header: const VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'T\u00E0i kho\u1EA3n',
          ),
          child: SingleChildScrollView(
            key: ProfilePage.contentKey,
            padding: AppSpacing.profileScrollPadding(bottomInset),
            physics: const BouncingScrollPhysics(),
            child: VitPageContent(
              padding: VitContentPadding.none,
              customGap: 0,
              fullBleed: true,
              children: [
                _ProfileHero(
                  user: snapshot.user,
                  copiedReferral: _copiedReferral,
                  onEdit: () => context.go(AppRoutePaths.profileEdit),
                  onCopyReferral: () {
                    Clipboard.setData(
                      ClipboardData(text: snapshot.user.referralCode),
                    );
                    setState(() => _copiedReferral = true);
                  },
                ),
                const SizedBox(height: AppSpacing.profileHeroToVipGap),
                _VipCard(vip: snapshot.vip),
                const SizedBox(height: AppSpacing.profileVipToSectionGap),
                const _SectionLabel(
                  label: 'D\u1EF1 \u0111o\u00E1n & Th\u00E1ch \u0111\u1EA5u',
                  accent: _profilePurple,
                ),
                const SizedBox(height: AppSpacing.profileSectionLabelGap),
                _PredictionCard(
                  prediction: snapshot.prediction,
                  onTap: () => context.go(AppRoutePaths.profilePredictions),
                ),
                const SizedBox(height: AppSpacing.profilePredictionToArenaGap),
                _ArenaCard(
                  arena: snapshot.arena,
                  onTap: () => context.go(AppRoutePaths.profileArena),
                ),
                const SizedBox(height: AppSpacing.profileSectionGap),
                const _SectionLabel(
                  label: 'S\u1EA2N PH\u1EA8M & H\u1ED6 TR\u1EE2',
                  accent: _profileAmber,
                ),
                const SizedBox(height: AppSpacing.profileSectionLabelGap),
                if (snapshot.productShortcuts.isEmpty)
                  const VitEmptyState(
                    title: 'Ch\u01B0a c\u00F3 s\u1EA3n ph\u1EA9m',
                    message:
                        'C\u00E1c shortcut s\u1EA3n ph\u1EA9m s\u1EBD hi\u1EC3n th\u1ECB khi kh\u1EA3 d\u1EE5ng.',
                    icon: Icons.explore_outlined,
                  )
                else
                  _ProfileProductHub(shortcuts: snapshot.productShortcuts),
                const SizedBox(height: AppSpacing.profileSectionGap),
                if (snapshot.sections.isEmpty)
                  const VitEmptyState(
                    title: 'Ch\u01B0a c\u00F3 m\u1EE5c t\u00E0i kho\u1EA3n',
                    message:
                        'C\u00E1c c\u00E0i \u0111\u1EB7t profile s\u1EBD hi\u1EC3n th\u1ECB sau khi t\u1EA3i xong.',
                    icon: Icons.account_circle_outlined,
                  )
                else
                  for (final section in snapshot.sections) ...[
                    _SectionLabel(
                      label: section.label,
                      accent: Color(section.accentHex),
                    ),
                    const SizedBox(height: AppSpacing.profileSectionLabelGap),
                    _MenuSection(section: section),
                    const SizedBox(height: AppSpacing.profileSectionGap),
                  ],
                _ActivityButton(
                  onTap: () => context.go(AppRoutePaths.profileActivity),
                ),
                const SizedBox(height: AppSpacing.profileActivityGap),
                _LogoutButton(onTap: () => context.go(AppRoutePaths.authLogin)),
                const SizedBox(height: AppSpacing.profileFooterGap),
                Text(
                  'VitTrade v2.4.1 \u2022 Tham gia t\u1EEB ${snapshot.user.joinDate}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(color: _profileMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
