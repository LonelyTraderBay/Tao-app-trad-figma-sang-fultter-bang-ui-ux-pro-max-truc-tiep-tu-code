part of 'referral_entities.dart';

/// Data for the referral rules/terms screen: commission [tiers], reward
/// type explanations, terms, and FAQs.
final class ReferralRulesSnapshot {
  const ReferralRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tiers,
    required this.rewardTypes,
    required this.terms,
    required this.faqs,
    required this.disclaimer,
    required this.currentTierIndex,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<ReferralTierRuleDraft> tiers;
  final List<ReferralRewardTypeRuleDraft> rewardTypes;
  final List<String> terms;
  final List<ReferralFaqDraft> faqs;
  final String disclaimer;
  final int currentTierIndex;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

/// One referral commission tier (friend threshold, commission %, KYC
/// bonus) shown on the rules screen.
final class ReferralTierRuleDraft {
  const ReferralTierRuleDraft({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.minFriends,
    required this.commissionPercent,
    required this.kycBonus,
  });

  final String id;
  final String name;
  final String nameEn;
  final int minFriends;
  final int commissionPercent;
  final double kycBonus;
}

/// One reward-type explanation entry on the referral rules screen.
final class ReferralRewardTypeRuleDraft {
  const ReferralRewardTypeRuleDraft({
    required this.id,
    required this.title,
    required this.body,
    required this.highlight,
  });

  final String id;
  final String title;
  final String body;
  final String highlight;
}

/// One question/answer FAQ entry on the referral rules screen.
final class ReferralFaqDraft {
  const ReferralFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}
