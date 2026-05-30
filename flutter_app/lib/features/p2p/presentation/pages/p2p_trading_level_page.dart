import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PTradingLevelPage extends ConsumerWidget {
  const P2PTradingLevelPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc230_p2p_trading_level_content');
  static const upgradeButtonKey = Key('sc230_p2p_trading_level_upgrade');

  static Key levelKey(int id) => Key('sc230_p2p_trading_level_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pTradingLevelProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-230 P2PTradingLevelPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Cấp độ giao dịch P2P',
              subtitle: 'Cấp bậc · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PTradingLevelPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CurrentLevelHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      if (snapshot.userLevel.currentLevel <
                          snapshot.levels.length)
                        _NextLevelProgress(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      Text(
                        'Tất cả cấp độ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      for (final level in snapshot.levels) ...[
                        _LevelCard(snapshot: snapshot, level: level),
                        const SizedBox(height: AppSpacing.x3),
                      ],
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

class _CurrentLevelHero extends StatelessWidget {
  const _CurrentLevelHero({required this.snapshot});

  final P2PTradingLevelSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final user = snapshot.userLevel;
    final level = snapshot.currentLevel;
    final accent = _levelColor(level);
    final dailyRatio = user.dailyUsed / user.dailyLimit;

    return VitCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.x5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.18),
                  accent.withValues(alpha: 0.07),
                ],
              ),
              border: Border(
                bottom: BorderSide(color: accent.withValues(alpha: 0.20)),
              ),
            ),
            child: Row(
              children: [
                _LevelIconBadge(level: level, size: 56),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Lv.${level.id} ${level.nameVi}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.pageTitle.copyWith(
                                color: AppColors.text1,
                                fontSize: 25,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          const VitStatusPill(
                            label: 'Hiện tại',
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: accent,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                          Flexible(
                            child: Text(
                              'Phí giao dịch ${_formatFee(user.fee)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                color: accent,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _HeroMetricCard(
                        icon: Icons.groups_2_outlined,
                        label: 'Giao dịch hoàn tất',
                        value: '${user.completedOrders}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _HeroMetricCard(
                        icon: Icons.bar_chart_rounded,
                        label: 'Volume tích lũy',
                        value: _formatCompact(user.accumulatedVolume),
                        subvalue: '${_formatVnd(user.accumulatedVolume)} đ',
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hạn mức ngày',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    VitStatusPill(
                      label: '${snapshot.dailyUsagePercent}%',
                      status: VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProgressTrack(value: dailyRatio, color: accent, height: 9),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Đã dùng: ',
                          children: [
                            TextSpan(
                              text: '${_formatVnd(user.dailyUsed)} đ',
                              style: TextStyle(
                                color: accent,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    Text(
                      'Tối đa: ${_formatVnd(user.dailyLimit)} đ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  const _HeroMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subvalue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subvalue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 90),
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.24)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: AppRadii.smRadius,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (subvalue != null)
            Text(
              subvalue!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class _NextLevelProgress extends StatelessWidget {
  const _NextLevelProgress({required this.snapshot});

  final P2PTradingLevelSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final nextLevel = snapshot.userLevel.currentLevel + 1;
    final progress = snapshot.userLevel.nextLevelProgress;
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.accent,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tiến trình lên Lv.$nextLevel',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressTrack(value: progress, color: AppColors.accent, height: 6),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.snapshot, required this.level});

  final P2PTradingLevelSnapshot snapshot;
  final P2PTradingLevelDraft level;

  @override
  Widget build(BuildContext context) {
    final currentLevel = snapshot.userLevel.currentLevel;
    final current = level.id == currentLevel;
    final passed = level.id < currentLevel;
    final locked = level.id > currentLevel;
    final accent = _levelColor(level);

    return VitCard(
      key: P2PTradingLevelPage.levelKey(level.id),
      padding: EdgeInsets.zero,
      clip: true,
      borderColor: current ? accent : AppColors.divider,
      child: Opacity(
        opacity: locked ? 0.62 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                color: current
                    ? accent.withValues(alpha: 0.10)
                    : passed
                    ? accent.withValues(alpha: 0.05)
                    : AppColors.surface2,
                border: Border(
                  bottom: BorderSide(
                    color: current
                        ? accent.withValues(alpha: 0.20)
                        : AppColors.divider,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _LevelIconBadge(level: level, size: 48, locked: locked),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Lv.${level.id} ${level.nameVi}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            if (current)
                              const VitStatusPill(
                                label: 'Hiện tại',
                                status: VitStatusPillStatus.success,
                                size: VitStatusPillSize.sm,
                              )
                            else if (passed)
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppColors.buy,
                                size: 15,
                              )
                            else
                              const VitStatusPill(
                                label: 'Chưa đạt',
                                status: VitStatusPillStatus.neutral,
                                size: VitStatusPillSize.sm,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Row(
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              color: locked ? AppColors.text3 : accent,
                              size: 15,
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Text(
                              'Phí ${_formatFee(level.fee)}',
                              style: AppTextStyles.caption.copyWith(
                                color: locked ? AppColors.text3 : accent,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            if (!locked && level.id > 1) ...[
                              const SizedBox(width: AppSpacing.x2),
                              VitStatusPill(
                                label:
                                    '-${_discountFromBasic(snapshot, level)}%',
                                status: level.id == 3
                                    ? VitStatusPillStatus.purple
                                    : VitStatusPillStatus.info,
                                size: VitStatusPillSize.sm,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _LimitTile(
                          label: 'Hạn mức/ngày',
                          value: _formatLimit(level.dailyLimit),
                          accent: current ? accent : AppColors.text1,
                          highlighted: current,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _LimitTile(
                          label: 'Hạn mức/đơn',
                          value: _formatLimit(level.perOrderLimit),
                          accent: current ? accent : AppColors.text1,
                          highlighted: current,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Yêu cầu:',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final requirement in level.requirements) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: locked ? AppColors.text3 : AppColors.buy,
                          size: 14,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            requirement,
                            style: AppTextStyles.caption.copyWith(
                              color: locked ? AppColors.text3 : AppColors.text2,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                  ],
                  if (locked && level.id == currentLevel + 1) ...[
                    const SizedBox(height: AppSpacing.x3),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: AppSpacing.x3),
                    VitCtaButton(
                      key: P2PTradingLevelPage.upgradeButtonKey,
                      variant: VitCtaButtonVariant.warning,
                      height: 38,
                      leading: const Icon(Icons.trending_up_rounded),
                      onPressed: () {},
                      child: Text('Nâng cấp lên ${level.nameVi}'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelIconBadge extends StatelessWidget {
  const _LevelIconBadge({
    required this.level,
    required this.size,
    this.locked = false,
  });

  final P2PTradingLevelDraft level;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final accent = _levelColor(level);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: locked
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, accent.withValues(alpha: 0.68)],
              ),
        color: locked ? AppColors.surface2 : null,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: locked
            ? null
            : [
                BoxShadow(
                  color: accent.withValues(alpha: 0.26),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Icon(
        _levelIcon(level.id),
        color: locked ? AppColors.text3 : AppColors.navCenterIcon,
        size: size * 0.48,
      ),
    );
  }
}

class _LimitTile extends StatelessWidget {
  const _LimitTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.highlighted,
  });

  final String label;
  final String value;
  final Color accent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: highlighted
            ? accent.withValues(alpha: 0.08)
            : AppColors.surface2,
        border: Border.all(
          color: highlighted
              ? accent.withValues(alpha: 0.20)
              : AppColors.divider,
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.stacked_line_chart_rounded,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({
    required this.value,
    required this.color,
    required this.height,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.smRadius,
      child: LinearProgressIndicator(
        minHeight: height,
        value: value.clamp(0, 1),
        backgroundColor: AppColors.surface2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

Color _levelColor(P2PTradingLevelDraft level) {
  return switch (level.id) {
    1 => AppColors.text3,
    2 => AppColors.primary,
    3 => AppColors.accent,
    _ => AppColors.warn,
  };
}

IconData _levelIcon(int id) {
  return switch (id) {
    1 => Icons.shield_outlined,
    2 => Icons.trending_up_rounded,
    3 => Icons.workspace_premium_outlined,
    _ => Icons.workspace_premium_rounded,
  };
}

String _formatFee(double fee) {
  final decimals = fee == 0.1 ? 1 : 2;
  return '+${fee.toStringAsFixed(decimals)}%';
}

String _formatLimit(int value) {
  if (value == 0) return '∞';
  return _formatCompact(value);
}

String _formatCompact(int value) {
  if (value >= 1000000000) {
    final formatted = value / 1000000000;
    return '${formatted.toStringAsFixed(formatted >= 10 ? 0 : 2)}B';
  }
  if (value >= 1000000) {
    final formatted = value / 1000000;
    return '${formatted.toStringAsFixed(formatted >= 10 ? 0 : 1)}M';
  }
  return value.toString();
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

int _discountFromBasic(
  P2PTradingLevelSnapshot snapshot,
  P2PTradingLevelDraft level,
) {
  final baseFee = snapshot.levels.first.fee;
  return (((baseFee - level.fee) / baseFee) * 100).round();
}
