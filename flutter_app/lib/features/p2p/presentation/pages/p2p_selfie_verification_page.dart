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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

enum _SelfieStep { guide, capture, liveness, result }

class P2PSelfieVerificationPage extends ConsumerStatefulWidget {
  const P2PSelfieVerificationPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc251_p2p_selfie_hero');
  static const sampleKey = Key('sc251_p2p_selfie_sample');
  static const guidelinesKey = Key('sc251_p2p_selfie_guidelines');
  static const tipsKey = Key('sc251_p2p_selfie_tips');
  static const startKey = Key('sc251_p2p_selfie_start');
  static const captureKey = Key('sc251_p2p_selfie_capture');
  static const livenessKey = Key('sc251_p2p_selfie_liveness');
  static const livenessActionKey = Key('sc251_p2p_selfie_liveness_action');
  static const resultKey = Key('sc251_p2p_selfie_result');
  static const completeKey = Key('sc251_p2p_selfie_complete');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSelfieVerificationPage> createState() =>
      _P2PSelfieVerificationPageState();
}

class _P2PSelfieVerificationPageState
    extends ConsumerState<P2PSelfieVerificationPage> {
  _SelfieStep _step = _SelfieStep.guide;
  int _currentActionIndex = 0;
  final Set<String> _completedActions = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pSelfieVerificationProvider);
    final title = switch (_step) {
      _SelfieStep.guide => 'Selfie Verification',
      _SelfieStep.capture => 'Chụp ảnh Selfie',
      _SelfieStep.liveness => 'Liveness Detection',
      _SelfieStep.result => 'Kết quả xác minh',
    };

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-251 P2PSelfieVerificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: title,
              subtitle: 'KYC · P2P',
              showBack: _step != _SelfieStep.liveness,
              onBack: () => _step == _SelfieStep.guide
                  ? context.go(snapshot.parentRoute)
                  : setState(() => _resetToGuide()),
            ),
            Expanded(child: _buildStep(context, snapshot)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    P2PSelfieVerificationSnapshot snapshot,
  ) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.contentPad,
          AppSpacing.x4,
          AppSpacing.contentPad,
          bottomInset,
        ),
        child: switch (_step) {
          _SelfieStep.guide => _GuideStep(
            snapshot: snapshot,
            onStart: () {
              HapticFeedback.selectionClick();
              setState(() => _step = _SelfieStep.capture);
            },
          ),
          _SelfieStep.capture => _CaptureStep(
            onCapture: () {
              HapticFeedback.selectionClick();
              setState(() => _step = _SelfieStep.liveness);
            },
          ),
          _SelfieStep.liveness => _LivenessStep(
            snapshot: snapshot,
            currentActionIndex: _currentActionIndex,
            completedActions: _completedActions,
            onConfirmAction: () {
              HapticFeedback.selectionClick();
              setState(() {
                final action = snapshot.livenessActions[_currentActionIndex];
                _completedActions.add(action.id);
                if (_currentActionIndex < snapshot.livenessActions.length - 1) {
                  _currentActionIndex += 1;
                } else {
                  _step = _SelfieStep.result;
                }
              });
            },
          ),
          _SelfieStep.result => _ResultStep(
            snapshot: snapshot,
            onComplete: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.statusRoute);
            },
            onSupport: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.supportRoute);
            },
          ),
        },
      ),
    );
  }

  void _resetToGuide() {
    _step = _SelfieStep.guide;
    _currentActionIndex = 0;
    _completedActions.clear();
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.snapshot, required this.onStart});

  final P2PSelfieVerificationSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelfieHero(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Ví dụ mẫu',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _SampleCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Hướng dẫn chụp ảnh',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _GuidelinesCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _TipsCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PSelfieVerificationPage.startKey,
          onPressed: onStart,
          trailing: const Icon(Icons.photo_camera_outlined),
          child: const Text('Bắt đầu chụp ảnh'),
        ),
      ],
    );
  }
}

class _SelfieHero extends StatelessWidget {
  const _SelfieHero({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: AppColors.primary15,
              borderRadius: AppRadii.lgRadius,
              border: Border.all(color: AppColors.primary20),
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
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

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.sampleKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary12,
            borderRadius: AppRadii.cardRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: AppColors.text1,
                size: 72,
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                snapshot.sampleTitle,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                snapshot.sampleBody,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.guidelinesKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final guide in snapshot.guidelines) ...[
            _ChecklistRow(text: guide, color: AppColors.buy),
            if (guide != snapshot.guidelines.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.snapshot});

  final P2PSelfieVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.tipsKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.info_outline_rounded,
            title: 'Mẹo để thành công',
            color: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tip in snapshot.tips) ...[
            _ChecklistRow(text: tip, color: AppColors.warn),
            if (tip != snapshot.tips.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _CaptureStep extends StatelessWidget {
  const _CaptureStep({required this.onCapture});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSelfieVerificationPage.captureKey,
      radius: VitCardRadius.lg,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x6),
      onTap: onCapture,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSpacing.buttonHero,
              height: AppSpacing.buttonHero,
              decoration: const BoxDecoration(
                color: AppColors.primary15,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(height: AppSpacing.x5),
            Text(
              'Nhấn để chụp ảnh',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppModuleAccents.p2p,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Đảm bảo khuôn mặt và ID card rõ nét trong khung hình',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivenessStep extends StatelessWidget {
  const _LivenessStep({
    required this.snapshot,
    required this.currentActionIndex,
    required this.completedActions,
    required this.onConfirmAction,
  });

  final P2PSelfieVerificationSnapshot snapshot;
  final int currentActionIndex;
  final Set<String> completedActions;
  final VoidCallback onConfirmAction;

  @override
  Widget build(BuildContext context) {
    final currentAction = snapshot.livenessActions[currentActionIndex];

    return Column(
      key: P2PSelfieVerificationPage.livenessKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProgressBar(
          completed: completedActions.length,
          total: snapshot.livenessActions.length,
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            children: [
              Icon(
                _livenessIcon(currentAction.iconKey),
                color: AppModuleAccents.p2p,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                currentAction.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Làm theo hướng dẫn để tiếp tục',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.x3,
          mainAxisSpacing: AppSpacing.x3,
          childAspectRatio: 1.2,
          children: [
            for (final action in snapshot.livenessActions)
              _LivenessActionTile(
                action: action,
                completed: completedActions.contains(action.id),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PSelfieVerificationPage.livenessActionKey,
          onPressed: onConfirmAction,
          child: const Text('Xác nhận thao tác'),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '$completed/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.lgRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: pct,
            backgroundColor: AppColors.surface2,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppModuleAccents.p2p,
            ),
          ),
        ),
      ],
    );
  }
}

class _LivenessActionTile extends StatelessWidget {
  const _LivenessActionTile({required this.action, required this.completed});

  final P2PSelfieLivenessActionDraft action;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      variant: completed ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: completed ? AppColors.buy20 : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _livenessIcon(action.iconKey),
            color: completed ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: completed ? AppColors.buy : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (completed) ...[
            const SizedBox(height: AppSpacing.x1),
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({
    required this.snapshot,
    required this.onComplete,
    required this.onSupport,
  });

  final P2PSelfieVerificationSnapshot snapshot;
  final VoidCallback onComplete;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSelfieVerificationPage.resultKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: AppSpacing.buttonHero,
          height: AppSpacing.buttonHero,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          decoration: const BoxDecoration(
            color: AppColors.buy10,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconLg,
          ),
        ),
        Text(
          'Xác minh thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Khuôn mặt của bạn đã được xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              _ScoreRow(label: 'Face Match Score', value: snapshot.matchScore),
              Container(height: 1, color: AppColors.cardBorder),
              _ScoreRow(label: 'Liveness Score', value: snapshot.livenessScore),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Dữ liệu biometric được mã hóa và xóa sau khi xác minh. Chúng tôi không lưu trữ ảnh selfie của bạn.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PSelfieVerificationPage.completeKey,
          onPressed: onComplete,
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Hoàn tất'),
        ),
        const SizedBox(height: AppSpacing.x3),
        TextButton(
          onPressed: onSupport,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.text2,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Liên hệ hỗ trợ'),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            color == AppColors.warn
                ? Icons.auto_awesome_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 13,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _livenessIcon(String iconKey) {
  return switch (iconKey) {
    'smile' => Icons.sentiment_satisfied_alt_rounded,
    'blink' => Icons.visibility_outlined,
    'turn_left' => Icons.keyboard_arrow_left_rounded,
    'turn_right' => Icons.keyboard_arrow_right_rounded,
    _ => Icons.face_retouching_natural_outlined,
  };
}
