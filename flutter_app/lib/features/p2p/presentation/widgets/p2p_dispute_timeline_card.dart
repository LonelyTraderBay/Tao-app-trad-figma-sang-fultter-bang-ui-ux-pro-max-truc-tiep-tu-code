import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeTimelineCard extends StatelessWidget {
  const P2PDisputeTimelineCard({super.key, required this.timeline});

  final List<P2PDisputeTimelineDraft> timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến trình',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < timeline.length; index++)
            _TimelineItem(
              item: timeline[index],
              isLast: index == timeline.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final P2PDisputeTimelineDraft item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = item.active ? AppModuleAccents.p2p : AppColors.buy;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: .35)),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: AppSpacing.x6,
                color: AppColors.borderSolid,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.event,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (item.detail != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    item.detail!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.time,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
