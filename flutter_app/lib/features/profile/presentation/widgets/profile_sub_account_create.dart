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
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          const _FormFieldPreview(
            label: 'T\u00EAn t\u00E0i kho\u1EA3n',
            value: 'VD: Grid Bot #2',
          ),
          const SizedBox(height: 12),
          const _FormPillRow(
            label: 'Lo\u1EA1i t\u00E0i kho\u1EA3n',
            values: ['Spot', 'Margin', 'Futures', 'T\u1EA5t c\u1EA3'],
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 14),
          VitCtaButton(
            onPressed: () {},
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: AppSpacing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.borderSolid),
          ),
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1,
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
        _SmallPill(
          label: value,
          foreground: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        if (wrap)
          Wrap(spacing: 8, runSpacing: 8, children: children)
        else
          Row(
            children: [
              for (final child in children) ...[
                Expanded(child: child),
                if (child != children.last) const SizedBox(width: 8),
              ],
            ],
          ),
      ],
    );
  }
}
