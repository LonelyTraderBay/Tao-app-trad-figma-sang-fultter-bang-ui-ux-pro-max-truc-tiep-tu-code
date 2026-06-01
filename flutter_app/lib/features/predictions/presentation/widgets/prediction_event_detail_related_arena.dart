part of '../pages/prediction_event_detail_page.dart';

class _RelatedMarketsSection extends StatelessWidget {
  const _RelatedMarketsSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.relatedEvents.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Related Markets',
      accentColor: _predictionPurple,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (
                var index = 0;
                index < snapshot.relatedEvents.length;
                index += 1
              )
                Padding(
                  padding: EdgeInsets.only(
                    right: index == snapshot.relatedEvents.length - 1 ? 0 : 12,
                  ),
                  child: _RelatedMarketCard(
                    event: snapshot.relatedEvents[index],
                    onTap: () => context.go(
                      AppRoutePaths.marketsPredictionEvent(
                        snapshot.relatedEvents[index].id,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RelatedMarketCard extends StatelessWidget {
  const _RelatedMarketCard({required this.event, required this.onTap});

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = event.outcomes.first;
    return SizedBox(
      key: PredictionEventDetailPage.relatedKey(event.id),
      width: 220,
      child: VitCard(
        onTap: onTap,
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TinyBadge(
              label: event.category,
              color: _predictionPrimary,
              background: _predictionPrimary.withValues(alpha: .13),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                height: 1.35,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: top.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${top.chance}%',
                  style: AppTextStyles.body.copyWith(
                    color: top.color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  top.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const Spacer(),
                Text(
                  _formatVolume(event.volume24h),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaBridgeSection extends StatelessWidget {
  const _ArenaBridgeSection({required this.snapshot, required this.onCreate});

  final PredictionEventDetailSnapshot snapshot;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: AppColors.warn,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Arena trên cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      children: const [
                        _ArenaBadge('Arena Points only'),
                        _ArenaBadge('Event context only'),
                        _ArenaBadge('Không liên quan Wallet'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final room in snapshot.arenaRooms)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.gamepad_outlined,
                      color: AppColors.warn,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${room.slots} · ${room.points} Arena Points',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _TinyBadge(
                      label: room.badge,
                      color: AppColors.warn,
                      background: AppColors.warn10,
                    ),
                  ],
                ),
              ),
            ),
          InkWell(
            key: PredictionEventDetailPage.arenaCreateKey,
            onTap: onCreate,
            borderRadius: AppRadii.mdRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.warn08,
                border: Border.all(color: AppColors.warningBorder),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.warn,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tạo Arena từ event này',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warn,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Event chỉ là bối cảnh, không liên kết ví hay P/L.',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _ArenaBadge('Arena Points only'),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.warn,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaBadge extends StatelessWidget {
  const _ArenaBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.warn,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
