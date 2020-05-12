import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/pages/base_view.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';

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
            child: TextField(
                decoration: InputDecoration(),
                maxLines: null,
                readOnly: false,
                controller: textEditingController
            ),
          ),
        );
      },
      
    );
  }
}
