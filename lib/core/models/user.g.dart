// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      picture: json['picture'] as String?,
      sub: json['sub'] as String?,
      preferredUsername: json['preferred_username'] as String?,
      givenName: json['given_name'] as String?,
      familyName: json['family_name'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.email case final value?) 'email': value,
      if (instance.picture case final value?) 'picture': value,
      if (instance.sub case final value?) 'sub': value,
      if (instance.preferredUsername case final value?)
        'preferred_username': value,
      if (instance.givenName case final value?) 'given_name': value,
      if (instance.familyName case final value?) 'family_name': value,
    };
