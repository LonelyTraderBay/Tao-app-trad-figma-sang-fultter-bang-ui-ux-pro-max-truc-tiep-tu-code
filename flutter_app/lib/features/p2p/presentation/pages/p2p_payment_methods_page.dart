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
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PPaymentMethodsPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc237_p2p_payment_methods_content');
  static const addBankKey = Key('sc237_p2p_payment_methods_add_bank');
  static const addEwalletKey = Key('sc237_p2p_payment_methods_add_ewallet');
  static const deleteConfirmKey = Key(
    'sc237_p2p_payment_methods_delete_confirm',
  );

  static Key methodKey(String id) => Key('sc237_p2p_payment_method_$id');
  static Key editKey(String id) => Key('sc237_p2p_payment_method_edit_$id');
  static Key deleteKey(String id) => Key('sc237_p2p_payment_method_delete_$id');
  static Key defaultKey(String id) =>
      Key('sc237_p2p_payment_method_default_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodsPage> createState() =>
      _P2PPaymentMethodsPageState();
}

class _P2PPaymentMethodsPageState extends ConsumerState<P2PPaymentMethodsPage> {
  var _seeded = false;
  List<P2PPaymentListMethodDraft> _methods = const [];
  String? _pendingDeleteId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getPaymentMethods();
    if (!_seeded) {
      _methods = List<P2PPaymentListMethodDraft>.of(snapshot.methods);
      _seeded = true;
    }

    final bankMethods = _methods
        .where((item) => item.type == P2PPaymentListMethodType.bank)
        .toList(growable: false);
    final ewalletMethods = _methods
        .where((item) => item.type == P2PPaymentListMethodType.ewallet)
        .toList(growable: false);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final pendingMethod = _pendingDeleteId == null
        ? null
        : _methodById(_pendingDeleteId!);

    return Stack(
      children: [
        VitPageLayout(
          variant: VitPageVariant.flush,
          semanticLabel: 'SC-237 P2PPaymentMethodsPage',
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Phương thức thanh toán',
                  subtitle: 'Thanh toán · P2P',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.p2p),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PPaymentMethodsPage.contentKey,
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
                          _AddMethodRow(snapshot: snapshot),
                          const SizedBox(height: AppSpacing.x5),
                          if (bankMethods.isNotEmpty) ...[
                            _SectionHeader(
                              icon: Icons.credit_card_rounded,
                              title:
                                  'Tài khoản ngân hàng (${bankMethods.length})',
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            for (final method in bankMethods) ...[
                              _PaymentMethodCard(
                                method: method,
                                onEdit: () => _openEdit(method),
                                onDelete: () => _requestDelete(method.id),
                                onSetDefault: () => _setDefault(method.id),
                              ),
                              const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                          if (ewalletMethods.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.x2),
                            _SectionHeader(
                              icon: Icons.phone_android_rounded,
                              title: 'Ví điện tử (${ewalletMethods.length})',
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            for (final method in ewalletMethods) ...[
                              _PaymentMethodCard(
                                method: method,
                                onEdit: () => _openEdit(method),
                                onDelete: () => _requestDelete(method.id),
                                onSetDefault: () => _setDefault(method.id),
                              ),
                              const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                          if (_methods.isEmpty)
                            _EmptyPaymentMethods(snapshot: snapshot),
                          _SecurityNotice(text: snapshot.securityNote),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (pendingMethod != null)
          _DeleteConfirmation(
            method: pendingMethod,
            title: snapshot.deleteConfirmTitle,
            message: snapshot.deleteConfirmMessage,
            onCancel: _cancelDelete,
            onConfirm: () => _confirmDelete(pendingMethod.id),
          ),
      ],
    );
  }

  void _openEdit(P2PPaymentListMethodDraft method) {
    HapticFeedback.selectionClick();
    final type = method.type == P2PPaymentListMethodType.bank
        ? 'bank'
        : 'ewallet';
    context.go('${AppRoutePaths.p2pPaymentMethodAdd}?type=$type');
  }

  void _requestDelete(String id) {
    HapticFeedback.selectionClick();
    setState(() => _pendingDeleteId = id);
  }

  void _cancelDelete() {
    HapticFeedback.selectionClick();
    setState(() => _pendingDeleteId = null);
  }

  void _confirmDelete(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      _methods = _methods.where((item) => item.id != id).toList();
      _pendingDeleteId = null;
    });
  }

  void _setDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _methods = _methods
          .map((item) => item.copyWith(isDefault: item.id == id))
          .toList();
    });
  }

  P2PPaymentListMethodDraft? _methodById(String id) {
    for (final method in _methods) {
      if (method.id == id) return method;
    }
    return null;
  }
}

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
      color: Colors.transparent,
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
      color: Colors.transparent,
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

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods({required this.snapshot});

  final P2PPaymentMethodsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
      child: VitEmptyState(
        icon: Icons.credit_card_off_rounded,
        title: snapshot.emptyTitle,
        message: 'Thêm tài khoản ngân hàng hoặc ví điện tử để giao dịch P2P.',
      ),
    );
  }
}

class _DeleteConfirmation extends StatelessWidget {
  const _DeleteConfirmation({
    required this.method,
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
  });

  final P2PPaymentListMethodDraft method;
  final String title;
  final String message;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: AppColors.bg.withValues(alpha: .78),
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.contentPad),
              child: VitCard(
                key: P2PPaymentMethodsPage.deleteConfirmKey,
                radius: VitCardRadius.lg,
                borderColor: AppColors.sell20,
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AppSpacing.buttonCompact,
                          height: AppSpacing.buttonCompact,
                          decoration: BoxDecoration(
                            color: AppColors.sell15,
                            borderRadius: AppRadii.mdRadius,
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.sell,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      method.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        Expanded(
                          child: VitCtaButton(
                            variant: VitCtaButtonVariant.secondary,
                            onPressed: onCancel,
                            child: const Text('Hủy'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: VitCtaButton(
                            variant: VitCtaButtonVariant.danger,
                            onPressed: onConfirm,
                            child: const Text('Xóa'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
