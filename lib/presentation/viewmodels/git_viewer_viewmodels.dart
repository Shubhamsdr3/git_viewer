
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

import '../../injection_container.dart';
import 'base_view_model.dart';


class BranchViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();
  List<BranchEntity> _branchList;

  Future fetchBranches() async {
    setBusy(true);
    final failureOrBranches = await gitRepository.getAllBranches();
    failureOrBranches.fold((l) => null, (r) {
      _branchList = r;
    });
    setBusy(false);
  }

  List<BranchEntity> get branchList => _branchList;
}

class FileViewerViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();

  String _content;
  TreeNodeEntity _nodeEntity;
  FileViewerViewModel();

  String get content => _content;


  Future fetchContent(TreeNodeEntity nodeEntity) async {
    setBusy(true);
    _nodeEntity = nodeEntity;
    final failureOrContent = await gitRepository.getRawContent(nodeEntity);
    failureOrContent.fold(
            (l) {_content = "Error loading the content";},
            (r) {_content = r;}
            );
    setBusy(false);
    notifyListeners();
  }

}


class GitViewerViewModel extends ChangeNotifier {

  List<BranchEntity> branchList;
  List<TreeNodeEntity> nodesInViewer;
  TreeNodeEntity _selectedNode;
  TreeNodeEntity _rootNode;
  GitRepository gitRepository = sl<GitRepository>();
  BranchEntity _selectedBranch;

  BranchEntity get selectedBranch => _selectedBranch;

  GitViewerViewModel({this.branchList}){
    nodesInViewer = [];
    if(branchList!=null && branchList.isNotEmpty)
      _selectedBranch = branchList[0];
  }

  TreeNodeEntity get rootNode {
    if (_rootNode ==null) {
      _rootNode = TreeNodeEntity(
          id: "071d621ea586b55a056b1dbe5175611a7994011e",
          fileName: "Root",
          isLeafNode: false);
      _rootNode.branch = "master";
    }
    return _rootNode;
  }

  void updateRootNode(BranchEntity branchEntity) async{
    print("Updating Root node");
    _selectedBranch = branchEntity;
    (await gitRepository.getRootNode(branchEntity)).fold((l) => null, (r) {
      _rootNode = r;
      notifyListeners();
    });
  }


  set rootNode(TreeNodeEntity value) {
    _rootNode = value;
  }

  TreeNodeEntity get selectedNode => _selectedNode;

  void set(TreeNodeEntity node){
    this.selectedNode = node;
    notifyListeners();
  }


  set selectedNode(TreeNodeEntity value) {
    _selectedNode = value;
    notifyListeners();
  }

  void addNode(TreeNodeEntity treeNodeEntity){
    if(!nodesInViewer.contains(treeNodeEntity))
      nodesInViewer.add(treeNodeEntity);
    _selectedNode = treeNodeEntity;

    notifyListeners();
  }

  void removeNode(TreeNodeEntity treeNodeEntity){
    int index = nodesInViewer.indexOf(treeNodeEntity);
    if(index<0){
      return;
    }
    nodesInViewer.remove(treeNodeEntity);
    if(nodesInViewer.length==0) {
      _selectedNode = null;
    }
    else if(nodesInViewer.length<=index && index>=0) {
      _selectedNode = nodesInViewer[index - 1];
    }
    else {
      _selectedNode = nodesInViewer[index];
    }
    notifyListeners();
  }

}