import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/core/views/base_view.dart';
import 'package:git_viewer/presentation/viewmodels/file_explorer_view_model.dart';
import 'package:git_viewer/presentation/viewmodels/project_viewer_viewmodels.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'branch_selector_view.dart';


typedef Function OnFileSelected(TreeNodeEntity filename);


Widget get fileExplorer{
  return Builder(
    builder: (context) {
      TreeNodeEntity rootNode = Provider.of<ProjectViewerViewModel>(context).rootNode;
      return Container(
        width: 250,
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 30,
              decoration: BoxDecoration(border: Border.all()),
              child: BranchSelectorView(),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                child: rootNode==null ? Container():
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: FileExplorer(nodeEntity: rootNode)),
                )
              ),
            )
          ],
        ),
      );
    }
  );
}


class FileExplorer extends StatelessWidget {

  final TreeNodeEntity nodeEntity;
  FileExplorer({this.nodeEntity});

  @override
  Widget build(BuildContext context) {
    return BaseView<FileExplorerViewModel>(
      onModelReady: (model) {
          model.nodeEntity = nodeEntity;
        },
      builder: (context, model, child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            GestureDetector(
              onTap: () {
                if(nodeEntity.isLeafNode) {
                  Provider.of<ProjectViewerViewModel>(
                      context, listen: false).addNodeInTab(nodeEntity);
                  return;
                }
                if (!(model.busy)) {
                  nodeEntity.isOpened = !nodeEntity.isOpened;
                  if (nodeEntity.isOpened) {
                    model.fetchChildNode();
                  }
                  else{
                    model.notifyListeners();
                  }
                }
              },
              child: row(model.busy),
            ),
            folderListWidget(model.busy)
          ],
        );

      },

    );


  }

  Widget row(bool isBusy) {
    return Row(children: <Widget>[
      isBusy
          ? SizedBox(width: 20,  height: 20, child: CircularProgressIndicator())
          : nodeEntity.isLeafNode
              ? SizedBox(
                  width: 20,
                  height: 20,
                )
              : nodeEntity.isOpened ? Icon(MdiIcons.menuDown) : Icon(MdiIcons.menuRight),
      nodeEntity.isLeafNode
          ? Icon(MdiIcons.file)
          : Icon(MdiIcons.folder),
      SizedBox(
        width: 4.0,
      ),
      Text(nodeEntity.fileName)
    ]);
  }

  Widget folderListWidget(bool isBusy) {
    List<dynamic> list = nodeEntity.treeNodeList;
    if (isBusy || !nodeEntity.isOpened || list == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map((e) => FileExplorer(
                  nodeEntity: e,
                ))
            .toList(),
      ),
    );
  }
}

