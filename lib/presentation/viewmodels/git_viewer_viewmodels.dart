
import 'package:dartz/dartz.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';
import 'package:git_viewer/domain/services/dialog_service.dart';

import '../../injection_container.dart';
import 'base_view_model.dart';


class BranchViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();
  final DialogService _dialogService = sl<DialogService>();

  List<BranchEntity> _branchList;
  BranchEntity _selectedBranch;
  List<BranchEntity> get branchList => _branchList;

  Future fetchBranches() async {
    setBusy(true);
    final failureOrBranches = await gitRepository.getAllBranches();
    failureOrBranches.fold((l)  {
    setBusy(false);
    }, (r) {
      _branchList = r;
      _selectedBranch = r[0];
    });
    setBusy(false);
  }

  Future doThings() async {
    print('dialog shown');
    var dialogResult = await _dialogService.showGitRepoChangeDialog();
    if (dialogResult.confirmed) {
      print('User has confirmed');
    } else {
      print('User cancelled the dialog');
    }
  }




  BranchEntity get selectedBranch => _selectedBranch;

  set selectedBranch(BranchEntity branchEntity){
    _selectedBranch =  branchEntity;
  }


}

class FileViewerViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();

  String _content;
  FileViewerViewModel();

  String get content => _content;


  Future fetchContent(TreeNodeEntity nodeEntity) async {
    setBusy(true);
    final failureOrContent = await gitRepository.getRawContent(nodeEntity);
    failureOrContent.fold(
            (l) {_content = "Error loading the content";},
            (r) {_content = r;}
            );
    setBusy(false);
    notifyListeners();
  }
}

class FileExplorerViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();
  TreeNodeEntity _nodeEntity;

  FileExplorerViewModel();

  set nodeEntity (TreeNodeEntity nodeEntity){
    _nodeEntity = nodeEntity;
  }

  Future fetchChildNode() async{
    setBusy(true);
    Either<Failure, List<TreeNodeEntity>> failureOrSuccess = await gitRepository.getChildNodes(_nodeEntity);
    failureOrSuccess.fold((l) {
      setBusy(false);
    }, (r) {
      _nodeEntity.treeNodeList = r;
      setBusy(false);
    });

  }
}

class GVViewModel extends BaseViewModel{

  GitRepository gitRepository = sl<GitRepository>();

  List<TreeNodeEntity> _nodesInTab;
  TreeNodeEntity _selectedFileNode;
  TreeNodeEntity _rootNode;
  TreeNodeEntity get selectedFile => _selectedFileNode;

  set selectedFile(TreeNodeEntity _selectedFileNode){
    this._selectedFileNode = _selectedFileNode;
    notifyListeners();
  }



  GVViewModel(){
    _nodesInTab = [];
  }

  void addNodeInTab(TreeNodeEntity treeNodeEntity){
    if(!_nodesInTab.contains(treeNodeEntity))
      _nodesInTab.add(treeNodeEntity);
    _selectedFileNode = treeNodeEntity;
    notifyListeners();
  }

  void removeNodeFromTab(TreeNodeEntity treeNodeEntity){
    int index = _nodesInTab.indexOf(treeNodeEntity);
    if(index<0){
      return;
    }
    _nodesInTab.remove(treeNodeEntity);

    if(selectedFile != treeNodeEntity) {
      notifyListeners();
      return;
    }

    if(_nodesInTab.length==0) {
      _selectedFileNode = null;
    }
    else if(_nodesInTab.length<=index && index>=0) {
      _selectedFileNode = _nodesInTab[index - 1];
    }
    else {
      _selectedFileNode = _nodesInTab[index];
    }
    notifyListeners();
  }

  TreeNodeEntity get rootNode => _rootNode;

  List<TreeNodeEntity> get nodesInTab => _nodesInTab;

  void fetchRootNode(BranchEntity branchEntity) async{
    (await gitRepository.getRootNode(branchEntity)).fold((l) => null, (r) {
      _rootNode = r;
      notifyListeners();
    });
  }


}



//class GitViewerViewModel2 extends BaseViewModel {
//  GitRepository gitRepository = sl<GitRepository>();
//  List<BranchEntity> branchList;
//  List<TreeNodeEntity> nodesInViewer;
//  TreeNodeEntity _selectedNode;
//  TreeNodeEntity _rootNode;
//  BranchEntity _selectedBranch;
//
//  BranchEntity get selectedBranch => _selectedBranch;
//
//  GitViewerViewModel({this.branchList}){
//    nodesInViewer = [];
//    if(branchList!=null && branchList.isNotEmpty)
//      _selectedBranch = branchList[0];
//  }
//
//  TreeNodeEntity get rootNode {
//    if (_rootNode ==null) {
//      _rootNode = TreeNodeEntity(
//          id: "071d621ea586b55a056b1dbe5175611a7994011e",
//          fileName: "Root",
//          isLeafNode: false);
//      _rootNode.branch = "master";
//    }
//    return _rootNode;
//  }
//
//  void updateRootNode(BranchEntity branchEntity) async{
//    print("Updating Root node");
//    _selectedBranch = branchEntity;
//    (await gitRepository.getRootNode(branchEntity)).fold((l) => null, (r) {
//      _rootNode = r;
//      notifyListeners();
//    });
//  }
//
//
//  set rootNode(TreeNodeEntity value) {
//    _rootNode = value;
//  }
//
//  TreeNodeEntity get selectedNode => _selectedNode;
//
//  void set(TreeNodeEntity node){
//    this.selectedNode = node;
//    notifyListeners();
//  }
//
//
//  set selectedNode(TreeNodeEntity value) {
//    _selectedNode = value;
//    notifyListeners();
//  }
//
//  void addNode(TreeNodeEntity treeNodeEntity){
//    if(!nodesInViewer.contains(treeNodeEntity))
//      nodesInViewer.add(treeNodeEntity);
//    _selectedNode = treeNodeEntity;
//
//    notifyListeners();
//  }
//
//  void removeNode(TreeNodeEntity treeNodeEntity){
//    int index = nodesInViewer.indexOf(treeNodeEntity);
//    if(index<0){
//      return;
//    }
//    nodesInViewer.remove(treeNodeEntity);
//    if(nodesInViewer.length==0) {
//      _selectedNode = null;
//    }
//    else if(nodesInViewer.length<=index && index>=0) {
//      _selectedNode = nodesInViewer[index - 1];
//    }
//    else {
//      _selectedNode = nodesInViewer[index];
//    }
//    notifyListeners();
//  }
//
//}