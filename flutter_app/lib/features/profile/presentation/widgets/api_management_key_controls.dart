part of '../pages/api_management_page.dart';

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? _apiGreen : _apiRed;
    return VitAccentPill(
      label: active ? '\u2022 Active' : '\u2022 Disabled',
      accentColor: color,
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      child: VitTogglePill(
        enabled: active,
        width: AppSpacing.profileApiToggleWidth,
        height: AppSpacing.profileApiToggleHeight,
        knobSize: AppSpacing.profileApiToggleKnob,
        knobMargin: AppSpacing.profileApiToggleKnobMargin,
        activeColor: _apiGreen.withValues(alpha: .16),
        activeKnobColor: _apiGreen,
        inactiveColor: AppColors.transparent,
        inactiveKnobColor: AppColors.borderSolid,
      ),
    );
  }
}

class _SecretRow extends StatelessWidget {
  const _SecretRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.trailing,
    this.redBorder = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Widget trailing;
  final bool redBorder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _apiPanel2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: redBorder
            ? BorderSide(color: _apiRed.withValues(alpha: .1))
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.x6 + AppSpacing.x4,
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: labelColor,
                  fontWeight: AppTextStyles.extraBold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.extraBold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      child: Icon(icon, color: color, size: AppSpacing.profileApiIconAction),
    );
  }
}

class _PermissionBadges extends StatelessWidget {
  const _PermissionBadges({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.profileApiPermissionSpacing,
      runSpacing: AppSpacing.profileApiPermissionRunSpacing,
      children: [
        for (final permission in apiKey.permissions)
          _SmallBadge(
            label: _permissionLabel(permission),
            color: _permissionColor(permission),
          ),
        if (apiKey.ipWhitelist.isNotEmpty)
          _SmallBadge(
            label: '${apiKey.ipWhitelist.length} IPs',
            color: _apiGreen,
            icon: Icons.language_rounded,
          )
        else
          const _SmallBadge(
            label: 'Kh\u00F4ng gi\u1EDBi h\u1EA1n IP',
            color: _apiAmber,
            icon: Icons.warning_amber_rounded,
          ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.smRadius,
        side: BorderSide(color: color.withValues(alpha: .24)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: _apiMuted,
          size: AppSpacing.profileApiUsageIcon,
        ),
        const SizedBox(width: AppSpacing.profileApiUsageGapInline),
        Expanded(
          child: Text(
            'D\u00F9ng l\u1EA7n cu\u1ED1i: ${apiKey.lastUsed ?? 'Ch\u01B0a d\u00F9ng'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: _apiMuted),
          ),
        ),
        Text(
          '${_formatInt(apiKey.requestCount)} requests',
          style: AppTextStyles.micro.copyWith(color: _apiMuted),
        ),
      ],
    );
  }
}

class _RegenerateButton extends StatelessWidget {
  const _RegenerateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      density: VitDensity.compact,
      variant: VitCtaButtonVariant.secondary,
      leading: const Icon(Icons.sync_rounded),
      child: const Text('T\u1EA1o l\u1EA1i Secret'),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap, required this.id});

  final VoidCallback onTap;
  final String id;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: ApiManagementPage.deleteKey(id),
      icon: Icons.delete_outline_rounded,
      tooltip: 'Xo\u00E1 API key',
      onPressed: onTap,
      variant: VitIconButtonVariant.danger,
      size: VitIconButtonSize.md,
    );
  }
}
