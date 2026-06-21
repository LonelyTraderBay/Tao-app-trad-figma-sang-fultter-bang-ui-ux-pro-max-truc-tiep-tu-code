part of '../pages/arena_creator_page.dart';

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.activeTab,
    required this.snapshot,
    required this.onMode,
    required this.onUseMode,
  });

  final _CreatorTab activeTab;
  final ArenaCreatorProfileSnapshot snapshot;
  final ValueChanged<String> onMode;
  final VoidCallback onUseMode;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      _CreatorTab.modes => _ModesTab(
        modes: snapshot.modes,
        onMode: onMode,
        onUseMode: onUseMode,
      ),
      _CreatorTab.live => _CompactStateCard(
        icon: Icons.bolt_rounded,
        title: 'Không có phòng',
        message: 'Hiện chưa có phòng nào đang mở',
      ),
      _CreatorTab.history => _HistoryTab(rooms: snapshot.historyRooms),
      _CreatorTab.about => _AboutTab(
        creator: snapshot.creator,
        rows: snapshot.aboutRows,
      ),
    };
  }
}

class _ModesTab extends StatelessWidget {
  const _ModesTab({
    required this.modes,
    required this.onMode,
    required this.onUseMode,
  });

  final List<ArenaModeDraft> modes;
  final ValueChanged<String> onMode;
  final VoidCallback onUseMode;

  @override
  Widget build(BuildContext context) {
    if (modes.isEmpty) {
      return const _CompactStateCard(
        icon: Icons.bolt_rounded,
        title: 'Chưa có mode',
        message: 'Creator chưa tạo mode nào',
      );
    }

    final firstMode = modes.first;
    return Column(
      children: [
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (final mode in modes)
                _ModeRow(mode: mode, onTap: () => onMode(mode.id)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: ArenaCreatorPage.viewModeKey,
                onPressed: () => onMode(firstMode.id),
                variant: VitCtaButtonVariant.secondary,
                height: _creatorTabButtonExtent,
                child: const Text('Xem mode'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaCreatorPage.useModeKey,
                onPressed: onUseMode,
                height: _creatorTabButtonExtent,
                child: const Text('Dùng mode'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({required this.mode, required this.onTap});

  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ArenaCreatorPage.modeKey(mode.id),
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.arenaCreatorModeRowPadding,
        child: Row(
          children: [
            const SizedBox(
              width: AppSpacing.arenaCreatorModeIconBox,
              height: AppSpacing.arenaCreatorModeIconBox,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.primary12,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.calculate_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.arenaCreatorModeGlyph,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mode.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${mode.cloneCount} clone · ${mode.completionRate}% hoàn thành',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.arenaCreatorModeChevron,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.rooms});

  final List<ArenaChallengeDraft> rooms;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const _CompactStateCard(
        icon: Icons.access_time_rounded,
        title: 'Chưa có lịch sử',
        message: 'Các challenge đã kết thúc sẽ hiển thị ở đây',
      );
    }

    return VitCard(
      padding: AppSpacing.arenaCreatorCardPadding,
      child: Text(
        '${rooms.length} challenge đã hoàn tất',
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.creator, required this.rows});

  final ArenaCreatorProfileDraft creator;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          padding: AppSpacing.arenaCreatorCardPadding,
          child: Text(
            creator.bio,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text2,
              height: _creatorAboutLineRatio,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: AppSpacing.arenaCreatorCardPadding,
          child: Column(
            children: [
              for (final row in rows) ...[
                _AboutRow(row: row),
                if (row != rows.last) const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.row});

  final ArenaRuleSummaryRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            row.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          row.value,
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}
