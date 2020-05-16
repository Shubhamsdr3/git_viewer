import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/core/views/base_view.dart';
import 'package:git_viewer/presentation/viewmodels/file_viewer_view_model.dart';
import 'package:git_viewer/presentation/viewmodels/project_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/widgets/code_viewer.dart';
import 'package:provider/provider.dart';


Widget get fileViewer  {
  return Builder(
    builder: (context) {
      TreeNodeEntity selectedFile = Provider.of<ProjectViewerViewModel>(context).selectedFile;
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
                      child: selectedFile!=null ? FileViewer(selectedFile): Container(),
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }
  );
}

class FileViewer extends StatelessWidget {
  final TreeNodeEntity nodeEntity;
  FileViewer(this.nodeEntity);
  @override
  Widget build(BuildContext context) {
    return BaseView<FileViewerViewModel>(
      onModelReady: (model) => model.fetchContent(nodeEntity),
      builder: (context, model, child){
        TextEditingController textEditingController = model.busy? TextEditingController():
        TextEditingController(text: model.content);
        return model.busy ? Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CodeViewer(code: model.content, filename: model.nodeEntity.fileName,),
          ),
        );
      },
      
    );
  }
}


class FileSelectionTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectViewerViewModel gitViewerViewModel = Provider.of<ProjectViewerViewModel>(context);
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
                    Provider.of<ProjectViewerViewModel>(context, listen: false).selectedFile = node;
                  },
                  child: Text(node.fileName)
              ),
              InkWell(child: Icon(Icons.cancel), onTap: (){
                Provider.of<ProjectViewerViewModel>(context, listen: false).removeNodeFromTab(node);
              },)
            ],),
        ),
      );
    },);
  }

}
