import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/bloc/folder_bloc/bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../injection_container.dart' as di;


typedef Function OnFileSelected(TreeNodeEntity filename);


class FileExplorer extends StatelessWidget {

  OnFileSelected onFileSelected;
  GlobalKey<FolderWidgetState> folderWidgetKey;

  FileExplorer({this.onFileSelected, this.folderWidgetKey});


  @override
  Widget build(BuildContext context) {
    print(onFileSelected);
    TreeNodeEntity tree = TreeNodeEntity(
        id: "071d621ea586b55a056b1dbe5175611a7994011e",
        fileName: "Root",
        isLeafNode: false);
    tree.path='';
    tree.branch='master';
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FolderWidget(
        treeNodeEntity: tree,
        onFileSelected: onFileSelected,
        key:folderWidgetKey
      ),
    );
  }
}

class FolderWidget extends StatefulWidget {

  final OnFileSelected onFileSelected;
  final TreeNodeEntity treeNodeEntity;
  FolderWidget({this.treeNodeEntity, this.onFileSelected, key}):super(key:key);

  @override
  FolderWidgetState createState() => FolderWidgetState();
}

class FolderWidgetState extends State<FolderWidget> {
  bool _isOpened;
  OnFileSelected _onFileSelected;


  @override
  void initState() {
    _isOpened = false;
    _onFileSelected = widget.onFileSelected;
    print("Init state");
    print(_onFileSelected);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TreeNodeEntity treeNodeEntity = widget.treeNodeEntity;
    return BlocProvider(
      create: (_) => di.sl<FolderBloc>(),
      child: BlocBuilder<FolderBloc, FolderState>(builder: (context, state) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("OnTap");
                //print(widget.onFileSelected);
                print(_onFileSelected);
                if(treeNodeEntity.isLeafNode){
                  if(_onFileSelected!=null) {
                    _onFileSelected(treeNodeEntity);
                  }
                  return;

                }

                if (!(state is Loading)) {
                  _isOpened = !_isOpened;
                  if (_isOpened) {
                    BlocProvider.of<FolderBloc>(context)
                        .add(GetSubFolderEvent(treeNodeEntity));
                  }
                  setState(() {});
                }
              },
              child: row(state),
            ),
            folderListWidget(state)
          ],
        );
      }),
    );
  }

  Widget row(FolderState state) {
    bool isLeafNode = widget.treeNodeEntity.isLeafNode;
    return Row(children: <Widget>[
      state is Loading
          ? SizedBox(width: 20,  height: 20, child: CircularProgressIndicator())
          : isLeafNode
              ? SizedBox(
                  width: 20,
                  height: 20,
                )
              : _isOpened ? Icon(MdiIcons.menuDown) : Icon(MdiIcons.menuRight),
      widget.treeNodeEntity.isLeafNode
          ? Icon(MdiIcons.file)
          : Icon(MdiIcons.folder),
      SizedBox(
        width: 4.0,
      ),
      Text(widget.treeNodeEntity.fileName)
    ]);
  }

  Widget folderListWidget(state) {
    List<dynamic> list = widget.treeNodeEntity.treeNodeList;
    if (!(state is Loaded) || !_isOpened || list == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        children: list
            .map((e) => FolderWidget(
                  treeNodeEntity: e,
                  onFileSelected: _onFileSelected,
                ))
            .toList(),
      ),
    );
  }
}

