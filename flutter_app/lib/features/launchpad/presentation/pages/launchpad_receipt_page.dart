import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

class LaunchpadReceiptPage extends ConsumerWidget {
  const LaunchpadReceiptPage({
    super.key,
    this.subscriptionId = 'sub001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc301_launchpad_receipt_content');
  static const errorKey = Key('sc301_launchpad_receipt_error');
  static const portfolioButtonKey = Key('sc301_launchpad_receipt_portfolio');
  static const launchpadButtonKey = Key('sc301_launchpad_receipt_launchpad');

  final String subscriptionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(launchpadRepositoryProvider)
        .getReceipt(subscriptionId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final hasSubscription = snapshot.subscription != null;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-301 LaunchpadReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: hasSubscription ? 'Biên lai đăng ký' : snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  customGap: AppSpacing.x4,
                  children: [
                    if (!hasSubscription)
                      const _ReceiptErrorState()
                    else
                      _ReceiptSuccess(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptErrorState extends StatelessWidget {
  const _ReceiptErrorState();

  @override
  Widget build(BuildContext context) {
    return VitErrorState(
      key: LaunchpadReceiptPage.errorKey,
      title: 'Không tải được dữ liệu',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.error_outline_rounded,
      iconContainerSize: 48,
      iconSize: 24,
      iconShape: BoxShape.circle,
      verticalPadding: 48,
      horizontalPadding: 24,
      titleStyle: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text3,
        height: 1.5,
      ),
    );
  }
}

class _ReceiptSuccess extends StatelessWidget {
  const _ReceiptSuccess({required this.snapshot});

  final LaunchpadReceiptSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final subscription = snapshot.subscription!;
    final status = _statusStyle(subscription.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuccessHero(subscription: subscription),
        const SizedBox(height: AppSpacing.x4),
        _ProjectReceiptCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.x4),
        _ReceiptDetailsCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.x4),
        const _ReceiptNextSteps(),
        const SizedBox(height: AppSpacing.x4),
        const _ReceiptDisclosure(),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          key: LaunchpadReceiptPage.portfolioButtonKey,
          onPressed: () => context.go(snapshot.portfolioRoute),
          leading: const Icon(Icons.business_center_outlined),
          child: const Text('Xem portfolio'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: LaunchpadReceiptPage.launchpadButtonKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => context.go(snapshot.launchpadRoute),
          child: const Text('Quay lại Launchpad'),
        ),
      ],
    );
  }
}

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.buy15,
              border: Border.all(color: AppColors.buy.withValues(alpha: .30)),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Đăng ký thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Đơn đăng ký ${subscription.projectSymbol} đã được ghi nhận. Token sẽ được phân bổ sau khi kết thúc.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectReceiptCard extends StatelessWidget {
  const _ProjectReceiptCard({required this.subscription, required this.status});

  final LaunchpadSubscriptionDraft subscription;
  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .20),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: subscription.accent.withValues(alpha: .12),
              border: Border.all(
                color: subscription.accent.withValues(alpha: .35),
              ),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Text(
              subscription.projectLogo,
              style: AppTextStyles.caption.copyWith(
                color: subscription.accent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '\$${subscription.projectSymbol}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _ReceiptStatusPill(status: status),
        ],
      ),
    );
  }
}

class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({required this.subscription, required this.status});

  final LaunchpadSubscriptionDraft subscription;
  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _ReceiptRowDraft('Mã đăng ký', subscription.id, isMono: true),
      _ReceiptRowDraft('Thời gian', subscription.timestamp),
      _ReceiptRowDraft(
        'Số tiền',
        '${_formatUsd(subscription.amount)} USDT',
        isMono: true,
        isStrong: true,
      ),
      _ReceiptRowDraft(
        'Dự kiến nhận',
        '${_formatInt(subscription.tokensAllocated)} ${subscription.projectSymbol}',
        isMono: true,
      ),
      _ReceiptRowDraft('Trạng thái', status.label, color: status.color),
      _ReceiptRowDraft('Mở khóa tiếp theo', subscription.nextUnlockDate),
    ];

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chi tiết đơn đăng ký',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) _ReceiptInfoRow(row: row),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tx Hash',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: subscription.txHash));
                  HapticFeedback.selectionClick();
                },
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
                  child: Row(
                    children: [
                      Text(
                        subscription.txHash,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.copy_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptInfoRow extends StatelessWidget {
  const _ReceiptInfoRow({required this.row});

  final _ReceiptRowDraft row;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            row.value,
            style: AppTextStyles.caption.copyWith(
              color:
                  row.color ??
                  (row.isStrong ? AppColors.text1 : AppColors.text2),
              fontWeight: row.isStrong
                  ? AppTextStyles.bold
                  : AppTextStyles.medium,
              fontFeatures: row.isMono ? AppTextStyles.tabularFigures : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptNextSteps extends StatelessWidget {
  const _ReceiptNextSteps();

  static const _steps = [
    'Đơn đăng ký đã được ghi nhận thành công.',
    'Token sẽ được phân bổ theo tỷ lệ sau khi kết thúc vòng mở bán.',
    'Phần USDT không được phân bổ sẽ được hoàn trả tự động.',
    'Theo dõi lịch vesting trong tab Portfolio.',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppModuleAccents.launchpad,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiếp theo là gì?',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var i = 0; i < _steps.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppSpacing.x5,
                    child: Text(
                      '${i + 1}.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppModuleAccents.launchpad,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _steps[i],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
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

class _ReceiptDisclosure extends StatelessWidget {
  const _ReceiptDisclosure();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Phân bổ thực tế có thể khác dự kiến nếu tổng đăng ký vượt hard cap. Hiệu suất quá khứ không đảm bảo kết quả tương lai.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptStatusPill extends StatelessWidget {
  const _ReceiptStatusPill({required this.status});

  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        status.label,
        style: AppTextStyles.micro.copyWith(
          color: status.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

final class _ReceiptRowDraft {
  const _ReceiptRowDraft(
    this.label,
    this.value, {
    this.isMono = false,
    this.isStrong = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isMono;
  final bool isStrong;
  final Color? color;
}

final class _StatusStyle {
  const _StatusStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_StatusStyle _statusStyle(LaunchpadSubscriptionStatus status) {
  return switch (status) {
    LaunchpadSubscriptionStatus.pending => const _StatusStyle(
      label: 'Chờ phân bổ',
      color: AppColors.warn,
    ),
    LaunchpadSubscriptionStatus.allocated => const _StatusStyle(
      label: 'Đã phân bổ',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.partiallyAllocated => const _StatusStyle(
      label: 'Phân bổ 1 phần',
      color: AppColors.primary,
    ),
    LaunchpadSubscriptionStatus.claimed => const _StatusStyle(
      label: 'Đã nhận',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.refunded => const _StatusStyle(
      label: 'Đã hoàn tiền',
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) => '\$${_withCommas(value.toStringAsFixed(2))}';

String _formatInt(int value) => _withCommas(value.toString());

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}
