part of '../pages/profile_page.dart';

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.section});

  final ProfileMenuSection section;

  @override
  Widget build(BuildContext context) {
    final accent = Color(section.accentHex);
    return VitCard(
      borderColor: _profileBorder,
      clip: true,
      child: Column(
        children: [
          for (final item in section.items) ...[
            _MenuRow(item: item, accent: accent),
            if (item != section.items.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileProductHub extends StatelessWidget {
  const _ProfileProductHub({required this.shortcuts});

  final List<ProfileProductShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - AppSpacing.profileProductGridGap) / 2;
        return Wrap(
          key: ProfilePage.productHubKey,
          spacing: AppSpacing.profileProductGridGap,
          runSpacing: AppSpacing.profileProductGridGap,
          children: [
            for (final shortcut in shortcuts)
              SizedBox(
                width: tileWidth,
                child: _ProfileProductTile(shortcut: shortcut),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileProductTile extends StatelessWidget {
  const _ProfileProductTile({required this.shortcut});

  final ProfileProductShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final accent = Color(shortcut.accentHex);
    return VitCard(
      key: ProfilePage.productShortcutKey(shortcut.id),
      onTap: () => context.go(shortcut.route),
      density: VitDensity.compact,
      borderColor: accent.withValues(alpha: .22),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.profileProductIconBox,
            height: AppSpacing.profileProductIconBox,
            child: Material(
              color: accent.withValues(alpha: .12),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
              child: Icon(
                _iconFor(shortcut.iconKey),
                color: accent,
                size: AppSpacing.profileProductIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.profileProductGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortcut.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.profileProductLabelGap),
                Text(
                  shortcut.stateLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: accent),
                ),
              ],
            ),
          ),
        ],
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.standard.controlHeight,
        ),
        child: Padding(
          padding: AppSpacing.profileMenuRowPadding,
          child: Row(
            children: [
              SizedBox(
                width: AppSpacing.profileMenuIconBox,
                height: AppSpacing.profileMenuIconBox,
                child: Material(
                  color: accent.withValues(alpha: .12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Icon(
                    _iconFor(item.iconKey),
                    color: accent,
                    size: AppSpacing.profileMenuIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.profileMenuGap),
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
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: AppSpacing.profileMenuSubtitleGap),
                      Text(
                        item.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: item.subtitleHex == null
                              ? _profileMuted
                              : Color(item.subtitleHex!),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profileMuted,
                size: AppSpacing.profileMenuChevron,
              ),
            ],
          ),
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
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: _profileBorder,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Center(
          child: Text(
            'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
            style: AppTextStyles.control.copyWith(color: AppColors.text2),
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
    return VitCard(
      key: ProfilePage.logoutKey,
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: _profileRed.withValues(alpha: .28),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: _profileRed,
              size: AppSpacing.profileLogoutIcon,
            ),
            const SizedBox(width: AppSpacing.profileLogoutGap),
            Text(
              '\u0110\u0103ng xu\u1EA5t',
              style: AppTextStyles.baseMedium.copyWith(
                color: _profileRed,
                fontWeight: AppTextStyles.bold,
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
    return VitSectionHeader(
      title: label,
      accentColor: accent,
      variant: VitSectionHeaderVariant.accentBar,
      density: VitDensity.compact,
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'shield-check' => Icons.verified_user_outlined,
    'wallet' => Icons.account_balance_wallet_outlined,
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
    'rocket' => Icons.rocket_launch_outlined,
    'copy' => Icons.content_copy_rounded,
    'zap' => Icons.bolt_rounded,
    'bot' => Icons.smart_toy_outlined,
    'help' => Icons.help_outline_rounded,
    'file' => Icons.article_outlined,
    'star' => Icons.star_border_rounded,
    _ => Icons.circle_outlined,
  };
}
