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

const _arenaAccent = AppModuleAccents.arena;

class ArenaUniversalPresetLibraryPage extends ConsumerStatefulWidget {
  const ArenaUniversalPresetLibraryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc187_preset_content');
  static const sectionTabsKey = Key('sc187_section_tabs');
  static const selectedSuggestionKey = Key('sc187_selected_suggestion');

  static Key sectionKey(String id) => Key('sc187_section_$id');

  static Key domainKey(String id) => Key('sc187_domain_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaUniversalPresetLibraryPage> createState() =>
      _ArenaUniversalPresetLibraryPageState();
}

class _ArenaUniversalPresetLibraryPageState
    extends ConsumerState<ArenaUniversalPresetLibraryPage> {
  var _activeSection = 'domains';
  String? _expandedDomainId;
  var _suggestionDomainId = 'sports';
  String? _selectedSuggestion;
  var _activeDemoIndex = 0;
  String? _selectedTitle;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaPresetLibrary();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-187 ArenaUniversalPresetLibraryPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'Universal Rule Presets',
              subtitle: '10B — Preset Library',
              showBack: true,
              onBack: _close,
            ),
            _SectionTabs(
              sections: snapshot.sections,
              activeId: _activeSection,
              onChanged: _selectSection,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaUniversalPresetLibraryPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset + AppSpacing.x6),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x4,
                    children: [
                      if (_activeSection == 'domains')
                        _DomainPacksSection(
                          packs: snapshot.domainPacks,
                          expandedId: _expandedDomainId,
                          onToggle: _toggleDomain,
                        )
                      else if (_activeSection == 'suggestions')
                        _SuggestionsSection(
                          packs: snapshot.domainPacks,
                          suggestionsByDomain: snapshot.suggestionsByDomain,
                          activeDomainId: _suggestionDomainId,
                          selectedSuggestion: _selectedSuggestion,
                          onDomainChanged: _selectSuggestionDomain,
                          onSuggestionSelected: _selectSuggestion,
                        )
                      else if (_activeSection == 'dropdowns')
                        _DropdownsSection(groups: snapshot.dropdownGroups)
                      else if (_activeSection == 'demo_flows')
                        _DemoFlowsSection(
                          flows: snapshot.demoFlows,
                          activeIndex: _activeDemoIndex,
                          onChanged: _selectDemo,
                        )
                      else
                        _TitlesSection(
                          titles: snapshot.titleSuggestions,
                          selectedTitle: _selectedTitle,
                          onSelected: _selectTitle,
                        ),
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

  void _selectSection(String id) {
    HapticFeedback.selectionClick();
    setState(() => _activeSection = id);
  }

  void _toggleDomain(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedDomainId = _expandedDomainId == id ? null : id;
    });
  }

  void _selectSuggestionDomain(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _suggestionDomainId = id;
      _selectedSuggestion = null;
    });
  }

  void _selectSuggestion(String text) {
    HapticFeedback.selectionClick();
    setState(() => _selectedSuggestion = text);
  }

  void _selectDemo(int index) {
    HapticFeedback.selectionClick();
    setState(() => _activeDemoIndex = index);
  }

  void _selectTitle(String title) {
    HapticFeedback.selectionClick();
    setState(() => _selectedTitle = title);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaStudio);
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.sections,
    required this.activeId,
    required this.onChanged,
  });

  final List<ArenaPresetSectionDraft> sections;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ArenaUniversalPresetLibraryPage.sectionTabsKey,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.borderSolid)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x3,
          AppSpacing.x5,
          AppSpacing.x3,
        ),
        child: Row(
          children: [
            for (final section in sections) ...[
              _SectionChip(
                section: section,
                active: activeId == section.id,
                onTap: () => onChanged(section.id),
              ),
              const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({
    required this.section,
    required this.active,
    required this.onTap,
  });

  final ArenaPresetSectionDraft section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaUniversalPresetLibraryPage.sectionKey(section.id),
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _sectionIcon(section.id),
            color: active ? AppColors.warn : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            section.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.warn : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DomainPacksSection extends StatelessWidget {
  const _DomainPacksSection({
    required this.packs,
    required this.expandedId,
    required this.onToggle,
  });

  final List<ArenaDomainPackDraft> packs;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Domain Packs',
          subtitle: '10 lĩnh vực bao phủ mọi loại challenge',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final pack in packs) ...[
          _DomainPackCard(
            pack: pack,
            expanded: expandedId == pack.id,
            onTap: () => onToggle(pack.id),
          ),
          const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _DomainPackCard extends StatelessWidget {
  const _DomainPackCard({
    required this.pack,
    required this.expanded,
    required this.onTap,
  });

  final ArenaDomainPackDraft pack;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaUniversalPresetLibraryPage.domainKey(pack.id),
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                _DomainIcon(id: pack.id),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        pack.description,
                        maxLines: expanded ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 20,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.borderSolid, height: 1),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'CHALLENGE TYPES HỖ TRỢ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final type in pack.supportedTypes)
                        _SmallPill(label: type, accentColor: _arenaAccent),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'GỢI Ý MẪU',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final example in pack.examples)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: _ExampleRow(text: example),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({
    required this.packs,
    required this.suggestionsByDomain,
    required this.activeDomainId,
    required this.selectedSuggestion,
    required this.onDomainChanged,
    required this.onSuggestionSelected,
  });

  final List<ArenaDomainPackDraft> packs;
  final Map<String, List<ArenaPresetSuggestionDraft>> suggestionsByDomain;
  final String activeDomainId;
  final String? selectedSuggestion;
  final ValueChanged<String> onDomainChanged;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final activePack = packs.firstWhere(
      (pack) => pack.id == activeDomainId,
      orElse: () => packs.first,
    );
    final suggestions =
        suggestionsByDomain[activeDomainId] ??
        suggestionsByDomain['sports'] ??
        const <ArenaPresetSuggestionDraft>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Suggestion Library',
          subtitle: '6-8 gợi ý cho mỗi lĩnh vực',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final pack in packs.take(6)) ...[
                _DomainFilterChip(
                  pack: pack,
                  active: pack.id == activeDomainId,
                  onTap: () => onDomainChanged(pack.id),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MiniHeader(
                icon: Icons.auto_awesome_rounded,
                label: 'Gợi ý — ${activePack.title}',
                count: suggestions.length,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final item in suggestions)
                    _SuggestionChip(
                      item: item,
                      selected: selectedSuggestion == item.text,
                      onTap: () => onSuggestionSelected(item.text),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MiniHeader(
                icon: Icons.search_rounded,
                label: 'SmartAutocompleteList',
              ),
              const SizedBox(height: AppSpacing.x3),
              const _SearchBox(text: 'Gõ để tìm gợi ý...'),
              const SizedBox(height: AppSpacing.x3),
              for (final item in suggestions.take(3))
                _AutocompleteRow(
                  item: item,
                  selected: item.text == selectedSuggestion,
                ),
            ],
          ),
        ),
        if (selectedSuggestion != null) ...[
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            key: ArenaUniversalPresetLibraryPage.selectedSuggestionKey,
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Text(
              selectedSuggestion!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DropdownsSection extends StatelessWidget {
  const _DropdownsSection({required this.groups});

  final List<ArenaPresetDropdownGroupDraft> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Dropdown / Autocomplete',
          subtitle: 'Component set có đầy đủ states',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final group in groups) ...[
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.disabled
                      ? 'STATE — DISABLED'
                      : 'SEARCHABLE DROPDOWN — ${group.label.toUpperCase()}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                _DropdownPreview(group: group),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _DemoFlowsSection extends StatelessWidget {
  const _DemoFlowsSection({
    required this.flows,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<ArenaPresetDemoFlowDraft> flows;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final activeFlow = flows[activeIndex.clamp(0, flows.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Example Mappings',
          subtitle: 'Demo mini-flow minh họa end-to-end',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < flows.length; i++) ...[
                _DemoSelectorChip(
                  flow: flows[i],
                  active: i == activeIndex,
                  onTap: () => onChanged(i),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _DemoFlowCard(flow: activeFlow),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MiniHeader(
                icon: Icons.menu_book_outlined,
                label: 'Tổng quan demo flows',
              ),
              const SizedBox(height: AppSpacing.x3),
              for (var i = 0; i < flows.length; i++)
                _DemoSummaryRow(
                  flow: flows[i],
                  selected: i == activeIndex,
                  onTap: () => onChanged(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TitlesSection extends StatelessWidget {
  const _TitlesSection({
    required this.titles,
    required this.selectedTitle,
    required this.onSelected,
  });

  final List<String> titles;
  final String? selectedTitle;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Auto Title Suggestions',
          subtitle: 'Gợi ý title thông minh theo domain + type',
          accentColor: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MiniHeader(
                icon: Icons.bolt_rounded,
                label: 'AutoTitleSuggestionRow',
                count: titles.length,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final title in titles)
                    _TitleChip(
                      title: title,
                      selected: selectedTitle == title,
                      onTap: () => onSelected(title),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (selectedTitle != null) ...[
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            borderColor: AppColors.sell20,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MiniHeader(
                  icon: Icons.visibility_outlined,
                  label: 'Title đã chọn',
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  selectedTitle!,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProcessRow(step: '1', text: 'Chọn Domain để lọc title phù hợp'),
              _ProcessRow(
                step: '2',
                text: 'Chọn Challenge Type để refine suggestions',
              ),
              _ProcessRow(
                step: '3',
                text: 'Tap suggestion để auto-fill title input',
              ),
              _ProcessRow(
                step: '4',
                text: 'Có thể chỉnh sửa title trước khi tiếp tục',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _PresetEngineNote(),
      ],
    );
  }
}

class _PresetSectionHeader extends StatelessWidget {
  const _PresetSectionHeader({
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(title: title, accentColor: accentColor),
        const SizedBox(height: AppSpacing.x1),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _DomainIcon extends StatelessWidget {
  const _DomainIcon({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
      child: Icon(_domainIcon(id), color: _arenaAccent, size: 20),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        border: Border.all(color: AppColors.warningBorder),
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
            color: accentColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.text3,
              size: 12,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
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

class _DomainFilterChip extends StatelessWidget {
  const _DomainFilterChip({
    required this.pack,
    required this.active,
    required this.onTap,
  });

  final ArenaDomainPackDraft pack;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _domainIcon(pack.id),
            color: active ? AppColors.warn : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            pack.title,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.warn : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ArenaPresetSuggestionDraft item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _challengeIcon(item.type),
            color: selected ? AppColors.warn : AppColors.text3,
            size: 13,
          ),
          const SizedBox(width: AppSpacing.x1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.warn : AppColors.text2,
                fontWeight: selected
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _AutocompleteRow extends StatelessWidget {
  const _AutocompleteRow({required this.item, required this.selected});

  final ArenaPresetSuggestionDraft item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.buy : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          _SmallPill(label: item.type, accentColor: AppColors.warn),
        ],
      ),
    );
  }
}

class _DropdownPreview extends StatelessWidget {
  const _DropdownPreview({required this.group});

  final ArenaPresetDropdownGroupDraft group;

  @override
  Widget build(BuildContext context) {
    final selected = group.options.isEmpty
        ? 'Dropdown bị vô hiệu hóa'
        : group.options.first;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: group.disabled ? AppColors.borderSolid : AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                group.disabled
                    ? Icons.lock_outline_rounded
                    : Icons.search_rounded,
                color: group.disabled ? AppColors.text3 : AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  group.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            selected,
            style: AppTextStyles.base.copyWith(
              color: group.disabled ? AppColors.text3 : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (group.options.length > 1) ...[
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final option in group.options.skip(1).take(3))
                  _SmallPill(label: option, accentColor: AppColors.accent),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DemoSelectorChip extends StatelessWidget {
  const _DemoSelectorChip({
    required this.flow,
    required this.active,
    required this.onTap,
  });

  final ArenaPresetDemoFlowDraft flow;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.buy : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _domainIcon(flow.domainId),
            color: active ? AppColors.buy : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            flow.domainLabel,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.buy : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoFlowCard extends StatelessWidget {
  const _DemoFlowCard({required this.flow});

  final ArenaPresetDemoFlowDraft flow;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _DomainIcon(id: flow.domainId),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flow.domainLabel} + ${flow.typeLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Demo mapping flow',
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
          _DemoStep(step: '1', label: 'Domain', value: flow.domainLabel),
          _DemoStep(step: '2', label: 'Type', value: flow.typeLabel),
          _DemoSuggestions(values: flow.suggestions),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.buy20,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.buy,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    flow.generatedRule,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      height: 1.4,
                      fontWeight: AppTextStyles.bold,
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

class _DemoStep extends StatelessWidget {
  const _DemoStep({
    required this.step,
    required this.label,
    required this.value,
  });

  final String step;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.smRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            children: [
              _StepDot(step: step, color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 56,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(Icons.check_rounded, color: AppColors.buy, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoSuggestions extends StatelessWidget {
  const _DemoSuggestions({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _StepDot(step: '3', color: AppColors.buy),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Suggestion chips',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final value in values)
                  _SmallPill(label: value, accentColor: AppColors.buy),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoSummaryRow extends StatelessWidget {
  const _DemoSummaryRow({
    required this.flow,
    required this.selected,
    required this.onTap,
  });

  final ArenaPresetDemoFlowDraft flow;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: VitCard(
        variant: VitCardVariant.inner,
        borderColor: selected ? AppColors.buy20 : null,
        padding: const EdgeInsets.all(AppSpacing.x3),
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              _domainIcon(flow.domainId),
              color: selected ? AppColors.buy : AppColors.text3,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                '${flow.domainLabel} + ${flow.typeLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleChip extends StatelessWidget {
  const _TitleChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.sell20 : AppColors.borderSolid,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.sell : AppColors.text2,
            fontWeight: selected ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({required this.step, required this.text});

  final String step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.smRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepDot(step: step, color: AppColors.sell),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
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

class _PresetEngineNote extends StatelessWidget {
  const _PresetEngineNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.buy, size: 16),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Hệ preset dùng 1 rule engine chung. Tất cả domains tái sử dụng cùng challenge types, dropdowns và suggestion pipeline.',
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

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({required this.icon, required this.label, this.count});

  final IconData icon;
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _arenaAccent, size: 15),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (count != null)
          _SmallPill(label: '$count', accentColor: _arenaAccent),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.step, required this.color});

  final String step;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        step,
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

IconData _sectionIcon(String id) {
  switch (id) {
    case 'domains':
      return Icons.layers_outlined;
    case 'suggestions':
      return Icons.auto_awesome_rounded;
    case 'dropdowns':
      return Icons.list_rounded;
    case 'demo_flows':
      return Icons.play_arrow_rounded;
    case 'titles':
      return Icons.tag_rounded;
    default:
      return Icons.extension_outlined;
  }
}

IconData _domainIcon(String id) {
  switch (id) {
    case 'sports':
      return Icons.sports_soccer_rounded;
    case 'esports':
      return Icons.sports_esports_rounded;
    case 'crypto':
      return Icons.show_chart_rounded;
    case 'tech':
      return Icons.smart_toy_outlined;
    case 'science':
      return Icons.science_outlined;
    case 'health':
      return Icons.fitness_center_rounded;
    case 'entertainment':
      return Icons.movie_outlined;
    case 'work':
      return Icons.business_center_outlined;
    case 'community':
      return Icons.groups_2_outlined;
    default:
      return Icons.category_outlined;
  }
}

IconData _challengeIcon(String type) {
  if (type.contains('Closest')) return Icons.adjust_rounded;
  if (type.contains('Highest')) return Icons.bar_chart_rounded;
  if (type.contains('Vote')) return Icons.how_to_vote_outlined;
  if (type.contains('Proof')) return Icons.verified_outlined;
  return Icons.check_box_outlined;
}
