import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
part '../widgets/profile_home_hero.dart';
part '../widgets/profile_home_vip_prediction.dart';
part '../widgets/profile_home_arena_stats.dart';
part '../widgets/profile_home_menu_actions.dart';

const _profileBackground = AppColors.bg;
const _profilePanel = AppColors.surface;
const _profilePanel2 = AppColors.surface2;
const _profileHero = AppColors.surface;
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
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-156 ProfilePage',
      child: Material(
        color: _profileBackground,
        child: SingleChildScrollView(
          key: ProfilePage.contentKey,
          padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'T\u00E0i kho\u1EA3n',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 22),
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
              const SizedBox(height: 24),
              _VipCard(vip: snapshot.vip),
              const SizedBox(height: 26),
              const _SectionLabel(
                label: 'D\u1EF1 \u0111o\u00E1n & Th\u00E1ch \u0111\u1EA5u',
                accent: _profilePurple,
              ),
              const SizedBox(height: 11),
              _PredictionCard(
                prediction: snapshot.prediction,
                onTap: () => context.go(AppRoutePaths.profilePredictions),
              ),
              const SizedBox(height: 14),
              _ArenaCard(
                arena: snapshot.arena,
                onTap: () => context.go(AppRoutePaths.profileArena),
              ),
              const SizedBox(height: 25),
              for (final section in snapshot.sections) ...[
                _SectionLabel(
                  label: section.label,
                  accent: Color(section.accentHex),
                ),
                const SizedBox(height: 11),
                _MenuSection(section: section),
                const SizedBox(height: 25),
              ],
              _ActivityButton(
                onTap: () => context.go(AppRoutePaths.profileActivity),
              ),
              const SizedBox(height: 28),
              _LogoutButton(onTap: () => context.go(AppRoutePaths.authLogin)),
              const SizedBox(height: 38),
              Text(
                'VitTrade v2.4.1 \u2022 Tham gia t\u1EEB ${snapshot.user.joinDate}',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: _profileMuted,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
