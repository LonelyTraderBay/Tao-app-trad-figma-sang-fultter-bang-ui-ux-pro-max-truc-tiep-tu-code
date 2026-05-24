import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2POrderProofPage extends ConsumerStatefulWidget {
  const P2POrderProofPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc215_p2p_order_proof_content');
  static const cameraKey = Key('sc215_p2p_order_proof_camera');
  static const galleryKey = Key('sc215_p2p_order_proof_gallery');
  static const confirmKey = Key('sc215_p2p_order_proof_confirm');

  static Key removeKey(int index) => Key('sc215_p2p_order_proof_remove_$index');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderProofPage> createState() => _P2POrderProofPageState();
}

class _P2POrderProofPageState extends ConsumerState<P2POrderProofPage> {
  final List<String> _proofs = [];
  bool _isUploading = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getOrderProof(widget.orderId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-215 P2POrderProofPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Bằng chứng thanh toán',
              subtitle: 'Đơn hàng - P2P',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2POrderProofPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _OrderProofSummary(order: snapshot.order),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.x4),
                            _UploadSection(
                              title: snapshot.uploadTitle,
                              subtitle: snapshot.uploadSubtitle,
                              isUploading: _isUploading,
                              onCamera: () => _addProof('camera'),
                              onGallery: () => _addProof('gallery'),
                            ),
                            if (_proofs.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.x4),
                              _UploadedProofs(
                                proofs: _proofs,
                                onRemove: _removeProof,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.x4),
                            _TipsCard(
                              title: snapshot.tipsTitle,
                              tips: snapshot.tips,
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            _ProofWarning(message: snapshot.warningMessage),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      VitCtaButton(
                        key: P2POrderProofPage.confirmKey,
                        onPressed: _proofs.isEmpty
                            ? null
                            : () => _confirm(context, snapshot.order),
                        loading: _isSubmitting,
                        leading: const Icon(Icons.upload_outlined),
                        child: Text('Xác nhận (${_proofs.length} ảnh)'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProof(String type) async {
    if (_isUploading || _proofs.length >= 3) return;
    HapticFeedback.selectionClick();
    setState(() => _isUploading = true);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() {
      _proofs.add('proof_${type}_${_proofs.length + 1}.jpg');
      _isUploading = false;
    });
  }

  void _removeProof(int index) {
    HapticFeedback.selectionClick();
    setState(() => _proofs.removeAt(index));
  }

  Future<void> _confirm(BuildContext context, P2POrderProofDraft order) async {
    if (_proofs.isEmpty || _isSubmitting) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pOrder(order.id));
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.p2pOrder(widget.orderId));
  }
}

class _OrderProofSummary extends StatelessWidget {
  const _OrderProofSummary({required this.order});

  final P2POrderProofDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          _SummaryLine(label: 'Đơn hàng', value: order.orderNumber),
          const SizedBox(height: AppSpacing.x1),
          _SummaryLine(
            label: 'Số tiền',
            value: '${_formatVnd(order.totalVnd)} ${order.currency}',
            valueColor: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.title,
    required this.subtitle,
    required this.isUploading,
    required this.onCamera,
    required this.onGallery,
  });

  final String title;
  final String subtitle;
  final bool isUploading;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: _UploadSourceCard(
                key: P2POrderProofPage.cameraKey,
                icon: Icons.photo_camera_outlined,
                label: 'Chụp ảnh',
                caption: 'Mở camera',
                color: AppColors.primary,
                enabled: !isUploading,
                onPressed: onCamera,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _UploadSourceCard(
                key: P2POrderProofPage.galleryKey,
                icon: Icons.image_outlined,
                label: 'Thư viện',
                caption: 'Chọn từ ảnh',
                color: AppColors.accent,
                enabled: !isUploading,
                onPressed: onGallery,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadSourceCard extends StatelessWidget {
  const _UploadSourceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: AppSpacing.buttonHero + AppSpacing.ctaHeight,
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: .45), width: 2),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconLg),
              const SizedBox(height: AppSpacing.x3),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadedProofs extends StatelessWidget {
  const _UploadedProofs({required this.proofs, required this.onRemove});

  final List<String> proofs;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đã tải (${proofs.length}/3)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (var index = 0; index < proofs.length; index++)
              _ProofThumb(index: index, onRemove: () => onRemove(index)),
          ],
        ),
      ],
    );
  }
}

class _ProofThumb extends StatelessWidget {
  const _ProofThumb({required this.index, required this.onRemove});

  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSpacing.x7 + AppSpacing.x6,
          height: AppSpacing.x7 + AppSpacing.x6,
          decoration: BoxDecoration(
            color: AppColors.buy10,
            border: Border.all(color: AppColors.buy20),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Ảnh ${index + 1}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -AppSpacing.x2,
          right: -AppSpacing.x2,
          child: IconButton(
            key: P2POrderProofPage.removeKey(index),
            onPressed: onRemove,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.sell,
              minimumSize: const Size(AppSpacing.x6, AppSpacing.x6),
            ),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.title, required this.tips});

  final String title;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProofWarning extends StatelessWidget {
  const _ProofWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
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
                message,
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
