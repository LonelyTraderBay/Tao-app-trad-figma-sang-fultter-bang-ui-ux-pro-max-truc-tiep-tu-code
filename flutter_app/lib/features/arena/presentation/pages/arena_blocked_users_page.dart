import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

class ArenaBlockedUsersPage extends ConsumerStatefulWidget {
  const ArenaBlockedUsersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc203_blocked_content');
  static const emptyKey = Key('sc203_blocked_empty');

  static Key userKey(String id) => Key('sc203_blocked_user_$id');

  static Key unblockKey(String id) => Key('sc203_unblock_$id');

  static Key viewProfileKey(String id) => Key('sc203_view_profile_$id');

  static Key confirmUnblockKey(String id) => Key('sc203_confirm_unblock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaBlockedUsersPage> createState() =>
      _ArenaBlockedUsersPageState();
}

class _ArenaBlockedUsersPageState extends ConsumerState<ArenaBlockedUsersPage> {
  late List<ArenaBlockedUserDraft> _blockedUsers;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaBlockedUsers();
    if (!_initialized) {
      _blockedUsers = List<ArenaBlockedUserDraft>.of(snapshot.users);
      _initialized = true;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-203 ArenaBlockedUsersPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Người đã chặn',
            subtitle: 'An toàn · Open Arena',
            showBack: true,
            onBack: () => _close(context),
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
                    key: ArenaBlockedUsersPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: _blockedUsers.isEmpty
                        ? VitPageContent(
                            key: ArenaBlockedUsersPage.emptyKey,
                            padding: VitContentPadding.none,
                            children: [
                              VitEmptyState(
                                icon: Icons.shield_outlined,
                                title: snapshot.emptyTitle,
                                message: snapshot.emptySubtitle,
                              ),
                            ],
                          )
                        : VitPageContent(
                            padding: VitContentPadding.defaultPadding,
                            children: [
                              VitCard(
                                padding: EdgeInsets.zero,
                                child: _BlockInfoBanner(snapshot: snapshot),
                              ),
                              _BlockedUsersCard(
                                users: _blockedUsers,
                                onUnblock: (user) => _requestUnblock(user),
                                onViewProfile: (user) {
                                  HapticFeedback.selectionClick();
                                  context.go(
                                    AppRoutePaths.arenaCreator(user.id),
                                  );
                                },
                              ),
                              Text(
                                '${_blockedUsers.length} người đã bị chặn',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
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

  Future<void> _requestUnblock(ArenaBlockedUserDraft user) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _UnblockDialog(user: user),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _blockedUsers = _blockedUsers
          .where((blockedUser) => blockedUser.id != user.id)
          .toList(growable: false);
    });
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaSafety);
  }
}

class _BlockInfoBanner extends StatelessWidget {
  const _BlockInfoBanner({required this.snapshot});

  final ArenaBlockedUsersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ToneIcon(icon: Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.arenaBlockedBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedUsersCard extends StatelessWidget {
  const _BlockedUsersCard({
    required this.users,
    required this.onUnblock,
    required this.onViewProfile,
  });

  final List<ArenaBlockedUserDraft> users;
  final ValueChanged<ArenaBlockedUserDraft> onUnblock;
  final ValueChanged<ArenaBlockedUserDraft> onViewProfile;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < users.length; index++)
            _BlockedUserRow(
              key: ArenaBlockedUsersPage.userKey(users[index].id),
              user: users[index],
              isLast: index == users.length - 1,
              onUnblock: () => onUnblock(users[index]),
              onViewProfile: () => onViewProfile(users[index]),
            ),
        ],
      ),
    );
  }
}

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({
    super.key,
    required this.user,
    required this.isLast,
    required this.onUnblock,
    required this.onViewProfile,
  });

  final ArenaBlockedUserDraft user;
  final bool isLast;
  final VoidCallback onUnblock;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? AppColors.transparent : AppColors.divider,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            _BlockedAvatar(user: user),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.arenaBlockedTinyGap,
                    ),
                  ),
                  Text(
                    user.reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.arenaBlockedTinyGap,
                    ),
                  ),
                  Text(
                    '${user.blockedAt} · ${_sourceLabel(user.source)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _SmallActionButton(
                  key: ArenaBlockedUsersPage.unblockKey(user.id),
                  label: 'Bỏ chặn',
                  accentColor: AppColors.warn,
                  onTap: onUnblock,
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                _SmallActionButton(
                  key: ArenaBlockedUsersPage.viewProfileKey(user.id),
                  label: 'Xem hồ sơ',
                  accentColor: AppColors.text2,
                  onTap: onViewProfile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockedAvatar extends StatelessWidget {
  const _BlockedAvatar({required this.user});

  final ArenaBlockedUserDraft user;

  @override
  Widget build(BuildContext context) {
    final color = user.source == ArenaBlockedUserSource.reportOutcome
        ? AppColors.sell
        : AppColors.accent;
    final icon = user.source == ArenaBlockedUserSource.reportOutcome
        ? Icons.person_off_outlined
        : Icons.smart_toy_outlined;

    return Container(
      width: AppSpacing.arenaBlockedAvatarBox,
      height: AppSpacing.arenaBlockedAvatarBox,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(
        icon,
        color: color.withValues(alpha: 0.78),
        size: AppSpacing.arenaBlockedAvatarIcon,
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Container(
          height: AppSpacing.arenaBlockedActionHeight,
          constraints: const BoxConstraints(
            minWidth: AppSpacing.arenaBlockedActionMinWidth,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            border: Border.all(color: accentColor.withValues(alpha: 0.24)),
            borderRadius: AppRadii.xlRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: accentColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _UnblockDialog extends StatelessWidget {
  const _UnblockDialog({required this.user});

  final ArenaBlockedUserDraft user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      surfaceTintColor: AppColors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      title: Text(
        'Bỏ chặn ${user.name}?',
        style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
      ),
      content: Text(
        'Người này sẽ có thể thấy và tương tác với bạn trong Open Arena. Bạn có thể chặn lại bất cứ lúc nào.',
        style: AppTextStyles.body.copyWith(
          color: AppColors.text2,
          height: AppSpacing.arenaBlockedDialogLineHeight,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Giữ chặn',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ),
        TextButton(
          key: ArenaBlockedUsersPage.confirmUnblockKey(user.id),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Bỏ chặn',
            style: AppTextStyles.body.copyWith(
              color: AppColors.warn,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.arenaBlockedToneIconBox,
      height: AppSpacing.arenaBlockedToneIconBox,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.arenaBlockedToneIcon),
    );
  }
}

String _sourceLabel(ArenaBlockedUserSource source) {
  return switch (source) {
    ArenaBlockedUserSource.manual => 'Tự chặn',
    ArenaBlockedUserSource.reportOutcome => 'Từ báo cáo',
    ArenaBlockedUserSource.system => 'Hệ thống',
  };
}
