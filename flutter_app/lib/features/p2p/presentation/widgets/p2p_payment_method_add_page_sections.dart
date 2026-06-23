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
        const SizedBox(width: _p2pPaymentAddSectionGap),
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
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      fullWidth: true,
      height: _p2pPaymentAddTypeExtent,
      accentColor: AppModuleAccents.p2p,
      leading: Icon(icon),
      semanticLabel: '$label payment type',
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
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      padding: _p2pPaymentAddOptionPadding,
      accentColor: AppModuleAccents.p2p,
      showSelectedIcon: true,
      selectedIcon: Icons.check_circle_outline_rounded,
      semanticLabel: '$label payment option',
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
      padding: _p2pPaymentAddCardPadding,
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
              const SizedBox(width: _p2pPaymentAddSectionGap),
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
          const SizedBox(height: _p2pPaymentAddSectionGap),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: _p2pPaymentAddSectionGap),
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
      padding: _p2pPaymentAddCardPadding,
      borderColor: AppColors.warningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: _p2pPaymentAddSectionGap),
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
        width: _p2pPaymentAddIconBox,
        height: _p2pPaymentAddIconBox,
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
          width: _p2pPaymentAddPreviewLabelWidth,
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
