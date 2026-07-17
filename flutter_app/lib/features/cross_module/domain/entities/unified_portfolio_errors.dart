/// Thrown when [UnifiedPortfolioRepository] mock data is disabled but no
/// production remote implementation has been configured yet (ADR-001).
final class UnifiedPortfolioBackendContractMissingException
    implements Exception {
  const UnifiedPortfolioBackendContractMissingException();

  String get message =>
      'Unified portfolio remote repository is required when mock data is '
      'disabled.';

  String get userMessage =>
      'Unified portfolio is unavailable because the production backend is '
      'not configured yet.';

  @override
  String toString() =>
      'UnifiedPortfolioBackendContractMissingException: $message';
}
