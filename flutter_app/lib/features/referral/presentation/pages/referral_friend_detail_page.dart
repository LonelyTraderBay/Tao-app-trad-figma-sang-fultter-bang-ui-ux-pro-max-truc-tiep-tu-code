import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';

class ReferralFriendDetailPage extends ConsumerWidget {
  const ReferralFriendDetailPage({super.key, required this.friendId});

  static const contentKey = Key('sc289_referral_friend_detail_content');
  static const emptyKey = Key('sc289_referral_friend_detail_empty');
  static const listButtonKey = Key('sc289_back_to_friend_list');

  final String friendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(referralRepositoryProvider)
        .getFriendDetail(friendId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-289 ReferralFriendDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              key: ReferralFriendDetailPage.contentKey,
              child: VitPageContent(
                padding: VitContentPadding.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x6,
                        AppSpacing.x2,
                        AppSpacing.x6,
                        0,
                      ),
                      child: _NotFoundState(snapshot: snapshot),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState({required this.snapshot});

  final ReferralFriendDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralFriendDetailPage.emptyKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.iconLg + AppSpacing.x2,
          height: AppSpacing.iconLg + AppSpacing.x2,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderSolid, width: 2),
            borderRadius: AppRadii.xlRadius,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.error_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          snapshot.emptyTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          snapshot.emptyMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          key: ReferralFriendDetailPage.listButtonKey,
          onPressed: () => context.go(snapshot.listRoute),
          fullWidth: false,
          variant: VitCtaButtonVariant.primary,
          height: AppSpacing.inputHeight - AppSpacing.x3,
          child: const Text('Quay lại danh sách'),
        ),
      ],
    );
  }
}
