// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectEntity _$ProjectEntityFromJson(Map<String, dynamic> json) {
  return ProjectEntity(
    userName: json['userName'] as String,
    projectName: json['projectName'] as String,
  );
}

Map<String, dynamic> _$ProjectEntityToJson(ProjectEntity instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'projectName': instance.projectName,
    };
