/// Small, pure-Dart helpers for masking sensitive display values
/// (see AGENTS.md: "Mask sensitive account, wallet, email, phone, and
/// address data."). No Flutter dependency so these can be reused from
/// both domain entities and presentation widgets across features.
library;

/// Masks an email address for display, keeping the first character of the
/// local part and the full domain, e.g. `nguyenvana@email.com` ->
/// `n***@email.com`. Returns [email] unchanged if it has no `@` (defensive
/// fallback for malformed/placeholder input).
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0) return email;
  return '${email.substring(0, 1)}***${email.substring(at)}';
}

/// Masks an account-like identifier (bank account number, e-wallet
/// number/phone, payment account id) for display, keeping a short prefix
/// and the last 4 characters, e.g. `0901234567` -> `090...4567`.
String maskAccountNumber(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.length <= 4) return '***';
  final prefix = trimmed.substring(0, trimmed.length < 7 ? 1 : 3);
  return '$prefix...${trimmed.substring(trimmed.length - 4)}';
}

/// Masks a wallet/contract address for display, keeping [head] leading and
/// [tail] trailing characters, e.g. `maskAddress('TQnKxxx4d8eRh9Kf2Lz5mNp7')`
/// -> `TQnKxx...mNp7`. If [value] is too short to show both [head] and
/// [tail] without overlapping, returns [value] unchanged rather than
/// exposing more than it hides.
String maskAddress(String value, {int head = 6, int tail = 4}) {
  final trimmed = value.trim();
  if (trimmed.length <= head + tail) return trimmed;
  return '${trimmed.substring(0, head)}...${trimmed.substring(trimmed.length - tail)}';
}
