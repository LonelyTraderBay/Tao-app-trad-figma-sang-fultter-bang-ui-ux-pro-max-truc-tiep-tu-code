part of '../pages/p2p_payment_method_add_page.dart';

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.value, required this.onChanged});

  final P2PPaymentAddType value;
  final ValueChanged<P2PPaymentAddType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeButton(
            key: P2PPaymentMethodAddPage.bankTypeKey,
            label: 'Ngân hàng',
            icon: Icons.account_balance_rounded,
            active: value == P2PPaymentAddType.bank,
            onTap: () => onChanged(P2PPaymentAddType.bank),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _TypeButton(
            key: P2PPaymentMethodAddPage.ewalletTypeKey,
            label: 'Ví điện tử',
            icon: Icons.phone_iphone_rounded,
            active: value == P2PPaymentAddType.ewallet,
            onTap: () => onChanged(P2PPaymentAddType.ewallet),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: '$label payment type',
      child: Material(
        color: active ? AppColors.primary12 : AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(
            color: active ? AppColors.primary40 : AppColors.borderSolid,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: SizedBox(
            height: AppSpacing.ctaHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? AppModuleAccents.p2p : AppColors.text3,
                  size: AppSpacing.p2pPaymentTypeIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: active ? AppColors.text1 : AppColors.text2,
                      fontWeight: active
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionWrap extends StatelessWidget {
  const _PaymentOptionWrap({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final option in options)
          _PaymentOptionChip(
            key: P2PPaymentMethodAddPage.optionKey(option),
            label: option,
            selected: option == selected,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

class _PaymentOptionChip extends StatelessWidget {
  const _PaymentOptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label payment option',
      child: Material(
        color: selected ? AppColors.primary12 : AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(
            color: selected ? AppColors.primary40 : AppColors.borderSolid,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.xlRadius,
          child: Padding(
            padding: AppSpacing.p2pPaymentOptionPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.text1 : AppColors.text2,
                    fontWeight: selected
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentPreview extends StatelessWidget {
  const _PaymentPreview({required this.preview, required this.type});

  final P2PPaymentMethodPreview preview;
  final P2PPaymentAddType type;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodAddPage.previewKey,
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pPaymentCardPadding,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: type == P2PPaymentAddType.bank
                    ? Icons.account_balance_rounded
                    : Icons.phone_iphone_rounded,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.method,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    Text(
                      type == P2PPaymentAddType.bank
                          ? 'Ngân hàng'
                          : 'Ví điện tử',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.x3),
          _PreviewRow(label: 'Tài khoản', value: preview.maskedAccount),
          const SizedBox(height: AppSpacing.x2),
          _PreviewRow(label: 'Chủ tài khoản', value: preview.ownerName),
          const SizedBox(height: AppSpacing.x2),
          _PreviewRow(label: 'Ownership', value: preview.ownershipRiskMessage),
          const SizedBox(height: AppSpacing.x2),
          _PreviewRow(label: 'Limit', value: preview.limitMessage),
        ],
      ),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pPaymentCardPadding,
      borderColor: AppColors.warningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary12,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(color: AppColors.primary20),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.p2pPaymentPreviewLabelWidth,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}
