import 'package:equatable/equatable.dart';
import 'package:git_viewer/data/models/git_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'git_entities.g.dart';

@JsonSerializable()
class ProjectEntity extends Equatable{
  final String userName;
  final String projectName;

  ProjectEntity({this.userName, this.projectName});

  factory ProjectEntity.fromJson(Map<String, dynamic> json) => _$ProjectEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectEntityToJson(this);

  @override
  List<Object> get props => [userName, projectName];
}

class BranchEntity extends Equatable {
  String name;
  String commitId;

  BranchEntity._(this.name, this.commitId);

  factory BranchEntity.from(BranchModel branchModel){
    return BranchEntity._(branchModel.name, branchModel.commit.sha);
  }


  @override
  List<Object> get props => [name, commitId];

}

class TreeNodeEntity extends Equatable{

  final String id;
  final String fileName;
  final bool isLeafNode;
  bool _isOpened = false;
  String _path;
  String _branch;
  String _url;

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  List<TreeNodeEntity> _treeNodeList;

  TreeNodeEntity({this.id, this.fileName, this.isLeafNode});

  factory TreeNodeEntity.from(GithubTreeNodeModel githubTreeNodeModel){
    return TreeNodeEntity(
      id: githubTreeNodeModel.sha,
      fileName: githubTreeNodeModel.path,
      isLeafNode: githubTreeNodeModel.isLeafNode
    );
  }


  bool get isOpened => _isOpened;

  set isOpened(bool value) {
    _isOpened = value;
  }

  String get path => _path;

  set path(String value) {
    _path = value;
  }

  String get branch => _branch;

  set branch(String value) {
    _branch = value;
  }

  List<TreeNodeEntity> get treeNodeList => _treeNodeList;

  set treeNodeList(List<TreeNodeEntity> value) {
    _treeNodeList = value;
  }


  @override
  List<Object> get props => [id, fileName];
}