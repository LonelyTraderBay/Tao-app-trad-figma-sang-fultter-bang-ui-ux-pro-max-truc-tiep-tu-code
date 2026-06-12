part of '../pages/api_management_page.dart';

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? _apiGreen : _apiRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        active ? '\u2022 Active' : '\u2022 Disabled',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _apiGreen : AppColors.borderSolid;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 27,
        height: 16,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        alignment: active ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
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
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _apiPanel2,
        borderRadius: AppRadii.inputRadius,
        border: redBorder
            ? Border.all(color: _apiRed.withValues(alpha: .1))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w800,
                height: 1,
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
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, color: color, size: 14),
    );
  }
}

class _PermissionBadges extends StatelessWidget {
  const _PermissionBadges({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
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
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
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
        Icon(Icons.access_time_rounded, color: _apiMuted, size: 11),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            'D\u00F9ng l\u1EA7n cu\u1ED1i: ${apiKey.lastUsed ?? 'Ch\u01B0a d\u00F9ng'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: _apiMuted, height: 1),
          ),
        ),
        Text(
          '${_formatInt(apiKey.requestCount)} requests',
          style: AppTextStyles.micro.copyWith(color: _apiMuted, height: 1),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: _apiPrimary.withValues(alpha: .1),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _apiPrimary.withValues(alpha: .25)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sync_rounded, color: _apiPrimary, size: 13),
            const SizedBox(width: 5),
            Text(
              'T\u1EA1o l\u1EA1i Secret',
              style: AppTextStyles.micro.copyWith(
                color: _apiPrimary,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap, required this.id});

  final VoidCallback onTap;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ApiManagementPage.deleteKey(id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          color: _apiRed.withValues(alpha: .1),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _apiRed.withValues(alpha: .25)),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: _apiRed,
          size: 17,
        ),
      ),
    );
  }
}
