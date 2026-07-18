import 'package:json_annotation/json_annotation.dart';

part 'auth_session_dto.g.dart';

/// PROVISIONAL wire shape for a persisted/returned auth session.
///
/// GĐ4-F8 serialization pilot (ADR-010,
/// `docs/05_ARCHITECTURE/decisions/ADR-010-dto-provisional.md`): this DTO is
/// the JSON counterpart of the domain [AuthSession] entity — mirrors it
/// field-for-field (`identifier`, `demo`, `issuedAt` as ISO-8601). It backs
/// the one real integration point of the pilot, `AuthSessionController`'s
/// SecureStore persistence (see `auth_dto_mappers.dart`).
///
/// The shape has NOT been confirmed against a signed backend contract
/// (`docs/02_FLUTTER_MIGRATION/Auth-Backend-Contract-Skeleton.md` still
/// lists `/auth/login` response DTOs as "to confirm"). Only `data/dto/` and
/// its mapper should need to change once the contract is signed — the
/// domain entity and UI must stay untouched.
///
/// `checked: true` makes generated `fromJson` throw a controlled
/// [CheckedFromJsonException] (rather than a raw cast failure) when a field
/// is missing or has the wrong type.
@JsonSerializable(checked: true)
final class AuthSessionDto {
  /// Creates a DTO directly from wire-shape fields.
  const AuthSessionDto({
    required this.identifier,
    required this.demo,
    required this.issuedAt,
  });

  /// Decodes a DTO from a JSON map. Throws [CheckedFromJsonException] if a
  /// required field is missing or has the wrong runtime type.
  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  /// Login/contact identifier (email or phone) — PROVISIONAL, matches
  /// [AuthSession.identifier].
  final String identifier;

  /// Whether the session was issued in demo mode — PROVISIONAL, matches
  /// [AuthSession.demo].
  final bool demo;

  /// Session issue time, encoded as an ISO-8601 string — PROVISIONAL,
  /// matches [AuthSession.issuedAt].
  final DateTime issuedAt;

  /// Encodes this DTO to a JSON map (`issuedAt` as ISO-8601 string).
  Map<String, dynamic> toJson() => _$AuthSessionDtoToJson(this);
}
