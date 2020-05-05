
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/widgets/file_explorer.dart';
import 'package:git_viewer/presentation/widgets/file_viewer.dart';
import 'package:provider/provider.dart';

class GitViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GitViewerViewModel>(
          create: (context){ return GitViewerViewModel();},
        )
      ],
      child: Row(
        children: <Widget>[

          SizedBox(
            width: 200,
            child: Consumer<GitViewerViewModel>(builder: (BuildContext context, GitViewerViewModel model, Widget child) {
              return FileExplorerContainer(nodeEntity: model.rootNode);
            },),
          ),
          Consumer<GitViewerViewModel>(builder: (BuildContext context, GitViewerViewModel model, Widget child) {
            return FileViewerTabsContainer();
          },)

        ],
      ),
    );
  }
}

class FileExplorerContainer extends StatelessWidget {
  
  final TreeNodeEntity nodeEntity;
  FileExplorerContainer({this.nodeEntity});
  
  
  @override
  Widget build(BuildContext context) {
    return FileExplorer(nodeEntity: nodeEntity);
  }
}

class FileViewerTabsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GitViewerViewModel gitViewerViewModel = Provider.of<GitViewerViewModel>(context);
    List<TreeNodeEntity> treeNodeEntityList = gitViewerViewModel.nodesInViewer;
    TreeNodeEntity selectedNode = gitViewerViewModel.selectedNode;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: treeNodeEntityList.map((node){
            return getTabButton(node, node==selectedNode);
          }).toList(),
        ),
        if(selectedNode!=null)
          Expanded(child: FileViewer(selectedNode))
      ],
    );
  }

  Widget getTabButton(TreeNodeEntity node, bool isSelected){
    return Builder(builder: (context){
      return Row(children: <Widget>[
        InkWell(
            onTap: (){
              Provider.of<GitViewerViewModel>(context, listen: false).selectedNode = node;
            },
            child: Text(node.fileName)
        ),
        IconButton(icon: Icon(Icons.cancel), onPressed: (){
          Provider.of<GitViewerViewModel>(context, listen: false).removeNode(node);
        },)
      ],);
    },);
  }

}




