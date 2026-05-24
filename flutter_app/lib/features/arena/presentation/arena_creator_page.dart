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

const _arenaAccent = AppModuleAccents.arena;

enum _CreatorTab { modes, live, history, about }

class ArenaCreatorPage extends ConsumerStatefulWidget {
  const ArenaCreatorPage({
    super.key,
    required this.creatorId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc193_creator_content');
  static const trustDetailKey = Key('sc193_trust_detail');
  static const viewModeKey = Key('sc193_view_mode');
  static const useModeKey = Key('sc193_use_mode');
  static const policyKey = Key('sc193_policy');

  static Key modeKey(String id) => Key('sc193_mode_$id');

  final String creatorId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaCreatorPage> createState() => _ArenaCreatorPageState();
}

class _ArenaCreatorPageState extends ConsumerState<ArenaCreatorPage> {
  _CreatorTab _activeTab = _CreatorTab.modes;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaCreator(widget.creatorId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-193 ArenaCreatorPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Creator Profile',
              subtitle: 'Nhà sáng tạo · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaCreatorPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x3,
                    children: [
                      _CreatorHero(
                        creator: snapshot.creator,
                        onTrust: () =>
                            _go(AppRoutePaths.arenaTrust(snapshot.creator.id)),
                      ),
                      _TrustSection(
                        metrics: snapshot.trustMetrics,
                        onDetails: () =>
                            _go(AppRoutePaths.arenaTrust(snapshot.creator.id)),
                      ),
                      VitTabBar(
                        tabs: const [
                          VitTabItem(key: 'modes', label: 'Modes'),
                          VitTabItem(key: 'live', label: 'Live Rooms'),
                          VitTabItem(key: 'history', label: 'Lịch sử'),
                          VitTabItem(key: 'about', label: 'Giới thiệu'),
                        ],
                        activeKey: _activeTab.name,
                        variant: VitTabBarVariant.segment,
                        onChanged: (key) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = _tabFromKey(key));
                        },
                      ),
                      _TabContent(
                        activeTab: _activeTab,
                        snapshot: snapshot,
                        onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                        onUseMode: () => _go(AppRoutePaths.arenaStudio),
                      ),
                      _PolicyLink(
                        label: snapshot.policyLabel,
                        onTap: () => _go(AppRoutePaths.arenaSafety),
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

  _CreatorTab _tabFromKey(String key) {
    return _CreatorTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _CreatorTab.modes,
    );
  }

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _CreatorHero extends StatelessWidget {
  const _CreatorHero({required this.creator, required this.onTrust});

  final ArenaCreatorProfileDraft creator;
  final VoidCallback onTrust;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: _arenaAccent,
                  size: 34,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        if (creator.fairPlayBadge)
                          const VitStatusPill(
                            label: 'Fair Play',
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                            icon: Icons.shield_outlined,
                          ),
                        VitStatusPill(
                          label: creator.badge,
                          status: VitStatusPillStatus.orange,
                          size: VitStatusPillSize.sm,
                        ),
                        VitStatusPill(
                          label: 'Lv.${creator.level}',
                          status: VitStatusPillStatus.purple,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _CreatorStatTile(
                  label: 'Modes',
                  value: '${creator.modesCreated}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Phòng HT',
                  value: '${creator.completedRooms}',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Clone',
                  value: '${creator.totalClones}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Trust',
                  value: '${creator.trustScore}%',
                  color: AppColors.warn,
                  onTap: onTrust,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorStatTile extends StatelessWidget {
  const _CreatorStatTile({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: onTap == null ? null : color.withValues(alpha: .28),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TrustSection extends StatelessWidget {
  const _TrustSection({required this.metrics, required this.onDetails});

  final List<ArenaCreatorTrustMetricDraft> metrics;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TrustHeader(onDetails: onDetails),
        const SizedBox(height: AppSpacing.x3),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _TrustMetricCard(metric: metrics[0])),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _TrustMetricCard(metric: metrics[1])),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(child: _TrustMetricCard(metric: metrics[2])),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _TrustMetricCard(metric: metrics[3])),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustHeader extends StatelessWidget {
  const _TrustHeader({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.buy,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            'Chi tiết tin cậy',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ArenaCreatorPage.trustDetailKey,
            onTap: onDetails,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.buy,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustMetricCard extends StatelessWidget {
  const _TrustMetricCard({required this.metric});

  final ArenaCreatorTrustMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.kind);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(_metricIcon(metric.kind), color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          padding: EdgeInsets.zero,
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
                height: 44,
                child: const Text('Xem mode'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaCreatorPage.useModeKey,
                onPressed: onUseMode,
                height: 44,
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary12,
                borderRadius: AppRadii.mdRadius,
              ),
              child: const Icon(
                Icons.calculate_rounded,
                color: AppColors.primary,
                size: 20,
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
              size: 20,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            creator.bio,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
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

class _CompactStateCard extends StatelessWidget {
  const _CompactStateCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: 28),
          const SizedBox(height: AppSpacing.x3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PolicyLink extends StatelessWidget {
  const _PolicyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: ArenaCreatorPage.policyKey,
          onTap: onTap,
          borderRadius: AppRadii.smRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x1,
              vertical: AppSpacing.x2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(width: AppSpacing.x1),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.accent,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _metricColor(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => AppColors.buy,
    ArenaCreatorTrustMetricKind.disputeRate => AppColors.buy,
    ArenaCreatorTrustMetricKind.completion => AppColors.primary,
    ArenaCreatorTrustMetricKind.communityRating => AppColors.warn,
  };
}

IconData _metricIcon(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => Icons.shield_outlined,
    ArenaCreatorTrustMetricKind.disputeRate => Icons.flag_outlined,
    ArenaCreatorTrustMetricKind.completion => Icons.verified_outlined,
    ArenaCreatorTrustMetricKind.communityRating => Icons.star_outline_rounded,
  };
}
