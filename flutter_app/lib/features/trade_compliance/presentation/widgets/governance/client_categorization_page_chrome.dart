part of '../../pages/governance/client_categorization_page.dart';

class _CurrentCategoryCard extends StatelessWidget {
  const _CurrentCategoryCard({required this.category});

  final TradeClientCategoryInfo category;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: TradeSpacingTokens.tradeBotClientCategoryHeroIcon,
                iconSize:
                    TradeSpacingTokens.tradeBotClientCategoryHeroIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: TradeSpacingTokens.tradeBotDisclosureGap,
                        ),
                        VitStatusPill(
                          label: 'CURRENT',
                          status: style.color == _clientAmber
                              ? VitStatusPillStatus.warning
                              : style.color == _clientPrimary
                              ? VitStatusPillStatus.info
                              : VitStatusPillStatus.success,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(
                Icons.check_circle_outline,
                color: style.color,
                size: TradeSpacingTokens.tradeBotClientCurrentIcon,
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.text1,
                  size: TradeSpacingTokens.tradeBotMediumIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.compact,
                    children: [
                      Text(
                        'Maximum Protection Active',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'You have full MiFID II retail investor protections',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
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

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.text1,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              density: VitDensity.compact,
              children: [
                Text(
                  'MiFID II Categorization',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Your client category determines the level of regulatory protection you receive. Retail clients have maximum protection.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
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

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: ClientCategorizationPage.disclosuresKey,
            icon: Icons.description_outlined,
            iconColor: _clientPrimary,
            label: 'Disclosures',
            onTap: () =>
                context.go(AppRoutePaths.tradeCopyRegulatoryDisclosures),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _QuickLinkButton(
            key: ClientCategorizationPage.settingsKey,
            icon: Icons.settings_outlined,
            iconColor: _clientGreen,
            label: 'Settings',
            onTap: () => context.go(AppRoutePaths.settingsSecurity),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      borderColor: _clientBorder.withValues(alpha: .72),
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.tradeBotMediumIcon,
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.style,
    required this.size,
    required this.iconSize,
  });

  final _CategoryStyle style;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: size,
      height: size,
      radius: size >= TradeSpacingTokens.tradeBotClientCategoryHeroIcon
          ? VitCardRadius.large
          : VitCardRadius.standard,
      variant: VitCardVariant.inner,
      borderColor: style.color.withValues(alpha: .24),
      alignment: Alignment.center,
      child: Icon(style.icon, color: style.color, size: iconSize),
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

_CategoryStyle _categoryStyle(String id) {
  return switch (id) {
    'professional' => const _CategoryStyle(
      color: _clientPrimary,
      icon: Icons.workspace_premium_outlined,
    ),
    'ecp' => const _CategoryStyle(
      color: _clientAmber,
      icon: Icons.lock_outline,
    ),
    _ => const _CategoryStyle(color: _clientGreen, icon: Icons.person_outline),
  };
}
