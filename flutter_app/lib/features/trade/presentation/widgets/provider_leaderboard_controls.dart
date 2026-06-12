part of '../pages/provider_leaderboard_page.dart';

class _SurvivorshipWarning extends StatelessWidget {
  const _SurvivorshipWarning({required this.snapshot});

  final TradeProviderLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      borderColor: _leaderWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _leaderWarningText,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  snapshot.warningText,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontWeight: AppTextStyles.medium,
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

class _SortTabs extends StatelessWidget {
  const _SortTabs({
    required this.options,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardSort> options;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: InkWell(
                key: ProviderLeaderboardPage.sortKey(option.id),
                onTap: () => onChanged(option.id),
                borderRadius: AppRadii.cardRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  alignment: Alignment.center,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: option.id == activeId
                        ? _leaderPrimary
                        : AppColors.transparent,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Text(
                    option.label,
                    style: AppTextStyles.caption.copyWith(
                      color: option.id == activeId
                          ? AppColors.onAccent
                          : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RiskFilters extends StatelessWidget {
  const _RiskFilters({
    required this.filters,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardRiskFilter> filters;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Level',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            for (final filter in filters) ...[
              _RiskChip(
                filter: filter,
                selected: filter.id == activeId,
                onTap: () => onChanged(filter.id),
              ),
              if (filter != filters.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final TradeProviderLeaderboardRiskFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ProviderLeaderboardPage.riskKey(filter.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected ? _leaderPrimary : _leaderChip,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? _leaderPrimary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text2,
            fontWeight: selected ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _VerifiedToggle extends StatelessWidget {
  const _VerifiedToggle({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ProviderLeaderboardPage.verifiedToggleKey,
      onTap: () => onChanged(!checked),
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 49,
        padding: const EdgeInsets.fromLTRB(12, 12, 13, 12),
        decoration: BoxDecoration(
          color: _leaderPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: checked ? _leaderPrimary : AppColors.text3,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            _TogglePill(checked: checked),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 48,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: checked ? _leaderPrimary : AppColors.borderSolid,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Align(
        alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
