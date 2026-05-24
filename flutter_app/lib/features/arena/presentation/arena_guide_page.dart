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
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

enum _GuideTab { guide, tips, safety, faq }

enum _GuideMode { create, join }

class ArenaGuidePage extends ConsumerStatefulWidget {
  const ArenaGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc209_arena_guide_content');
  static const modeCreateKey = Key('sc209_mode_create');
  static const modeJoinKey = Key('sc209_mode_join');
  static const ctaKey = Key('sc209_primary_cta');
  static const safetyCenterKey = Key('sc209_safety_center');
  static const supportKey = Key('sc209_support');

  static Key tabKey(String id) => Key('sc209_tab_$id');
  static Key tipKey(String id) => Key('sc209_tip_$id');
  static Key faqKey(String id) => Key('sc209_faq_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaGuidePage> createState() => _ArenaGuidePageState();
}

class _ArenaGuidePageState extends ConsumerState<ArenaGuidePage> {
  _GuideTab _tab = _GuideTab.guide;
  _GuideMode _mode = _GuideMode.create;
  int? _expandedTip;
  int? _expandedFaq;
  bool _showAllTips = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaGuide();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-209 ArenaGuidePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Hướng dẫn Arena',
              subtitle: 'Hướng dẫn - Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            _GuideTabs(active: _tab, onChanged: _setTab),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaGuidePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: _tabChildren(context, snapshot),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabChildren(BuildContext context, ArenaGuideSnapshot snapshot) {
    return switch (_tab) {
      _GuideTab.guide => [
        _GuideHero(snapshot: snapshot),
        _ModeSwitch(mode: _mode, onChanged: _setMode),
        _StepsTimeline(
          steps: _mode == _GuideMode.create
              ? snapshot.createSteps
              : snapshot.joinSteps,
        ),
        _StartCard(mode: _mode, onPressed: () => _openPrimary(context)),
        if (_mode == _GuideMode.create)
          _ExampleSection(examples: snapshot.examples),
        _ConceptSection(concepts: snapshot.keyConcepts),
      ],
      _GuideTab.tips => [
        _TipsHeader(total: snapshot.proTips.length),
        _ImpactLegend(),
        _TipsList(
          tips: _showAllTips
              ? snapshot.proTips
              : snapshot.proTips.take(5).toList(),
          expandedIndex: _expandedTip,
          onToggle: _toggleTip,
        ),
        if (!_showAllTips && snapshot.proTips.length > 5)
          _ShowMoreTipsButton(
            remaining: snapshot.proTips.length - 5,
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() => _showAllTips = true);
            },
          ),
        _ChecklistCard(items: snapshot.checklist),
        VitCtaButton(
          onPressed: () => context.go(AppRoutePaths.arenaStudio),
          leading: const Icon(Icons.auto_awesome, size: 16),
          child: const Text('Áp dụng ngay - Tạo Challenge'),
        ),
      ],
      _GuideTab.safety => [
        _SafetyHero(),
        _PointsOnlyBanner(),
        _SafetyTipList(items: snapshot.safetyTips),
        _SafetyCenterCard(
          onPressed: () => context.go(AppRoutePaths.arenaSafety),
        ),
      ],
      _GuideTab.faq => [
        _FaqHeader(total: snapshot.faqs.length),
        _FaqList(
          items: snapshot.faqs,
          expandedIndex: _expandedFaq,
          onToggle: _toggleFaq,
        ),
        _SupportCard(onPressed: () => context.go('/support')),
      ],
    };
  }

  void _setTab(_GuideTab tab) {
    HapticFeedback.selectionClick();
    setState(() => _tab = tab);
  }

  void _setMode(_GuideMode mode) {
    HapticFeedback.selectionClick();
    setState(() => _mode = mode);
  }

  void _toggleTip(int index) {
    HapticFeedback.selectionClick();
    setState(() => _expandedTip = _expandedTip == index ? null : index);
  }

  void _toggleFaq(int index) {
    HapticFeedback.selectionClick();
    setState(() => _expandedFaq = _expandedFaq == index ? null : index);
  }

  void _openPrimary(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.go(
      _mode == _GuideMode.create
          ? AppRoutePaths.arenaStudio
          : AppRoutePaths.arena,
    );
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({required this.active, required this.onChanged});

  final _GuideTab active;
  final ValueChanged<_GuideTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active.name,
          onChanged: (key) =>
              onChanged(_GuideTab.values.firstWhere((tab) => tab.name == key)),
          tabs: [
            VitTabItem(
              key: _GuideTab.guide.name,
              label: 'Hướng dẫn',
              icon: Icons.menu_book_outlined,
            ),
            VitTabItem(
              key: _GuideTab.tips.name,
              label: 'Mẹo hay',
              icon: Icons.lightbulb_outline,
            ),
            VitTabItem(
              key: _GuideTab.safety.name,
              label: 'An toàn',
              icon: Icons.shield_outlined,
            ),
            VitTabItem(
              key: _GuideTab.faq.name,
              label: 'FAQ',
              icon: Icons.help_outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero({required this.snapshot});

  final ArenaGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppModuleAccents.arena,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.arena,
                size: 17,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'HƯỚNG DẪN NHANH',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.heroSubtitle,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.mode, required this.onChanged});

  final _GuideMode mode;
  final ValueChanged<_GuideMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              key: ArenaGuidePage.modeCreateKey,
              label: 'Tạo Challenge',
              icon: Icons.auto_awesome,
              active: mode == _GuideMode.create,
              onPressed: () => onChanged(_GuideMode.create),
            ),
          ),
          Expanded(
            child: _ModeButton(
              key: ArenaGuidePage.modeJoinKey,
              label: 'Tham gia',
              icon: Icons.play_arrow_outlined,
              active: mode == _GuideMode.join,
              onPressed: () => onChanged(_GuideMode.join),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary : Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.ctaHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? Colors.white : AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? Colors.white : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
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

class _StepsTimeline extends StatelessWidget {
  const _StepsTimeline({required this.steps});

  final List<ArenaGuideStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 18,
          top: 26,
          bottom: 26,
          child: Container(width: 2, color: AppColors.divider),
        ),
        Column(
          children: [
            for (var index = 0; index < steps.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == steps.length - 1 ? 0 : AppSpacing.x3,
                ),
                child: _StepRow(step: steps[index]),
              ),
          ],
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ArenaGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(_iconFor(step.iconKey), color: color, size: 17),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _SmallBadge(label: 'Bước ${step.step}', color: color),
                    Text(
                      step.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                _TipPill(text: step.tip, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StartCard extends StatelessWidget {
  const _StartCard({required this.mode, required this.onPressed});

  final _GuideMode mode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final creating = mode == _GuideMode.create;
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.bolt_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sẵn sàng bắt đầu!',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      creating
                          ? 'Tạo challenge đầu tiên của bạn'
                          : 'Khám phá challenge đang mở',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: ArenaGuidePage.ctaKey,
            onPressed: onPressed,
            child: Text(creating ? 'Tạo challenge ngay' : 'Khám phá challenge'),
          ),
        ],
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({required this.examples});

  final List<ArenaGuideExampleDraft> examples;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'So sánh challenge',
      accentColor: AppModuleAccents.arena,
      children: [
        Text(
          'Challenge tốt vs cần cải thiện',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        for (final example in examples) _ExampleCard(example: example),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final ArenaGuideExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(example.tone);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  example.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallBadge(label: example.rating, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _MetaChip(example.template),
              _MetaChip(example.format),
              _MetaChip('${example.entryPoints} pts'),
              _MetaChip(example.resolution),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final reason in example.reasons)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x1),
              child: Row(
                children: [
                  Icon(
                    example.tone == ArenaGuideTone.success
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                    color: color,
                    size: 13,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      reason,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
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

class _ConceptSection extends StatelessWidget {
  const _ConceptSection({required this.concepts});

  final List<ArenaGuideConceptDraft> concepts;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thuật ngữ quan trọng',
      accentColor: AppModuleAccents.arena,
      children: [
        for (final concept in concepts)
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${concept.term}:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.arena,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  concept.definition,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TipsHeader extends StatelessWidget {
  const _TipsHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppModuleAccents.arena,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppModuleAccents.arena,
            size: 19,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total mẹo từ Top Creator',
                  style: AppTextStyles.body.copyWith(
                    color: AppModuleAccents.arena,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Những bí quyết giúp challenge nổi bật, thu hút người chơi và giảm tranh chấp.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Mức ảnh hưởng:',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x3),
        _LegendDot(label: 'Cao', color: AppColors.sell),
        const SizedBox(width: AppSpacing.x3),
        _LegendDot(label: 'Trung bình', color: AppColors.warn),
      ],
    );
  }
}

class _TipsList extends StatelessWidget {
  const _TipsList({
    required this.tips,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<ArenaGuideTipDraft> tips;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < tips.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == tips.length - 1 ? 0 : AppSpacing.x2,
            ),
            child: _AccordionCard(
              key: ArenaGuidePage.tipKey(tips[index].category),
              icon: _iconFor(tips[index].iconKey),
              title: tips[index].title,
              description: tips[index].description,
              badgeColor: tips[index].impact == ArenaGuideImpact.high
                  ? AppColors.sell
                  : AppColors.warn,
              open: expandedIndex == index,
              onTap: () => onToggle(index),
            ),
          ),
      ],
    );
  }
}

class _ShowMoreTipsButton extends StatelessWidget {
  const _ShowMoreTipsButton({required this.remaining, required this.onPressed});

  final int remaining;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.expand_more, size: 16),
        label: Text('Xem thêm $remaining mẹo'),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.buy,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Checklist trước khi đăng',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var index = 0; index < items.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderSolid),
                      borderRadius: AppRadii.xsRadius,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      items[index],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
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

class _SafetyHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.buy, size: 19),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An toàn trong Arena',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Open Arena dùng Arena Points, Trust Score, Fair Play và quy trình tranh chấp minh bạch để bảo vệ cộng đồng.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsOnlyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points only - không có rủi ro tài chính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Arena Points không liên quan đến crypto hay fiat.',
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

class _SafetyTipList extends StatelessWidget {
  const _SafetyTipList({required this.items});

  final List<ArenaGuideSafetyTipDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.x3,
            ),
            child: _SafetyTipCard(item: items[index]),
          ),
      ],
    );
  }
}

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard({required this.item});

  final ArenaGuideSafetyTipDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(_iconFor(item.iconKey), color: color, size: 18),
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyCenterCard extends StatelessWidget {
  const _SafetyCenterCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaGuidePage.safetyCenterKey,
      onTap: onPressed,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Center',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Xem quy tắc cộng đồng đầy đủ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.text3, size: 18),
        ],
      ),
    );
  }
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.help_outline, color: AppModuleAccents.arena, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Câu hỏi thường gặp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _SmallBadge(label: '$total', color: AppModuleAccents.arena),
      ],
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.items,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<ArenaGuideFaqDraft> items;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.x2,
            ),
            child: _AccordionCard(
              key: ArenaGuidePage.faqKey('$index'),
              icon: Icons.help_outline,
              title: items[index].question,
              description: items[index].answer,
              badgeColor: AppModuleAccents.arena,
              open: expandedIndex == index,
              onTap: () => onToggle(index),
            ),
          ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.help_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vẫn cần trợ giúp?',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Liên hệ đội ngũ hỗ trợ 24/7',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          TextButton.icon(
            key: ArenaGuidePage.supportKey,
            onPressed: onPressed,
            icon: const Icon(Icons.chevron_right, size: 14),
            label: const Text('Hỗ trợ'),
          ),
        ],
      ),
    );
  }
}

class _AccordionCard extends StatelessWidget {
  const _AccordionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.badgeColor,
    required this.open,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color badgeColor;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: open
                        ? badgeColor.withValues(alpha: .12)
                        : AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    icon,
                    color: open ? badgeColor : AppColors.text3,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                AnimatedRotation(
                  turns: open ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.expand_more,
                    color: open ? badgeColor : AppColors.text3,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.x3),
                child: Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ),
            ),
            crossFadeState: open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
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
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _TipPill extends StatelessWidget {
  const _TipPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .16)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: color, size: 12),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

Color _toneColor(ArenaGuideTone tone) {
  return switch (tone) {
    ArenaGuideTone.arena => AppModuleAccents.arena,
    ArenaGuideTone.info => AppColors.accent,
    ArenaGuideTone.success => AppColors.buy,
    ArenaGuideTone.warning => AppColors.warn,
    ArenaGuideTone.danger => AppColors.sell,
    ArenaGuideTone.accent => AppColors.primary,
    ArenaGuideTone.neutral => AppColors.text3,
  };
}

IconData _iconFor(String key) {
  return switch (key) {
    'auto' => Icons.auto_mode,
    'check' => Icons.check_circle_outline,
    'clock' => Icons.schedule,
    'eye' => Icons.visibility_outlined,
    'file' => Icons.description_outlined,
    'gift' => Icons.card_giftcard,
    'layers' => Icons.layers_outlined,
    'lock' => Icons.lock_outline,
    'points' => Icons.toll_outlined,
    'report' => Icons.flag_outlined,
    'search' => Icons.search,
    'shield' => Icons.shield_outlined,
    'tag' => Icons.sell_outlined,
    'target' => Icons.track_changes,
    'trophy' => Icons.emoji_events_outlined,
    'users' => Icons.group_outlined,
    'warning' => Icons.warning_amber_outlined,
    'zap' => Icons.bolt_outlined,
    _ => Icons.circle_outlined,
  };
}
