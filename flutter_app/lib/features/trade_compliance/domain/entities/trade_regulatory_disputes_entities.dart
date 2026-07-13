part of 'trade_compliance_entities.dart';

final class TradeComplaintsHandlingSnapshot {
  const TradeComplaintsHandlingSnapshot({
    required this.activeCount,
    required this.resolvedCount,
    required this.averageResolutionDays,
    required this.categories,
    required this.timeline,
    required this.complaints,
    required this.processSteps,
    required this.ombudsman,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int activeCount;
  final int resolvedCount;
  final int averageResolutionDays;
  final List<TradeComplaintCategory> categories;
  final List<TradeComplaintTimelineStep> timeline;
  final List<TradeComplaint> complaints;
  final List<TradeComplaintProcessStep> processSteps;
  final TradeOmbudsmanInfo ombudsman;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintSubmissionSnapshot {
  const TradeComplaintSubmissionSnapshot({
    required this.processTitle,
    required this.processDescription,
    required this.categories,
    required this.subjectMinLength,
    required this.subjectMaxLength,
    required this.descriptionMinLength,
    required this.descriptionMaxLength,
    required this.termsIntro,
    required this.terms,
    required this.confirmationComplaintId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String processTitle;
  final String processDescription;
  final List<String> categories;
  final int subjectMinLength;
  final int subjectMaxLength;
  final int descriptionMinLength;
  final int descriptionMaxLength;
  final String termsIntro;
  final List<String> terms;
  final String confirmationComplaintId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingSnapshot {
  const TradeComplaintTrackingSnapshot({
    required this.complaintId,
    required this.statusLabel,
    required this.submittedLabel,
    required this.responseDueLabel,
    required this.daysRemaining,
    required this.deadlineNotice,
    required this.timeline,
    required this.actions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String complaintId;
  final String statusLabel;
  final String submittedLabel;
  final String responseDueLabel;
  final int daysRemaining;
  final String deadlineNotice;
  final List<TradeComplaintTrackingStep> timeline;
  final List<TradeComplaintTrackingAction> actions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingStep {
  const TradeComplaintTrackingStep({
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.state,
  });

  final String title;
  final String description;
  final String dateLabel;
  final TradeComplaintTrackingStepState state;
}

final class TradeComplaintTrackingAction {
  const TradeComplaintTrackingAction({
    required this.id,
    required this.label,
    required this.icon,
    this.routePath,
  });

  final String id;
  final String label;
  final TradeComplaintTrackingActionIcon icon;
  final String? routePath;
}

enum TradeComplaintTrackingStepState { completed, current, pending }

enum TradeComplaintTrackingActionIcon { message, document, warning }

final class TradeOmbudsmanReferralSnapshot {
  const TradeOmbudsmanReferralSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.eligibility,
    required this.contacts,
    required this.processSteps,
    required this.ctaLabel,
    required this.externalUrl,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final List<TradeOmbudsmanEligibility> eligibility;
  final List<TradeOmbudsmanContact> contacts;
  final List<TradeOmbudsmanProcessStep> processSteps;
  final String ctaLabel;
  final String externalUrl;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeOmbudsmanEligibility {
  const TradeOmbudsmanEligibility({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanContact {
  const TradeOmbudsmanContact({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final TradeOmbudsmanContactIcon icon;
  final String? detail;
}

final class TradeOmbudsmanProcessStep {
  const TradeOmbudsmanProcessStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

enum TradeOmbudsmanContactIcon { phone, website, address }

final class TradeComplaintCategory {
  const TradeComplaintCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final TradeComplaintCategoryIcon icon;
}

final class TradeComplaintTimelineStep {
  const TradeComplaintTimelineStep({
    required this.step,
    required this.label,
    required this.time,
  });

  final int step;
  final String label;
  final String time;
}

final class TradeComplaint {
  const TradeComplaint({
    required this.id,
    required this.category,
    required this.status,
    required this.submittedDate,
    required this.deadline,
    required this.subject,
  });

  final String id;
  final String category;
  final TradeComplaintStatus status;
  final String submittedDate;
  final String deadline;
  final String subject;
}

final class TradeComplaintProcessStep {
  const TradeComplaintProcessStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanInfo {
  const TradeOmbudsmanInfo({
    required this.description,
    required this.phone,
    required this.website,
  });

  final String description;
  final String phone;
  final String website;
}

enum TradeComplaintCategoryIcon {
  trade,
  account,
  payment,
  service,
  fees,
  other,
}

enum TradeComplaintStatus { submitted, underReview, resolved, escalated }
