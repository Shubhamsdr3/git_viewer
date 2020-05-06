
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
      child: GitViewerLayout(),
    );
  }

}


class GitViewerLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              decoration: BoxDecoration(border: Border.all()),
              child: topBar(),
            ),
            Expanded(child: Row(
              children: <Widget>[
                fileExplorerLayout(),
                fileViewerLayout()
              ],
            ),),
            Container(
              height: 30,
              decoration: BoxDecoration(border: Border.all()),
            ),
          ],
        ),
      ),
    );
  }

  Widget topBar(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: FilePathContainer(),
        ),
      ],
    );
  }

  Widget fileExplorerLayout()  {
    return Container(
      width: 250,
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border.all()),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child: FileExplorerContainer(),
            ),
          )
        ],
      ),
    );
  }

  Widget fileViewerLayout()  {
    return Expanded(
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                decoration: BoxDecoration(border: Border.all()),
                child: FileSelectionTabs(),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: Colors.green),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FileViewerContainer(),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

class FilePathContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitViewerViewModel>(
      builder: (BuildContext context, GitViewerViewModel model, Widget child){
        TreeNodeEntity selectedNode = Provider.of<GitViewerViewModel>(context).selectedNode;
        return selectedNode!=null ? Text(selectedNode.path): Container();
      },
    );
  }
}

class FileViewerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitViewerViewModel>(
      builder: (BuildContext context, GitViewerViewModel model, Widget child){
        TreeNodeEntity selectedNode = Provider.of<GitViewerViewModel>(context).selectedNode;
        return selectedNode!=null ? FileViewer(selectedNode): Container();
      },
    );
  }
}

class FileExplorerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitViewerViewModel>(
        builder: (BuildContext context, GitViewerViewModel model, Widget child){
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FileExplorer(nodeEntity: model.rootNode)),
          );
        },
    );
  }
}

class FileSelectionTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitViewerViewModel>(
        builder: (BuildContext context, GitViewerViewModel model, Widget child){
          
          GitViewerViewModel gitViewerViewModel = Provider.of<GitViewerViewModel>(context);
          List<TreeNodeEntity> treeNodeEntityList = gitViewerViewModel.nodesInViewer;
          TreeNodeEntity selectedNode = gitViewerViewModel.selectedNode;
          
          return Row(
            children: treeNodeEntityList.map((node){
              return getTabButton(node, node==selectedNode);
            }).toList(),
          );
        }
    );
  }

  Widget getTabButton(TreeNodeEntity node, bool isSelected){
    return Builder(builder: (context){
      return Container(
        decoration: BoxDecoration(border: Border.all(), color: isSelected?Colors.white : Colors.grey),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  onTap: (){
                    Provider.of<GitViewerViewModel>(context, listen: false).selectedNode = node;
                  },
                  child: Text(node.fileName)
              ),
              InkWell(child: Icon(Icons.cancel), onTap: (){
                Provider.of<GitViewerViewModel>(context, listen: false).removeNode(node);
              },)
            ],),
        ),
      );
    },);
  }

}



