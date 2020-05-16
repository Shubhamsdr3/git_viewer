
import 'package:dartz/dartz.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/data/datasources/git_data_source.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

import '../../injection_container.dart';
import 'package:git_viewer/core/viewmodels/base_view_model.dart';


class BranchViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();
  GitRemoteDataSource gitDataSource = sl<GitRemoteDataSource>();

  List<BranchEntity> _branchList;
  ProjectEntity _projectEntity;
  BranchEntity _selectedBranch;
  List<BranchEntity> get branchList => _branchList;
  ProjectEntity get projectEntity => _projectEntity;

  Future fetchBranches(ProjectEntity projectEntity) async {
    _projectEntity = projectEntity;
    gitDataSource.updateGitInfo(projectEntity.userName,
        projectEntity.projectName);
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

  BranchEntity get selectedBranch => _selectedBranch;

  set selectedBranch(BranchEntity branchEntity){
    _selectedBranch =  branchEntity;
    notifyListeners();
  }


}


class ProjectViewerViewModel extends BaseViewModel{

  GitRepository gitRepository = sl<GitRepository>();

  List<TreeNodeEntity> _nodesInTab;
  TreeNodeEntity _selectedFileNode;
  TreeNodeEntity _rootNode;
  TreeNodeEntity get selectedFile => _selectedFileNode;

  set selectedFile(TreeNodeEntity _selectedFileNode){
    this._selectedFileNode = _selectedFileNode;
    notifyListeners();
  }



  ProjectViewerViewModel(){
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
