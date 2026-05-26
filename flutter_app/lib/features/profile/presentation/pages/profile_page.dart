import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

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
    final snapshot = ref.watch(profileRepositoryProvider).getProfile();
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
                onEdit: () => context.go('/profile/edit'),
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
                onTap: () => context.go('/profile/predictions'),
              ),
              const SizedBox(height: 14),
              _ArenaCard(
                arena: snapshot.arena,
                onTap: () => context.go('/profile/arena'),
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
              _ActivityButton(onTap: () => context.go('/profile/activity')),
              const SizedBox(height: 28),
              _LogoutButton(onTap: () => context.go('/auth/login')),
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

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.copiedReferral,
    required this.onEdit,
    required this.onCopyReferral,
  });

  final ProfileUser user;
  final bool copiedReferral;
  final VoidCallback onEdit;
  final VoidCallback onCopyReferral;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _profileHero,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.portfolioBorder),
        gradient: const RadialGradient(
          center: Alignment(.85, -.9),
          radius: 1.15,
          colors: [AppColors.primary12, _profileHero],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: AppRadii.cardRadius,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _profilePurple.withValues(alpha: .45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  user.fullName.characters.first,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _HeroPill(label: user.vipLevel, color: _profileAmber),
                        const SizedBox(width: 8),
                        _HeroPill(
                          label: 'KYC ${user.kycLevel}',
                          color: _profileGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: ProfilePage.editProfileKey,
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .11),
                    borderRadius: AppRadii.lgRadius,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .12),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.text2,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroInfoBox(label: 'UID', value: user.id),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  key: ProfilePage.copyReferralKey,
                  onTap: onCopyReferral,
                  behavior: HitTestBehavior.opaque,
                  child: _HeroInfoBox(
                    label: 'M\u00E3 gi\u1EDBi thi\u1EC7u',
                    value: user.referralCode,
                    valueColor: AppColors.primarySoft,
                    trailing: Icon(
                      copiedReferral
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      color: copiedReferral
                          ? _profileGreen
                          : AppColors.primarySoft,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _HeroInfoBox extends StatelessWidget {
  const _HeroInfoBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: valueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}

class _VipCard extends StatelessWidget {
  const _VipCard({required this.vip});

  final ProfileVipProgress vip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _profilePanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _profileBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'VIP Progress',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${vip.label} \u2192 ${vip.nextLabel}',
                style: AppTextStyles.micro.copyWith(
                  color: _profileAmber,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: vip.progress,
              color: AppColors.primary,
              backgroundColor: _profilePanel2,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vip.volumeLabel,
              style: AppTextStyles.micro.copyWith(
                color: _profileMuted,
                fontSize: 10,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.prediction, required this.onTap});

  final ProfilePredictionBlock prediction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ProfilePage.predictionCardKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 137,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _profilePanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _profilePurple.withValues(alpha: .38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.adjust_rounded,
                  color: _profilePurple,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Prediction Portfolio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _TinyTag(label: 'Prediction Market', color: _profilePurple),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _ModuleStat(
                  label: 'V\u1ECB th\u1EBF',
                  value: '${prediction.positions}',
                ),
                const SizedBox(width: 28),
                _ModuleStat(
                  label: 'L\u1EC7nh m\u1EDF',
                  value: '${prediction.openOrders}',
                ),
                const SizedBox(width: 28),
                _ModuleStat(
                  label: 'P/L',
                  value: prediction.pnlLabel,
                  valueColor: _profileGreen,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Xem portfolio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profilePurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _profilePurple,
                  size: 14,
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.emoji_events_outlined,
                  color: _profileMuted,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Leaderboard',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profileMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaCard extends StatelessWidget {
  const _ArenaCard({required this.arena, required this.onTap});

  final ProfileArenaBlock arena;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ProfilePage.arenaCardKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 137,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _profilePanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _profileAmber.withValues(alpha: .34)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.sports_esports_outlined,
                  color: _profileAmber,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Open Arena',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _TinyTag(label: 'Points only', color: _profileAmber),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _ModuleStat(
                  label: 'Arena Points',
                  value: arena.pointsLabel,
                  valueColor: _profileAmber,
                ),
                const SizedBox(width: 28),
                _ModuleStat(label: 'Ph\u00F2ng', value: '${arena.rooms}'),
                const SizedBox(width: 28),
                _ModuleStat(
                  label: 'Creator',
                  value: arena.creatorScoreLabel,
                  valueColor: _profileGreen,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'V\u00E0o s\u00E2n ch\u01A1i c\u1EE7a t\u00F4i',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profileAmber,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _profileAmber,
                  size: 14,
                ),
                const SizedBox(width: 18),
                const Icon(
                  Icons.shield_outlined,
                  color: _profileMuted,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'An to\u00E0n & B\u00E1o c\u00E1o',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profileMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleStat extends StatelessWidget {
  const _ModuleStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: _profileMuted,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.section});

  final ProfileMenuSection section;

  @override
  Widget build(BuildContext context) {
    final accent = Color(section.accentHex);
    return Container(
      decoration: BoxDecoration(
        color: _profilePanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _profileBorder),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            for (final item in section.items) ...[
              _MenuRow(item: item, accent: accent),
              if (item != section.items.last)
                const Divider(height: 1, color: AppColors.divider),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item, required this.accent});

  final ProfileMenuItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ProfilePage.menuKey(item.id),
      onTap: () => context.go(item.route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(item.iconKey), color: accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: item.subtitleHex == null
                            ? _profileMuted
                            : Color(item.subtitleHex!),
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: _profileMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityButton extends StatelessWidget {
  const _ActivityButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _profilePanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _profileBorder),
        ),
        child: Text(
          'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ProfilePage.logoutKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _profileRed.withValues(alpha: .1),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _profileRed.withValues(alpha: .28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: _profileRed, size: 21),
            const SizedBox(width: 10),
            Text(
              '\u0110\u0103ng xu\u1EA5t',
              style: AppTextStyles.baseMedium.copyWith(
                color: _profileRed,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'shield-check' => Icons.verified_user_outlined,
    'shield' => Icons.shield_outlined,
    'crown' => Icons.workspace_premium_outlined,
    'bell' => Icons.notifications_none_rounded,
    'key' => Icons.key_rounded,
    'phone' => Icons.phone_android_rounded,
    'users' => Icons.groups_outlined,
    'clipboard' => Icons.assignment_outlined,
    'globe' => Icons.language_rounded,
    'settings' => Icons.settings_outlined,
    'rotate' => Icons.history_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'compass' => Icons.explore_outlined,
    'trophy' => Icons.emoji_events_outlined,
    'refresh' => Icons.sync_rounded,
    'zap' => Icons.bolt_rounded,
    'bot' => Icons.smart_toy_outlined,
    'help' => Icons.help_outline_rounded,
    'file' => Icons.article_outlined,
    'star' => Icons.star_border_rounded,
    _ => Icons.circle_outlined,
  };
}
