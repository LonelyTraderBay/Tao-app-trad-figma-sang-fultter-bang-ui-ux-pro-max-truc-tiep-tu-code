import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PEscrowDetailPage extends ConsumerStatefulWidget {
  const P2PEscrowDetailPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc246_p2p_escrow_detail_hero');
  static const addressKey = Key('sc246_p2p_escrow_detail_address');
  static const copyKey = Key('sc246_p2p_escrow_detail_copy');
  static const revealKey = Key('sc246_p2p_escrow_detail_reveal');
  static const explorerKey = Key('sc246_p2p_escrow_detail_explorer');
  static const multisigKey = Key('sc246_p2p_escrow_detail_multisig');
  static const orderInfoKey = Key('sc246_p2p_escrow_detail_order_info');
  static const timelineKey = Key('sc246_p2p_escrow_detail_timeline');
  static const securityKey = Key('sc246_p2p_escrow_detail_security');
  static const orderLinkKey = Key('sc246_p2p_escrow_detail_order_link');
  static const feedbackKey = Key('sc246_p2p_escrow_detail_feedback');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowDetailPage> createState() =>
      _P2PEscrowDetailPageState();
}

class _P2PEscrowDetailPageState extends ConsumerState<P2PEscrowDetailPage> {
  bool _showFullAddress = false;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getEscrowDetail(widget.orderId);
    final order = snapshot.order;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-246 P2PEscrowDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết Escrow',
              subtitle: 'Escrow · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
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
                      _EscrowStatusHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowAddressCard(
                        snapshot: snapshot,
                        showFullAddress: _showFullAddress,
                        onReveal: () {
                          HapticFeedback.selectionClick();
                          setState(() => _showFullAddress = !_showFullAddress);
                        },
                        onCopy: () {
                          HapticFeedback.selectionClick();
                          Clipboard.setData(
                            ClipboardData(text: snapshot.escrowAddress),
                          );
                          setState(() => _feedback = 'Đã copy địa chỉ escrow');
                        },
                        onExplorer: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _feedback = 'Đã mở Blockchain Explorer',
                          );
                        },
                      ),
                      if (_feedback != null) ...[
                        const SizedBox(height: AppSpacing.x3),
                        _FeedbackBanner(message: _feedback!),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _MultiSigCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderInfoCard(order: order),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowTimelineCard(events: snapshot.timeline),
                      const SizedBox(height: AppSpacing.x4),
                      _SecurityNotice(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderLink(orderId: widget.orderId),
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
}

class _EscrowStatusHero extends StatelessWidget {
  const _EscrowStatusHero({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final order = snapshot.order;
    return VitCard(
      key: P2PEscrowDetailPage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.warn15,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.statusLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '${_formatAmount4(order.escrowAmount)} ${order.asset} (${_formatVnd(order.totalVnd)} ${order.currency})',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _EscrowAddressCard extends StatelessWidget {
  const _EscrowAddressCard({
    required this.snapshot,
    required this.showFullAddress,
    required this.onReveal,
    required this.onCopy,
    required this.onExplorer,
  });

  final P2PEscrowDetailSnapshot snapshot;
  final bool showFullAddress;
  final VoidCallback onReveal;
  final VoidCallback onCopy;
  final VoidCallback onExplorer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.addressKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.vpn_key_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Địa chỉ Escrow',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                key: P2PEscrowDetailPage.revealKey,
                label: showFullAddress ? 'Ẩn' : 'Hiện',
                status: VitStatusPillStatus.neutral,
                icon: showFullAddress
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: VitStatusPillSize.sm,
                onTap: onReveal,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    showFullAddress
                        ? snapshot.escrowAddress
                        : snapshot.maskedAddress,
                    maxLines: showFullAddress ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                VitIconButton(
                  key: P2PEscrowDetailPage.copyKey,
                  icon: Icons.copy_rounded,
                  tooltip: 'Copy địa chỉ escrow',
                  variant: VitIconButtonVariant.primary,
                  onPressed: onCopy,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            key: P2PEscrowDetailPage.explorerKey,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            onTap: onExplorer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.open_in_new_rounded,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    'Xem trên Blockchain Explorer',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
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

class _MultiSigCard extends StatelessWidget {
  const _MultiSigCard({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.multisigKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_2_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Multi-Signature (${snapshot.signedCount}/${snapshot.signerCount})',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SignatureRing(
                signed: snapshot.signedCount,
                total: snapshot.signerCount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Escrow yêu cầu tối thiểu 2/3 chữ ký để giải phóng coin. Platform luôn ký khi tạo escrow (1/3).',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final signer in snapshot.signers) ...[
            _SignerRow(signer: signer),
            if (signer != snapshot.signers.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _SignatureRing extends StatelessWidget {
  const _SignatureRing({required this.signed, required this.total});

  final int signed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : signed / total;
    return SizedBox(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            color: AppColors.buy,
            backgroundColor: AppColors.surface3,
          ),
          Text(
            '$signed/$total',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final P2PEscrowSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    final status = signer.hasSigned
        ? VitStatusPillStatus.success
        : VitStatusPillStatus.neutral;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: signer.hasSigned ? AppColors.buy20 : AppColors.borderSolid,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            decoration: BoxDecoration(
              color: signer.hasSigned ? AppColors.buy15 : AppColors.surface3,
              shape: BoxShape.circle,
            ),
            child: Icon(
              signer.hasSigned
                  ? Icons.check_circle_outline_rounded
                  : Icons.schedule_rounded,
              color: signer.hasSigned ? AppColors.buy : AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signer.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: signer.hasSigned ? AppColors.text1 : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  signer.maskedAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VitStatusPill(
                label: signer.hasSigned ? 'Đã ký' : 'Chờ ký',
                status: status,
                size: VitStatusPillSize.sm,
              ),
              if (signer.signedAt != null)
                Text(
                  signer.signedAt!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Mã đơn', order.orderNumber, false),
      ('Loại', '${order.typeLabel} ${order.asset}', false),
      (
        'Số lượng',
        '${_formatAmount4(order.escrowAmount)} ${order.asset}',
        false,
      ),
      ('Giá', '${_formatVnd(order.priceVnd)} VND/${order.asset}', false),
      ('Tổng', '${_formatVnd(order.totalVnd)} ${order.currency}', true),
      ('Merchant', order.merchant, false),
      ('Phương thức TT', order.paymentMethod, false),
    ];

    return VitCard(
      key: P2PEscrowDetailPage.orderInfoKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin đơn hàng',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) ...[
            _InfoRow(label: row.$1, value: row.$2, emphasis: row.$3),
            if (row != rows.last)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.emphasis,
  });

  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: emphasis
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EscrowTimelineCard extends StatelessWidget {
  const _EscrowTimelineCard({required this.events});

  final List<P2PEscrowTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.timelineKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiến trình Escrow',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < events.length; i++)
            _TimelineRow(event: events[i], isLast: i == events.length - 1),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast});

  final P2PEscrowTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _timelineColor(event.status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.buttonCompact,
          child: Column(
            children: [
              Container(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                decoration: BoxDecoration(
                  color: _timelineBackground(event.status),
                  shape: BoxShape.circle,
                  border: Border.all(color: color),
                ),
                child: Icon(
                  _timelineIcon(event.iconKey),
                  color: color,
                  size: 14,
                ),
              ),
              if (!isLast)
                Container(width: 1, height: AppSpacing.x5, color: color),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.label,
                        style: AppTextStyles.caption.copyWith(
                          color: event.status == P2POrderStepStatus.pending
                              ? AppColors.text3
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      event.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    event.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.securityKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.securityTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.securityBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _OrderLink extends StatelessWidget {
  const _OrderLink({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.orderLinkKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pOrder(orderId));
      },
      child: Row(
        children: [
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Xem chi tiết đơn hàng',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.feedbackKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _timelineColor(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy,
    P2POrderStepStatus.active => AppModuleAccents.p2p,
    P2POrderStepStatus.pending => AppColors.text3,
  };
}

Color _timelineBackground(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy10,
    P2POrderStepStatus.active => AppColors.primary12,
    P2POrderStepStatus.pending => AppColors.surface2,
  };
}

IconData _timelineIcon(String iconKey) {
  return switch (iconKey) {
    'key' => Icons.vpn_key_outlined,
    'lock' => Icons.lock_outline_rounded,
    'clock' => Icons.schedule_rounded,
    'shield' => Icons.shield_outlined,
    'unlock' => Icons.lock_open_rounded,
    _ => Icons.circle_outlined,
  };
}

String _formatAmount4(double value) => value.toStringAsFixed(4);

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
