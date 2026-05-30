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

class P2P2FASettingsPage extends ConsumerStatefulWidget {
  const P2P2FASettingsPage({super.key, this.shellRenderMode});

  static const statusKey = Key('sc254_p2p_2fa_status');
  static const methodsKey = Key('sc254_p2p_2fa_methods');
  static const thresholdsKey = Key('sc254_p2p_2fa_thresholds');
  static const recommendationKey = Key('sc254_p2p_2fa_recommendation');

  static Key methodKey(String id) => Key('sc254_p2p_2fa_method_$id');
  static Key methodSwitchKey(String id) =>
      Key('sc254_p2p_2fa_method_switch_$id');
  static Key thresholdKey(String id) => Key('sc254_p2p_2fa_threshold_$id');
  static Key thresholdSwitchKey(String id) =>
      Key('sc254_p2p_2fa_threshold_switch_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2P2FASettingsPage> createState() => _P2P2FASettingsPageState();
}

class _P2P2FASettingsPageState extends ConsumerState<P2P2FASettingsPage> {
  late List<P2PTwoFactorMethodDraft> _methods;
  late List<P2PTransactionThresholdDraft> _thresholds;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(p2pTwoFactorSettingsProvider);
    _methods = List.of(snapshot.methods);
    _thresholds = List.of(snapshot.thresholds);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pTwoFactorSettingsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    final enabledMethods = _methods.where((method) => method.enabled).length;
    final primaryMethod = _methods.firstWhere(
      (method) => method.isPrimary,
      orElse: () => _methods.first,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-254 P2P2FASettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: '2FA cho P2P',
              subtitle: 'Bảo mật · P2P',
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
                      _TwoFactorStatusCard(
                        enabledMethods: enabledMethods,
                        primaryMethod: primaryMethod.label,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _MethodSection(
                        methods: _methods,
                        onToggle: _toggleMethod,
                        onSetPrimary: _setPrimaryMethod,
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      _ThresholdSection(
                        thresholds: _thresholds,
                        onToggle: _toggleThreshold,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SecurityRecommendation(text: snapshot.recommendation),
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

  void _toggleMethod(String methodId) {
    HapticFeedback.selectionClick();
    setState(() {
      _methods = [
        for (final method in _methods)
          if (method.id == methodId)
            method.copyWith(
              enabled: !method.enabled,
              setupRequired: method.enabled ? method.setupRequired : false,
            )
          else
            method,
      ];
    });
  }

  void _setPrimaryMethod(String methodId) {
    HapticFeedback.selectionClick();
    setState(() {
      _methods = [
        for (final method in _methods)
          method.copyWith(isPrimary: method.id == methodId),
      ];
    });
  }

  void _toggleThreshold(String thresholdId) {
    HapticFeedback.selectionClick();
    setState(() {
      _thresholds = [
        for (final threshold in _thresholds)
          if (threshold.id == thresholdId)
            threshold.copyWith(enabled: !threshold.enabled)
          else
            threshold,
      ];
    });
  }
}

class _TwoFactorStatusCard extends StatelessWidget {
  const _TwoFactorStatusCard({
    required this.enabledMethods,
    required this.primaryMethod,
  });

  final int enabledMethods;
  final String primaryMethod;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2P2FASettingsPage.statusKey,
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .9),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .18),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.onAccent,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2FA đã bật ($enabledMethods phương thức)',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Phương thức chính: $primaryMethod',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .9),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodSection extends StatelessWidget {
  const _MethodSection({
    required this.methods,
    required this.onToggle,
    required this.onSetPrimary,
  });

  final List<P2PTwoFactorMethodDraft> methods;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2P2FASettingsPage.methodsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Phương thức xác thực'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < methods.length; index++) ...[
                _MethodRow(
                  method: methods[index],
                  onToggle: () => onToggle(methods[index].id),
                  onSetPrimary: () => onSetPrimary(methods[index].id),
                ),
                if (index != methods.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.method,
    required this.onToggle,
    required this.onSetPrimary,
  });

  final P2PTwoFactorMethodDraft method;
  final VoidCallback onToggle;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final color = _methodColor(method.colorKey);

    return Padding(
      key: P2P2FASettingsPage.methodKey(method.id),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: _methodIcon(method.iconKey),
                color: method.enabled ? color : AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            method.label,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (method.isPrimary) ...[
                          const SizedBox(width: AppSpacing.x2),
                          _SmallBadge(label: 'Chính', color: AppColors.buy),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      method.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                key: P2P2FASettingsPage.methodSwitchKey(method.id),
                value: method.enabled,
                onChanged: (_) => onToggle(),
                activeThumbColor: AppColors.onAccent,
                activeTrackColor: color,
                inactiveThumbColor: AppColors.onAccent,
                inactiveTrackColor: AppColors.surface3,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          if (method.setupRequired && !method.enabled) ...[
            const SizedBox(height: AppSpacing.x3),
            _InlineNotice(
              text: 'Cần setup Authenticator App trước khi sử dụng',
              color: AppColors.warn,
            ),
          ],
          if (method.enabled && !method.isPrimary) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCard(
              radius: VitCardRadius.md,
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              onTap: onSetPrimary,
              child: Center(
                child: Text(
                  'Đặt làm phương thức chính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThresholdSection extends StatelessWidget {
  const _ThresholdSection({required this.thresholds, required this.onToggle});

  final List<P2PTransactionThresholdDraft> thresholds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2P2FASettingsPage.thresholdsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionTitle('Ngưỡng giao dịch')),
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < thresholds.length; index++) ...[
                _ThresholdRow(
                  threshold: thresholds[index],
                  onToggle: () => onToggle(thresholds[index].id),
                ),
                if (index != thresholds.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThresholdRow extends StatelessWidget {
  const _ThresholdRow({required this.threshold, required this.onToggle});

  final P2PTransactionThresholdDraft threshold;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2P2FASettingsPage.thresholdKey(threshold.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBadge(
            icon: Icons.lock_outline_rounded,
            color: threshold.enabled ? AppModuleAccents.p2p : AppColors.text3,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  threshold.label,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  threshold.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (threshold.enabled && threshold.valueLabel.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    threshold.valueLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (threshold.editable) ...[
            VitCard(
              radius: VitCardRadius.md,
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Text(
                'Sửa',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Switch(
            key: P2P2FASettingsPage.thresholdSwitchKey(threshold.id),
            value: threshold.enabled,
            onChanged: (_) => onToggle(),
            activeThumbColor: AppColors.onAccent,
            activeTrackColor: AppColors.buy,
            inactiveThumbColor: AppColors.onAccent,
            inactiveTrackColor: AppColors.surface3,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _SecurityRecommendation extends StatelessWidget {
  const _SecurityRecommendation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2P2FASettingsPage.recommendationKey,
      radius: VitCardRadius.md,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khuyến nghị bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.micro.copyWith(
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: color, size: 12),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _methodColor(String colorKey) {
  return switch (colorKey) {
    'warning' => AppColors.warn,
    'p2p' => AppModuleAccents.p2p,
    _ => AppColors.buy,
  };
}

IconData _methodIcon(String iconKey) {
  return switch (iconKey) {
    'sms' => Icons.phone_iphone_rounded,
    'authenticator' => Icons.key_rounded,
    'email' => Icons.mail_outline_rounded,
    _ => Icons.security_rounded,
  };
}
