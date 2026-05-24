import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PInsuranceCertificatePage extends ConsumerStatefulWidget {
  const P2PInsuranceCertificatePage({super.key, this.shellRenderMode});

  static const cardKey = Key('sc239_p2p_insurance_certificate_card');
  static const downloadKey = Key('sc239_p2p_insurance_certificate_download');
  static const shareKey = Key('sc239_p2p_insurance_certificate_share');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PInsuranceCertificatePage> createState() =>
      _P2PInsuranceCertificatePageState();
}

class _P2PInsuranceCertificatePageState
    extends ConsumerState<P2PInsuranceCertificatePage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getInsuranceCertificate();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-239 P2PInsuranceCertificatePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chứng nhận bảo hiểm',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
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
                      _CertificateCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _ActionRow(
                        snapshot: snapshot,
                        onFeedback: (message) {
                          setState(() => _feedback = message);
                        },
                      ),
                      if (_feedback != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _FeedbackBanner(message: _feedback!),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _DisclosureCard(snapshot: snapshot),
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

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceCertificatePage.cardKey,
      clip: true,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CertificateHero(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CertificateIdBlock(snapshot: snapshot),
                const SizedBox(height: AppSpacing.x4),
                _IdentityRows(snapshot: snapshot),
                const SizedBox(height: AppSpacing.x5),
                _CoverageBox(snapshot: snapshot),
                const SizedBox(height: AppSpacing.x5),
                _ValidityRow(snapshot: snapshot),
                const SizedBox(height: AppSpacing.x5),
                _ProtectedCases(snapshot: snapshot),
                const SizedBox(height: AppSpacing.x5),
                _AuditCallout(snapshot: snapshot),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateHero extends StatelessWidget {
  const _CertificateHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.navCenter),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x5,
          vertical: AppSpacing.x6,
        ),
        child: Column(
          children: [
            Container(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              decoration: BoxDecoration(
                color: AppColors.portfolioBtnGhost,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.portfolioBtnGhostBorder),
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                color: Colors.white,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'CHỨNG NHẬN BẢO HIỂM',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: Colors.white.withValues(alpha: .78),
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Giao dịch P2P',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateIdBlock extends StatelessWidget {
  const _CertificateIdBlock({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x4),
        child: Column(
          children: [
            Text(
              'Mã chứng nhận',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              snapshot.certId,
              textAlign: TextAlign.center,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdentityRows extends StatelessWidget {
  const _IdentityRows({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CertificateInfoRow(
          icon: Icons.person_outline_rounded,
          label: 'Người được bảo hiểm',
          value: snapshot.holderName,
        ),
        _CertificateInfoRow(
          icon: Icons.workspace_premium_outlined,
          label: 'Tier',
          value: snapshot.tierName,
          valueColor: AppModuleAccents.p2p,
        ),
        _CertificateInfoRow(
          icon: Icons.shield_outlined,
          label: 'Mức bảo hiểm',
          value: '${snapshot.coveragePct}%',
          valueColor: AppColors.buy,
        ),
      ],
    );
  }
}

class _CoverageBox extends StatelessWidget {
  const _CoverageBox({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PHẠM VI BẢO HIỂM',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _CoverageLine(
            label: 'Hạn mức / claim',
            value: '${_formatVnd(snapshot.maxCoveragePerClaim)} đ',
          ),
          _CoverageLine(
            label: 'Hạn mức / 30 ngày',
            value: '${_formatVnd(snapshot.maxCoveragePer30Days)} đ',
          ),
          _CoverageLine(
            label: 'Cửa sổ claim',
            value: '${snapshot.claimWindowDays} ngày',
          ),
        ],
      ),
    );
  }
}

class _ValidityRow extends StatelessWidget {
  const _ValidityRow({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x4),
        child: _CertificateInfoRow(
          icon: Icons.calendar_month_outlined,
          label: 'Hiệu lực',
          value: '${snapshot.issueDate} — ${snapshot.validUntil}',
          bottomGap: 0,
        ),
      ),
    );
  }
}

class _ProtectedCases extends StatelessWidget {
  const _ProtectedCases({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CÁC TRƯỜNG HỢP ĐƯỢC BẢO VỆ',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in snapshot.coveredCases) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _AuditCallout extends StatelessWidget {
  const _AuditCallout({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gpp_good_outlined,
            color: AppModuleAccents.p2p,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kiểm toán bởi ${snapshot.auditor}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Gần nhất: ${snapshot.lastAuditDate}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.snapshot, required this.onFeedback});

  final P2PInsuranceCertificateSnapshot snapshot;
  final ValueChanged<String> onFeedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2PInsuranceCertificatePage.downloadKey,
            onPressed: () => _downloadCertificate(context, snapshot),
            leading: const Icon(Icons.download_rounded),
            child: const Text('Tải chứng nhận'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        VitIconButton(
          key: P2PInsuranceCertificatePage.shareKey,
          icon: Icons.share_outlined,
          tooltip: 'Chia sẻ chứng nhận',
          size: VitIconButtonSize.lg,
          variant: VitIconButtonVariant.ghost,
          onPressed: () => _shareCertificate(context, snapshot),
        ),
      ],
    );
  }

  void _downloadCertificate(
    BuildContext context,
    P2PInsuranceCertificateSnapshot snapshot,
  ) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: snapshot.exportText));
    onFeedback('Đã chuẩn bị chứng nhận ${snapshot.certId}');
  }

  void _shareCertificate(
    BuildContext context,
    P2PInsuranceCertificateSnapshot snapshot,
  ) {
    HapticFeedback.selectionClick();
    Clipboard.setData(ClipboardData(text: snapshot.shareText));
    onFeedback('Đã sao chép thông tin chứng nhận');
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
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

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.disclosure,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateInfoRow extends StatelessWidget {
  const _CertificateInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.bottomGap = AppSpacing.x4,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.text3, size: 17),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageLine extends StatelessWidget {
  const _CoverageLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatVnd(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
