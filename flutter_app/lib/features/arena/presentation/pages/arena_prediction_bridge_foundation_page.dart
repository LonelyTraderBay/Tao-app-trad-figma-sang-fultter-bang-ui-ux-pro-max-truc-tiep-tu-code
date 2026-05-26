import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

enum _BridgeSection { principles, topics, boundary, bridge, examples }

class ArenaPredictionBridgeFoundationPage extends ConsumerStatefulWidget {
  const ArenaPredictionBridgeFoundationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc207_bridge_content');
  static const tabsKey = Key('sc207_bridge_tabs');
  static const predictionProfileKey = Key('sc207_profile_predictions');
  static const arenaProfileKey = Key('sc207_profile_arena');

  static Key tabKey(String id) => Key('sc207_tab_$id');
  static Key topicKey(String id) => Key('sc207_topic_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPredictionBridgeFoundationPage> createState() =>
      _ArenaPredictionBridgeFoundationPageState();
}

class _ArenaPredictionBridgeFoundationPageState
    extends ConsumerState<ArenaPredictionBridgeFoundationPage> {
  _BridgeSection _activeSection = _BridgeSection.principles;
  String? _selectedTopicId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaPredictionBridge();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-207 ArenaPredictionBridgeFoundationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Bridge Foundation',
              subtitle: 'Kết nối · Prediction - Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaPredictionBridgeFoundationPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      const _BridgeHero(),
                      _SectionTabs(
                        active: _activeSection,
                        onChanged: (section) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeSection = section);
                        },
                      ),
                      _ActiveSection(
                        section: _activeSection,
                        snapshot: snapshot,
                        selectedTopicId: _selectedTopicId,
                        onTopicSelected: (id) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedTopicId = _selectedTopicId == id
                                ? null
                                : id;
                          });
                        },
                        onPredictionTap: () =>
                            _go(context, AppRoutePaths.profilePredictions),
                        onArenaTap: () =>
                            _go(context, AppRoutePaths.profileArena),
                      ),
                      _DisclosureFooter(text: snapshot.footerDisclosure),
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

  void _go(BuildContext context, String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _BridgeHero extends StatelessWidget {
  const _BridgeHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.link_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09A - Arena × Predictions Bridge Foundation',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Nền tảng kết nối an toàn giữa Open Arena và Prediction Markets. Khóa boundary trước khi nối flow.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.active, required this.onChanged});

  final _BridgeSection active;
  final ValueChanged<_BridgeSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ArenaPredictionBridgeFoundationPage.tabsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final config in _sectionConfigs) ...[
            _BridgeTabPill(
              config: config,
              active: config.section == active,
              onTap: () => onChanged(config.section),
            ),
            if (config != _sectionConfigs.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _BridgeTabPill extends StatelessWidget {
  const _BridgeTabPill({
    required this.config,
    required this.active,
    required this.onTap,
  });

  final _SectionConfig config;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ArenaPredictionBridgeFoundationPage.tabKey(config.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : AppColors.surface2,
            border: Border.all(
              color: active
                  ? AppColors.primary.withValues(alpha: .55)
                  : AppColors.cardBorder,
              width: active ? 1.5 : 1,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                config.icon,
                color: active ? AppColors.primary : AppColors.text2,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                config.label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.selectedTopicId,
    required this.onTopicSelected,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final _BridgeSection section;
  final ArenaPredictionBridgeSnapshot snapshot;
  final String? selectedTopicId;
  final ValueChanged<String> onTopicSelected;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _BridgeSection.principles => _PrinciplesSection(snapshot: snapshot),
      _BridgeSection.topics => _TopicsSection(
        snapshot: snapshot,
        selectedTopicId: selectedTopicId,
        onTopicSelected: onTopicSelected,
      ),
      _BridgeSection.boundary => _BoundarySection(snapshot: snapshot),
      _BridgeSection.bridge => _BridgeComponentsSection(
        snapshot: snapshot,
        onPredictionTap: onPredictionTap,
        onArenaTap: onArenaTap,
      ),
      _BridgeSection.examples => _ExamplesSection(snapshot: snapshot),
    };
  }
}

class _PrinciplesSection extends StatelessWidget {
  const _PrinciplesSection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '1 - Cross-Module Principles',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '6 nguyên tắc bắt buộc khi kết nối Arena - Prediction Markets. Vi phạm = reject trong code review.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final principle in snapshot.principles) ...[
          _PrincipleCard(principle: principle),
          if (principle != snapshot.principles.last)
            const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x5),
        const VitModuleSectionHeader(
          title: 'Allowed vs Not Allowed',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        _RuleBoard(
          title: 'Allowed',
          icon: Icons.check_rounded,
          color: AppColors.buy,
          items: snapshot.allowedItems,
        ),
        const SizedBox(height: AppSpacing.x4),
        _RuleBoard(
          title: 'Not Allowed',
          icon: Icons.close_rounded,
          color: AppColors.sell,
          items: snapshot.notAllowedItems,
        ),
      ],
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({required this.principle});

  final ArenaBridgePrincipleDraft principle;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(principle.tone);
    return VitCard(
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(tone: principle.tone),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '#${principle.number}',
                        style: AppTextStyles.micro.copyWith(
                          color: tone,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        principle.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  principle.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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

class _RuleBoard extends StatelessWidget {
  const _RuleBoard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<ArenaBridgeRuleDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .25),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            _RuleRow(item: item, color: color),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.item, required this.color});

  final ArenaBridgeRuleDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_rounded : Icons.close_rounded,
          color: color,
          size: 13,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicsSection extends StatelessWidget {
  const _TopicsSection({
    required this.snapshot,
    required this.selectedTopicId,
    required this.onTopicSelected,
  });

  final ArenaPredictionBridgeSnapshot snapshot;
  final String? selectedTopicId;
  final ValueChanged<String> onTopicSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '2 - Shared Topic Taxonomy',
          accentColor: AppModuleAccents.arena,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '8 topics dùng chung cho cả Arena và Prediction Markets. Bridge chỉ qua topic, không qua value.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final topic in snapshot.topics)
                _TopicChip(
                  topic: topic,
                  selected: selectedTopicId == topic.id,
                  onTap: () => onTopicSelected(topic.id),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final topic in snapshot.topics.take(4)) ...[
          _TopicMappingCard(topic: topic),
          if (topic != snapshot.topics.take(4).last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.selected,
    required this.onTap,
  });

  final ArenaBridgeTopicDraft topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(topic.tone);
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        key: ArenaPredictionBridgeFoundationPage.topicKey(topic.id),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: tone.withValues(alpha: selected ? .20 : .10),
            border: Border.all(
              color: tone.withValues(alpha: selected ? .50 : .20),
              width: selected ? 1.5 : 1,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            topic.label,
            style: AppTextStyles.micro.copyWith(
              color: tone,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicMappingCard extends StatelessWidget {
  const _TopicMappingCard({required this.topic});

  final ArenaBridgeTopicDraft topic;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InlineTitle(icon: Icons.topic_outlined, title: topic.label),
          const SizedBox(height: AppSpacing.x3),
          _MiniMetric(label: 'Prediction', value: topic.predictionUsage),
          const SizedBox(height: AppSpacing.x2),
          _MiniMetric(label: 'Arena', value: topic.arenaUsage),
          const SizedBox(height: AppSpacing.x2),
          _MiniMetric(label: 'Bridge', value: topic.bridgeUsage),
        ],
      ),
    );
  }
}

class _BoundarySection extends StatelessWidget {
  const _BoundarySection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '3 - Module Boundary Components',
          accentColor: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Banner, badge và info row bắt buộc khi hiển thị content cross-module.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final banner in snapshot.boundaryBanners) ...[
          _BoundaryBanner(banner: banner),
          if (banner != snapshot.boundaryBanners.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final badge in snapshot.badges)
                _BridgeBadge(label: badge.label, tone: badge.tone),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (final row in snapshot.infoRows) ...[
                _InfoRow(text: row.text, tone: row.tone),
                if (row != snapshot.infoRows.last)
                  const SizedBox(height: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BoundaryBanner extends StatelessWidget {
  const _BoundaryBanner({required this.banner});

  final ArenaBridgeBoundaryDraft banner;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(banner.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: tone.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(tone: banner.tone, small: true),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  banner.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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

class _BridgeComponentsSection extends StatelessWidget {
  const _BridgeComponentsSection({
    required this.snapshot,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final ArenaPredictionBridgeSnapshot snapshot;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '4 - Bridge Components',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '4 reusable bridge components. Mỗi component đều có mandatory disclosure badge.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final component in snapshot.bridgeComponents) ...[
          _ComponentDemoCard(component: component),
          if (component != snapshot.bridgeComponents.last)
            const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x4),
        _DualStatsCard(
          stats: snapshot.dualStats,
          onPredictionTap: onPredictionTap,
          onArenaTap: onArenaTap,
        ),
      ],
    );
  }
}

class _ComponentDemoCard extends StatelessWidget {
  const _ComponentDemoCard({required this.component});

  final ArenaBridgeComponentDraft component;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  component.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _BridgeBadge(label: component.badgeLabel, tone: component.tone),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            component.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _DemoFrame(
            title: component.sampleTitle,
            meta: component.sampleMeta,
            tone: component.tone,
          ),
        ],
      ),
    );
  }
}

class _DualStatsCard extends StatelessWidget {
  const _DualStatsCard({
    required this.stats,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final ArenaBridgeDualStatsDraft stats;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InlineTitle(
            icon: Icons.account_tree_outlined,
            title: 'DualModuleStatCard - separated profile blocks',
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _ModuleStatButton(
                  key: ArenaPredictionBridgeFoundationPage.predictionProfileKey,
                  label: 'Prediction',
                  value: '${stats.predictionPositions} positions',
                  detail: stats.predictionPnlLabel,
                  tone: ArenaBridgeTone.prediction,
                  onTap: onPredictionTap,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ModuleStatButton(
                  key: ArenaPredictionBridgeFoundationPage.arenaProfileKey,
                  label: 'Open Arena',
                  value: stats.arenaPointsLabel,
                  detail: '${stats.arenaRooms} rooms',
                  tone: ArenaBridgeTone.arena,
                  onTap: onArenaTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const _InfoRow(
            text: 'Hai khối stats mở hai module riêng. Không tổng hợp số liệu.',
            tone: ArenaBridgeTone.disclosure,
          ),
        ],
      ),
    );
  }
}

class _ModuleStatButton extends StatelessWidget {
  const _ModuleStatButton({
    super.key,
    required this.label,
    required this.value,
    required this.detail,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final String value;
  final String detail;
  final ArenaBridgeTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 112),
          padding: const EdgeInsets.all(AppSpacing.x3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            border: Border.all(color: color.withValues(alpha: .20)),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_toneIcon(tone), color: color, size: 18),
              const SizedBox(height: AppSpacing.x3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '5 - Example Usage Frames',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '4 frame demo: A-C là đúng cách, D là sai cách.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final example in snapshot.examples) ...[
          _ExampleCard(example: example),
          if (example != snapshot.examples.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final ArenaBridgeExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final allowed = example.status == ArenaBridgeExampleStatus.correct;
    final tone = allowed ? ArenaBridgeTone.disclosure : ArenaBridgeTone.blocked;
    final color = _toneColor(tone);
    return VitCard(
      borderColor: color.withValues(alpha: .25),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                allowed ? Icons.check_rounded : Icons.close_rounded,
                color: color,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                allowed ? 'Correct' : 'DO NOT USE',
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            example.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            example.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _DemoFrame(
            title: example.frameTitle,
            meta: example.evidenceRows.first,
            tone: tone,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in example.evidenceRows) ...[
            _InfoRow(text: row, tone: tone),
            if (row != example.evidenceRows.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _DemoFrame extends StatelessWidget {
  const _DemoFrame({
    required this.title,
    required this.meta,
    required this.tone,
  });

  final String title;
  final String meta;
  final ArenaBridgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: color.withValues(alpha: .18)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          _ToneIcon(tone: tone, small: true),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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

class _InlineTitle extends StatelessWidget {
  const _InlineTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _BridgeBadge extends StatelessWidget {
  const _BridgeBadge({required this.label, required this.tone});

  final String label;
  final ArenaBridgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_toneIcon(tone), color: color, size: 12),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text, required this.tone});

  final String text;
  final ArenaBridgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_toneIcon(tone), color: color, size: 13),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.tone, this.small = false});

  final ArenaBridgeTone tone;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    final size = small ? 30.0 : 36.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: BorderRadius.circular(small ? 12 : 14),
      ),
      child: Icon(_toneIcon(tone), color: color, size: small ? 15 : 17),
    );
  }
}

class _DisclosureFooter extends StatelessWidget {
  const _DisclosureFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 14),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
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

final class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _BridgeSection section;
  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _BridgeSection.principles,
    id: 'principles',
    label: 'Principles',
    icon: Icons.menu_book_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.topics,
    id: 'topics',
    label: 'Topics',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.boundary,
    id: 'boundary',
    label: 'Boundary',
    icon: Icons.shield_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.bridge,
    id: 'bridge',
    label: 'Bridge',
    icon: Icons.link_rounded,
  ),
  _SectionConfig(
    section: _BridgeSection.examples,
    id: 'examples',
    label: 'Examples',
    icon: Icons.visibility_outlined,
  ),
];

Color _toneColor(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => AppColors.primary,
    ArenaBridgeTone.arena => AppModuleAccents.arena,
    ArenaBridgeTone.prediction => AppModuleAccents.predictions,
    ArenaBridgeTone.disclosure => AppColors.buy,
    ArenaBridgeTone.danger => AppColors.sell,
    ArenaBridgeTone.blocked => AppColors.sell,
    ArenaBridgeTone.neutral => AppColors.text2,
  };
}

IconData _toneIcon(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => Icons.link_rounded,
    ArenaBridgeTone.arena => Icons.sports_esports_outlined,
    ArenaBridgeTone.prediction => Icons.shield_outlined,
    ArenaBridgeTone.disclosure => Icons.info_outline_rounded,
    ArenaBridgeTone.danger => Icons.warning_amber_rounded,
    ArenaBridgeTone.blocked => Icons.close_rounded,
    ArenaBridgeTone.neutral => Icons.shield_outlined,
  };
}
