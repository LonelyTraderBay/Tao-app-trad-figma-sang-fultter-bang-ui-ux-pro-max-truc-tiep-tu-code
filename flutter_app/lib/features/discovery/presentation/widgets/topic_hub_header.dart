part of '../pages/topic_hub_page.dart';

class _TopicRail extends StatelessWidget {
  const _TopicRail({
    required this.topics,
    required this.selectedTopicId,
    required this.onSelect,
  });

  final List<DiscoveryTopicDraft> topics;
  final String selectedTopicId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SingleChildScrollView(
        key: TopicHubPage.topicRailKey,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentPad,
          vertical: AppSpacing.x4,
        ),
        child: Row(
          children: [
            for (final topic in topics) ...[
              _TopicChip(
                topic: topic,
                active: topic.id == selectedTopicId,
                onTap: () => onSelect(topic.id),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.active,
    required this.onTap,
  });

  final DiscoveryTopicDraft topic;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTopic(topic);
    return InkWell(
      key: TopicHubPage.topicKey(topic.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: AppSpacing.buttonCompact + AppSpacing.x2,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: .14) : AppColors.surface2,
          border: Border.all(
            color: active
                ? accent.withValues(alpha: .44)
                : AppColors.transparent,
            width: 1.5,
          ),
          borderRadius: AppRadii.lgRadius,
        ),
        child: Text(
          topic.label,
          style: AppTextStyles.caption.copyWith(
            color: active ? accent : AppColors.text2,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _TopicContent extends StatelessWidget {
  const _TopicContent({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasContent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopicHero(snapshot: snapshot),
          VitEmptyState(
            title: 'Chưa có nội dung cho ${snapshot.selectedTopic.label}',
            message: 'Hãy quay lại sau hoặc chọn chủ đề khác',
            icon: Icons.search_rounded,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopicHero(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _PredictionSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _ArenaRoomsSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _ModesSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _CreatorsSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _CreateRoomCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _DisclosureCard(notes: snapshot.contractNotes),
      ],
    );
  }
}

class _TopicHero extends StatelessWidget {
  const _TopicHero({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final topic = snapshot.selectedTopic;
    final accent = _accentForTopic(topic);
    return VitCard(
      key: TopicHubPage.heroKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: accent.withValues(alpha: .22),
      child: Column(
        children: [
          Row(
            children: [
              _HeroIcon(topic: topic),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.label,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      topic.summary,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
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
                child: _HeroStat(
                  value: snapshot.predictions.length,
                  label: 'Events',
                  color: AppModuleAccents.predictions,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaRooms.length,
                  label: 'Rooms',
                  color: AppModuleAccents.arena,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaModes.length,
                  label: 'Modes',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.creators.length,
                  label: 'Creators',
                  color: AppModuleAccents.markets,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.topic});

  final DiscoveryTopicDraft topic;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTopic(topic);
    return Container(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .14),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(_iconForTopic(topic), color: accent, size: 23),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
