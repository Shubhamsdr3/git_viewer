// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubTreeNodeModel _$GithubTreeNodeModelFromJson(Map<String, dynamic> json) {
  return GithubTreeNodeModel(
    path: json['path'] as String,
    type: json['type'] as String,
    sha: json['sha'] as String,
  );
}

Map<String, dynamic> _$GithubTreeNodeModelToJson(
        GithubTreeNodeModel instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
      'sha': instance.sha,
    };

GithubTreeModel _$GithubTreeModelFromJson(Map<String, dynamic> json) {
  return GithubTreeModel(
    sha: json['sha'] as String,
    tree: (json['tree'] as List)
        ?.map((e) => e == null
            ? null
            : GithubTreeNodeModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GithubTreeModelToJson(GithubTreeModel instance) =>
    <String, dynamic>{
      'sha': instance.sha,
      'tree': instance.tree,
    };

CommitDetailModel _$CommitDetailModelFromJson(Map<String, dynamic> json) {
  return CommitDetailModel(
    tree: GithubTreeModel.fromJson(json['tree'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommitDetailModelToJson(CommitDetailModel instance) =>
    <String, dynamic>{
      'tree': instance.tree,
    };

CommitModel _$CommitModelFromJson(Map<String, dynamic> json) {
  return CommitModel(
    sha: json['sha'] as String,
  );
}

Map<String, dynamic> _$CommitModelToJson(CommitModel instance) =>
    <String, dynamic>{
      'sha': instance.sha,
    };

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) {
  return BranchModel(
    name: json['name'] as String,
    commit: CommitModel.fromJson(json['commit'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'commit': instance.commit,
    };
