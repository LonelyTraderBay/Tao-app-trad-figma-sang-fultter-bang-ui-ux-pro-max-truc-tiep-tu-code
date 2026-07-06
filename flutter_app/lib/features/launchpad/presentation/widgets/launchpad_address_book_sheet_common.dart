part of '../pages/launchpad_address_book_page.dart';

class _AddAddressSheet extends StatelessWidget {
  const _AddAddressSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadAddressBookPage.addSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.launchpadSheetMaxWidth,
          ),
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.sheetTopLargeRadius,
              ),
            ),
            child: Padding(
              padding: AppSpacing.launchpadPaddingX5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      width: AppSpacing.launchpadBox44,
                      height: AppSpacing.x1,
                      child: DecoratedBox(
                        decoration: const ShapeDecoration(
                          color: AppColors.borderSolid,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Text(
                    'Them dia chi moi',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Address mutation se can KYC submission-step va preview confirm truoc khi ghi len backend.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    key: LaunchpadAddressBookPage.addSheetCloseKey,
                    onPressed: onClose,
                    leading: const Icon(
                      Icons.close_rounded,
                      color: AppColors.onAccent,
                    ),
                    child: const Text('Dong'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadAddressBookPage.infoKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      background: const ColoredBox(color: AppColors.primary08),
      padding: AppSpacing.launchpadPaddingX3,
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.launchpadIconXl,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'So dia chi duoc luu tren thiet bi. Luon kiem tra lai dia chi truoc khi thuc hien giao dich.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.launchpadLineHeightShort,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      accentColor: color,
      onTap: onTap,
      padding: AppSpacing.launchpadPillPadding,
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCardStat(
        padding: AppSpacing.launchpadInlinePillPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.launchpadIconMd),
            const SizedBox(width: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.heavy,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainIcon extends StatelessWidget {
  const _ChainIcon({required this.address});

  final LaunchpadWalletAddressDraft address;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox44,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: address.accent.resolve().withValues(alpha: .16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.lgRadius,
            side: BorderSide(
              color: address.accent.resolve().withValues(alpha: .28),
            ),
          ),
        ),
        child: Center(
          child: Icon(
            _chainIcon(address.iconKey),
            color: address.accent.resolve(),
            size: AppSpacing.launchpadIcon3xl,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadLiveBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.launchpadVerticalPaddingX1,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _chainColor(String chain) {
  return switch (chain) {
    'BSC' => AppColors.warn,
    'Polygon' => AppColors.accent,
    'Arbitrum' => AppColors.primary,
    _ => AppModuleAccents.launchpad,
  };
}

IconData _chainIcon(String iconKey) {
  return switch (iconKey) {
    'bsc' => Icons.hexagon_outlined,
    'polygon' => Icons.hive_outlined,
    'arbitrum' => Icons.change_circle_outlined,
    _ => Icons.account_balance_wallet_outlined,
  };
}
