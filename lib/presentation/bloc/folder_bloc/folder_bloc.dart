import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/domain/usecases/get_subfolders.dart';

import 'folder_event.dart';
import 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {

  final GetSubFolders getSubFolders;

  @override
  FolderState get initialState => Empty();

  FolderBloc({@required GetSubFolders getSubFolders}):
        assert(getSubFolders!=null),
        getSubFolders=getSubFolders;

  @override
  Stream<FolderState> mapEventToState(FolderEvent event) async* {
    if(event is GetSubFolderEvent){
      yield Loading();
      final failureOrBranches = await getSubFolders(Params(treeNodeEntity: event.treeNodeEntity));
      yield failureOrBranches.fold(
          (failure) => Error(message: "Error loading branches"),
          (list) {
            event.treeNodeEntity.treeNodeList = list;
            return Loaded(list);
          }
      );
    }
  }

}