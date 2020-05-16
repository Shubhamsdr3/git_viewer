// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_util_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModel _$TestModelFromJson(Map<String, dynamic> json) {
  return TestModel(
    path: json['path'] as String,
    type: json['type'] as String,
    sha: json['sha'] as String,
  );
}

Map<String, dynamic> _$TestModelToJson(TestModel instance) => <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
      'sha': instance.sha,
    };
