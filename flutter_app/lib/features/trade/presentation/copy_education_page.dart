import 'package:flutter/material.dart';
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
import '../data/trade_repository.dart';

const _copyPrimary = AppColors.primary;
const _educationCard = AppColors.surface;
const _educationPanel = AppColors.surface2;

class CopyEducationPage extends ConsumerStatefulWidget {
  const CopyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc065_copy_education_scroll_content');
  static const providerCtaKey = Key('sc065_provider_cta');
  static Key tabKey(String id) => Key('sc065_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyEducationPage> createState() => _CopyEducationPageState();
}

class _CopyEducationPageState extends ConsumerState<CopyEducationPage> {
  late String _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = 'how-it-works';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getCopyEducation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 146 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-065 CopyEducationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Hướng dẫn Copy Trading',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyEducationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _IntroBanner(snapshot: snapshot),
                    const SizedBox(height: 26),
                    _EducationTabs(
                      tabs: snapshot.tabs,
                      active: _activeTab,
                      onChanged: (value) => setState(() => _activeTab = value),
                    ),
                    const SizedBox(height: 25),
                    if (_activeTab == 'how-it-works')
                      _HowItWorksContent(snapshot: snapshot)
                    else
                      _SupplementalTabContent(activeTab: _activeTab),
                    const SizedBox(height: 24),
                    _ProviderCta(
                      onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
                    ),
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

class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.snapshot});

  final TradeCopyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _copyPrimary.withValues(alpha: .08),
        border: Border.all(color: _copyPrimary),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_outlined, color: _copyPrimary, size: 25),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.introTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _copyPrimary,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.introDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.42,
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

class _EducationTabs extends StatelessWidget {
  const _EducationTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TradeCopyEducationTab> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopyEducationPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _tabLabel(tab),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: active == tab.id
                              ? _copyPrimary
                              : AppColors.text3,
                          fontSize: 12,
                          fontWeight: active == tab.id
                              ? AppTextStyles.bold
                              : AppTextStyles.medium,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (active == tab.id)
                      const Positioned(
                        left: 28,
                        right: 28,
                        bottom: 0,
                        child: SizedBox(
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: _copyPrimary),
                          ),
                        ),
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

class _HowItWorksContent extends StatelessWidget {
  const _HowItWorksContent({required this.snapshot});

  final TradeCopyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepsCard(steps: snapshot.steps),
        const SizedBox(height: 22),
        _CopyModesCard(modes: snapshot.copyModes),
        const SizedBox(height: 22),
        _ConceptsCard(concepts: snapshot.concepts),
      ],
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});

  final List<TradeCopyEducationStep> steps;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Copy Trading hoạt động như thế nào?',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 17),
          for (final step in steps) ...[
            _StepRow(step: step),
            if (step != steps.last) const SizedBox(height: 17),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final TradeCopyEducationStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: Text(
              '${step.number}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: _copyPrimary,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _iconFor(step.iconName),
                    color: AppColors.text1,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1.38,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyModesCard extends StatelessWidget {
  const _CopyModesCard({required this.modes});

  final List<TradeCopyModeGuide> modes;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các chế độ sao chép',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final mode in modes) ...[
            _CopyModeTile(mode: mode),
            if (mode != modes.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CopyModeTile extends StatelessWidget {
  const _CopyModeTile({required this.mode});

  final TradeCopyModeGuide mode;

  @override
  Widget build(BuildContext context) {
    final color = Color(mode.colorHex);
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      decoration: BoxDecoration(
        color: _educationPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                mode.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            mode.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  text: mode.pro,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.cancel_outlined,
                  color: AppColors.sell,
                  text: mode.con,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConceptsCard extends StatelessWidget {
  const _ConceptsCard({required this.concepts});

  final List<TradeCopyConceptGuide> concepts;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khái niệm quan trọng',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final concept in concepts) ...[
            _ConceptRow(concept: concept),
            if (concept != concepts.last) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }
}

class _ConceptRow extends StatelessWidget {
  const _ConceptRow({required this.concept});

  final TradeCopyConceptGuide concept;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_iconFor(concept.iconName), color: _copyPrimary, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                concept.term,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                concept.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.34,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupplementalTabContent extends StatelessWidget {
  const _SupplementalTabContent({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    final title = switch (activeTab) {
      'scenarios' => 'Kịch bản Copy Trading',
      'fees' => 'Phí & Chi phí',
      'mistakes' => 'Sai lầm phổ biến',
      'regulatory' => 'Quy định & bảo vệ nhà đầu tư',
      _ => 'Hướng dẫn Copy Trading',
    };
    final description = switch (activeTab) {
      'scenarios' =>
        'Mô phỏng lợi nhuận, lỗ và slippage trước khi bạn copy provider.',
      'fees' =>
        'Tính platform fee, performance fee, trading fee và chi phí ẩn do slippage.',
      'mistakes' =>
        'Nhắc lại các sai lầm thường gặp: chỉ nhìn ROI, không kiểm Max Drawdown, copy toàn bộ vốn.',
      'regulatory' =>
        'Tóm tắt các nghĩa vụ disclosure, cooling-off, appropriateness assessment và quyền dừng copy.',
      _ =>
        'Nội dung giáo dục giúp bạn hiểu rõ cơ chế, rủi ro và chi phí trước khi copy.',
    };

    return _CardShell(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderCta extends StatelessWidget {
  const _ProviderCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyEducationPage.providerCtaKey,
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _copyPrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility_outlined,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 9),
            Text(
              'Xem danh sách providers',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallGuideLine extends StatelessWidget {
  const _SmallGuideLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _educationCard,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: child,
    );
  }
}

String _tabLabel(TradeCopyEducationTab tab) {
  if (tab.id == 'fees') return 'Phí & Chi\nphí';
  return tab.label;
}

IconData _iconFor(String name) {
  return switch (name) {
    'users' => Icons.group_outlined,
    'target' => Icons.adjust_rounded,
    'zap' => Icons.bolt_outlined,
    'activity' => Icons.show_chart_rounded,
    'down' => Icons.trending_down_rounded,
    'up' => Icons.trending_up_rounded,
    'clock' => Icons.access_time_rounded,
    _ => Icons.info_outline_rounded,
  };
}
