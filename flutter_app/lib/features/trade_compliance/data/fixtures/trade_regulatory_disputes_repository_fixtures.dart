part of '../repositories/mock_trade_regulatory_repository.dart';

const List<TradeComplaintCategory> _complaintCategories = [
  TradeComplaintCategory(
    id: 'trade',
    label: 'Trade Execution',
    icon: TradeComplaintCategoryIcon.trade,
  ),
  TradeComplaintCategory(
    id: 'account',
    label: 'Account Management',
    icon: TradeComplaintCategoryIcon.account,
  ),
  TradeComplaintCategory(
    id: 'payment',
    label: 'Payments & Withdrawals',
    icon: TradeComplaintCategoryIcon.payment,
  ),
  TradeComplaintCategory(
    id: 'service',
    label: 'Customer Service',
    icon: TradeComplaintCategoryIcon.service,
  ),
  TradeComplaintCategory(
    id: 'fees',
    label: 'Fees & Charges',
    icon: TradeComplaintCategoryIcon.fees,
  ),
  TradeComplaintCategory(
    id: 'other',
    label: 'Other',
    icon: TradeComplaintCategoryIcon.other,
  ),
];

const List<TradeComplaintTimelineStep> _complaintTimeline = [
  TradeComplaintTimelineStep(step: 1, label: 'Submit Complaint', time: 'Day 0'),
  TradeComplaintTimelineStep(
    step: 2,
    label: 'Acknowledgement',
    time: 'Within 5 days',
  ),
  TradeComplaintTimelineStep(
    step: 3,
    label: 'Investigation',
    time: 'Up to 8 weeks',
  ),
  TradeComplaintTimelineStep(
    step: 4,
    label: 'Final Response',
    time: 'By deadline',
  ),
];

const List<TradeComplaint> _complaints = [
  TradeComplaint(
    id: 'COMP-2026-001',
    category: 'Trade Execution',
    status: TradeComplaintStatus.underReview,
    submittedDate: '2026-02-15',
    deadline: '2026-04-12',
    subject: 'Order not executed at expected price',
  ),
  TradeComplaint(
    id: 'COMP-2025-089',
    category: 'Customer Service',
    status: TradeComplaintStatus.resolved,
    submittedDate: '2025-11-20',
    deadline: '2026-01-15',
    subject: 'Delayed response to support ticket',
  ),
];

const List<TradeComplaintProcessStep> _complaintProcessSteps = [
  TradeComplaintProcessStep(
    title: 'Fair Investigation',
    description: 'We investigate all complaints fairly and independently',
  ),
  TradeComplaintProcessStep(
    title: '8-Week Deadline',
    description: "We'll send a final response within 8 weeks (FCA requirement)",
  ),
  TradeComplaintProcessStep(
    title: 'Ombudsman Rights',
    description:
        "If you're not satisfied, you can refer to the Financial Ombudsman "
        'Service (free)',
  ),
];

const List<TradeComplaintTrackingStep> _complaintTrackingTimeline = [
  TradeComplaintTrackingStep(
    title: 'Complaint Submitted',
    description: 'Your complaint has been received',
    dateLabel: 'February 15, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Acknowledgement Sent',
    description: 'We acknowledged your complaint within 5 business days',
    dateLabel: 'February 16, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Investigation Started',
    description: 'Our compliance team is investigating',
    dateLabel: 'February 20, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Under Review',
    description: 'Currently reviewing evidence and preparing response',
    dateLabel: 'March 10, 2026',
    state: TradeComplaintTrackingStepState.current,
  ),
  TradeComplaintTrackingStep(
    title: 'Final Response',
    description: 'Deadline for our final response',
    dateLabel: 'April 12, 2026',
    state: TradeComplaintTrackingStepState.pending,
  ),
];

const List<TradeComplaintTrackingAction> _complaintTrackingActions = [
  TradeComplaintTrackingAction(
    id: 'add-info',
    label: 'Add Information',
    icon: TradeComplaintTrackingActionIcon.message,
  ),
  TradeComplaintTrackingAction(
    id: 'correspondence',
    label: 'View Correspondence',
    icon: TradeComplaintTrackingActionIcon.document,
  ),
  TradeComplaintTrackingAction(
    id: 'ombudsman',
    label: 'Ombudsman Referral Info',
    icon: TradeComplaintTrackingActionIcon.warning,
    routePath: '/trade/copy-trading/ombudsman-referral',
  ),
];

const List<TradeOmbudsmanEligibility> _ombudsmanEligibility = [
  TradeOmbudsmanEligibility(
    title: 'After 8 Weeks',
    description: "If we haven't sent you a final response within 8 weeks",
  ),
  TradeOmbudsmanEligibility(
    title: 'Not Satisfied',
    description: "If you're not satisfied with our final response",
  ),
  TradeOmbudsmanEligibility(
    title: 'Within 6 Months',
    description: 'You must refer within 6 months of our final response',
  ),
];

const List<TradeOmbudsmanContact> _ombudsmanContacts = [
  TradeOmbudsmanContact(
    label: 'Phone',
    value: '0800 023 4567',
    detail: 'Monday to Friday, 8am to 8pm - Saturday, 9am to 1pm',
    icon: TradeOmbudsmanContactIcon.phone,
  ),
  TradeOmbudsmanContact(
    label: 'Website',
    value: 'www.financial-ombudsman.org.uk',
    icon: TradeOmbudsmanContactIcon.website,
  ),
  TradeOmbudsmanContact(
    label: 'Address',
    value: 'Financial Ombudsman Service\nExchange Tower\nLondon E14 9SR',
    icon: TradeOmbudsmanContactIcon.address,
  ),
];

const List<TradeOmbudsmanProcessStep> _ombudsmanProcessSteps = [
  TradeOmbudsmanProcessStep(
    step: 1,
    title: 'Submit Your Complaint',
    description: 'Contact FOS with your complaint details',
  ),
  TradeOmbudsmanProcessStep(
    step: 2,
    title: 'FOS Reviews',
    description: 'They review both sides of the story',
  ),
  TradeOmbudsmanProcessStep(
    step: 3,
    title: 'Investigation',
    description: 'Independent investigation of the facts',
  ),
  TradeOmbudsmanProcessStep(
    step: 4,
    title: 'Decision',
    description: 'FOS makes a binding decision (for us, not you)',
  ),
];
