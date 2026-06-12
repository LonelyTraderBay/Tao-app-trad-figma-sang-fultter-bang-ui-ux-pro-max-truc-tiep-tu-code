import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PE2EInfoPage extends ConsumerWidget {
  const P2PE2EInfoPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc259_p2p_e2e_hero');
  static const diagramKey = Key('sc259_p2p_e2e_diagram');
  static const infoItemsKey = Key('sc259_p2p_e2e_info_items');
  static const fingerprintKey = Key('sc259_p2p_e2e_fingerprint');
  static const stepsKey = Key('sc259_p2p_e2e_steps');
  static const serverKey = Key('sc259_p2p_e2e_server');

  static Key infoItemKey(String id) => Key('sc259_p2p_e2e_info_$id');

  static Key stepKey(String id) => Key('sc259_p2p_e2e_step_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pE2EInfoProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-259 P2PE2EInfoPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Mã hóa đầu cuối',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _Hero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        _EncryptionDiagram(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x3),
                        _InfoItems(items: snapshot.infoItems),
                        const SizedBox(height: AppSpacing.x3),
                        _FingerprintCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x3),
                        _HowItWorks(steps: snapshot.steps),
                        const SizedBox(height: AppSpacing.x3),
                        _ServerInfo(snapshot: snapshot),
                      ],
                    ),
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

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PE2EInfoPage.heroKey,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.buy.withValues(alpha: .12),
            borderRadius: AppRadii.cardLargeRadius,
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconLg,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          snapshot.heroTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          snapshot.heroSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _EncryptionDiagram extends StatelessWidget {
  const _EncryptionDiagram({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.diagramKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EndpointAvatar(
                label: snapshot.localLabel,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x3),
              const _SecureConnector(),
              const SizedBox(width: AppSpacing.x3),
              _EndpointAvatar(
                label: snapshot.partnerLabel,
                color: AppModuleAccents.p2p,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.diagramCaption,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndpointAvatar extends StatelessWidget {
  const _EndpointAvatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SecureConnector extends StatelessWidget {
  const _SecureConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 2, color: AppColors.buy),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.buy.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.buy,
            size: 14,
          ),
        ),
        Container(width: 16, height: 2, color: AppColors.buy),
      ],
    );
  }
}

class _InfoItems extends StatelessWidget {
  const _InfoItems({required this.items});

  final List<P2PE2EInfoItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PE2EInfoPage.infoItemsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _InfoItemCard(item: items[index]),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _InfoItemCard extends StatelessWidget {
  const _InfoItemCard({required this.item});

  final P2PE2EInfoItemDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);

    return VitCard(
      key: P2PE2EInfoPage.infoItemKey(item.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(_infoIcon(item.iconKey), color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1.6,
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

class _FingerprintCard extends StatelessWidget {
  const _FingerprintCard({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.fingerprintKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fingerprint_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'MÃ XÁC MINH BẢO MẬT',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.fingerprint,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              letterSpacing: 2,
              height: 1.9,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.fingerprintHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.steps});

  final List<P2PE2EStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.stepsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cách hoạt động',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < steps.length; index++) ...[
            _StepRow(step: steps[index]),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final P2PE2EStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PE2EInfoPage.stepKey(step.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.buy.withValues(alpha: .12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.buy20),
          ),
          child: Text(
            step.step,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
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
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServerInfo extends StatelessWidget {
  const _ServerInfo({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PE2EInfoPage.serverKey,
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .08),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.dns_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                snapshot.serverNote,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _toneColor(String key) {
  return switch (key) {
    'accent' => AppColors.accent,
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

IconData _infoIcon(String key) {
  return switch (key) {
    'key' => Icons.vpn_key_outlined,
    'verified' => Icons.verified_user_outlined,
    'warning' => Icons.warning_amber_rounded,
    _ => Icons.lock_outline_rounded,
  };
}
