part of 'predictions_entities.dart';

enum PredictionLeaderboardMetric { pnl, volume }

String _monthLabel(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

final List<PredictionCalendarEventDraft> _predictionCalendarEvents = [
  PredictionCalendarEventDraft(
    id: 'pred-1',
    title: 'BTC > \$100K by Dec 2026?',
    category: 'Crypto',
    resolutionDate: DateTime.utc(2026, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 68,
    volume: 2340000,
    isWatching: true,
    notifyBefore: '1 week',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-12',
    title: 'SpaceX Mars landing in 2026?',
    category: 'Tech',
    resolutionDate: DateTime.utc(2026, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 35,
    volume: 3400000,
    isWatching: true,
    notifyBefore: '1 week',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-2',
    title: 'ETH merge to PoS in 2025?',
    category: 'Crypto',
    resolutionDate: DateTime.utc(2025, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 75,
    volume: 1890000,
    isWatching: true,
    notifyBefore: '1 day',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-3',
    title: 'US Election 2024 - Candidate A wins?',
    category: 'Politics',
    resolutionDate: DateTime.utc(2024, 11, 5),
    status: PredictionCalendarEventStatus.upcoming,
    probability: 42,
    volume: 5600000,
    isWatching: false,
  ),
  PredictionCalendarEventDraft(
    id: 'pred-6',
    title: 'AI beats human in chess 2025?',
    category: 'Tech',
    resolutionDate: DateTime.utc(2025, 6, 30),
    status: PredictionCalendarEventStatus.resolving,
    probability: 88,
    volume: 890000,
    isWatching: true,
    notifyBefore: '1 hour',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-5',
    title: 'Global GDP growth > 3% in 2025?',
    category: 'Macro',
    resolutionDate: DateTime.utc(2025, 3, 31),
    status: PredictionCalendarEventStatus.resolved,
    probability: 52,
    volume: 1200000,
    isWatching: false,
  ),
];
