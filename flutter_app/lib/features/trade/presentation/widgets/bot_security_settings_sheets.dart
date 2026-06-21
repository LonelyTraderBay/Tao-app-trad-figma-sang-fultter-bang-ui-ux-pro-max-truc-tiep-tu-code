part of '../pages/bot_security_settings_page.dart';

class _ApiKeySheet extends StatefulWidget {
  const _ApiKeySheet({required this.snapshot});

  final TradeBotSecuritySettingsSnapshot snapshot;

  @override
  State<_ApiKeySheet> createState() => _ApiKeySheetState();
}

class _ApiKeySheetState extends State<_ApiKeySheet> {
  bool _generated = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final keyText = widget.snapshot.generatedApiKeyPreview;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).bottom + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create API Key',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x2),
          const _SheetInput(label: 'Key Name', hint: 'e.g., Trading Bot Key'),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Permissions',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: const [
              Expanded(child: _PermissionChip('Read Only')),
              SizedBox(width: AppSpacing.x2),
              Expanded(child: _PermissionChip('Trade + Read')),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          if (_generated)
            VitCard(
              variant: VitCardVariant.inner,
              density: VitDensity.compact,
              borderColor: _securityGreen.withValues(alpha: .2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'API Key Generated',
                    style: AppTextStyles.caption.copyWith(
                      color: _securityGreen,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  VitCard(
                    variant: VitCardVariant.ghost,
                    density: VitDensity.compact,
                    borderColor: AppColors.borderSolid,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _visible ? keyText : '********************',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        VitIconButton(
                          icon: _visible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          tooltip: _visible ? 'Hide API key' : 'Show API key',
                          size: VitIconButtonSize.sm,
                          variant: VitIconButtonVariant.transparent,
                          onPressed: () => setState(() => _visible = !_visible),
                        ),
                        const Icon(
                          Icons.copy_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Save this key now - you will not be able to see it again.',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            )
          else
            VitCtaButton(
              onPressed: () => setState(() => _generated = true),
              variant: VitCtaButtonVariant.primary,
              child: const Text('Generate API Key'),
            ),
        ],
      ),
    );
  }
}

class _IpSheet extends StatelessWidget {
  const _IpSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).bottom + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add IP to Whitelist',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x2),
          const _SheetInput(label: 'IP Address', hint: 'e.g., 192.168.1.100'),
          const SizedBox(height: AppSpacing.x2),
          const _SheetInput(
            label: 'Label (Optional)',
            hint: 'e.g., Home Network',
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            variant: VitCtaButtonVariant.primary,
            child: const Text('Add IP Address'),
          ),
        ],
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        VitCard(
          density: VitDensity.compact,
          alignment: Alignment.centerLeft,
          variant: VitCardVariant.inner,
          borderColor: AppColors.borderSolid,
          child: Text(
            hint,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
