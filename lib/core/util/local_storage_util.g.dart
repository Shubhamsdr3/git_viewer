// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_util.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpiryObject _$ExpiryObjectFromJson(Map<String, dynamic> json) {
  return ExpiryObject(
    content: json['content'],
    expireAt: json['expireAt'] == null
        ? null
        : DateTime.parse(json['expireAt'] as String),
  );
}

Map<String, dynamic> _$ExpiryObjectToJson(ExpiryObject instance) =>
    <String, dynamic>{
      'content': instance.content,
      'expireAt': instance.expireAt?.toIso8601String(),
    };
