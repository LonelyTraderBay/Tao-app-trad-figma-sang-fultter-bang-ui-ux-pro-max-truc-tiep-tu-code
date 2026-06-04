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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_payment_methods_page_sections.dart';
part '../widgets/p2p_payment_methods_page_common.dart';

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
    final snapshot = ref.watch(p2pPaymentMethodsProvider);
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
            child: VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Phương thức thanh toán',
                subtitle: 'Thanh toán · P2P',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.p2p),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
