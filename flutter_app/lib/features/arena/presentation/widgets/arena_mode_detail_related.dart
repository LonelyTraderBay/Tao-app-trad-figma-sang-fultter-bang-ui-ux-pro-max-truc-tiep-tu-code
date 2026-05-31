import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ArenaModeRelatedRooms extends StatelessWidget {
  const ArenaModeRelatedRooms({
    super.key,
    required this.roomKey,
    required this.rooms,
    required this.onRoom,
  });

  final Key Function(String id) roomKey;
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
                  rowKey: roomKey(rooms[index].id),
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
  const _RoomRow({
    required this.rowKey,
    required this.room,
    required this.onTap,
  });

  final Key rowKey;
  final ArenaChallengeDraft room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: rowKey,
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

class ArenaModeRelatedModes extends StatelessWidget {
  const ArenaModeRelatedModes({
    super.key,
    required this.relatedModeKey,
    required this.modes,
    required this.onMode,
  });

  final Key Function(String id) relatedModeKey;
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
                    cardKey: relatedModeKey(item.id),
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
  const _RelatedModeCard({
    required this.cardKey,
    required this.mode,
    required this.onTap,
  });

  final Key cardKey;
  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kind = arenaKindForMode(mode.templateId);
    return VitCard(
      key: cardKey,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(minHeight: 132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ArenaModeActionIcon(
                icon: arenaTemplateIcon(kind),
                color: arenaTemplateColor(kind),
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
