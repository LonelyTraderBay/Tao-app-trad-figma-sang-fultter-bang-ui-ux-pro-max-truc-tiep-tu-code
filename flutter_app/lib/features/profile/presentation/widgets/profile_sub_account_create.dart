part of '../pages/sub_account_page.dart';

class _CreateSubAccountButton extends StatelessWidget {
  const _CreateSubAccountButton({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SubAccountPage.createButtonKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.compact,
      leading: Icon(isOpen ? Icons.close_rounded : Icons.add_rounded),
      child: Text(
        isOpen
            ? '\u0110\u00F3ng bi\u1EC3u m\u1EABu'
            : 'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 m\u1EDBi',
      ),
    );
  }
}

class _CreateSubAccountForm extends StatelessWidget {
  const _CreateSubAccountForm();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SubAccountPage.createFormKey,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const _FormFieldPreview(
            label: 'T\u00EAn t\u00E0i kho\u1EA3n',
            value: 'VD: Grid Bot #2',
          ),
          const SizedBox(height: AppSpacing.x3),
          const _FormPillRow(
            label: 'Lo\u1EA1i t\u00E0i kho\u1EA3n',
            values: ['Spot', 'Margin', 'Futures', 'T\u1EA5t c\u1EA3'],
          ),
          const SizedBox(height: AppSpacing.x3),
          const _FormPillRow(
            label: 'Quy\u1EC1n h\u1EA1n',
            values: [
              'Spot',
              'Margin',
              'Futures',
              'Chuy\u1EC3n',
              'R\u00FAt',
              'Xem',
            ],
            wrap: true,
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            onPressed: () {},
            density: VitDensity.compact,
            child: const Text('T\u1EA1o t\u00E0i kho\u1EA3n'),
          ),
        ],
      ),
    );
  }
}

class _FormFieldPreview extends StatelessWidget {
  const _FormFieldPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: VitDensity.compact.controlHeight,
          ),
          child: Material(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: const BorderSide(color: AppColors.borderSolid),
            ),
            child: Padding(
              padding: AppSpacing.profileSubAccountFormInputPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(color: AppColors.text3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormPillRow extends StatelessWidget {
  const _FormPillRow({
    required this.label,
    required this.values,
    this.wrap = false,
  });

  final String label;
  final List<String> values;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final value in values)
        VitAccentPill(label: value, accentColor: AppColors.primary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        if (wrap)
          Wrap(
            spacing: AppSpacing.profileSubAccountFormPillGap,
            runSpacing: AppSpacing.profileSubAccountFormPillGap,
            children: children,
          )
        else
          Row(
            children: [
              for (final child in children) ...[
                Expanded(child: child),
                if (child != children.last)
                  const SizedBox(
                    width: AppSpacing.profileSubAccountFormPillGap,
                  ),
              ],
            ],
          ),
      ],
    );
  }
}
