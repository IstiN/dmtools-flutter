import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDto {
  const UserDto({
    this.id,
    this.name,
    this.email,
    this.picture,
    this.sub,
    this.preferredUsername,
    this.givenName,
    this.familyName,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  static const toJsonFactory = _$UserDtoToJson;
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;

  @JsonKey(name: 'picture', includeIfNull: false)
  final String? picture;

  @JsonKey(name: 'sub', includeIfNull: false)
  final String? sub;

  @JsonKey(name: 'preferred_username', includeIfNull: false)
  final String? preferredUsername;

  @JsonKey(name: 'given_name', includeIfNull: false)
  final String? givenName;

  @JsonKey(name: 'family_name', includeIfNull: false)
  final String? familyName;

  static const fromJsonFactory = _$UserDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserDto &&
            (identical(other.id, id) || (other.id != null && other.id == id)) &&
            (identical(other.name, name) || (other.name != null && other.name == name)) &&
            (identical(other.email, email) || (other.email != null && other.email == email)) &&
            (identical(other.picture, picture) || (other.picture != null && other.picture == picture)));
  }

  @override
  String toString() => 'UserDto(id: $id, name: $name, email: $email, picture: $picture)';

  @override
  int get hashCode => Object.hash(id, name, email, picture);

  UserDto copyWith({
    String? id,
    String? name,
    String? email,
    String? picture,
    String? sub,
    String? preferredUsername,
    String? givenName,
    String? familyName,
  }) {
    return UserDto(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      picture: picture ?? this.picture,
      sub: sub ?? this.sub,
      preferredUsername: preferredUsername ?? this.preferredUsername,
      givenName: givenName ?? this.givenName,
      familyName: familyName ?? this.familyName,
    );
  }
}
