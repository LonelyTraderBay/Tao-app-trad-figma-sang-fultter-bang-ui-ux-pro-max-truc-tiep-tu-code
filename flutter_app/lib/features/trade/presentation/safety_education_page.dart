import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _safetyBlue = Color(0xFF3B82F6);
const _safetyCard = Color(0xFF121720);
const _safetyTabs = Color(0xFF121720);
const _safetyHeroBg = Color(0x223B82F6);

class SafetyEducationPage extends ConsumerStatefulWidget {
  const SafetyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc080_safety_education_content');
  static Key tabKey(String id) => Key('sc080_tab_$id');
  static Key scamKey(String id) => Key('sc080_scam_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SafetyEducationPage> createState() =>
      _SafetyEducationPageState();
}

class _SafetyEducationPageState extends ConsumerState<SafetyEducationPage> {
  late String _activeTabId;
  String? _expandedScamId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getSafetyEducation();
    if (!_initialized) {
      _activeTabId = snapshot.defaultTabId;
      _initialized = true;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 132 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-080 SafetyEducationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'An toàn & Bảo mật',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: SafetyEducationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroBanner(snapshot: snapshot),
                    const SizedBox(height: 25),
                    _SafetyTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTabId,
                      onChanged: (id) {
                        setState(() {
                          _activeTabId = id;
                          _expandedScamId = null;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    if (_activeTabId == 'scams')
                      _ScamsTab(
                        scams: snapshot.scams,
                        expandedId: _expandedScamId,
                        onToggle: (id) => setState(
                          () => _expandedScamId = _expandedScamId == id
                              ? null
                              : id,
                        ),
                      )
                    else if (_activeTabId == 'redflags')
                      _RedFlagsTab(flags: snapshot.redFlags)
                    else if (_activeTabId == 'verification')
                      _VerificationTab(tiers: snapshot.verificationTiers)
                    else
                      _ReportTab(reasons: snapshot.reportReasons),
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

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeSafetyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _safetyHeroBg,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _safetyBlue, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _safetyBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: _safetyBlue,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _safetyBlue,
                    fontSize: 11,
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

class _SafetyTabs extends StatelessWidget {
  const _SafetyTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeSafetyTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: _safetyTabs,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: SafetyEducationPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          textAlign: TextAlign.center,
                          maxLines: tab.id == 'scams' ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _safetyBlue
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1.12,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: _safetyBlue,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScamsTab extends StatelessWidget {
  const _ScamsTab({
    required this.scams,
    required this.expandedId,
    required this.onToggle,
  });

  final List<TradeSafetyScamType> scams;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${scams.length} loại scam phổ biến trong copy trading. Tap để xem chi tiết.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 13),
        for (final scam in scams) ...[
          _ScamCard(
            scam: scam,
            expanded: expandedId == scam.id,
            onTap: () => onToggle(scam.id),
          ),
          if (scam != scams.last) const SizedBox(height: 13),
        ],
      ],
    );
  }
}

class _ScamCard extends StatelessWidget {
  const _ScamCard({
    required this.scam,
    required this.expanded,
    required this.onTap,
  });

  final TradeSafetyScamType scam;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          InkWell(
            key: SafetyEducationPage.scamKey(scam.id),
            onTap: onTap,
            borderRadius: AppRadii.cardRadius,
            child: SizedBox(
              height: 68,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 12, 14, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.sell,
                      size: 20,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scam.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontSize: 13,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            scam.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 120),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            _ScamExpandedContent(
              examples: scam.examples,
              howToAvoid: scam.howToAvoid,
            ),
        ],
      ),
    );
  }
}

class _ScamExpandedContent extends StatelessWidget {
  const _ScamExpandedContent({
    required this.examples,
    required this.howToAvoid,
  });

  final List<String> examples;
  final List<String> howToAvoid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExpandedList(
            title: 'Ví dụ:',
            items: examples,
            color: AppColors.text3,
          ),
          const SizedBox(height: 14),
          _ExpandedList(
            title: 'Cách tránh:',
            items: howToAvoid,
            color: AppColors.buy,
            bullet: '✓',
          ),
        ],
      ),
    );
  }
}

class _ExpandedList extends StatelessWidget {
  const _ExpandedList({
    required this.title,
    required this.items,
    required this.color,
    this.bullet = '•',
  });

  final String title;
  final List<String> items;
  final Color color;
  final String bullet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items) ...[
          Text(
            '$bullet $item',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          if (item != items.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _RedFlagsTab extends StatelessWidget {
  const _RedFlagsTab({required this.flags});

  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Checklist để đánh giá provider trước khi copy. Nếu có ≥2 red flags nghiêm trọng, KHÔNG nên copy.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        for (final severity in ['critical', 'warning', 'caution']) ...[
          _SeveritySection(
            title: _severityTitle(severity),
            color: _severityColor(severity),
            flags: flags.where((flag) => flag.severity == severity).toList(),
          ),
          if (severity != 'caution') const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _SeveritySection extends StatelessWidget {
  const _SeveritySection({
    required this.title,
    required this.color,
    required this.flags,
  });

  final String title;
  final Color color;
  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        for (final flag in flags) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.inputRadius,
              border: Border.all(color: color.withValues(alpha: .65)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.flag,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  flag.explanation,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (flag != flags.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _VerificationTab extends StatelessWidget {
  const _VerificationTab({required this.tiers});

  final List<TradeSafetyVerificationTier> tiers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoPanel(
          text:
              'Verification là cơ chế bảo vệ user. Provider verified đã qua kiểm tra KYC và performance audit.',
          color: _safetyBlue,
        ),
        const SizedBox(height: 14),
        Text(
          'Verification Tiers',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 12),
        for (final tier in tiers) ...[
          _TierCard(tier: tier),
          if (tier != tiers.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier});

  final TradeSafetyVerificationTier tier;

  @override
  Widget build(BuildContext context) {
    final color = Color(tier.colorHex);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                tier.tier,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final req in tier.requirements) ...[
            Text(
              '• $req',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
                height: 1.4,
              ),
            ),
            if (req != tier.requirements.last) const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  const _ReportTab({required this.reasons});

  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoPanel(
          text:
              'Khi nào nên report?\n${reasons.map((item) => '• $item').join('\n')}',
          color: AppColors.sell,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _safetyCard,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Provider',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 13),
              const _ReportField(label: 'Provider ID hoặc tên'),
              const SizedBox(height: 12),
              const _ReportField(label: 'Lý do report'),
              const SizedBox(height: 12),
              const _ReportField(label: 'Mô tả chi tiết', height: 82),
              const SizedBox(height: 13),
              Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sell,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  'Submit Report',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportField extends StatelessWidget {
  const _ReportField({required this.label, this.height = 45});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.cardBorder),
          ),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .65)),
      ),
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          height: 1.5,
        ),
      ),
    );
  }
}

String _severityTitle(String severity) {
  switch (severity) {
    case 'critical':
      return 'Critical (Tuyệt đối không copy)';
    case 'warning':
      return 'Warning (Cần thận trọng)';
    default:
      return 'Caution (Kiểm tra kỹ)';
  }
}

Color _severityColor(String severity) {
  switch (severity) {
    case 'critical':
      return AppColors.sell;
    case 'warning':
      return AppColors.warn;
    default:
      return _safetyBlue;
  }
}
