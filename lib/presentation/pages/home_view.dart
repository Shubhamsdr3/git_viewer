
import 'package:flutter/material.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
import 'package:provider/provider.dart';

import '../../router.dart';
import 'base_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onModelReady: (model) => model.getProjectList(),
      builder: (context, model, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                Provider.of<HomeViewModel>(context, listen: false).addProject();
              },
              child: Icon(Icons.add)
          ),
          body: ListView.builder(
            itemCount: model.projectList.length,
            itemBuilder: (context, idx){
              var projectEntity = model.projectList[idx];
              return ListTile(
                title: Text(projectEntity.projectName),
                subtitle: Text(projectEntity.userName),
                onTap: () {
                  Navigator.pushNamed(
                      context, ViewerRoute, arguments: projectEntity);
                },
              );
            }
          )
        );
      }
    );
  }
}
