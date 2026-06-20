part of 'arena_production_ready_page.dart';

class _ComponentLine extends StatelessWidget {
  const _ComponentLine({required this.component});

  final ArenaProductionComponentDraft component;

  @override
  Widget build(BuildContext context) {
    final color = _componentColor(component.type);

    return Padding(
      padding: AppSpacing.arenaBottomPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: color.withValues(alpha: .13),
            borderRadius: AppRadii.xsRadius,
            child: Padding(
              padding: AppSpacing.arenaProductionPillPadding,
              child: Text(
                component.type,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1.08,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.14,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  component.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.24,
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

class _DictionaryBoard extends StatelessWidget {
  const _DictionaryBoard({required this.dictionary});

  final ArenaProductionDictionaryDraft dictionary;

  @override
  Widget build(BuildContext context) {
    return _HandoffBoard(
      icon: Icons.menu_book_outlined,
      color: AppColors.warn,
      title: dictionary.category,
      child: Column(
        children: [
          for (final item in dictionary.items) _DictionaryLine(item: item),
        ],
      ),
    );
  }
}

class _DictionaryLine extends StatelessWidget {
  const _DictionaryLine({required this.item});

  final ArenaProductionDictionaryItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaBottomPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: AppColors.surface2,
            borderRadius: AppRadii.xsRadius,
            child: Padding(
              padding: AppSpacing.arenaProductionPillPadding,
              child: Text(
                item.code,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.08,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.14,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.24,
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

class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaBottomPaddingX2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.buy,
            size: AppSpacing.arenaProductionChecklistIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InternalOnlyFooter extends StatelessWidget {
  const _InternalOnlyFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.arenaProductionChecklistIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ArenaProductionScreenStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Material(
      color: color.withValues(alpha: .13),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.arenaProductionPillPadding,
        child: Text(
          _statusLabel(status),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1.08,
          ),
        ),
      ),
    );
  }
}

class _StateMiniPill extends StatelessWidget {
  const _StateMiniPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.arenaProductionPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: 1.08,
          ),
        ),
      ),
    );
  }
}

class _StateLegendItem extends StatelessWidget {
  const _StateLegendItem({required this.state, required this.active});

  final ArenaProductionScreenState state;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = _stateColor(state);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _stateIcon(state),
          color: color,
          size: AppSpacing.arenaProductionStateIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          _stateLabel(state),
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.text2 : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _StateMatrixPill extends StatelessWidget {
  const _StateMatrixPill({required this.state, required this.active});

  final ArenaProductionScreenState state;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = _stateColor(state);

    return Opacity(
      opacity: active ? 1 : .32,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 64),
        child: Material(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          borderRadius: AppRadii.xsRadius,
          child: Padding(
            padding: AppSpacing.arenaProductionPillPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _stateIcon(state),
                  color: color,
                  size: AppSpacing.arenaProductionStateMatrixIcon,
                ),
                const SizedBox(width: AppSpacing.x1),
                Flexible(
                  child: Text(
                    _stateLabel(state),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: active ? AppTextStyles.bold : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _resolvedRoute(String route) {
  if (route == '/arena/production-ready') {
    return AppRoutePaths.arenaProduction;
  }
  if (route == '/arena/report/:caseId') {
    return AppRoutePaths.arenaReportCase('rpt001');
  }
  if (route == '/arena/ledger/entry/:entryId') {
    return AppRoutePaths.arenaLedgerEntry('entry001');
  }
  if (route == '/arena/challenge/:challengeId' ||
      route == '/arena/challenge/:id') {
    return AppRoutePaths.arenaChallenge('ch003');
  }
  if (route == '/arena/join/:id') {
    return AppRoutePaths.arenaJoin('ch003');
  }
  if (route == '/arena/mode/:id') {
    return AppRoutePaths.arenaMode('mode001');
  }
  if (route == '/arena/creator/:id') {
    return AppRoutePaths.arenaCreator('cr001');
  }
  return route;
}

String _statusLabel(ArenaProductionScreenStatus status) {
  return switch (status) {
    ArenaProductionScreenStatus.live => 'Implemented',
    ArenaProductionScreenStatus.future => 'Release-gated',
    ArenaProductionScreenStatus.qaOnly => 'QA/Dev',
    ArenaProductionScreenStatus.archived => 'Archived',
  };
}

Color _statusColor(ArenaProductionScreenStatus status) {
  return switch (status) {
    ArenaProductionScreenStatus.live => AppColors.buy,
    ArenaProductionScreenStatus.future => AppColors.accent,
    ArenaProductionScreenStatus.qaOnly => AppColors.primary,
    ArenaProductionScreenStatus.archived => AppColors.text3,
  };
}

String _stateLabel(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => 'default',
    ArenaProductionScreenState.loading => 'loading',
    ArenaProductionScreenState.empty => 'empty',
    ArenaProductionScreenState.error => 'error',
    ArenaProductionScreenState.offline => 'offline',
    ArenaProductionScreenState.underReview => 'under_review',
    ArenaProductionScreenState.reported => 'reported',
    ArenaProductionScreenState.hidden => 'hidden',
    ArenaProductionScreenState.resolved => 'resolved',
    ArenaProductionScreenState.canceled => 'canceled',
    ArenaProductionScreenState.expired => 'expired',
  };
}

IconData _stateIcon(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => Icons.check_circle_outline,
    ArenaProductionScreenState.loading => Icons.schedule_rounded,
    ArenaProductionScreenState.empty => Icons.inbox_outlined,
    ArenaProductionScreenState.error => Icons.error_outline,
    ArenaProductionScreenState.offline => Icons.wifi_off_rounded,
    ArenaProductionScreenState.underReview => Icons.visibility_outlined,
    ArenaProductionScreenState.reported => Icons.flag_outlined,
    ArenaProductionScreenState.hidden => Icons.visibility_off_outlined,
    ArenaProductionScreenState.resolved => Icons.verified_outlined,
    ArenaProductionScreenState.canceled => Icons.block_rounded,
    ArenaProductionScreenState.expired => Icons.lock_clock_outlined,
  };
}

Color _stateColor(ArenaProductionScreenState state) {
  return switch (state) {
    ArenaProductionScreenState.defaultView => AppColors.buy,
    ArenaProductionScreenState.loading => AppColors.warn,
    ArenaProductionScreenState.empty => AppColors.text3,
    ArenaProductionScreenState.error => AppColors.sell,
    ArenaProductionScreenState.offline => AppColors.text3,
    ArenaProductionScreenState.underReview => AppColors.primary,
    ArenaProductionScreenState.reported => AppColors.sell,
    ArenaProductionScreenState.hidden => AppColors.text3,
    ArenaProductionScreenState.resolved => AppColors.buy,
    ArenaProductionScreenState.canceled => AppColors.sell,
    ArenaProductionScreenState.expired => AppColors.warn,
  };
}

Color _flowColor(String id) {
  return switch (id) {
    'creator' => AppColors.accent,
    'moderation' => AppColors.sell,
    'points_audit' => AppColors.buy,
    _ => AppColors.primary,
  };
}

IconData _flowIcon(String id) {
  return switch (id) {
    'creator' => Icons.auto_awesome_rounded,
    'moderation' => Icons.shield_outlined,
    'points_audit' => Icons.query_stats_rounded,
    _ => Icons.map_outlined,
  };
}

Color _componentColor(String type) {
  return switch (type) {
    'chip' => AppColors.buy,
    'dialog' => AppColors.sell,
    'sheet' => AppColors.warn,
    'card' => AppColors.accent,
    _ => AppColors.primary,
  };
}
