import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'git_models.g.dart';


@JsonSerializable()
class GithubTreeNodeModel extends Equatable {
  String path;
  String type;
  String sha;

  GithubTreeNodeModel({this.path, this.type, this.sha});

  @override
  List<Object> get props => [path, type, sha];

  factory GithubTreeNodeModel.fromJson(Map<String, dynamic> json) => _$GithubTreeNodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$GithubTreeNodeModelToJson(this);

  bool get isLeafNode => type=='blob';

}

@JsonSerializable()
class GithubTreeModel  extends Equatable {
  String sha;

  @JsonKey(nullable: true)
  List<GithubTreeNodeModel> tree;

  GithubTreeModel({this.sha, this.tree});


  factory GithubTreeModel.fromJson(Map<String, dynamic> json) => _$GithubTreeModelFromJson(json);
  Map<String, dynamic> toJson() => _$GithubTreeModelToJson(this);


  @override
  List<Object> get props => [sha, tree];
}

@JsonSerializable(nullable: false)
class CommitDetailModel extends Equatable{

  GithubTreeModel tree;

  CommitDetailModel({this.tree});

  factory CommitDetailModel.fromJson(Map<String, dynamic> json) => _$CommitDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommitDetailModelToJson(this);


  @override
  List<Object> get props => [tree];

}


@JsonSerializable(nullable: false)
class CommitModel extends Equatable{

  String sha;

  CommitModel({this.sha});

  factory CommitModel.fromJson(Map<String, dynamic> json) => _$CommitModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommitModelToJson(this);


  @override
  List<Object> get props => [sha];

}

@JsonSerializable(nullable: false)
class BranchModel extends Equatable{

  String name;
  CommitModel commit;

  BranchModel({this.name, this.commit});


  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);

  @override
  List<Object> get props => [name, commit];

}