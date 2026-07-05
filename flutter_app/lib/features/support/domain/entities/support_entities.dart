enum SupportScreenState { loading, empty, error, offline, ready }

enum SupportTicketStatus { open, inProgress, resolved, closed }

enum SupportTicketPriority { low, medium, high, urgent }

enum SupportTicketCategory { technical, trading, deposit, withdraw, kyc, other }

final class SupportHubSnapshot {
  const SupportHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.helpRoute,
    required this.announcementsRoute,
    required this.email,
    required this.hotline,
    required this.tickets,
    required this.faqItems,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String helpRoute;
  final String announcementsRoute;
  final String email;
  final String hotline;
  final List<SupportTicketDraft> tickets;
  final List<SupportFaqDraft> faqItems;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

final class SupportTicketDraft {
  const SupportTicketDraft({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.priority,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  final String id;
  final String subject;
  final SupportTicketCategory category;
  final SupportTicketStatus status;
  final SupportTicketPriority priority;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<SupportMessageDraft> messages;
}

final class SupportMessageDraft {
  const SupportMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  final String id;
  final String sender;
  final String text;
  final String time;
}

final class SupportFaqDraft {
  const SupportFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class HelpCenterSnapshot {
  const HelpCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.searchHint,
    required this.heroTitle,
    required this.heroBody,
    required this.chatRoute,
    required this.ticketRoute,
    required this.categories,
    required this.articles,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String searchHint;
  final String heroTitle;
  final String heroBody;
  final String chatRoute;
  final String ticketRoute;
  final List<HelpCategoryDraft> categories;
  final List<HelpArticleDraft> articles;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

final class HelpCategoryDraft {
  const HelpCategoryDraft({
    required this.id,
    required this.name,
    required this.count,
  });

  final String id;
  final String name;
  final int count;
}

final class HelpArticleDraft {
  const HelpArticleDraft({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    required this.views,
  });

  final String id;
  final String categoryId;
  final String title;
  final String summary;
  final int views;
}

enum AnnouncementType {
  promotion,
  newFeature,
  listing,
  maintenance,
  security,
  general,
}

final class AnnouncementsSnapshot {
  const AnnouncementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.filters,
    required this.announcements,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<AnnouncementFilterDraft> filters;
  final List<AnnouncementDraft> announcements;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

final class AnnouncementFilterDraft {
  const AnnouncementFilterDraft({
    required this.id,
    required this.label,
    this.type,
  });

  final String id;
  final String label;
  final AnnouncementType? type;
}

final class AnnouncementDraft {
  const AnnouncementDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedDate,
    required this.isPinned,
    required this.tags,
  });

  final String id;
  final AnnouncementType type;
  final String title;
  final String summary;
  final String content;
  final String publishedDate;
  final bool isPinned;
  final List<String> tags;
}
