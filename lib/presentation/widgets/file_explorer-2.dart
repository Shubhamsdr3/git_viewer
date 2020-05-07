//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:git_viewer/domain/entities/git_entities.dart';
//import 'package:git_viewer/presentation/bloc/folder_bloc/bloc.dart';
//import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:provider/provider.dart';
//import '../../injection_container.dart' as di;
//
//
//typedef Function OnFileSelected(TreeNodeEntity filename);
//
//
//class FileExplorer extends StatelessWidget {
//
//  final TreeNodeEntity nodeEntity;
//  FileExplorer({this.nodeEntity});
//
//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      create: (_) => di.sl<FolderBloc>(),
//      child: BlocBuilder<FolderBloc, FolderState>(builder: (context, state) {
//        return Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//
//          children: <Widget>[
//            GestureDetector(
//              onTap: () {
//                if(nodeEntity.isLeafNode) {
//                  Provider.of<GitViewerViewModel>(
//                      context, listen: false).addNode(nodeEntity);
//                  return;
//                }
//                if (!(state is Loading)) {
//                  nodeEntity.isOpened = !nodeEntity.isOpened;
//                  if (nodeEntity.isOpened) {
//                    BlocProvider.of<FolderBloc>(context)
//                        .add(GetSubFolderEvent(nodeEntity));
//                  }
//                }
//              },
//              child: row(state),
//            ),
//            folderListWidget(state)
//          ],
//        );
//      }),
//    );
//  }
//
//  Widget row(FolderState state) {
//    bool isLeafNode = nodeEntity.isLeafNode;
//    return Row(children: <Widget>[
//      state is Loading
//          ? SizedBox(width: 20,  height: 20, child: CircularProgressIndicator())
//          : isLeafNode
//              ? SizedBox(
//                  width: 20,
//                  height: 20,
//                )
//              : nodeEntity.isOpened ? Icon(MdiIcons.menuDown) : Icon(MdiIcons.menuRight),
//      nodeEntity.isLeafNode
//          ? Icon(MdiIcons.file)
//          : Icon(MdiIcons.folder),
//      SizedBox(
//        width: 4.0,
//      ),
//      Text(nodeEntity.fileName)
//    ]);
//  }
//
//  Widget folderListWidget(state) {
//    List<dynamic> list = nodeEntity.treeNodeList;
//    if (!(state is Loaded) || !nodeEntity.isOpened || list == null) return Container();
//    return Padding(
//      padding: const EdgeInsets.only(left: 16.0),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: list
//            .map((e) => FileExplorer(
//                  nodeEntity: e,
//                ))
//            .toList(),
//      ),
//    );
//  }
//}
//
