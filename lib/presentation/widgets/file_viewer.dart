import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/bloc/fileviewer_bloc/bloc.dart';

import '../../injection_container.dart' as di;


class FileViewer extends StatelessWidget {
  final TreeNodeEntity treeNodeEntity;
  FileViewer(@required this.treeNodeEntity);
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
  _FileViewer(this.treeNodeEntity);

  @override
  __FileViewerState createState() => __FileViewerState();
}

class __FileViewerState extends State<_FileViewer> {

  @override
  void didChangeDependencies() {
    print("Did change dependencies called");
    print(widget.treeNodeEntity);
    super.didChangeDependencies();
    BlocProvider.of<FileViewerBloc>(context)
        .add(GetRawContentEvent(widget.treeNodeEntity));

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileViewerBloc, FileViewerState>(
      builder: (context, state){
        if(state is Loaded){
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(state.content),
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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  TreeNodeEntity treeNodeEntity = TreeNodeEntity();
  treeNodeEntity.branch = 'master';
  treeNodeEntity.path = '.gitignore';

  runApp(MaterialApp(
    home: Scaffold(
      body: FileViewer(treeNodeEntity),
    ),
  ));
}
