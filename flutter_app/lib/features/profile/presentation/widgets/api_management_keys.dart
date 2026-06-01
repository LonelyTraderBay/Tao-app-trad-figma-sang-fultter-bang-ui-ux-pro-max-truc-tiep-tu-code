part of '../pages/api_management_page.dart';

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ApiManagementPage.createKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _apiPrimary.withValues(alpha: .15),
          borderRadius: AppRadii.lgRadius,
          border: Border.all(color: _apiPrimary.withValues(alpha: .28)),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add_rounded, color: _apiPrimary, size: 24),
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({
    required this.apiKey,
    required this.showSecret,
    required this.copiedId,
    required this.onToggle,
    required this.onReveal,
    required this.onCopy,
    required this.onDelete,
  });

  final ProfileApiKey apiKey;
  final bool showSecret;
  final String? copiedId;
  final VoidCallback onToggle;
  final VoidCallback onReveal;
  final void Function(String id, String value) onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Opacity(
      opacity: active ? 1 : .65,
      child: Container(
        key: ApiManagementPage.cardKey(apiKey.id),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: _apiPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: active ? _apiBorder : _apiRed.withValues(alpha: .15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApiKeyHeader(apiKey: apiKey, onToggle: onToggle),
            const SizedBox(height: 12),
            _SecretRow(
              label: 'API KEY',
              value: _maskedKey(apiKey.key),
              labelColor: _apiMuted,
              trailing: _IconTap(
                icon: copiedId == '${apiKey.id}_key'
                    ? Icons.check_circle_outline_rounded
                    : Icons.copy_rounded,
                color: copiedId == '${apiKey.id}_key'
                    ? _apiGreen
                    : AppColors.text2,
                onTap: () => onCopy('${apiKey.id}_key', apiKey.key),
              ),
            ),
            const SizedBox(height: 8),
            _SecretRow(
              label: 'SECRET',
              value: showSecret
                  ? apiKey.secret
                  : '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
              labelColor: _apiRed,
              redBorder: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconTap(
                    key: ApiManagementPage.revealKey(apiKey.id),
                    icon: showSecret
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.text2,
                    onTap: onReveal,
                  ),
                  if (showSecret) ...[
                    const SizedBox(width: 7),
                    _IconTap(
                      icon: copiedId == '${apiKey.id}_secret'
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      color: copiedId == '${apiKey.id}_secret'
                          ? _apiGreen
                          : AppColors.text2,
                      onTap: () => onCopy('${apiKey.id}_secret', apiKey.secret),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PermissionBadges(apiKey: apiKey),
            const SizedBox(height: 13),
            _UsageRow(apiKey: apiKey),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _RegenerateButton(onTap: () {})),
                const SizedBox(width: 10),
                _DeleteButton(onTap: onDelete, id: apiKey.id),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiKeyHeader extends StatelessWidget {
  const _ApiKeyHeader({required this.apiKey, required this.onToggle});

  final ProfileApiKey apiKey;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active
                ? _apiPrimary.withValues(alpha: .15)
                : _apiRed.withValues(alpha: .1),
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: active
                  ? _apiPrimary.withValues(alpha: .22)
                  : _apiRed.withValues(alpha: .22),
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.key_rounded,
            color: active ? _apiPrimary : _apiRed,
            size: 19,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      apiKey.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  _StatusBadge(active: active),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                'T\u1EA1o: ${apiKey.createdAt} \u2022 ${apiKey.expiresAt == null ? 'Kh\u00F4ng h\u1EBFt h\u1EA1n' : 'H\u1EBFt h\u1EA1n: ${apiKey.expiresAt}'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: _apiMuted,
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        _ToggleSwitch(
          key: ApiManagementPage.toggleKey(apiKey.id),
          active: active,
          onTap: onToggle,
        ),
      ],
    );
  }
}
