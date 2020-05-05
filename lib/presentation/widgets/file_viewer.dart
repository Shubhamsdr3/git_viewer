import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/bloc/fileviewer_bloc/bloc.dart';

import '../../injection_container.dart' as di;


class FileViewer extends StatelessWidget {
  final TreeNodeEntity treeNodeEntity;
  FileViewer(@required this.treeNodeEntity){
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<FileViewerBloc>(),
      child: _FileViewer(this.treeNodeEntity)
      );
  }
}

class _FileViewer extends StatefulWidget {
  TreeNodeEntity treeNodeEntity;
  _FileViewer(this.treeNodeEntity){
  }

  @override
  __FileViewerState createState() => __FileViewerState();
}

class __FileViewerState extends State<_FileViewer> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<FileViewerBloc>(context)
        .add(GetRawContentEvent(widget.treeNodeEntity));

  }


  @override
  void didUpdateWidget(_FileViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if((oldWidget!=widget)) {
      BlocProvider.of<FileViewerBloc>(context)
          .add(GetRawContentEvent(widget.treeNodeEntity));
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileViewerBloc, FileViewerState>(
      builder: (context, state){
        if(state is Loaded){
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SelectableText(state.content),
            ),
          );
        }else if(state is Loading){
          return Center(child: CircularProgressIndicator());
        }
        return Container();

      },
    );
  }
}
