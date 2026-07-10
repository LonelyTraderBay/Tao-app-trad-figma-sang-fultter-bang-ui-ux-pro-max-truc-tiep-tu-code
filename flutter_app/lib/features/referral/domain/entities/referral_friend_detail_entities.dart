part of 'referral_entities.dart';

final class ReferralFriendDetailSnapshot {
  const ReferralFriendDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.friendId,
    required this.found,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.listRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String friendId;
  final bool found;
  final String emptyTitle;
  final String emptyMessage;
  final String listRoute;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}
