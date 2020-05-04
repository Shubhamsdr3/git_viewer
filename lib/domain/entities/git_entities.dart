import 'package:equatable/equatable.dart';
import 'package:git_viewer/data/models/git_models.dart';

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
  String _path;
  String _branch;

  List<TreeNodeEntity> _treeNodeList;

  TreeNodeEntity({this.id, this.fileName, this.isLeafNode});

  factory TreeNodeEntity.from(GithubTreeNodeModel githubTreeNodeModel){
    return TreeNodeEntity(
      id: githubTreeNodeModel.sha,
      fileName: githubTreeNodeModel.path,
      isLeafNode: githubTreeNodeModel.isLeafNode
    );
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
  List<Object> get props => [];
}