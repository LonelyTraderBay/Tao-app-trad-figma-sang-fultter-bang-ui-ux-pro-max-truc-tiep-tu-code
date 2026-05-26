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

class ArenaModeDetailPage extends ConsumerStatefulWidget {
  const ArenaModeDetailPage({
    super.key,
    required this.modeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc189_mode_detail_content');
  static const creatorKey = Key('sc189_creator');
  static const trustKey = Key('sc189_trust');
  static const infoKey = Key('sc189_info');
  static const useModeKey = Key('sc189_use_mode');
  static const createRoomKey = Key('sc189_create_room');
  static const predictionKey = Key('sc189_prediction_context');

  static Key roomKey(String id) => Key('sc189_room_$id');
  static Key relatedModeKey(String id) => Key('sc189_related_mode_$id');

  final String modeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaModeDetailPage> createState() =>
      _ArenaModeDetailPageState();
}

class _ArenaModeDetailPageState extends ConsumerState<ArenaModeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaModeDetail(widget.modeId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-189 ArenaModeDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.mode.title,
              subtitle: 'Chế độ chơi · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaModeDetailPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _ModeHero(
                        snapshot: snapshot,
                        onCreator: () => _go(
                          AppRoutePaths.arenaCreator(snapshot.creator.id),
                        ),
                        onTrust: () =>
                            _go(AppRoutePaths.arenaTrust(snapshot.creator.id)),
                      ),
                      _DescriptionCard(description: snapshot.mode.description),
                      _RulesSummary(rows: snapshot.ruleRows),
                      _QualitySection(
                        metrics: snapshot.qualityMetrics,
                        onInfo: _showTrustSheet,
                      ),
                      _ModeActions(
                        onUseMode: () => _go(AppRoutePaths.arenaStudio),
                        onCreateRoom: () => _go(AppRoutePaths.arenaStudio),
                      ),
                      if (snapshot.relatedRooms.isNotEmpty)
                        _RelatedRooms(
                          rooms: snapshot.relatedRooms,
                          onRoom: (id) => _go(AppRoutePaths.arenaChallenge(id)),
                        ),
                      if (snapshot.relatedModes.isNotEmpty)
                        _RelatedModes(
                          modes: snapshot.relatedModes,
                          onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                        ),
                      _PredictionContext(
                        contextDraft: snapshot.predictionContext,
                        onTap: () => _go(
                          AppRoutePaths.marketsPredictionEvent(
                            snapshot.predictionContext.eventId,
                          ),
                        ),
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

  void _showTrustSheet() {
    HapticFeedback.selectionClick();
    final snapshot = ref
        .read(arenaRepositoryProvider)
        .getArenaModeDetail(widget.modeId);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: Colors.black.withValues(alpha: .55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) => _TrustSheet(snapshot: snapshot),
    );
  }
}

class _ModeHero extends StatelessWidget {
  const _ModeHero({
    required this.snapshot,
    required this.onCreator,
    required this.onTrust,
  });

  final ArenaModeDetailSnapshot snapshot;
  final VoidCallback onCreator;
  final VoidCallback onTrust;

  @override
  Widget build(BuildContext context) {
    final templateColor = _templateColor(snapshot.template.kind);
    return VitModuleHeroCard(
      accentColor: templateColor,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _ActionIcon(
                icon: _templateIcon(snapshot.template.kind),
                color: templateColor,
                size: 48,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.mode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.template.title} template',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _CreatorRow(snapshot: snapshot, onTap: onCreator),
          const SizedBox(height: AppSpacing.x4),
          Align(
            alignment: Alignment.centerLeft,
            child: VitStatusPill(
              key: ArenaModeDetailPage.trustKey,
              label: 'Trust Score: ${snapshot.creator.trustScore}%',
              icon: Icons.shield_outlined,
              status: VitStatusPillStatus.success,
              size: VitStatusPillSize.md,
              onTap: onTrust,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitStatusPill(
                label: snapshot.template.complexity,
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const VitStatusPill(
                label: 'Points-only',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
              for (final tag in snapshot.mode.tags)
                VitStatusPill(
                  label: tag,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.copy_rounded,
                  label: 'Clone',
                  value: '${snapshot.mode.cloneCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.play_arrow_outlined,
                  label: 'Đang mở',
                  value: '${snapshot.mode.activeChallenges}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Hoàn thành',
                  value: '${snapshot.mode.completionRate}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorRow extends StatelessWidget {
  const _CreatorRow({required this.snapshot, required this.onTap});

  final ArenaModeDetailSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaModeDetailPage.creatorKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Row(
            children: [
              _ActionIcon(
                icon: Icons.person_rounded,
                color: _arenaAccent,
                size: 34,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (snapshot.creator.fairPlayBadge) ...[
                const VitStatusPill(
                  label: 'Fair Play',
                  icon: Icons.shield_outlined,
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
              VitStatusPill(
                label: snapshot.creator.badge,
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Mô tả',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _RulesSummary extends StatelessWidget {
  const _RulesSummary({required this.rows});

  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Tóm tắt luật chơi',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                _RuleRow(row: rows[index]),
                if (index != rows.length - 1)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.row});

  final ArenaRuleSummaryRow row;

  @override
  Widget build(BuildContext context) {
    final isRisk = row.label == 'Rủi ro tranh chấp';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            row.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: isRisk
                ? const VitStatusPill(
                    label: 'Thấp',
                    status: VitStatusPillStatus.success,
                    size: VitStatusPillSize.sm,
                  )
                : Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: 1.35,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _QualitySection extends StatelessWidget {
  const _QualitySection({required this.metrics, required this.onInfo});

  final List<ArenaQualityMetricDraft> metrics;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Chất lượng & Tin cậy',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            mainAxisExtent: 62,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _QualityMetricCard(metric: metric);
          },
        ),
        const SizedBox(height: AppSpacing.x3),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: ArenaModeDetailPage.infoKey,
            onPressed: onInfo,
            icon: const Icon(Icons.info_outline_rounded, size: 14),
            label: const Text('Hiểu chỉ số này'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, AppSpacing.buttonCompact),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.micro.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QualityMetricCard extends StatelessWidget {
  const _QualityMetricCard({required this.metric});

  final ArenaQualityMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.status);
    final icon = _metricIcon(metric.status, metric.label);
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  metric.description,
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

class _ModeActions extends StatelessWidget {
  const _ModeActions({required this.onUseMode, required this.onCreateRoom});

  final VoidCallback onUseMode;
  final VoidCallback onCreateRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: ArenaModeDetailPage.useModeKey,
          onPressed: onUseMode,
          child: const Text('Dùng mode này'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: ArenaModeDetailPage.createRoomKey,
          onPressed: onCreateRoom,
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Tạo room mới'),
        ),
      ],
    );
  }
}

class _RelatedRooms extends StatelessWidget {
  const _RelatedRooms({required this.rooms, required this.onRoom});

  final List<ArenaChallengeDraft> rooms;
  final ValueChanged<String> onRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Phòng đang mở',
          accentColor: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          clip: true,
          child: Column(
            children: [
              for (var index = 0; index < rooms.length; index++) ...[
                _RoomRow(
                  room: rooms[index],
                  onTap: () => onRoom(rooms[index].id),
                ),
                if (index != rooms.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room, required this.onTap});

  final ArenaChallengeDraft room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaModeDetailPage.roomKey(room.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${room.slotsFilled}/${room.slotsTotal} slots · ${room.entryPoints} pts',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Chờ tham gia',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelatedModes extends StatelessWidget {
  const _RelatedModes({required this.modes, required this.onMode});

  final List<ArenaModeDraft> modes;
  final ValueChanged<String> onMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Mode tương tự',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final item in modes) ...[
                SizedBox(
                  width: 184,
                  child: _RelatedModeCard(
                    mode: item,
                    onTap: () => onMode(item.id),
                  ),
                ),
                if (item != modes.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RelatedModeCard extends StatelessWidget {
  const _RelatedModeCard({required this.mode, required this.onTap});

  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kind = _kindForMode(mode.templateId);
    return VitCard(
      key: ArenaModeDetailPage.relatedModeKey(mode.id),
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(minHeight: 132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ActionIcon(
                icon: _templateIcon(kind),
                color: _templateColor(kind),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  mode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            mode.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '${mode.cloneCount} clone · ${mode.completionRate}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PredictionContext extends StatelessWidget {
  const _PredictionContext({required this.contextDraft, required this.onTap});

  final ArenaPredictionContextDraft contextDraft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final probability = contextDraft.probability.clamp(0, 100) / 100;
    final color = contextDraft.probability >= 50
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      key: ArenaModeDetailPage.predictionKey,
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accent,
                size: 13,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Prediction Markets',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Bối cảnh thị trường',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contextDraft.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: AppColors.accent,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Xác suất "${contextDraft.outcomeName}":',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${contextDraft.probability}%',
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 6,
              value: probability,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.open_in_new_rounded, size: 13),
              label: const Text('Xem thị trường dự đoán'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, AppSpacing.buttonCompact),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: AppTextStyles.micro.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          Text(
            'Thông tin chỉ mang tính tham khảo. Arena Points và Prediction Markets là 2 hệ thống hoàn toàn riêng biệt.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustSheet extends StatelessWidget {
  const _TrustSheet({required this.snapshot});

  final ArenaModeDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x5,
          AppSpacing.x5,
          AppSpacing.x6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const _ActionIcon(
                  icon: Icons.shield_outlined,
                  color: AppColors.buy,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chi tiết tin cậy',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${snapshot.creator.name} · ${snapshot.creator.trustScore}% Trust',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x5),
            for (final metric in snapshot.qualityMetrics) ...[
              _TrustSheetRow(metric: metric),
              const SizedBox(height: AppSpacing.x3),
            ],
            VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.accent20,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Text(
                'Các chỉ số dựa trên lịch sử challenge, báo cáo cộng đồng và hệ thống kiểm duyệt. Đây là tín hiệu an toàn của Open Arena, không phải chỉ số tài chính.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustSheetRow extends StatelessWidget {
  const _TrustSheetRow({required this.metric});

  final ArenaQualityMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.status);
    return Row(
      children: [
        Icon(_metricIcon(metric.status, metric.label), color: color, size: 17),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            metric.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
        Text(
          metric.value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color, this.size = 32});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(
          size >= 40 ? AppRadii.card : AppRadii.md,
        ),
        border: Border.all(color: color.withValues(alpha: .20)),
      ),
      child: Icon(icon, color: color, size: size >= 40 ? 22 : 17),
    );
  }
}

IconData _templateIcon(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => Icons.track_changes_rounded,
    ArenaTemplateKind.closestGuess => Icons.pin_outlined,
    ArenaTemplateKind.teamBattle => Icons.groups_rounded,
    ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
    ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
    ArenaTemplateKind.proof => Icons.verified_user_outlined,
  };
}

Color _templateColor(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => AppColors.accent,
    ArenaTemplateKind.closestGuess => AppColors.primary,
    ArenaTemplateKind.teamBattle => AppColors.accent,
    ArenaTemplateKind.bracket => AppColors.warn,
    ArenaTemplateKind.vote => AppColors.buy,
    ArenaTemplateKind.proof => AppColors.text2,
  };
}

ArenaTemplateKind _kindForMode(String templateId) {
  return switch (templateId) {
    'prediction' => ArenaTemplateKind.prediction,
    'team_battle' => ArenaTemplateKind.teamBattle,
    'community_vote' => ArenaTemplateKind.vote,
    'proof_challenge' => ArenaTemplateKind.proof,
    'bracket' => ArenaTemplateKind.bracket,
    _ => ArenaTemplateKind.closestGuess,
  };
}

Color _metricColor(VitArenaMetricStatus status) {
  return switch (status) {
    VitArenaMetricStatus.success => AppColors.buy,
    VitArenaMetricStatus.warning => AppColors.warn,
    VitArenaMetricStatus.info => AppColors.primary,
    VitArenaMetricStatus.neutral => AppColors.text2,
  };
}

IconData _metricIcon(VitArenaMetricStatus status, String label) {
  if (label == 'Fair Play') return Icons.shield_outlined;
  if (label == 'Dùng lại') return Icons.refresh_rounded;
  if (label == 'Tỷ lệ báo cáo') return Icons.flag_outlined;
  return switch (status) {
    VitArenaMetricStatus.success => Icons.check_circle_outline_rounded,
    VitArenaMetricStatus.warning => Icons.warning_amber_rounded,
    VitArenaMetricStatus.info => Icons.info_outline_rounded,
    VitArenaMetricStatus.neutral => Icons.circle_outlined,
  };
}
