
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

class GitViewerViewModel extends ChangeNotifier {

  List<TreeNodeEntity> nodesInViewer;
  TreeNodeEntity _selectedNode;
  TreeNodeEntity _rootNode;

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

  GitViewerViewModel(){
    nodesInViewer = [];
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