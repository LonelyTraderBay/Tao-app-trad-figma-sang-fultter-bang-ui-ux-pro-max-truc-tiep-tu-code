part of 'earn_entities.dart';

final class StakingEmergencyStatusDraft {
  const StakingEmergencyStatusDraft({
    required this.title,
    required this.value,
    required this.body,
    required this.tone,
  });

  final String title;
  final String value;
  final String body;
  final String tone;
}

final class StakingEmergencySheetDraft {
  const StakingEmergencySheetDraft({
    required this.title,
    required this.body,
    required this.bullets,
    required this.confirmLabel,
    required this.tone,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final String confirmLabel;
  final String tone;
}

final class StakingContingencyPlanSnapshot {
  const StakingContingencyPlanSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.metrics,
    required this.scenarios,
    required this.validationItems,
    required this.validationBody,
    required this.documents,
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
  final List<StakingContingencyMetricDraft> metrics;
  final List<StakingContingencyScenarioDraft> scenarios;
  final List<StakingContingencyValidationDraft> validationItems;
  final String validationBody;
  final List<StakingContingencyDocumentDraft> documents;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingContingencyMetricDraft {
  const StakingContingencyMetricDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingContingencyScenarioDraft {
  const StakingContingencyScenarioDraft({
    required this.scenario,
    required this.likelihood,
    required this.impact,
    required this.response,
    required this.preventative,
  });

  final String scenario;
  final String likelihood;
  final String impact;
  final List<String> response;
  final List<String> preventative;
}

final class StakingContingencyValidationDraft {
  const StakingContingencyValidationDraft({
    required this.title,
    required this.dateLabel,
    required this.tone,
  });

  final String title;
  final String dateLabel;
  final String tone;
}

final class StakingContingencyDocumentDraft {
  const StakingContingencyDocumentDraft({
    required this.name,
    required this.size,
    required this.updatedLabel,
  });

  final String name;
  final String size;
  final String updatedLabel;
}

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

final class StakingWebhooksSnapshot {
  const StakingWebhooksSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.createLabel,
    required this.activeTitle,
    required this.webhooks,
    required this.eventsTitle,
    required this.availableEvents,
    required this.sheetTitle,
    required this.urlLabel,
    required this.urlPlaceholder,
    required this.eventsLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String createLabel;
  final String activeTitle;
  final List<StakingWebhookDraft> webhooks;
  final String eventsTitle;
  final List<String> availableEvents;
  final String sheetTitle;
  final String urlLabel;
  final String urlPlaceholder;
  final String eventsLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingWebhookDraft {
  const StakingWebhookDraft({
    required this.id,
    required this.url,
    required this.events,
    required this.active,
    required this.lastTriggered,
  });

  final String id;
  final String url;
  final List<String> events;
  final bool active;
  final String lastTriggered;
}
