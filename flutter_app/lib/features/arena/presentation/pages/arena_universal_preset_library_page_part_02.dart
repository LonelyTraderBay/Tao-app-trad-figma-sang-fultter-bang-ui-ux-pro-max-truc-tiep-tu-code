part of 'arena_universal_preset_library_page.dart';

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
          padding: AppSpacing.arenaPaddingX4,
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
            padding: AppSpacing.arenaPaddingX4,
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
          padding: AppSpacing.arenaPaddingX4,
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
            height: AppSpacing.arenaPresetCaptionLineHeight,
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
    return SizedBox(
      width: AppSpacing.arenaPresetDomainIconBox,
      height: AppSpacing.arenaPresetDomainIconBox,
      child: Material(
        color: AppColors.surface2,
        shape: const CircleBorder(),
        child: Icon(
          _domainIcon(id),
          color: _arenaAccent,
          size: AppSpacing.arenaPresetDomainIcon,
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warn10,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.warningBorder),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: AppSpacing.arenaPresetPillPadding,
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
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: AppSpacing.arenaPaddingX2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.text3,
              size: AppSpacing.arenaPresetTinyIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  height: AppSpacing.arenaPresetBodyLineHeight,
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
      padding: AppSpacing.arenaPresetChipPadding,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _domainIcon(pack.id),
            color: active ? AppColors.warn : AppColors.text3,
            size: AppSpacing.arenaPresetSmallIcon,
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
      padding: AppSpacing.arenaPresetChipPadding,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _challengeIcon(item.type),
            color: selected ? AppColors.warn : AppColors.text3,
            size: AppSpacing.arenaPresetMicroIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.arenaPresetSuggestionMaxWidth,
            ),
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
      padding: AppSpacing.arenaPresetSectionChipPadding,
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: AppSpacing.arenaPresetSearchIcon,
          ),
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
      padding: AppSpacing.arenaBottomPaddingX2,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.buy : AppColors.text3,
            size: AppSpacing.arenaPresetSmallIcon,
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
      padding: AppSpacing.arenaPaddingX3,
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
                size: AppSpacing.arenaPresetInlineIcon,
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
                size: AppSpacing.arenaPresetChevron,
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
      padding: AppSpacing.arenaPresetChipPadding,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _domainIcon(flow.domainId),
            color: active ? AppColors.buy : AppColors.text3,
            size: AppSpacing.arenaPresetSmallIcon,
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
