
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/widgets/file_explorer.dart';
import 'package:git_viewer/presentation/widgets/file_viewer.dart';

class GitViewer extends StatefulWidget {
  @override
  _GitViewerState createState() => _GitViewerState();
}

class _GitViewerState extends State<GitViewer> {
  List<TreeNodeEntity> _selectedNodeList;
  ValueKey<String> valueKey;
  GlobalKey<FolderWidgetState> folderWidgetKey;

  @override
  void initState() {
    _selectedNodeList = [];
    folderWidgetKey = GlobalKey<FolderWidgetState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FileExplorer(
              folderWidgetKey: folderWidgetKey,
              onFileSelected: (node){
                _selectedNodeList.add(node);
                setState(() {});
                return;
            },),
          ),
        ),
        Flexible(
          flex: 6,
          child: Expanded(
              child: Container(color: Colors.red, child: _selectedNodeList.length>0 ?
              FileViewer(_selectedNodeList[0]):Container(),)),
        )
      ],
    );
  }
}


