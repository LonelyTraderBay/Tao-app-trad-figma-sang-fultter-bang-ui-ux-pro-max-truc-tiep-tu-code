// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthSessionDto', json, ($checkedConvert) {
      final val = AuthSessionDto(
        identifier: $checkedConvert('identifier', (v) => v as String),
        demo: $checkedConvert('demo', (v) => v as bool),
        issuedAt: $checkedConvert(
          'issuedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuthSessionDtoToJson(AuthSessionDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'demo': instance.demo,
      'issuedAt': instance.issuedAt.toIso8601String(),
    };
