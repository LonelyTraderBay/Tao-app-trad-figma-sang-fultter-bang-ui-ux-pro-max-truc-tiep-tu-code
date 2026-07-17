part of 'earn_entities.dart';

/// Data contract for the staking social feed screen.
final class StakingSocialFeedSnapshot {
  const StakingSocialFeedSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.composerPlaceholder,
    required this.tabs,
    required this.defaultTabId,
    required this.posts,
    required this.stats,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final String composerPlaceholder;
  final List<StakingSocialFeedTabDraft> tabs;
  final String defaultTabId;
  final List<StakingSocialFeedPostDraft> posts;
  final List<StakingSocialFeedStatDraft> stats;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A tab entry in the social feed screen's tab bar.
final class StakingSocialFeedTabDraft {
  const StakingSocialFeedTabDraft({
    required this.id,
    required this.label,
    required this.sectionTitle,
  });

  final String id;
  final String label;
  final String sectionTitle;
}

/// A single post in the staking social feed.
final class StakingSocialFeedPostDraft {
  const StakingSocialFeedPostDraft({
    required this.id,
    required this.author,
    required this.avatarLabel,
    this.badge,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.likes,
    required this.comments,
    this.asset,
    this.apy,
  });

  final String id;
  final String author;
  final String avatarLabel;
  final String? badge;
  final String timestamp;
  final String content;
  final String type;
  final int likes;
  final int comments;
  final String? asset;
  final String? apy;
}

/// A single summary stat card on the social feed screen.
final class StakingSocialFeedStatDraft {
  const StakingSocialFeedStatDraft({
    required this.value,
    required this.label,
    required this.tone,
  });

  final String value;
  final String label;
  final String tone;
}

/// Data contract for the staking community governance screen.
final class StakingCommunityGovernanceSnapshot {
  const StakingCommunityGovernanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.proposalsRoute,
    required this.forumRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.statsTitle,
    required this.stats,
    required this.activeProposal,
    required this.recentDecisions,
    required this.governanceSteps,
    required this.votingPower,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String proposalsRoute;
  final String forumRoute;
  final String infoTitle;
  final String infoBody;
  final String statsTitle;
  final List<StakingGovernanceStatDraft> stats;
  final StakingGovernanceActiveProposalDraft activeProposal;
  final List<StakingGovernanceDecisionDraft> recentDecisions;
  final List<StakingGovernanceStepDraft> governanceSteps;
  final StakingGovernanceVotingPowerDraft votingPower;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single summary stat card on the governance screen.
final class StakingGovernanceStatDraft {
  const StakingGovernanceStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

/// The currently active governance proposal highlighted on the governance
/// screen.
final class StakingGovernanceActiveProposalDraft {
  const StakingGovernanceActiveProposalDraft({
    required this.title,
    required this.body,
    required this.badge,
  });

  final String title;
  final String body;
  final String badge;
}

/// A single past governance decision row.
final class StakingGovernanceDecisionDraft {
  const StakingGovernanceDecisionDraft({
    required this.proposal,
    required this.status,
    required this.votes,
    required this.dateLabel,
  });

  final String proposal;
  final String status;
  final String votes;
  final String dateLabel;
}

/// A single step in the governance process explainer.
final class StakingGovernanceStepDraft {
  const StakingGovernanceStepDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

/// The current user's voting power summary.
final class StakingGovernanceVotingPowerDraft {
  const StakingGovernanceVotingPowerDraft({
    required this.title,
    required this.body,
    required this.value,
    required this.share,
  });

  final String title;
  final String body;
  final String value;
  final String share;
}

/// Data contract for the governance proposals list screen.
final class StakingProposalsSnapshot {
  const StakingProposalsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.createLabel,
    required this.proposals,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String createLabel;
  final List<StakingProposalDraft> proposals;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single governance proposal listing with live vote tallies.
final class StakingProposalDraft {
  const StakingProposalDraft({
    required this.id,
    required this.title,
    required this.status,
    required this.yesVotes,
    required this.noVotes,
    required this.quorum,
    required this.endsIn,
    required this.category,
    required this.votingRoute,
  });

  final String id;
  final String title;
  final String status;
  final int yesVotes;
  final int noVotes;
  final int quorum;
  final String endsIn;
  final String category;
  final String votingRoute;

  int get totalVotes => yesVotes + noVotes;

  double get yesPercent => totalVotes == 0 ? 0 : yesVotes / totalVotes * 100;

  double get noPercent => 100 - yesPercent;
}

/// Data contract for the governance proposal voting screen.
final class StakingVotingSnapshot {
  const StakingVotingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.category,
    required this.proposalTitle,
    required this.proposalBody,
    required this.proposedByLabel,
    required this.proposedBy,
    required this.resultsTitle,
    required this.results,
    required this.voteTitle,
    required this.options,
    required this.votingPowerPrefix,
    required this.votingPower,
    required this.votingPowerSuffix,
    required this.submitLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String category;
  final String proposalTitle;
  final String proposalBody;
  final String proposedByLabel;
  final String proposedBy;
  final String resultsTitle;
  final List<StakingVotingResultDraft> results;
  final String voteTitle;
  final List<StakingVotingOptionDraft> options;
  final String votingPowerPrefix;
  final String votingPower;
  final String votingPowerSuffix;
  final String submitLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single option's tallied result on the voting screen.
final class StakingVotingResultDraft {
  const StakingVotingResultDraft({
    required this.id,
    required this.label,
    required this.percent,
    required this.votes,
    required this.tone,
  });

  final String id;
  final String label;
  final int percent;
  final int votes;
  final String tone;
}

/// A single selectable vote option on the voting screen.
final class StakingVotingOptionDraft {
  const StakingVotingOptionDraft({
    required this.id,
    required this.label,
    required this.tone,
  });

  final String id;
  final String label;
  final String tone;
}

/// Data contract for the staking community forum screen.
final class StakingForumSnapshot {
  const StakingForumSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.categoriesTitle,
    required this.categories,
    required this.threadsTitle,
    required this.threads,
    required this.createLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String categoriesTitle;
  final List<StakingForumCategoryDraft> categories;
  final String threadsTitle;
  final List<StakingForumThreadDraft> threads;
  final String createLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single forum category summary row.
final class StakingForumCategoryDraft {
  const StakingForumCategoryDraft({
    required this.name,
    required this.threads,
    required this.posts,
  });

  final String name;
  final int threads;
  final int posts;
}

/// A single forum discussion thread listing.
final class StakingForumThreadDraft {
  const StakingForumThreadDraft({
    required this.title,
    required this.replies,
    required this.views,
    required this.pinned,
    required this.author,
  });

  final String title;
  final int replies;
  final int views;
  final bool pinned;
  final String author;
}
