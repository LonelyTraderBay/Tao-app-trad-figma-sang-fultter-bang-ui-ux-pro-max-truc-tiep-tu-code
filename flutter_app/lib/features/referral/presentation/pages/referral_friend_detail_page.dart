import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';

class ReferralFriendDetailPage extends ConsumerWidget {
  const ReferralFriendDetailPage({super.key, required this.friendId});

  static const contentKey = Key('sc289_referral_friend_detail_content');
  static const emptyKey = Key('sc289_referral_friend_detail_empty');
  static const listButtonKey = Key('sc289_back_to_friend_list');

  final String friendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(referralControllerProvider)
        .getFriendDetail(friendId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-289 ReferralFriendDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                key: ReferralFriendDetailPage.contentKey,
                child: VitPageContent(rhythm: VitPageRhythm.standard, 
                  padding: VitContentPadding.compact,
                  children: [
                    VitEmptyState(
                      key: ReferralFriendDetailPage.emptyKey,
                      icon: Icons.person_search_rounded,
                      title: snapshot.emptyTitle,
                      message: snapshot.emptyMessage,
                      actionLabel: 'Quay lại danh sách',
                      actionKey: ReferralFriendDetailPage.listButtonKey,
                      onAction: () => context.go(snapshot.listRoute),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
