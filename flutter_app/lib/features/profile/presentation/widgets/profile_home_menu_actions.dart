part of '../pages/profile_page.dart';

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

class _ProfileProductHub extends StatelessWidget {
  const _ProfileProductHub({required this.shortcuts});

  final List<ProfileProductShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          key: ProfilePage.productHubKey,
          spacing: 10,
          runSpacing: 10,
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
    return GestureDetector(
      key: ProfilePage.productShortcutKey(shortcut.id),
      onTap: () => context.go(shortcut.route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 74,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _profilePanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: accent.withValues(alpha: .22)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(shortcut.iconKey), color: accent, size: 19),
            ),
            const SizedBox(width: 10),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    shortcut.stateLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
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
