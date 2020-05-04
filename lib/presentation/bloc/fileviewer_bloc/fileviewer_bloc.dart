import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/domain/usecases/get_raw_content.dart';

import 'fileviewer_event.dart';
import 'fileviewer_state.dart';

class FileViewerBloc extends Bloc<FileViewerEvent, FileViewerState> {

  final GetRawContent getRawContent;

  @override
  FileViewerState get initialState => Empty();

  FileViewerBloc({@required  GetRawContent getRawContent}):
        assert(getRawContent!=null),
        getRawContent=getRawContent;

  @override
  Stream<FileViewerState> mapEventToState(FileViewerEvent event) async* {
    print(event);
    if(event is GetRawContentEvent){
      yield Loading();
      final failureOrBranches = await getRawContent(Params(treeNodeEntity: event.treeNodeEntity));
      print(failureOrBranches);
      yield failureOrBranches.fold(
          (failure) => Error(message: "Error loading branches"),
          (content) => Loaded(content)
      );
    }
  }

}