// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'createdDate': instance.createdDate.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
    };
