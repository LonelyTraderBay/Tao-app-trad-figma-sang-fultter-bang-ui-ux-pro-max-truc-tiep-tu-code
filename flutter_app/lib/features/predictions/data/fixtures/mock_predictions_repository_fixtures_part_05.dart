part of '../repositories/mock_predictions_repository.dart';

const List<PredictionReceiptDraft> _predictionReceipts = [
  PredictionReceiptDraft(
    id: 'po-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    total: 60,
    fee: 1.2,
    status: 'submitted',
  ),
];

const List<PredictionRewardDraft> _predictionRewards = [
  PredictionRewardDraft(
    id: 'rw-1',
    eventId: 'pred-1',
    category: 'Live Crypto',
    dailyReward: 45,
    earningsPct: 12.5,
  ),
  PredictionRewardDraft(
    id: 'rw-10',
    eventId: 'pred-10',
    category: 'Finance',
    dailyReward: 35,
    earningsPct: 11,
  ),
];
