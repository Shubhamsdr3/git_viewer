
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/widgets/drop_down.dart';
import 'package:git_viewer/presentation/widgets/file_explorer.dart';
import 'package:git_viewer/presentation/widgets/file_viewer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'base_view.dart';

class GitViewer extends StatelessWidget {
  final ProjectEntity projectEntity;
  GitViewer(this.projectEntity);

  @override
  Widget build(BuildContext context) {
    print(projectEntity.userName);
    return Scaffold(
      body: BaseView<BranchViewModel>(
        onModelReady: (model) => model.fetchBranches(projectEntity),
        builder: (context, model, child) {
          return (model.busy)? Container(): GitViewerLayout(model.selectedBranch);
      }
      ),
    );
  }

}

class GitViewerLayout extends StatelessWidget {
  BranchEntity branchEntity;
  GitViewerLayout(this.branchEntity);

  @override
  Widget build(BuildContext context) {
    return BaseView<GVViewModel>(
        onModelReady: (model) => model.fetchRootNode(branchEntity),
        builder: (context, model, child) {
          return model.busy? Container() :
          Container(
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
        Expanded(child: Container(),),
        changRepoButton()
      ],
    );
  }

  Widget changRepoButton(){
    return Builder(
      builder: (context) {
        return MaterialButton(
          child: Text('Switch Repository'),
          onPressed: (){
            Provider.of<BranchViewModel>(context, listen: false).doThings();
          },
        );
      }
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
            child: BranchSelector(),
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

class BranchSelector extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<BranchViewModel>(
      builder: (BuildContext context, BranchViewModel model, Widget child){
        BranchViewModel model = Provider.of<BranchViewModel>(context);
        if(model.branchList!=null)
          return dropDown(model.branchList, model.selectedBranch);
        return Container();
      },
    );
  }

  Widget dropDown(List<BranchEntity> branchList, BranchEntity selectedBranch){
    DropDownItemModel selectedItem;
    List items = branchList.map((e) {
      DropDownItemModel dropDownItemModel = DropDownItemModel(id: e, value: e.name, isDivider: false);
      if(e == selectedBranch){
        selectedItem = dropDownItemModel;
      }
      return dropDownItemModel;
    } ).toList();
    return Builder(
      builder: (context) {
        return DropDown(items: items, dropDownSelected: (e){
          Provider.of<BranchViewModel>(context, listen: false).selectedBranch = e.id;
        }, selection: selectedItem, color: Colors.black,);
      }
    );
  }


}

class FilePathContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TreeNodeEntity selectedNode = Provider
        .of<GVViewModel>(context)
        .selectedFile;

    return selectedNode == null ? Container():
    GestureDetector(
        child: Text(selectedNode.path, style: TextStyle(color: Colors.blue,),),
        onTap: () async{
          String url = selectedNode.url;
          if (await canLaunch(url)) {
          await launch(url);
          } else {
          throw 'Could not launch $url';
          }
        },
    );
  }
}

class FileViewerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        TreeNodeEntity selectedFile = Provider.of<GVViewModel>(context).selectedFile;
        return selectedFile!=null ? FileViewer(selectedFile): Container();
  }
}

class FileExplorerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return Container();
    TreeNodeEntity rootNode = Provider.of<GVViewModel>(context).rootNode;
    if(rootNode==null)
      return Container();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FileExplorer(nodeEntity: rootNode)),
    );
  }
}

class FileSelectionTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          GVViewModel gitViewerViewModel = Provider.of<GVViewModel>(context);
          List<TreeNodeEntity> treeNodeEntityList = gitViewerViewModel.nodesInTab;
          TreeNodeEntity selectedNode = gitViewerViewModel.selectedFile;
          return Row(
            children: treeNodeEntityList.map((node){
              return getTabButton(node, node==selectedNode);
            }).toList(),
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
                    print("on tap");
                    Provider.of<GVViewModel>(context, listen: false).selectedFile = node;
                  },
                  child: Text(node.fileName)
              ),
              InkWell(child: Icon(Icons.cancel), onTap: (){
                Provider.of<GVViewModel>(context, listen: false).removeNodeFromTab(node);
              },)
            ],),
        ),
      );
    },);
  }

}



