part of '../pages/p2p_payment_methods_page.dart';

class _AddMethodRow extends StatelessWidget {
  const _AddMethodRow({required this.snapshot});

  final P2PPaymentMethodsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AddMethodButton(
            key: P2PPaymentMethodsPage.addBankKey,
            icon: Icons.credit_card_rounded,
            label: 'Thêm ngân hàng',
            color: AppModuleAccents.p2p,
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.addBankRoute);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _AddMethodButton(
            key: P2PPaymentMethodsPage.addEwalletKey,
            icon: Icons.phone_android_rounded,
            label: 'Thêm ví điện tử',
            color: AppColors.accent,
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.addEwalletRoute);
            },
          ),
        ),
      ],
    );
  }
}

class _AddMethodButton extends StatelessWidget {
  const _AddMethodButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: color == AppColors.accent
                ? AppColors.accent08
                : AppColors.warn08,
            border: Border.all(
              color: color == AppColors.accent
                  ? AppColors.accent30
                  : AppColors.warningBorder,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final P2PPaymentListMethodDraft method;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  bool get _isBank => method.type == P2PPaymentListMethodType.bank;
  Color get _tone => _isBank ? AppModuleAccents.p2p : AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodsPage.methodKey(method.id),
      radius: VitCardRadius.sm,
      borderColor: method.isDefault ? AppColors.warningBorder : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MethodIcon(isBank: _isBank, tone: _tone),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          method.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        if (method.isVerified)
                          const Icon(
                            Icons.shield_outlined,
                            color: AppColors.buy,
                            size: 13,
                          ),
                        if (method.isDefault)
                          const VitStatusPill(
                            label: 'Mặc định',
                            status: VitStatusPillStatus.orange,
                            size: VitStatusPillSize.sm,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      method.accountNumber,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      method.accountName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Row(
                children: [
                  VitIconButton(
                    key: P2PPaymentMethodsPage.editKey(method.id),
                    icon: Icons.edit_rounded,
                    tooltip: 'Sửa phương thức',
                    size: VitIconButtonSize.sm,
                    variant: VitIconButtonVariant.ghost,
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  VitIconButton(
                    key: P2PPaymentMethodsPage.deleteKey(method.id),
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Xóa phương thức',
                    size: VitIconButtonSize.sm,
                    variant: VitIconButtonVariant.danger,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          if (!method.isDefault) ...[
            const SizedBox(height: AppSpacing.x3),
            _SetDefaultButton(methodId: method.id, onTap: onSetDefault),
          ],
          if (!method.isVerified) ...[
            const SizedBox(height: AppSpacing.x3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Chưa xác minh — Cần xác minh để sử dụng trên P2P',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.isBank, required this.tone});

  final bool isBank;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: tone == AppColors.accent ? AppColors.accent12 : AppColors.warn10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(
        isBank ? Icons.credit_card_rounded : Icons.phone_android_rounded,
        color: tone,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

class _SetDefaultButton extends StatelessWidget {
  const _SetDefaultButton({required this.methodId, required this.onTap});

  final String methodId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: P2PPaymentMethodsPage.defaultKey(methodId),
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.xlRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_border_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Flexible(
                child: Text(
                  'Đặt làm mặc định',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.medium,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
