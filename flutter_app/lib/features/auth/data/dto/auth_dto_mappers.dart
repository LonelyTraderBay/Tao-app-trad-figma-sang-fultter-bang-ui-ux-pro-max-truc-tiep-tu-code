import 'package:vit_trade_flutter/features/auth/data/dto/auth_session_dto.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';

/// PROVISIONAL entity<->DTO mapping for [AuthSession] / [AuthSessionDto]
/// (GĐ4-F8 serialization pilot, ADR-010
/// `docs/05_ARCHITECTURE/decisions/ADR-010-dto-provisional.md`).
///
/// Kept as a thin, field-for-field mirror deliberately: [AuthSession] is the
/// domain entity (no serialization annotations, may later carry UI/mock
/// metadata that must never reach JSON); [AuthSessionDto] is the wire shape.
/// If the shapes diverge once the backend contract is signed, only this
/// mapper (and the DTO) should need to change.
extension AuthSessionDtoMapper on AuthSessionDto {
  /// Converts this wire DTO to the domain [AuthSession] entity.
  AuthSession toEntity() =>
      AuthSession(identifier: identifier, demo: demo, issuedAt: issuedAt);
}

/// PROVISIONAL entity->DTO direction — see [AuthSessionDtoMapper].
extension AuthSessionEntityMapper on AuthSession {
  /// Converts this domain entity to its wire-shape [AuthSessionDto].
  AuthSessionDto toDto() =>
      AuthSessionDto(identifier: identifier, demo: demo, issuedAt: issuedAt);
}
