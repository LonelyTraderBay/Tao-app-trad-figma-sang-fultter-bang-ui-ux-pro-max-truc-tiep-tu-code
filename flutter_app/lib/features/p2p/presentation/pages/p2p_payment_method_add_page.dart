import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

enum P2PPaymentAddType { bank, ewallet }

class P2PPaymentMethodAddPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodAddPage({
    super.key,
    this.initialType = P2PPaymentAddType.bank,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc232_p2p_payment_method_add_content');
  static const bankTypeKey = Key('sc232_payment_add_bank_type');
  static const ewalletTypeKey = Key('sc232_payment_add_ewallet_type');
  static const accountFieldKey = Key('sc232_payment_add_account');
  static const ownerFieldKey = Key('sc232_payment_add_owner');
  static const saveButtonKey = Key('sc232_payment_add_save');
  static const confirmSaveKey = Key('sc232_payment_add_confirm');
  static const previewKey = Key('sc232_payment_add_preview');

  static Key optionKey(String value) => Key('sc232_payment_option_$value');

  final P2PPaymentAddType initialType;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodAddPage> createState() =>
      _P2PPaymentMethodAddPageState();
}

class _P2PPaymentMethodAddPageState
    extends ConsumerState<P2PPaymentMethodAddPage> {
  final _accountController = TextEditingController();
  final _ownerController = TextEditingController();

  late P2PPaymentAddType _type;
  String? _selectedMethod;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pPaymentMethodAddProvider);
    final controller = P2PPaymentMethodAddController(
      state: P2PPaymentMethodAddViewState(snapshot: snapshot),
    );
    final options = controller.optionsFor(
      bankType: _type == P2PPaymentAddType.bank,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const bottomInset = AppSpacing.x4;
    final footerInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-232 P2PPaymentMethodAddPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title:
                  'Thêm ${_type == P2PPaymentAddType.bank ? 'ngân hàng' : 'ví điện tử'}',
              subtitle: 'Thanh toán · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PPaymentMethodAddPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TypeSelector(value: _type, onChanged: _changeType),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionLabel(
                        _type == P2PPaymentAddType.bank
                            ? 'Chọn ngân hàng'
                            : 'Chọn ví điện tử',
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _PaymentOptionWrap(
                        options: options,
                        selected: _selectedMethod,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedMethod = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      VitInput(
                        controller: _accountController,
                        fieldKey: P2PPaymentMethodAddPage.accountFieldKey,
                        semanticLabel: 'P2P payment account',
                        label: _type == P2PPaymentAddType.bank
                            ? 'Số tài khoản'
                            : 'Số điện thoại / tài khoản ví',
                        hintText: _type == P2PPaymentAddType.bank
                            ? snapshot.defaultBankAccountHint
                            : snapshot.defaultEwalletAccountHint,
                        prefix: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      VitInput(
                        controller: _ownerController,
                        fieldKey: P2PPaymentMethodAddPage.ownerFieldKey,
                        semanticLabel: 'P2P payment account owner',
                        label: 'Tên chủ tài khoản',
                        hintText: snapshot.ownerNameHint,
                        prefix: const Icon(Icons.person_outline_rounded),
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [_UppercaseTextFormatter()],
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _SecurityNote(note: snapshot.securityNote),
                      if (_isValidFor(controller)) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _PaymentPreview(
                          preview: controller.preview(
                            selectedMethod: _selectedMethod!,
                            account: _accountController.text,
                            ownerName: _ownerController.text,
                          ),
                          type: _type,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            VitStickyFooter(
              backgroundColor: AppColors.surface.withValues(alpha: 0.96),
              child: Padding(
                padding: EdgeInsets.only(bottom: footerInset),
                child: Semantics(
                  label: 'Preview and add P2P payment method',
                  button: true,
                  enabled: _isValidFor(controller) && !_submitting,
                  child: VitCtaButton(
                    key: P2PPaymentMethodAddPage.saveButtonKey,
                    loading: _submitting,
                    onPressed: _isValidFor(controller) && !_submitting
                        ? () => _confirmSave(context, controller)
                        : null,
                    child: Text(
                      _submitting ? 'Đang lưu...' : 'Thêm phương thức',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeType(P2PPaymentAddType type) {
    if (_type == type) return;
    HapticFeedback.selectionClick();
    setState(() {
      _type = type;
      _selectedMethod = null;
    });
  }

  bool _isValidFor(P2PPaymentMethodAddController controller) {
    return controller.canPreview(
      selectedMethod: _selectedMethod,
      account: _accountController.text,
      ownerName: _ownerController.text,
    );
  }

  Future<void> _confirmSave(
    BuildContext context,
    P2PPaymentMethodAddController controller,
  ) async {
    final preview = controller.preview(
      selectedMethod: _selectedMethod ?? '',
      account: _accountController.text,
      ownerName: _ownerController.text,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        title: Text(
          preview.confirmTitle,
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfirmRow(label: 'Phương thức', value: _selectedMethod ?? '--'),
            _ConfirmRow(label: 'Tài khoản', value: preview.maskedAccount),
            _ConfirmRow(label: 'Chủ tài khoản', value: preview.ownerName),
            _ConfirmRow(
              label: 'Ownership',
              value: preview.ownershipRiskMessage,
            ),
            _ConfirmRow(label: 'Limit', value: preview.limitMessage),
            const SizedBox(height: AppSpacing.x3),
            Text(
              preview.confirmMessage,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Hủy',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          TextButton(
            key: P2PPaymentMethodAddPage.confirmSaveKey,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Xác nhận',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (!context.mounted || confirmed != true) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    context.go(preview.saveRoute);
  }
}

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
        color: AppColors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          height: AppSpacing.ctaHeight,
          decoration: BoxDecoration(
            color: active ? AppColors.primary12 : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: active ? AppColors.primary40 : AppColors.borderSolid,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.inputRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? AppModuleAccents.p2p : AppColors.text3,
                  size: 18,
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
        color: AppColors.transparent,
        borderRadius: AppRadii.xlRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            borderRadius: AppRadii.xlRadius,
            border: Border.all(
              color: selected ? AppColors.primary40 : AppColors.borderSolid,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.xlRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const Divider(color: AppColors.divider, height: 1),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
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
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.primary20),
      ),
      child: Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
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
          width: 108,
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

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
        ],
      ),
    );
  }
}

class _UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
