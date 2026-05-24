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
import '../data/profile_repository.dart';

const _kycBackground = AppColors.bg;
const _kycPanel = AppColors.surface;
const _kycGreen = AppColors.buy;
const _kycPrimary = AppColors.primary;
const _kycMuted = AppColors.text3;

class KYCPage extends ConsumerStatefulWidget {
  const KYCPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc159_kyc_content');
  static const statusCardKey = Key('sc159_kyc_status_card');
  static const privacyCardKey = Key('sc159_kyc_privacy_card');
  static Key levelKey(int level) => Key('sc159_kyc_level_$level');
  static Key startKey(int level) => Key('sc159_kyc_start_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends ConsumerState<KYCPage> {
  int? _expandedLevel;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getKyc();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 120
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-159 KYCPage',
      child: Material(
        color: _kycBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'X\u00E1c minh danh t\u00EDnh',
              subtitle: 'KYC \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: KYCPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 31, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _KycStatusCard(snapshot: snapshot),
                    const SizedBox(height: 33),
                    for (final level in snapshot.levels) ...[
                      _KycLevelCard(
                        level: level,
                        done: snapshot.currentLevel >= level.level,
                        expanded: _expandedLevel == level.level,
                        currentLevel: snapshot.currentLevel,
                        submitting: _submitting,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _expandedLevel = _expandedLevel == level.level
                                ? null
                                : level.level,
                          );
                        },
                        onStart: () => _startVerification(level.level),
                      ),
                      if (level != snapshot.levels.last)
                        const SizedBox(height: 25),
                    ],
                    const SizedBox(height: 29),
                    const _PrivacyCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startVerification(int level) async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() => _submitting = false);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _KycStatusCard extends StatelessWidget {
  const _KycStatusCard({required this.snapshot});

  final ProfileKycSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KYCPage.statusCardKey,
      height: 81,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _kycGreen.withValues(alpha: .45)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kycGreen.withValues(alpha: .2),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_outlined,
              color: _kycGreen,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.statusTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        snapshot.statusDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: _kycGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.check_rounded, color: _kycGreen, size: 14),
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

class _KycLevelCard extends StatelessWidget {
  const _KycLevelCard({
    required this.level,
    required this.done,
    required this.expanded,
    required this.currentLevel,
    required this.submitting,
    required this.onTap,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final bool expanded;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final border = done ? accent.withValues(alpha: .44) : AppColors.borderSolid;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: _kycPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            GestureDetector(
              key: KYCPage.levelKey(level.level),
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 73,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _LevelIcon(level: level.level, done: done, accent: accent),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: done ? AppColors.text1 : AppColors.text2,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (done)
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: _kycMuted,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '\u0110\u00E3 ho\u00E0n th\u00E0nh',
                                  style: AppTextStyles.micro.copyWith(
                                    color: _kycMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Ch\u01B0a x\u00E1c minh',
                              style: AppTextStyles.micro.copyWith(
                                color: _kycMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? .25 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.text3,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) ...[
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: _ExpandedLevelDetails(
                  level: level,
                  done: done,
                  currentLevel: currentLevel,
                  submitting: submitting,
                  onStart: onStart,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelIcon extends StatelessWidget {
  const _LevelIcon({
    required this.level,
    required this.done,
    required this.accent,
  });

  final int level;
  final bool done;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: done ? accent.withValues(alpha: .13) : Colors.transparent,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(
          color: done ? accent : AppColors.borderSolid,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: done
          ? Icon(Icons.check_circle_outline_rounded, color: accent, size: 24)
          : Text(
              '$level',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
    );
  }
}

class _ExpandedLevelDetails extends StatelessWidget {
  const _ExpandedLevelDetails({
    required this.level,
    required this.done,
    required this.currentLevel,
    required this.submitting,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final canStart = !done && level.level == currentLevel + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailsBlock(
          title: 'Gi\u1EDBi h\u1EA1n giao d\u1ECBch:',
          lines: level.limits,
        ),
        const SizedBox(height: 14),
        _DetailsBlock(
          title: 'T\u00EDnh n\u0103ng m\u1EDF kh\u00F3a:',
          lines: level.features,
          done: done,
        ),
        if (canStart) ...[
          const SizedBox(height: 14),
          GestureDetector(
            key: KYCPage.startKey(level.level),
            onTap: submitting ? null : onStart,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: AppSpacing.inputHeight,
              decoration: BoxDecoration(
                borderRadius: AppRadii.cardRadius,
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: .8)],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                submitting
                    ? '\u0110ang g\u1EEDi...'
                    : 'B\u1EAFt \u0111\u1EA7u x\u00E1c minh ${level.title}',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailsBlock extends StatelessWidget {
  const _DetailsBlock({
    required this.title,
    required this.lines,
    this.done = true,
  });

  final String title;
  final List<String> lines;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        for (final line in lines) ...[
          Row(
            children: [
              if (title.startsWith('T')) ...[
                Icon(
                  Icons.check_circle_rounded,
                  color: done ? _kycGreen : AppColors.text3,
                  size: 12,
                ),
                const SizedBox(width: 8),
              ] else
                Text(
                  '\u2022 ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              Expanded(
                child: Text(
                  line,
                  style: AppTextStyles.caption.copyWith(
                    color: done ? AppColors.text1 : AppColors.text3,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KYCPage.privacyCardKey,
      height: 95,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _kycPrimary.withValues(alpha: .24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _kycPrimary, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'B\u1EA3o m\u1EADt th\u00F4ng tin c\u00E1 nh\u00E2n',
                  style: AppTextStyles.caption.copyWith(
                    color: _kycPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    'Th\u00F4ng tin KYC \u0111\u01B0\u1EE3c m\u00E3 h\u00F3a AES-256. Ch\u00FAng t\u00F4i kh\u00F4ng chia\n'
                    's\u1EBB v\u1EDBi b\u00EAn th\u1EE9 ba.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.38,
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
