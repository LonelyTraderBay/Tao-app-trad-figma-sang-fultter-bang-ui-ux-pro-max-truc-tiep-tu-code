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
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create API Key',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: 18),
          const _SheetInput(label: 'Key Name', hint: 'e.g., Trading Bot Key'),
          const SizedBox(height: 14),
          Text(
            'Permissions',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: _PermissionChip('Read Only')),
              SizedBox(width: 8),
              Expanded(child: _PermissionChip('Trade + Read')),
            ],
          ),
          const SizedBox(height: 16),
          if (_generated)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _securityGreen.withValues(alpha: .08),
                border: Border.all(color: _securityGreen.withValues(alpha: .2)),
                borderRadius: AppRadii.inputRadius,
              ),
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
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _securityPanel,
                      borderRadius: AppRadii.smRadius,
                    ),
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
                        IconButton(
                          onPressed: () => setState(() => _visible = !_visible),
                          icon: Icon(
                            _visible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.text3,
                            size: 18,
                          ),
                        ),
                        const Icon(
                          Icons.copy_rounded,
                          color: AppColors.text3,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save this key now - you will not be able to see it again.',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: () => setState(() => _generated = true),
                style: FilledButton.styleFrom(
                  backgroundColor: _securityPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                child: const Text('Generate API Key'),
              ),
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
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add IP to Whitelist',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: 18),
          const _SheetInput(label: 'IP Address', hint: 'e.g., 192.168.1.100'),
          const SizedBox(height: 14),
          const _SheetInput(
            label: 'Label (Optional)',
            hint: 'e.g., Home Network',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: _securityPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                ),
              ),
              child: const Text('Add IP Address'),
            ),
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
        const SizedBox(height: 8),
        Container(
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _securityPanel2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.mdRadius,
          ),
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
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _securityPanel2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.mdRadius,
      ),
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
