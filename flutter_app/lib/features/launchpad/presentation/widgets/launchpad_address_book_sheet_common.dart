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
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.launchpadSheetMaxWidth,
          ),
          padding: const EdgeInsets.all(AppSpacing.x5),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.cardLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppSpacing.launchpadBox44,
                  height: AppSpacing.launchpadSheetHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.xlRadius,
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
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadAddressBookPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.inputRadius,
      ),
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
                height: AppSpacing.launchpadLineHeightReadable,
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
    return InkWell(
      borderRadius: AppRadii.xlRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active
                ? color.withValues(alpha: .32)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: active ? AppTextStyles.extraBold : AppTextStyles.medium,
          ),
        ),
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.xlRadius,
        ),
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
    return Container(
      width: AppSpacing.launchpadBox44,
      height: AppSpacing.launchpadBox44,
      decoration: BoxDecoration(
        color: address.accent.withValues(alpha: .16),
        border: Border.all(color: address.accent.withValues(alpha: .28)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(
        _chainIcon(address.iconKey),
        color: address.accent,
        size: AppSpacing.launchpadIcon3xl,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.extraBold,
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
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
