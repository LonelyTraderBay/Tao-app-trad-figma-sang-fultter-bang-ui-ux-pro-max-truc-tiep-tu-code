part of 'arena_governance_gate_page.dart';

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        child,
      ],
    );
  }
}

class _MiniOptionChip extends StatelessWidget {
  const _MiniOptionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? AppColors.warn : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 132),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.warn : AppColors.text3,
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

class _BuilderField extends StatelessWidget {
  const _BuilderField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        _DropdownCard(value: value, placeholder: 'Chọn...', onTap: onTap),
      ],
    );
  }
}

class _EdgeField extends StatelessWidget {
  const _EdgeField({
    required this.label,
    required this.publicRoom,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final bool publicRoom;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x1,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (publicRoom)
                const _RequiredPill(text: 'PUBLIC', compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _DropdownCard(value: value, placeholder: placeholder, onTap: onTap),
        ],
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: hasValue ? AppColors.accent20 : AppColors.borderSolid,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasValue ? value : placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: hasValue ? AppColors.text1 : AppColors.text3,
                fontWeight: hasValue
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
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
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) => onTap(),
            activeThumbColor: AppColors.warn,
            activeTrackColor: AppColors.warn15,
            inactiveThumbColor: AppColors.text2,
            inactiveTrackColor: AppColors.surface3,
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({required this.icon, required this.label, this.pill});

  final IconData icon;
  final String label;
  final String? pill;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _arenaAccent, size: 16),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (pill != null) _StatusPill(label: pill!, color: AppColors.accent),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequiredPill extends StatelessWidget {
  const _RequiredPill({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StatusPill(label: text, color: AppColors.sell, compact: compact);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    this.compact = false,
  });

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color == AppColors.sell
            ? AppColors.sell10
            : color == AppColors.buy
            ? AppColors.buy10
            : AppColors.warn10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.x1 : AppSpacing.x2,
          vertical: compact ? 1 : 3,
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

class _NextActionChip extends StatelessWidget {
  const _NextActionChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          const Icon(Icons.add_rounded, color: AppColors.accent, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationNote extends StatelessWidget {
  const _ModerationNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Governance Gate giúp bạn tạo room chất lượng, không cản bạn sáng tạo. Custom mode vẫn mở cho mọi lĩnh vực, nhưng room public cần rule rõ ràng để bảo vệ người tham gia.',
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

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: AppColors.surface2,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x3,
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.borderSolid, width: 1.4),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.4),
    ),
  );
}

String _formatArenaDateInput(String isoDate) {
  final parts = isoDate.split('-');
  if (parts.length != 3) return isoDate;
  return '${parts[1]}/${parts[2]}/${parts[0]}';
}

String _normalizeArenaDateInput(String displayDate) {
  final parts = displayDate.split('/');
  if (parts.length != 3) return displayDate;
  return '${parts[2].padLeft(4, '0')}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}';
}

IconData _privacyIcon(String id) {
  switch (id) {
    case 'public':
      return Icons.public_rounded;
    case 'private':
      return Icons.lock_outline_rounded;
    default:
      return Icons.link_rounded;
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

IconData _challengeIcon(String id) {
  switch (id) {
    case 'multi_choice':
      return Icons.format_list_bulleted_rounded;
    case 'closest_guess':
      return Icons.adjust_rounded;
    case 'highest_wins':
      return Icons.bar_chart_rounded;
    case 'lowest_wins':
      return Icons.trending_down_rounded;
    case 'first_to_finish':
      return Icons.flag_outlined;
    case 'team_score':
      return Icons.groups_rounded;
    case 'referee_decision':
      return Icons.gavel_rounded;
    case 'community_vote':
      return Icons.how_to_vote_outlined;
    case 'proof_challenge':
      return Icons.verified_outlined;
    default:
      return Icons.check_box_outlined;
  }
}

String _tierLabel(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return 'Public-ready';
    case _EligibilityTier.amber:
      return 'Private only';
    case _EligibilityTier.red:
      return 'Chưa đủ điều kiện';
  }
}
