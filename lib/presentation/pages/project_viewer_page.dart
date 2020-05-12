import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/views/home_view.dart';
import 'package:git_viewer/presentation/views/project_viewer_view.dart';

class ProjectViewerPage extends StatelessWidget {
  final ProjectEntity projectEntity;
  ProjectViewerPage(this.projectEntity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectViewerView(projectEntity),
    );
  }
}
