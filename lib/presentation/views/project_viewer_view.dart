import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/core/util/ui_util.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/viewmodels/project_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/views/file_explorer_view.dart';
import 'package:git_viewer/presentation/views/file_viewer_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:git_viewer/core/views/base_view.dart';

class ProjectViewerView extends StatelessWidget {
  final ProjectEntity projectEntity;
  ProjectViewerView(this.projectEntity);

  @override
  Widget build(BuildContext context) {
    return BaseView<BranchViewModel>(
        onModelReady: (model) => model.fetchBranches(projectEntity),
        builder: (context, model, child) {
          return (model.busy)? Container(): _ProjectViewer(model.selectedBranch);
      });
  }
}

class _ProjectViewer extends StatelessWidget {
  final BranchEntity branchEntity;
  _ProjectViewer(this.branchEntity);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProjectViewerViewModel>(
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
                    child: _topBarWidget,
                  ),
                  Expanded(child: Row(
                    children: <Widget>[
                      fileExplorer,
                      fileViewer
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

  Widget get _topBarWidget{
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: _filePathWidget,
        ),
        Expanded(child: Container(),),
        _changRepoButton
      ],
    );
  }

  Widget get _changRepoButton{
    return Builder(
      builder: (context) {
        var projectEntity = Provider.of<BranchViewModel>(context).projectEntity;
        return Tooltip(
          message: "Change Repo",
          child: RaisedButton(
            child: Row(children: <Widget>[
              Icon(Icons.book),
              UiUtil.horizontalSpaceTiny(),
              Text(projectEntity.userName+"/"+projectEntity.projectName)
            ],),
            onPressed: (){
                Navigator.pop(context);
            },
          ),
        );
      }
    );
  }

  Widget get _filePathWidget {
    return Builder(
      builder: (context){
      TreeNodeEntity selectedNode = Provider.of<ProjectViewerViewModel>(
          context).selectedFile;
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
      },
    );
  }
}



