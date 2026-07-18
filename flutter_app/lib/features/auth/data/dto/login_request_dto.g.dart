// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestDto _$LoginRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginRequestDto', json, ($checkedConvert) {
      final val = LoginRequestDto(
        identifier: $checkedConvert('identifier', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
        demo: $checkedConvert('demo', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$LoginRequestDtoToJson(LoginRequestDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'password': instance.password,
      'demo': instance.demo,
    };
